import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ssma/features/presets/models/stream_preset.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('ssma_presets.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {

    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final dbPath = await getApplicationDocumentsDirectory();
    final path = join(dbPath.path, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE presets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        categoryName TEXT NOT NULL,
        categoryImageUrl TEXT,
        tags TEXT NOT NULL,
        isMature INTEGER NOT NULL,
        deletedDate TEXT
      )
    ''');
  }

  Future<int> createPreset(StreamPreset preset) async {
    final db = await instance.database;
    return await db.insert('presets', preset.toMap());
  }

  Future<List<StreamPreset>> getAllPresets() async {
    final db = await instance.database;
    final result = await db.query('presets', where: 'deletedDate IS NULL', orderBy: 'id DESC');
    return result.map((json) => StreamPreset.fromMap(json)).toList();
  }
}