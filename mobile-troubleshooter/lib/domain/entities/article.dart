import 'package:flutter/foundation.dart';

@immutable
class Article {
  final String id;
  final String title;
  final String author;
  final DateTime date;
  final bool isPremium;
  final List<String> tags;
  final String content; // This will be HTML/Markdown content

  const Article({
    required this.id,
    required this.title,
    required this.author,
    required this.date,
    required this.isPremium,
    required this.tags,
    required this.content,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Article &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
