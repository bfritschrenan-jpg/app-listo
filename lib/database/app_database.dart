import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._();

  static Database? _database;

  AppDatabase._(); // construtor privado para garantir que a classe seja singleton

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _iniciarBanco();
    return _database!;
  }

  Future<Database> _iniciarBanco() async {
    String caminhoDoBanco;

    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
      caminhoDoBanco = 'listas.db';
    } else {
      final pastaDosBancos = await getDatabasesPath();

      caminhoDoBanco = join(pastaDosBancos, 'listas.db');
    }

    return openDatabase(caminhoDoBanco, version: 1, onCreate: _criarTabelas);
  }

  Future<void> _criarTabelas(Database db, int version) async {
    await db.execute('''CREATE TABLE listas (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nome TEXT
      )
    ''');
    await db.execute('''CREATE TABLE itens_da_lista (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nome TEXT,
          lista_id INTEGER,
          marcado BOOLEAN DEFAULT 0,
          FOREIGN KEY (lista_id) REFERENCES listas (id) ON DELETE CASCADE
      )
    ''');
  }

  //----------------------------------------------------------------------------//
  // FUNÇÕES DA TABELA LISTAS_COMPRAS
  //----------------------------------------------------------------------------//

  Future<int> salvarLista(String nome) async {
    final db = await database;

    final lista = {'nome': nome};

    return await db.insert('listas', lista);
  }

  Future<bool> deletarLista(int id) async {
    final db = await database;
    final int linhasExcluidas = await db.delete(
      'listas',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (linhasExcluidas > 0) {
      return true;
    }
    return false;
  }

  Future<bool> editaLista(int id, String nome) async {
    final db = await database;

    final int linhasAfetadas = await db.update(
      'listas',
      {'nome': nome},
      where: 'id = ?',
      whereArgs: [id],
    );

    if (linhasAfetadas > 0) {
      return true;
    }
    return false;
  }

  Future<List<Map<String, dynamic>>> buscarListas() async {
    final db = await database;
    print('estou buscando as listas no banco');
    List<Map<String, dynamic>> listas = await db.query('listas');
    print('listas encontradas no banco: $listas');
    return listas;
  }

  Future<Map<String, dynamic>?> buscarListaPorId(int id) async {
    final db = await database;

    final lista = await db.query(
      'listas',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (lista.isEmpty) {
      return null;
    }
    return lista.first;
  }

  //----------------------------------------------------------------------------//
  // FUNÇÕES DA TABELA ITENS_DA_LISTA
  //----------------------------------------------------------------------------//

  Future<int> salvarItemDaLista(String nome, int listaId) async {
    final db = await database;
    final item = {'nome': nome, 'lista_id': listaId};
    int idDoItemSalvo = await db.insert('itens_da_lista', item);
    print("item salvo com id: $idDoItemSalvo");
    return idDoItemSalvo;
  }

  Future<List<Map<String, dynamic>>> buscarItensDaLista(int listaId) async {
    final db = await database;
    print('estou buscando os itens da lista no banco');
    List<Map<String, dynamic>> itens = await db.query(
      'itens_da_lista',
      where: 'lista_id = ?',
      whereArgs: [listaId],
    );
    print('itens encontrados no banco: $itens');
    return itens;
  }

  Future<bool> deletarItemDaLista(int id) async {
    final db = await database;
    print('estou deletando o item com id: $id');
    final int linhasExcluidas = await db.delete(
      'itens_da_lista',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (linhasExcluidas > 0) {
      return true;
    }
    return false;
  }

  Future<bool> editarItemDaLista(
    int idDoItem,
    int idDaLista,
    String novoNomeDoItem,
    bool comprado,
  ) async {
    final db = await database;
    int compradoSqlite;
    if (comprado == true) {
      compradoSqlite = 1;
    } else {
      compradoSqlite = 0;
    }
    final int linhasAfetadas = await db.update(
      'itens_da_lista',
      {'nome': novoNomeDoItem, 'marcado': compradoSqlite},
      where: 'id = ? AND lista_id = ?',
      whereArgs: [idDoItem, idDaLista],
    );
    if (linhasAfetadas > 0) {
      return true;
    }
    return false;
  }
}
