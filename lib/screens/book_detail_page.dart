import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../models/book.dart';
import '../services/store_controller.dart';
import '../widgets/book_cover.dart';
import '../widgets/checkout_runner.dart';

class BookDetailPage extends StatefulWidget {
  const BookDetailPage({super.key, required this.book, required this.store});

  final Book book;
  final StoreController store;

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  bool _busy = false;

  Future<void> _buyNow() async {
    setState(() => _busy = true);
    await runCheckout(context, widget.store, books: [widget.book]);
    if (mounted) setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    final book = widget.book;
    final store = widget.store;

    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final owned = store.owns(book);
        final inCart = store.inCart(book);

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        book.color.withValues(alpha: 0.28),
                        const Color(0xFFF3F5F9),
                      ],
                    ),
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(12, 8, 0, 0),
                            child: IconButton.filled(
                              onPressed: () => Navigator.pop(context),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black87,
                              ),
                              icon: const PhosphorIcon(
                                PhosphorIconsBold.caretLeft,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 190,
                          height: 285,
                          child: BookCover(book: book, radius: 14),
                        ),
                        const SizedBox(height: 28),
                      ],
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                sliver: SliverList.list(
                  children: [
                    Text(
                      book.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      book.author,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        _Stat(
                          icon: PhosphorIconsRegular.bookOpenText,
                          label: 'Pages',
                          value: '${book.pages}',
                        ),
                        _Stat(
                          icon: PhosphorIconsRegular.tag,
                          label: 'Category',
                          value: book.category,
                        ),
                        const _Stat(
                          icon: PhosphorIconsRegular.fileText,
                          label: 'Format',
                          value: 'PDF · ePub',
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'About this book',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      book.description,
                      style: const TextStyle(
                        fontSize: 15.5,
                        height: 1.6,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
                child: owned
                    ? FilledButton.icon(
                        onPressed: () {},
                        icon: const PhosphorIcon(
                          PhosphorIconsFill.bookOpenText,
                          size: 20,
                        ),
                        label: const Text('Read now'),
                        style: _buttonStyle(const Color(0xFF1E9E5A)),
                      )
                    : Row(
                        children: [
                          IconButton.outlined(
                            onPressed: _busy
                                ? null
                                : () => inCart
                                      ? store.removeFromCart(book)
                                      : store.addToCart(book),
                            style: IconButton.styleFrom(
                              minimumSize: const Size(54, 54),
                              side: BorderSide(
                                color: inCart
                                    ? const Color(0xFF635BFF)
                                    : Colors.black26,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            icon: PhosphorIcon(
                              inCart
                                  ? PhosphorIconsFill.shoppingBag
                                  : PhosphorIconsRegular.shoppingBag,
                              color: inCart
                                  ? const Color(0xFF635BFF)
                                  : Colors.black87,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: FilledButton(
                              onPressed: _busy ? null : _buyNow,
                              style: _buttonStyle(const Color(0xFF635BFF)),
                              child: _busy
                                  ? const SizedBox(
                                      height: 22,
                                      width: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text('Buy now · ${book.priceLabel}'),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        );
      },
    );
  }

  ButtonStyle _buttonStyle(Color color) => FilledButton.styleFrom(
    backgroundColor: color,
    minimumSize: const Size.fromHeight(54),
    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  );
}

class _Stat extends StatelessWidget {
  const _Stat({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            PhosphorIcon(icon, size: 22, color: const Color(0xFF635BFF)),
            const SizedBox(height: 8),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.black45),
            ),
          ],
        ),
      ),
    );
  }
}
