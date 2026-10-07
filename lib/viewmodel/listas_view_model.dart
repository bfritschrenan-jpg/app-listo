import 'package:flutter/foundation.dart';
import 'package:lista_compra/models/lista.dart';
import 'package:lista_compra/repository/lista_repository.dart';

class ListasViewModel extends ChangeNotifier {
  final ListaRepository _repository = ListaRepository();

  List<Lista> _listas = [];

  List<Lista> get listasCarregadas => _listas;

  Future<void> carregarListas() async {
    _listas = await _repository.buscarListas();
    notifyListeners();
  }

  Future<void> salvarLista(String nome) async {
    int id = await _repository.salvarLista(nome);
    if (id != 0) {
      _listas.add(Lista(id: id, nome: nome));
      notifyListeners();
    }
  }

  Future<void> deletarLista(int id) async {
    bool listaFoiDeletada = await _repository.deletarLista(id);
    if (listaFoiDeletada) {
      _listas.removeWhere((lista) => lista.id == id);
      notifyListeners();
    }
  }

  Future<void> editarLista(int id, String nome) async {
    bool listaFoiEditada = await _repository.editarLista(id, nome);
    if (listaFoiEditada) {
      Lista listaNaoEditada = _listas.firstWhere((lista) => lista.id == id);
      listaNaoEditada.nome = nome;
      notifyListeners();
    }
  }
}
