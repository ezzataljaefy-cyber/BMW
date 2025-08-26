import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../domain/entities/article.dart';
import '../../providers/article_providers.dart';

// Provider to fetch a single article by its ID
final articleDetailProvider = FutureProvider.family<Article?, String>((ref, id) {
  final getArticleById = ref.watch(getArticleByIdProvider);
  return getArticleById(id);
});

class ArticleDetailScreen extends ConsumerStatefulWidget {
  final String articleId;

  const ArticleDetailScreen({Key? key, required this.articleId}) : super(key: key);

  @override
  ConsumerState<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends ConsumerState<ArticleDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Log the article view event when the screen is first built
    ref.read(articleDetailProvider(widget.articleId).future).then((article) {
      if (article != null) {
        ref.read(analyticsServiceProvider).logArticleView(article.id, article.title);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final articleValue = ref.watch(articleDetailProvider(widget.articleId));

    return Scaffold(
      appBar: AppBar(
        title: articleValue.when(
          data: (article) => Text(article?.title ?? 'Article'),
          loading: () => const Text('Loading...'),
          error: (_, __) => const Text('Error'),
        ),
      ),
      body: articleValue.when(
        data: (article) {
          if (article == null) {
            return const Center(child: Text('Article not found.'));
          }

          // Check for premium content
          if (article.isPremium) {
            // Here you would check the user's subscription status
            bool isSubscribed = false; // Placeholder
            if (!isSubscribed) {
              return _buildPremiumBlocker(context);
            }
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'By ${article.author} on ${article.date.toLocal().toString().substring(0, 10)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const Divider(height: 32),
                Html(
                  data: article.content,
                  // You can customize styling for HTML elements here
                  style: {
                    "h1": Style(fontSize: FontSize.xxLarge),
                    "p": Style(fontSize: FontSize.large, lineHeight: LineHeight.em(1.5)),
                    "ul": Style(fontSize: FontSize.large),
                  },
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Failed to load article: $err')),
      ),
      bottomNavigationBar: _buildActionBar(context),
    );
  }

  Widget _buildPremiumBlocker(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock, size: 60, color: Colors.amber.shade700),
            const SizedBox(height: 20),
            Text(
              'Premium Article',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Subscribe to unlock this and other premium articles.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: Navigate to subscription screen
              },
              child: const Text('Subscribe Now'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.download_for_offline_outlined),
            tooltip: 'Save Offline',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Offline saving not implemented yet.')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            tooltip: 'Bookmark',
            onPressed: () {
               ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Bookmarking not implemented yet.')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.check_circle_outline),
            tooltip: 'Mark as Solved',
            onPressed: () {
               ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Mark as solved not implemented yet.')),
              );
            },
          ),
        ],
      ),
    );
  }
}
