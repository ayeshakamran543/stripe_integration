import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../models/book.dart';
import '../services/store_controller.dart';
import '../widgets/book_cover.dart';
import 'book_detail_page.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key, required this.store});

  final StoreController store;

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  String _category = 'All';
  String _query = '';

  List<String> get _categories => [
    'All',
    ...{for (final b in catalog) b.category},
  ];

  void _open(Book book) => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => BookDetailPage(book: book, store: widget.store),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final q = _query.trim().toLowerCase();
    final books = catalog.where((b) {
      final inCategory = _category == 'All' || b.category == _category;
      final matches =
          q.isEmpty ||
          b.title.toLowerCase().contains(q) ||
          b.author.toLowerCase().contains(q);
      return inCategory && matches;
    }).toList();
    final showFeatured = q.isEmpty && _category == 'All';

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Discover',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Your next favourite read, one tap away',
                  style: TextStyle(color: Colors.black54, fontSize: 15),
                ),
                const SizedBox(height: 18),
                TextField(
                  onChanged: (v) => setState(() => _query = v),
                  decoration: InputDecoration(
                    hintText: 'Search title or author',
                    prefixIcon: const Padding(
                      padding: EdgeInsets.all(12),
                      child: PhosphorIcon(
                        PhosphorIconsRegular.magnifyingGlass,
                        size: 20,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 64,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              itemCount: _categories.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final c = _categories[i];
                final selected = c == _category;
                return ChoiceChip(
                  label: Text(c),
                  selected: selected,
                  showCheckmark: false,
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                  selectedColor: const Color(0xFF1B1B1F),
                  backgroundColor: Colors.white,
                  side: BorderSide.none,
                  shape: const StadiumBorder(),
                  onSelected: (_) => setState(() => _category = c),
                );
              },
            ),
          ),
        ),
        if (showFeatured) ...[
          const _SectionTitle('Featured'),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 270,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: 4,
                separatorBuilder: (_, _) => const SizedBox(width: 16),
                itemBuilder: (_, i) => SizedBox(
                  width: 150,
                  child: _BookTile(
                    book: catalog[i],
                    owned: widget.store.owns(catalog[i]),
                    onTap: () => _open(catalog[i]),
                    heroSuffix: 'featured',
                  ),
                ),
              ),
            ),
          ),
          const _SectionTitle('All books'),
        ],
        if (books.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Text(
                'No books found',
                style: TextStyle(color: Colors.black45),
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            sliver: SliverGrid.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                mainAxisSpacing: 20,
                crossAxisSpacing: 16,
                childAspectRatio: 0.52,
              ),
              itemCount: books.length,
              itemBuilder: (_, i) => _BookTile(
                book: books[i],
                owned: widget.store.owns(books[i]),
                onTap: () => _open(books[i]),
              ),
            ),
          ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
        child: Text(
          text,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}

class _BookTile extends StatelessWidget {
  const _BookTile({
    required this.book,
    required this.owned,
    required this.onTap,
    this.heroSuffix,
  });

  final Book book;
  final bool owned;
  final VoidCallback onTap;
  final String? heroSuffix;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  // Featured and grid tiles can show the same book on one
                  // screen, so only the grid copy takes part in the Hero.
                  child: heroSuffix == null
                      ? BookCover(book: book)
                      : BookCover(book: book, hero: false),
                ),
                if (owned)
                  const Positioned(
                    top: 8,
                    right: 8,
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.white,
                      child: PhosphorIcon(
                        PhosphorIconsFill.checkCircle,
                        size: 22,
                        color: Color(0xFF1E9E5A),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            book.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          ),
          const SizedBox(height: 2),
          Text(
            book.author,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.black54, fontSize: 13),
          ),
          const SizedBox(height: 6),
          Text(
            owned ? 'Owned' : book.priceLabel,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: owned ? const Color(0xFF1E9E5A) : const Color(0xFF635BFF),
            ),
          ),
        ],
      ),
    );
  }
}
