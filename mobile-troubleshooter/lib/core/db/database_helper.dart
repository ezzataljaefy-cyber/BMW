import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'articles.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Main table to store articles
    await db.execute('''
      CREATE TABLE articles(
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        author TEXT,
        date TEXT,
        isPremium BOOLEAN NOT NULL,
        tags TEXT,
        content TEXT NOT NULL
      )
    ''');

    // FTS5 virtual table for full-text search
    await db.execute('''
      CREATE VIRTUAL TABLE articles_fts USING fts5(
        title,
        content,
        content='articles',
        content_rowid='rowid'
      )
    ''');

    // Trigger to keep FTS table in sync with the articles table
    await db.execute('''
      CREATE TRIGGER articles_ai AFTER INSERT ON articles BEGIN
        INSERT INTO articles_fts(rowid, title, content) VALUES (new.rowid, new.title, new.content);
      END;
    ''');
    await db.execute('''
      CREATE TRIGGER articles_ad AFTER DELETE ON articles BEGIN
        INSERT INTO articles_fts(articles_fts, rowid, title, content) VALUES ('delete', old.rowid, old.title, old.content);
      END;
    ''');
    await db.execute('''
      CREATE TRIGGER articles_au AFTER UPDATE ON articles BEGIN
        INSERT INTO articles_fts(articles_fts, rowid, title, content) VALUES ('delete', old.rowid, old.title, old.content);
        INSERT INTO articles_fts(rowid, title, content) VALUES (new.rowid, new.title, new.content);
      END;
    ''');

    // Populate with demo data
    await _populateWithDemoData(db);
  }

  Future<void> _populateWithDemoData(Database db) async {
    final String response = await rootBundle.loadString('demo-data/articles.json');
    final data = await json.decode(response);
    final List<dynamic> articles = data['articles'];

    final batch = db.batch();
    for (var article in articles) {
      batch.insert('articles', article, conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }
}
