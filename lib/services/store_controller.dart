import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../models/book.dart';

enum CheckoutResult { success, cancelled, failed }

/// Holds the cart and purchased books, and runs the Stripe checkout.
/// Purchases are kept in memory only, so they reset when the app restarts.
class StoreController extends ChangeNotifier {
  final Set<String> _cart = {};
  final Set<String> _owned = {};

  List<Book> get cartBooks =>
      catalog.where((b) => _cart.contains(b.id)).toList();
  List<Book> get ownedBooks =>
      catalog.where((b) => _owned.contains(b.id)).toList();
  int get cartTotalCents => cartBooks.fold(0, (sum, b) => sum + b.priceCents);

  bool inCart(Book b) => _cart.contains(b.id);
  bool owns(Book b) => _owned.contains(b.id);

  void addToCart(Book b) {
    if (owns(b)) return;
    _cart.add(b.id);
    notifyListeners();
  }

  void removeFromCart(Book b) {
    _cart.remove(b.id);
    notifyListeners();
  }

  /// Pays for [books] (the cart by default). Throws on setup errors.
  Future<CheckoutResult> checkout({List<Book>? books}) async {
    final items = books ?? cartBooks;
    if (items.isEmpty) return CheckoutResult.failed;

    final result = await FirebaseFunctions.instance
        .httpsCallable('createPaymentIntent')
        .call({'bookIds': items.map((b) => b.id).toList()});
    final clientSecret = (result.data as Map)['clientSecret'] as String;

    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: 'Ikay Books',
      ),
    );

    try {
      await Stripe.instance.presentPaymentSheet();
    } on StripeException catch (e) {
      return e.error.code == FailureCode.Canceled
          ? CheckoutResult.cancelled
          : CheckoutResult.failed;
    }

    _owned.addAll(items.map((b) => b.id));
    _cart.removeAll(items.map((b) => b.id));
    notifyListeners();
    return CheckoutResult.success;
  }
}
