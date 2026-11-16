import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();

    final path = join(databasePath, 'expense.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        amount REAL NOT NULL,
        date TEXT NOT NULL,
        category TEXT NOT NULL,
        is_income INTEGER NOT NULL DEFAULT 0,
        note TEXT NOT NULL DEFAULT ''
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
        "ALTER TABLE transactions ADD COLUMN is_income INTEGER NOT NULL DEFAULT 0",
      );
      await db.execute(
        "ALTER TABLE transactions ADD COLUMN note TEXT NOT NULL DEFAULT ''",
      );
    }
  }

  Future<int> insertTransaction(Map<String, dynamic> data) async {
    final db = await database;

    return await db.insert('transactions', data);
  }

  Future<List<Map<String, dynamic>>> getTransactions() async {
    final db = await database;

    return await db.query('transactions', orderBy: 'id DESC');
  }

  Future<int> updateTransaction(int id, Map<String, dynamic> data) async {
    final db = await database;

    return await db.update(
      'transactions',
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteTransaction(int id) async {
    final db = await database;

    return await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }
}
