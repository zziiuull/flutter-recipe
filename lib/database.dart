import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'receitas.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE receitas(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo TEXT,
            ingredientes TEXT,
            preparo TEXT
          )
        ''');
      },
    );
  }

  Future<int> inserirReceita(
    String titulo,
    String ingredientes,
    String preparo,
  ) async {
    Database db = await database;
    return await db.insert('receitas', {
      'titulo': titulo,
      'ingredientes': ingredientes,
      'preparo': preparo,
    });
  }

  Future<List<Map<String, dynamic>>> buscarReceitas() async {
    Database db = await database;
    return await db.query('receitas');
  }

  Future<int> atualizarReceita(
    int id,
    String titulo,
    String ingredientes,
    String preparo,
  ) async {
    Database db = await database;
    return await db.update(
      'receitas',
      {'titulo': titulo, 'ingredientes': ingredientes, 'preparo': preparo},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deletarReceita(int id) async {
    Database db = await database;
    return await db.delete('receitas', where: 'id = ?', whereArgs: [id]);
  }
}
