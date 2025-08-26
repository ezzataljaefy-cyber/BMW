import '../entities/article.dart';
import '../repositories/article_repository.dart';

class GetAllArticles {
  final ArticleRepository repository;

  GetAllArticles(this.repository);

  Future<List<Article>> call() async {
    return await repository.getAllArticles();
  }
}
