import 'package:flutter/material.dart';
import 'package:lista_compra/database/app_database.dart';
import 'package:lista_compra/pages/screen_list_itens.dart';
import 'package:lista_compra/viewmodel/listas_view_model.dart';
import 'package:provider/provider.dart';

//--------------------------------------------------------------//
// Tela principal: responsável por mostrar as listas de compras //
//--------------------------------------------------------------//

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _getNomeDaNovaListaController =
      TextEditingController();

  List<Card> listasDeCompras = [];

  final int _limiteDeCaracteresDoNomeDaLista = 30;

  //--------------------------------------------------------------//
  // Função que abre o dialog para editar uma lista
  //--------------------------------------------------------------//

  void _abrirDialogoDeEdicao(String nomeDaListaAtual, int idDaLista) {
    final TextEditingController getNovoNomeDaListaController =
        TextEditingController(text: nomeDaListaAtual);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar lista'),
          content: TextField(
            maxLength: _limiteDeCaracteresDoNomeDaLista,
            controller: getNovoNomeDaListaController,
            decoration: InputDecoration(
              border: OutlineInputBorder(), // Adiciona borda ao campo de texto
              hintText: 'Digite o nome da lista',
              labelText: 'Nome da lista',
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                context.read<ListasViewModel>().editarLista(
                  idDaLista,
                  getNovoNomeDaListaController.text,
                );
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

  //--------------------------------------------------------------//
  // Função que confirma a exclusão da lista no banco de dados    //
  //--------------------------------------------------------------//
  void _abrirDialogoDeConfirmacaoDeExclusao(int idDaLista) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Excluir Lista'),
          content: Text('Tem certeza que deseja excluir está lista?'),
          actions: [
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
            ElevatedButton(
              onPressed: () {
                context.read<ListasViewModel>().deletarLista(idDaLista);
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
              child: Text('EXCLUIR'),
            ),
          ],
        );
      },
    );
  }

  //--------------------------------------------------------------//
  // Função que cria uma nova lista
  //--------------------------------------------------------------//
  void _criaNovaLista() async {
    final nome = _getNomeDaNovaListaController.text;
    if (nome.isNotEmpty) {
      context.read<ListasViewModel>().salvarLista(nome);
      _getNomeDaNovaListaController.clear();
    }
  }

  //--------------------------------------------------------------//
  // Função que cria um card de lista
  //--------------------------------------------------------------//
  Card criaCardDeLista(int id, String nome) {
    return Card(
      key: ValueKey(id),
      child: ListTile(
        title: Text(nome),
        trailing: Row(
          mainAxisSize:
              MainAxisSize.min, // para que os botões não ocupem toda a linha
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                _abrirDialogoDeEdicao(nome, id);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                _abrirDialogoDeConfirmacaoDeExclusao(id);
              },
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ScreenListItens(idDaLista: id),
            ),
          );
        }, // abrir detalhes da lista
      ),
    );
  }

  //--------------------------------------------------------------//
  // Função que monta a tela
  //--------------------------------------------------------------//
  @override
  Widget build(BuildContext context) {
    final ListasViewModel viewModel = context.watch<ListasViewModel>();
    return Scaffold(
      resizeToAvoidBottomInset: true, // para que o teclado não cubra o conteúdo
      appBar: AppBar(title: Center(child: Text('Lista de Compras'))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    maxLength: _limiteDeCaracteresDoNomeDaLista,
                    decoration: InputDecoration(
                      counterText: '', // retira o contador de caracteres do campo de texto
                      border: OutlineInputBorder(), // Adiciona borda ao campo de texto
                      hintText: 'Digite o nome da lista',
                    ),
                    controller: _getNomeDaNovaListaController,
                    onSubmitted: (valorDoCampo) {
                      _criaNovaLista();
                    },
                  ),
                ),

                SizedBox(width: 10),

                ElevatedButton(
                  onPressed: () {
                    _criaNovaLista();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: Size(0, 50),
                  ),
                  child: Text('Criar Lista'),
                ),
              ],
            ),

            Divider(height: 50), // para separar visualmente o input e o botão

            if (viewModel.listasCarregadas.isEmpty)
              Text('Nenhuma lista cadastrada.', style: TextStyle(fontSize: 20))
            else
              Expanded(
                child: ListView.builder(
                  itemCount: viewModel.listasCarregadas.length,
                  itemBuilder: (context, index) {
                    final lista = viewModel.listasCarregadas[index];
                    return criaCardDeLista(lista.id, lista.nome);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
