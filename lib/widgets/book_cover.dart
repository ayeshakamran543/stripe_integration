import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../models/book.dart';

class BookCover extends StatelessWidget {
  const BookCover({
    super.key,
    required this.book,
    this.radius = 12,
    this.hero = true,
  });

  final Book book;
  final double radius;
  final bool hero;

  @override
  Widget build(BuildContext context) {
    final cover = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: CachedNetworkImage(
          imageUrl: book.coverUrl,
          fit: BoxFit.cover,
          fadeInDuration: const Duration(milliseconds: 250),
          placeholder: (_, _) =>
              ColoredBox(color: book.color.withValues(alpha: 0.15)),
          errorWidget: (_, _, _) => _Fallback(book: book),
        ),
      ),
    );
    return hero ? Hero(tag: 'cover-${book.id}', child: cover) : cover;
  }
}

class _Fallback extends StatelessWidget {
  const _Fallback({required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: book.color,
      padding: const EdgeInsets.all(12),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const PhosphorIcon(
            PhosphorIconsFill.bookOpenText,
            color: Colors.white,
            size: 36,
          ),
          const SizedBox(height: 8),
          Text(
            book.title,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
