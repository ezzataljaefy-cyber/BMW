import '../entities/article.dart';

abstract class ArticleRepository {
  Future<List<Article>> getAllArticles();
  Future<List<Article>> searchArticles(String query);
  Future<Article?> getArticleById(String id);
  Future<void> saveArticleOffline(Article article);
  Future<void> removeArticleFromOffline(String id);
  Future<List<Article>> getOfflineArticles();
}
