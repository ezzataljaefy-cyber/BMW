import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/database_helper.dart';
import '../../data/datasources/local_article_datasource.dart';
import '../../data/repositories/article_repository_impl.dart';
import '../../domain/entities/article.dart';
import '../../domain/repositories/article_repository.dart';
import '../../domain/usecases/get_all_articles.dart';
import '../../domain/usecases/search_articles.dart';
import '../../domain/usecases/get_article_by_id.dart';

// 1. Data Layer Providers
final databaseHelperProvider = Provider<DatabaseHelper>((ref) => DatabaseHelper());

final localArticleDatasourceProvider = Provider<LocalArticleDatasource>((ref) {
  return LocalArticleDatasourceImpl(databaseHelper: ref.watch(databaseHelperProvider));
});

final articleRepositoryProvider = Provider<ArticleRepository>((ref) {
  return ArticleRepositoryImpl(localDatasource: ref.watch(localArticleDatasourceProvider));
});

// 2. Domain Layer (Use Case) Providers
final getAllArticlesProvider = Provider<GetAllArticles>((ref) {
  return GetAllArticles(ref.watch(articleRepositoryProvider));
});

final searchArticlesProvider = Provider<SearchArticles>((ref) {
  return SearchArticles(ref.watch(articleRepositoryProvider));
});

final getArticleByIdProvider = Provider<GetArticleById>((ref) {
  return GetArticleById(ref.watch(articleRepositoryProvider));
});


// 3. Presentation Layer (State) Providers

// Provider to fetch all articles
final articlesProvider = FutureProvider<List<Article>>((ref) async {
  return ref.watch(getAllArticlesProvider).call();
});

// Provider for the search query state
final searchQueryProvider = StateProvider<String>((ref) => '');

// Provider to perform the search based on the query
final searchedArticlesProvider = FutureProvider<List<Article>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) {
    return [];
  }
  return ref.watch(searchArticlesProvider).call(query);
});
