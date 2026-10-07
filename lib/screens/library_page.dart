import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../services/store_controller.dart';
import '../widgets/book_cover.dart';
import '../widgets/empty_state.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key, required this.store});

  final StoreController store;

  @override
  Widget build(BuildContext context) {
    final books = store.ownedBooks;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: Text(
            'My library',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
        ),
        Expanded(
          child: books.isEmpty
              ? const EmptyState(
                  icon: PhosphorIconsDuotone.books,
                  title: 'Nothing here yet',
                  message: 'Books you buy will show up here, ready to read.',
                )
              : GridView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.55,
                  ),
                  itemCount: books.length,
                  itemBuilder: (_, i) {
                    final b = books[i];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SizedBox.expand(
                            child: BookCover(book: b, hero: false),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          b.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 2),
                        const Row(
                          children: [
                            PhosphorIcon(
                              PhosphorIconsFill.checkCircle,
                              size: 14,
                              color: Color(0xFF1E9E5A),
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Purchased',
                              style: TextStyle(
                                color: Color(0xFF1E9E5A),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
        ),
      ],
    );
  }
}
