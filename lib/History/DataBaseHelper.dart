import 'dart:io'; 
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'HistoryItem.dart';

class DatabaseHelperHistory {
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
      
      await db.execute(
        '''CREATE TABLE IF NOT EXISTS historyItems(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          originalText TEXT,
          translatedText TEXT,
          fromLanguage TEXT,
          toLanguage TEXT,
          fromFlag TEXT,
          toFlag TEXT
        )''',
      );
    });
  }

  
  static Future<String> _getIOSDatabasePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return join(directory.path, 'history_ios.db'); 
  }

 
  static Future<String> _getAndroidDatabasePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return join(directory.path, 'history_android.db');
  }

  
  static Future<void> insertHistory(HistoryItem item) async {
    final db = await database;
    await db.insert('historyItems', item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  
  static Future<List<HistoryItem>> getHistory() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('historyItems');

    return List.generate(maps.length, (i) {
      return HistoryItem(
        id: maps[i]['id'],
        originalText: maps[i]['originalText'],
        translatedText: maps[i]['translatedText'],
        fromLanguage: maps[i]['fromLanguage'],
        toLanguage: maps[i]['toLanguage'],
        fromFlag: maps[i]['fromFlag'],
        toFlag: maps[i]['toFlag'],
      );
    });
  }

 
  static Future<void> clearHistory() async {
    final db = await database;
    await db.delete('historyItems');
  }
}
