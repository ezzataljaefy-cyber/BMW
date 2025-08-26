import '../../domain/entities/article.dart';
import '../../domain/repositories/article_repository.dart';
import '../datasources/local_article_datasource.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final LocalArticleDatasource localDatasource;

  ArticleRepositoryImpl({required this.localDatasource});

  @override
  Future<List<Article>> getAllArticles() {
    return localDatasource.getAllArticles();
  }

  @override
  Future<List<Article>> searchArticles(String query) {
    return localDatasource.searchArticles(query);
  }

  @override
  Future<Article?> getArticleById(String id) {
    return localDatasource.getArticleById(id);
  }

  // The following methods are for offline functionality, which will be fully
  // implemented later. For now, they are placeholders.

  @override
  Future<void> saveArticleOffline(Article article) async {
    // In a real app, we'd have a separate table for offline articles
    // or a flag in the main table.
    print('Simulating saving article ${article.id} for offline use.');
    await Future.delayed(const Duration(milliseconds: 100));
  }

  @override
  Future<void> removeArticleFromOffline(String id) async {
    print('Simulating removing article $id from offline storage.');
    await Future.delayed(const Duration(milliseconds: 100));
  }

  @override
  Future<List<Article>> getOfflineArticles() async {
    print('Simulating fetching offline articles.');
    return [];
  }
}
