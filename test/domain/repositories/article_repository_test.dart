import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mobile_troubleshooter/data/datasources/local_article_datasource.dart';
import 'package:mobile_troubleshooter/data/repositories/article_repository_impl.dart';
import 'package:mobile_troubleshooter/domain/entities/article.dart';

import 'article_repository_test.mocks.dart';

@GenerateMocks([LocalArticleDatasource])
void main() {
  late MockLocalArticleDatasource mockLocalDatasource;
  late ArticleRepositoryImpl repository;

  setUp(() {
    mockLocalDatasource = MockLocalArticleDatasource();
    repository = ArticleRepositoryImpl(localDatasource: mockLocalDatasource);
  });

  final tArticle = Article(
    id: 'art001',
    title: 'Test Article',
    author: 'Tester',
    date: DateTime.now(),
    isPremium: false,
    tags: ['test'],
    content: 'This is a test.',
  );

  group('getAllArticles', () {
    test('should call getAllArticles from the datasource', () async {
      // arrange
      when(mockLocalDatasource.getAllArticles()).thenAnswer((_) async => [tArticle]);
      // act
      await repository.getAllArticles();
      // assert
      verify(mockLocalDatasource.getAllArticles());
      verifyNoMoreInteractions(mockLocalDatasource);
    });
  });

  group('searchArticles', () {
    const tQuery = 'test';
    test('should call searchArticles from the datasource', () async {
      // arrange
      when(mockLocalDatasource.searchArticles(tQuery)).thenAnswer((_) async => [tArticle]);
      // act
      await repository.searchArticles(tQuery);
      // assert
      verify(mockLocalDatasource.searchArticles(tQuery));
      verifyNoMoreInteractions(mockLocalDatasource);
    });
  });

  group('getArticleById', () {
    const tId = 'art001';
    test('should call getArticleById from the datasource', () async {
      // arrange
      when(mockLocalDatasource.getArticleById(tId)).thenAnswer((_) async => tArticle);
      // act
      await repository.getArticleById(tId);
      // assert
      verify(mockLocalDatasource.getArticleById(tId));
      verifyNoMoreInteractions(mockLocalDatasource);
    });
  });
}
