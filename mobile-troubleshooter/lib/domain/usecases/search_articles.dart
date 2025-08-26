import '../entities/article.dart';
import '../repositories/article_repository.dart';

class SearchArticles {
  final ArticleRepository repository;

  SearchArticles(this.repository);

  Future<List<Article>> call(String query) async {
    if (query.isEmpty) {
      return [];
    }
    return await repository.searchArticles(query);
  }
}
