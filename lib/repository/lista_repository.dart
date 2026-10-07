import 'package:lista_compra/services/lista_service.dart';
import 'package:lista_compra/models/lista.dart';

class ListaRepository {
  final _service = ListaService();

  Future<List<Lista>> buscarListas() async {
    final listas = await _service.buscarListas();
    final listaFormatada = listas.map((lista) {
      return Lista.fromMap(lista);
    }).toList();

    return listaFormatada;
  }

  Future<int> salvarLista(String nome) async {
    return await _service.salvarLista(nome);
  }

  Future<bool> deletarLista(int id) async {
    return await _service.deletarLista(id);
  }

  Future<bool> editarLista(int id, String nome) async {
    return await _service.editarLista(id, nome);
  }
}
