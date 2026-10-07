import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../models/book.dart';
import '../services/store_controller.dart';
import '../widgets/book_cover.dart';
import '../widgets/checkout_runner.dart';
import '../widgets/empty_state.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key, required this.store});

  final StoreController store;

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool _busy = false;

  Future<void> _checkout() async {
    setState(() => _busy = true);
    await runCheckout(context, widget.store);
    if (mounted) setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    final store = widget.store;
    final items = store.cartBooks;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: Text(
            'Your cart',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
        ),
        Expanded(
          child: items.isEmpty
              ? const EmptyState(
                  icon: PhosphorIconsDuotone.shoppingBag,
                  title: 'Your cart is empty',
                  message: 'Add a few books from the store to get started.',
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (_, i) => _CartItem(
                    book: items[i],
                    onRemove: () => store.removeFromCart(items[i]),
                  ),
                ),
        ),
        if (items.isNotEmpty)
          Container(
            padding: const EdgeInsets.fromLTRB(24, 18, 24, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${items.length} ${items.length == 1 ? 'book' : 'books'}',
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      formatPrice(store.cartTotalCents),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _busy ? null : _checkout,
                  icon: _busy
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const PhosphorIcon(PhosphorIconsBold.lock, size: 18),
                  label: const Text('Secure checkout'),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF635BFF),
                    minimumSize: const Size.fromHeight(54),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _CartItem extends StatelessWidget {
  const _CartItem({required this.book, required this.onRemove});

  final Book book;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 56,
            height: 84,
            child: BookCover(book: book, radius: 8, hero: false),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  book.author,
                  style: const TextStyle(color: Colors.black54, fontSize: 13),
                ),
                const SizedBox(height: 8),
                Text(
                  book.priceLabel,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF635BFF),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onRemove,
            tooltip: 'Remove',
            icon: const PhosphorIcon(
              PhosphorIconsRegular.trash,
              color: Colors.black45,
            ),
          ),
        ],
      ),
    );
  }
}
