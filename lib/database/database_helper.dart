// database_helper.dart

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('profitf5.db');

    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();

    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE usuarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        senha TEXT NOT NULL
      )
    ''');
  }

  // CADASTRAR USUARIO
  Future<int> cadastrarUsuario(
    String nome,
    String email,
    String senha,
  ) async {
    final db = await instance.database;

    return await db.insert(
      'usuarios',
      {
        'nome': nome,
        'email': email,
        'senha': senha,
      },
    );
  }

  // LOGIN
  Future<Map<String, dynamic>?> login(
    String email,
    String senha,
  ) async {
    final db = await instance.database;

    final result = await db.query(
      'usuarios',
      where: 'email = ? AND senha = ?',
      whereArgs: [email, senha],
    );

    if (result.isNotEmpty) {
      return result.first;
    }

    return null;
  }

  // FECHAR BANCO
  Future close() async {
    final db = await instance.database;

    db.close();
  }
}