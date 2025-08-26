import 'package:flutter/material.dart';
import '../../domain/entities/article.dart';
import '../screens/article_detail/article_detail_screen.dart';

class ArticleListItem extends StatelessWidget {
  final Article article;

  const ArticleListItem({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ArticleDetailScreen(articleId: article.id),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (article.isPremium)
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber.shade700, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      'Premium',
                      style: TextStyle(
                        color: Colors.amber.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              if (article.isPremium) const SizedBox(height: 8),
              Text(
                article.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                // A simple excerpt - in a real app, you'd parse and truncate HTML
                article.content.replaceAll(RegExp(r'<[^>]*>'), ' ').substring(0, 100) + '...',
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    article.author,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Spacer(),
                  Text(
                    '${article.date.day}/${article.date.month}/${article.date.year}',
                     style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
