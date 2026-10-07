import 'package:flutter/material.dart';

class Book {
  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.priceCents,
    required this.pages,
    required this.category,
    required this.isbn,
    required this.color,
  });

  final String id;
  final String title;
  final String author;
  final String description;
  final int priceCents;
  final int pages;
  final String category;
  final String isbn;

  /// Tint shown while the cover loads or if it fails to load.
  final Color color;

  String get coverUrl =>
      'https://covers.openlibrary.org/b/isbn/$isbn-L.jpg?default=false';

  String get priceLabel => formatPrice(priceCents);
}

String formatPrice(int cents) => '\$${(cents / 100).toStringAsFixed(2)}';

// Prices here are for display only. The server (functions/index.js) is the
// source of truth for what is actually charged.
const List<Book> catalog = [
  Book(
    id: 'atomic-habits',
    title: 'Atomic Habits',
    author: 'James Clear',
    description:
        'A practical guide to building good habits and breaking bad ones, '
        'using tiny changes that compound into remarkable results.',
    priceCents: 1299,
    pages: 320,
    category: 'Self-help',
    isbn: '9780735211292',
    color: Color(0xFFE8863A),
  ),
  Book(
    id: 'deep-work',
    title: 'Deep Work',
    author: 'Cal Newport',
    description:
        'Rules for focused success in a distracted world. Learn to master '
        'hard things quickly and produce at an elite level.',
    priceCents: 1199,
    pages: 296,
    category: 'Productivity',
    isbn: '9781455586691',
    color: Color(0xFF3C4F9E),
  ),
  Book(
    id: 'the-alchemist',
    title: 'The Alchemist',
    author: 'Paulo Coelho',
    description:
        'A shepherd boy travels from Spain to Egypt in search of treasure '
        'and discovers the meaning of following your dreams.',
    priceCents: 899,
    pages: 208,
    category: 'Fiction',
    isbn: '9780062315007',
    color: Color(0xFFD9A441),
  ),
  Book(
    id: 'clean-code',
    title: 'Clean Code',
    author: 'Robert C. Martin',
    description:
        'A handbook of agile software craftsmanship. Write code that is '
        'readable, maintainable and a pleasure to work with.',
    priceCents: 2499,
    pages: 464,
    category: 'Programming',
    isbn: '9780132350884',
    color: Color(0xFF2F8F6B),
  ),
  Book(
    id: 'psychology-of-money',
    title: 'The Psychology of Money',
    author: 'Morgan Housel',
    description:
        'Timeless lessons on wealth, greed and happiness, told through '
        'short stories about how people think about money.',
    priceCents: 1399,
    pages: 256,
    category: 'Finance',
    isbn: '9780857197689',
    color: Color(0xFF2F6F7E),
  ),
  Book(
    id: 'flutter-in-action',
    title: 'Flutter in Action',
    author: 'Eric Windmill',
    description:
        'Build beautiful cross-platform apps with Flutter, from widgets and '
        'layouts to state management and platform integration.',
    priceCents: 1999,
    pages: 368,
    category: 'Programming',
    isbn: '9781617296147',
    color: Color(0xFF2A8FB8),
  ),
];
