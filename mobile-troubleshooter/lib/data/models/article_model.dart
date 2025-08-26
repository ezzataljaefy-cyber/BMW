import '../../domain/entities/article.dart';

class ArticleModel extends Article {
  const ArticleModel({
    required String id,
    required String title,
    required String author,
    required DateTime date,
    required bool isPremium,
    required List<String> tags,
    required String content,
  }) : super(
          id: id,
          title: title,
          author: author,
          date: date,
          isPremium: isPremium,
          tags: tags,
          content: content,
        );

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id'],
      title: json['title'],
      author: json['author'] ?? 'Unknown Author',
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      isPremium: json['isPremium'] ?? false,
      tags: List<String>.from(json['tags'] ?? []),
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'date': date.toIso8601String(),
      'isPremium': isPremium,
      'tags': tags,
      'content': content,
    };
  }
}
