import 'package:flutter/material.dart';

import '../models/book.dart';
import '../services/store_controller.dart';

/// Runs checkout and shows feedback. Returns true when payment succeeded.
Future<bool> runCheckout(
  BuildContext context,
  StoreController store, {
  List<Book>? books,
}) async {
  final messenger = ScaffoldMessenger.of(context);
  try {
    final result = await store.checkout(books: books);
    switch (result) {
      case CheckoutResult.success:
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Payment successful! Find your books in Library.'),
            backgroundColor: Color(0xFF1E9E5A),
          ),
        );
        return true;
      case CheckoutResult.cancelled:
        return false;
      case CheckoutResult.failed:
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Payment failed. Please try again.'),
            backgroundColor: Color(0xFFD93F3F),
          ),
        );
        return false;
    }
  } catch (e) {
    debugPrint('checkout error: $e');
    messenger.showSnackBar(
      SnackBar(content: Text('Could not start payment: $e')),
    );
    return false;
  }
}
