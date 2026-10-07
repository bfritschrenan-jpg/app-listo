import 'package:flutter/material.dart';
import 'package:lista_compra/database/app_database.dart';

class CardItem extends StatefulWidget {
  final int idDoItem;
  final int idDaLista;
  final String nomeDoItem;
  final bool statusComprado;
  final Function(ValueKey<int> id) deletarItem;
  const CardItem({
    super.key,
    required this.idDoItem,
    required this.idDaLista,
    required this.nomeDoItem,
    required this.statusComprado,
    required this.deletarItem,
  });

  @override
  State<CardItem> createState() => _CardItemState();
}

class _CardItemState extends State<CardItem> {
  late bool comprado;
  late String nomeDoItem;

  void _salvarAlteracoesNoItem(
    int idDoItem,
    int idDaLista,
    String novoNomeDoItem,
    bool comprado,
  ) async {
    // TODO: implementar edição do item da lista
    bool itemFoiEditado = await AppDatabase.instance.editarItemDaLista(
      idDoItem,
      idDaLista,
      novoNomeDoItem,
      comprado,
    );
    if (itemFoiEditado) {
      setState(() {
        nomeDoItem = novoNomeDoItem;
        Navigator.pop(context);
      });
    }
  }

  void _abrirDialogoDeEdicao(
    String nomeAtualDoItem,
    int idDoItem,
    bool comprado,
  ) {
    final TextEditingController getNovoNomeDoItemController =
        TextEditingController(text: nomeAtualDoItem);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Item'),
          content: TextField(
            maxLength: 25,
            controller: getNovoNomeDoItemController,
            decoration: InputDecoration(
              border: OutlineInputBorder(), // Adiciona borda ao campo de texto
              hintText: 'Digite o nome do item',
              labelText: 'Nome do item',
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _salvarAlteracoesNoItem(
                  idDoItem,
                  widget.idDaLista,
                  getNovoNomeDoItemController.text,
                  comprado,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: Size(0, 50),
              ),
              child: Text('SALVAR'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: Size(0, 50),
              ),
              child: Text('CANCELAR'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    comprado = widget.statusComprado;
    nomeDoItem = widget.nomeDoItem;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color corDoCardDoItem = Theme.of(context).colorScheme.onInverseSurface;
    if (comprado) {
      corDoCardDoItem = Theme.of(context).colorScheme.primaryContainer;
    }

    return Card(
      color: corDoCardDoItem,
      child: ListTile(
        leading: Checkbox(
          shape: CircleBorder(),
          onChanged: (value) async {
            bool itemFoiEditado = await AppDatabase.instance.editarItemDaLista(
              widget.idDoItem,
              widget.idDaLista,
              nomeDoItem,
              value!,
            );
            if (itemFoiEditado) {
              setState(() {
                comprado = value;
              });
            }
          },
          value: comprado,
        ),
        title: Text(nomeDoItem),
        trailing: Row(
          mainAxisSize:
              MainAxisSize.min, // para que os botões não ocupem toda a linha
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                _abrirDialogoDeEdicao(nomeDoItem, widget.idDoItem, comprado);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                widget.deletarItem(ValueKey<int>(widget.idDoItem));
              },
            ),
          ],
        ),
        onTap: () {
          //TODO: implementar a lógica de marcar como comprado ou não
        }, // abrir detalhes da lista
      ),
    );
  }
}
