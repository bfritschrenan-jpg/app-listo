import 'package:flutter/material.dart';
import 'package:lista_compra/database/app_database.dart';
import 'package:lista_compra/card_item.dart';

class ScreenListItens extends StatefulWidget {
  final int idDaLista;

  const ScreenListItens({super.key, required this.idDaLista});

  @override
  State<ScreenListItens> createState() => _ScreenListItensState();
}

class _ScreenListItensState extends State<ScreenListItens> {
  final TextEditingController _getNomeDoNovoItemController =
      TextEditingController();

  List<CardItem> listaDeItens = [];

  final int _limiteDeCaracteresDoNomeDoItem = 25;

  CardItem _criaCardDoItem(String nomeDoItem, int idDoItem, bool comprado) {
    return CardItem(
      key: ValueKey<int>(idDoItem),
      idDoItem: idDoItem,
      idDaLista: widget.idDaLista,
      nomeDoItem: nomeDoItem,
      statusComprado: comprado,
      deletarItem: _deletarItemDaLista,
    );
  }

  void _addNovoItem() async {
    String nome = _getNomeDoNovoItemController.text;
    int idDoItem = await AppDatabase.instance.salvarItemDaLista(
      nome,
      widget.idDaLista,
    );
    setState(() {
      listaDeItens.add(_criaCardDoItem(nome, idDoItem, false));
      _getNomeDoNovoItemController.clear();
    });
  }

  void _buscarItensDaLista() async {
    final itens = await AppDatabase.instance.buscarItensDaLista(
      widget.idDaLista,
    );
    for (var item in itens) {
      bool comprado = item['comprado'] == 1 ? true : false;
      setState(() {
        listaDeItens.add(_criaCardDoItem(item['nome'], item['id'], comprado));
      });
    }
  }

  void _deletarItemDaLista(ValueKey<int> keyDoItem) async {
    bool deletado = await AppDatabase.instance.deletarItemDaLista(
      keyDoItem.value,
    );
    if (deletado) {
      setState(() {
        listaDeItens.removeWhere((card) => card.key == keyDoItem);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    print("id da lista selecionada: ${widget.idDaLista}");
    _buscarItensDaLista();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Itens da Lista'), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    maxLength: _limiteDeCaracteresDoNomeDoItem,
                    decoration: InputDecoration(
                      counterText: '', // retira o contador de caracteres do campo de texto
                      border: OutlineInputBorder(), // Adiciona borda ao campo de texto
                      hintText: 'Digite o nome do item',
                    ),
                    controller: _getNomeDoNovoItemController,
                    onSubmitted: (valorDoCampo) {
                      if (valorDoCampo.isNotEmpty) {
                        _addNovoItem();
                      }
                    }, // ao pressionar enter no campo de texto, cria uma nova lista
                  ),
                ),

                const SizedBox(width: 16),

                ElevatedButton(
                  onPressed: () {
                    if (_getNomeDoNovoItemController.text.isNotEmpty) {
                      _addNovoItem();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Digite o nome do item')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: Size(0, 50),
                  ),
                  child: Text('Adicionar'),
                ),
              ],
            ),

            Divider(height: 50),

            if (listaDeItens.isEmpty)
              Text("Nenhum item na lista", style: TextStyle(fontSize: 16))
            else
              Expanded(
                child: ListView.builder(
                  itemCount: listaDeItens.length,
                  itemBuilder: (context, index) {
                    return listaDeItens[index];
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
