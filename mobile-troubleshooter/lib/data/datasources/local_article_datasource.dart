import '../../core/db/database_helper.dart';
import '../models/article_model.dart';

abstract class LocalArticleDatasource {
  Future<List<ArticleModel>> getAllArticles();
  Future<List<ArticleModel>> searchArticles(String query);
  Future<ArticleModel?> getArticleById(String id);
}

class LocalArticleDatasourceImpl implements LocalArticleDatasource {
  final DatabaseHelper databaseHelper;

  LocalArticleDatasourceImpl({required this.databaseHelper});

  @override
  Future<List<ArticleModel>> getAllArticles() async {
    final db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('articles', orderBy: 'date DESC');
    return List.generate(maps.length, (i) {
      return ArticleModel.fromJson(maps[i]);
    });
  }

  @override
  Future<List<ArticleModel>> searchArticles(String query) async {
    final db = await databaseHelper.database;
    final sanitizedQuery = query.replaceAll(RegExp(r'[^\w\s]+'), '').trim();
    if (sanitizedQuery.isEmpty) {
      return [];
    }

    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT a.* FROM articles a
      JOIN articles_fts fts ON a.rowid = fts.rowid
      WHERE articles_fts MATCH ? ORDER BY rank
    ''', [sanitizedQuery]);

    return List.generate(maps.length, (i) {
      return ArticleModel.fromJson(maps[i]);
    });
  }

  @override
  Future<ArticleModel?> getArticleById(String id) async {
    final db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'articles',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return ArticleModel.fromJson(maps.first);
    }
    return null;
  }
}
