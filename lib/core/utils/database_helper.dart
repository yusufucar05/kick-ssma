import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ssma/domain/models/stream_preset.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('ssma_final_v4.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
    final dbPath = await getApplicationDocumentsDirectory();
    final path = join(dbPath.path, filePath);
    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _onUpgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE presets (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      categoryName TEXT NOT NULL,
      categoryImageUrl TEXT,
      categoryId INTEGER,
      tags TEXT,
      isMature INTEGER NOT NULL,
      createdDate TEXT NOT NULL,
      deletedDate TEXT
    )
  ''');
  }

  Future<int> createPreset(StreamPreset preset) async {
    final db = await instance.database;
    final map = preset.toMap();
    map.remove('id'); 
    return await db.insert('presets', map);
  }

  Future<List<StreamPreset>> getAllPresets() async {
    final db = await instance.database;
    final result = await db.query(
      'presets',
      where: 'deletedDate IS NULL',
      orderBy: 'id DESC',
    );
    return result.map((json) => StreamPreset.fromMap(json)).toList();
  }

  Future<int> updatePreset(StreamPreset preset) async {
    final db = await instance.database;
    return await db.update(
      'presets',
      preset.toMap(),
      where: 'id = ?',
      whereArgs: [preset.id],
    );
  }

  Future _onUpgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      
      final columns = await db.rawQuery('PRAGMA table_info(presets)');
      final columnNames = columns.map((c) => c['name'] as String).toList();

      if (!columnNames.contains('createdDate')) {
        await db.execute("ALTER TABLE presets ADD COLUMN createdDate TEXT NOT NULL DEFAULT ''");
      }
      if (!columnNames.contains('deletedDate')) {
        await db.execute("ALTER TABLE presets ADD COLUMN deletedDate TEXT");
      }
    }
  }
  Future<List<StreamPreset>> getDeletedPresets() async {
    final db = await instance.database;
    final result = await db.query(
      'presets',
      where: 'deletedDate IS NOT NULL',
      orderBy: 'deletedDate DESC',
    );
    return result.map((json) => StreamPreset.fromMap(json)).toList();
  }

  Future<void> softDeletePreset(int id) async {
    final db = await instance.database;
    await db.update(
      'presets',
      {'deletedDate': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> restorePreset(int id) async {
    final db = await instance.database;
    await db.update(
      'presets',
      {'deletedDate': null},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> permanentDeletePreset(int id) async {
    final db = await instance.database;
    await db.delete('presets', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> cleanupExpiredPresets() async {
    final db = await instance.database;
    final cutoff = DateTime.now().subtract(const Duration(days: 4)).toIso8601String();
    await db.delete(
      'presets',
      where: 'deletedDate IS NOT NULL AND deletedDate < ?',
      whereArgs: [cutoff],
    );
  }
}
