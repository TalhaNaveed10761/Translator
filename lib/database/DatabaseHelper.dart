import 'dart:io'; 
import 'package:flutter_application_26/bottomnavigationscreen/FavouriteItem.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

 
  static Future<Database> _initDatabase() async {
    String path;

    if (Platform.isIOS) {
      path = await _getIOSDatabasePath();
    } else if (Platform.isAndroid) {
      path = await _getAndroidDatabasePath();
    } else {
      throw Exception("Unsupported platform");
    }

    return await openDatabase(path, version: 1, onCreate: (db, version) async {
     
      await db.execute(''' 
        CREATE TABLE IF NOT EXISTS favorites(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          originalText TEXT,
          translatedText TEXT,
          fromLanguage TEXT,
          toLanguage TEXT,
          fromFlag TEXT,
          toFlag TEXT
        )
      ''');
    });
  }

 
  static Future<String> _getIOSDatabasePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return join(directory.path, 'favorites_ios.db'); 
  }


  static Future<String> _getAndroidDatabasePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return join(directory.path, 'favorites_android.db');
  }


  static Future<void> insertFavorite(FavoriteItem item) async {
    final db = await database;
    await db.insert(
      'favorites',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

 
  static Future<List<FavoriteItem>> getFavorites() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('favorites');
    return List.generate(maps.length, (i) {
      return FavoriteItem.fromMap(maps[i]);
    });
  }

  static Future<void> deleteFavorite(int id) async {
    final db = await database;
    await db.delete(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

 
  static Future<void> closeDatabase() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
