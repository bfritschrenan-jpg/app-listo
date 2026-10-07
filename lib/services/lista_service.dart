import 'package:lista_compra/database/app_database.dart';

class ListaService {
  //==========================================================================//
  // FUNÇÕES PARA A TABELA LISTAS
  //==========================================================================//
  Future<List<Map<String, dynamic>>> buscarListas() async {
    return await AppDatabase.instance.buscarListas();
  }

  Future<int> salvarLista(String nome) async {
    return await AppDatabase.instance.salvarLista(nome);
  }

  Future<bool> deletarLista(int id) async {
    return await AppDatabase.instance.deletarLista(id);
  }

  Future<bool> editarLista(int id, String nome) async {
    return await AppDatabase.instance.editaLista(id, nome);
  }
}
