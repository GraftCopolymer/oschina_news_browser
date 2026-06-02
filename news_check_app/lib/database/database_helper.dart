import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  Database? _database;
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'news_check.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE cache_items (
        item_type TEXT NOT NULL,
        item_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        author TEXT NOT NULL,
        pub_date TEXT NOT NULL,
        body TEXT NOT NULL,
        local_body TEXT,
        cached_at INTEGER NOT NULL,
        PRIMARY KEY (item_type, item_id)
      )
    ''');

    await db.execute('''
      CREATE TABLE image_cache (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cache_key TEXT NOT NULL,
        original_url TEXT NOT NULL,
        local_path TEXT,
        status TEXT NOT NULL DEFAULT 'pending',
        UNIQUE(cache_key, original_url)
      )
    ''');

    await db.execute('''
      CREATE TABLE read_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        item_type TEXT NOT NULL,
        item_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        word_count INTEGER NOT NULL,
        read_at INTEGER NOT NULL
      )
    ''');

    await db.execute('CREATE INDEX idx_read_history_read_at ON read_history(read_at)');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // 预留迁移入口
  }
}