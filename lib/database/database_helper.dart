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
      version: 3,
      onCreate: _createDB,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // adicionar colunas de dados físicos
          try {
            await db.execute('ALTER TABLE usuarios ADD COLUMN idade INTEGER');
          } catch (_) {}

          try {
            await db.execute('ALTER TABLE usuarios ADD COLUMN peso REAL');
          } catch (_) {}

          try {
            await db.execute('ALTER TABLE usuarios ADD COLUMN altura REAL');
          } catch (_) {}
        }
        if (oldVersion < 3) {
          // adicionar coluna objetivo
          try {
            await db.execute('ALTER TABLE usuarios ADD COLUMN objetivo TEXT');
          } catch (_) {}
        }
      },
      onOpen: (db) async {
        await _ensureColumn(db, 'usuarios', 'idade', 'INTEGER');
        await _ensureColumn(db, 'usuarios', 'peso', 'REAL');
        await _ensureColumn(db, 'usuarios', 'altura', 'REAL');
        await _ensureColumn(db, 'usuarios', 'objetivo', 'TEXT');
      },
    );
  }

  Future<bool> _hasColumn(Database db, String table, String column) async {
    final info = await db.rawQuery("PRAGMA table_info($table)");

    return info.any((row) {
      final name = row['name'];
      return name is String && name == column;
    });
  }

  Future<void> _ensureColumn(
    Database db,
    String table,
    String column,
    String columnType,
  ) async {
    final hasColumn = await _hasColumn(db, table, column);

    if (!hasColumn) {
      try {
        await db.execute('ALTER TABLE $table ADD COLUMN $column $columnType');
      } catch (_) {}
    }
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE usuarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        senha TEXT NOT NULL,
        idade INTEGER,
        peso REAL,
        altura REAL,
        objetivo TEXT
      )
    ''');
  }

  // CADASTRAR USUARIO
  Future<int> cadastrarUsuario(
    String nome,
    String email,
    String senha, {
    int? idade,
    double? peso,
    double? altura,
    String? objetivo,
  }) async {
    final db = await instance.database;

    return await db.insert('usuarios', {
      'nome': nome,
      'email': email,
      'senha': senha,
      'idade': idade,
      'peso': peso,
      'altura': altura,
      'objetivo': objetivo,
    });
  }

  // LOGIN
  Future<Map<String, dynamic>?> login(String email, String senha) async {
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

  // OBTER USUÁRIO POR ID
  Future<Map<String, dynamic>?> getUsuarioById(int id) async {
    final db = await instance.database;

    final result = await db.query('usuarios', where: 'id = ?', whereArgs: [id]);

    if (result.isNotEmpty) return result.first;

    return null;
  }

  // OBTER USUÁRIO POR EMAIL
  Future<Map<String, dynamic>?> getUsuarioByEmail(String email) async {
    final db = await instance.database;

    final result = await db.query(
      'usuarios',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (result.isNotEmpty) return result.first;

    return null;
  }

  // ATUALIZAR USUÁRIO (nome, email, senha, dados físicos, objetivo)
  Future<int> atualizarUsuario(
    int id, {
    String? nome,
    String? email,
    String? senha,
    int? idade,
    double? peso,
    double? altura,
    String? objetivo,
  }) async {
    final db = await instance.database;

    final Map<String, Object?> values = {};

    if (nome != null) values['nome'] = nome;
    if (email != null) values['email'] = email;
    if (senha != null) values['senha'] = senha;
    if (idade != null) values['idade'] = idade;
    if (peso != null) values['peso'] = peso;
    if (altura != null) values['altura'] = altura;
    if (objetivo != null) values['objetivo'] = objetivo;

    if (values.isEmpty) return 0;

    return await db.update(
      'usuarios',
      values,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // EXCLUIR USUÁRIO
  Future<int> excluirUsuario(int id) async {
    final db = await instance.database;

    return await db.delete('usuarios', where: 'id = ?', whereArgs: [id]);
  }
}
