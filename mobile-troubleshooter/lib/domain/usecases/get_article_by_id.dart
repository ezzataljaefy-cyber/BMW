import '../entities/article.dart';
import '../repositories/article_repository.dart';

class GetArticleById {
  final ArticleRepository repository;

  GetArticleById(this.repository);

  Future<Article?> call(String id) async {
    return await repository.getArticleById(id);
  }
}
