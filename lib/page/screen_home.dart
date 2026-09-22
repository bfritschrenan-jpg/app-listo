import 'package:flutter/material.dart';
import 'package:lista_compra/database/app_database.dart';
import 'package:lista_compra/page/screen_list_itens.dart';

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
                _salvaListaEditada(
                  idDaLista,
                  getNovoNomeDaListaController.text,
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
                _excluiLista(ValueKey(idDaLista));
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
  // Função que salva a edição da lista no banco de dados
  //--------------------------------------------------------------//
  void _salvaListaEditada(int idDalista, String novoNomeDalista) async {
    bool listaFoiEditada = await AppDatabase.instance.editaLista(
      idDalista,
      novoNomeDalista,
    );
    if (listaFoiEditada) {
      setState(() {
        listasDeCompras.removeWhere((card) => card.key == ValueKey(idDalista));
        listasDeCompras.add(criaCardDeLista(idDalista, novoNomeDalista));
        Navigator.pop(context);
      });
    }
  }

  //--------------------------------------------------------------//
  // Função que cria uma nova lista
  //--------------------------------------------------------------//
  void _criaNovaLista() async {
    int idDaNovaLista = await AppDatabase.instance.salvarLista(
      _getNomeDaNovaListaController.text,
    );
    if (idDaNovaLista > 0) {
      setState(() {
        listasDeCompras.add(
          criaCardDeLista(idDaNovaLista, _getNomeDaNovaListaController.text),
        );
        _getNomeDaNovaListaController
            .clear(); // limpa o campo após clicar no botão
      });
    }
  }

  //--------------------------------------------------------------//
  // Função que exclui uma lista
  //--------------------------------------------------------------//
  void _excluiLista(ValueKey<int> keyDaLista) async {
    bool listaFoiDeletada = await AppDatabase.instance.deletarLista(
      keyDaLista.value,
    );
    if (listaFoiDeletada) {
      setState(() {
        listasDeCompras.removeWhere((card) => card.key == keyDaLista);
      });
    }
  }

  //--------------------------------------------------------------//
  // Função que busca as listas salvas no banco de dados          //
  // e as adiciona à lista de compras as quais apareceram na tela //
  //--------------------------------------------------------------//
  void _buscaListas() async {
    final listas = await AppDatabase.instance.buscarListas();
    for (var lista in listas) {
      Card cardLista = criaCardDeLista(lista['id'], lista['nome']);
      setState(() {
        listasDeCompras.add(cardLista);
      });
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
  // Função que inicializa a tela e busca as listas
  //--------------------------------------------------------------//
  @override
  void initState() {
    super.initState();
    _buscaListas();
  }

  //--------------------------------------------------------------//
  // Função que monta a tela
  //--------------------------------------------------------------//
  @override
  Widget build(BuildContext context) {
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
                      _criaNovaLista(); // ao pressionar enter no campo de texto, cria uma nova lista
                    },
                  ),
                ),

                SizedBox(width: 10),

                ElevatedButton(
                  onPressed: _criaNovaLista,
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

            if (listasDeCompras.isEmpty)
              Text('Nenhuma lista cadastrada.', style: TextStyle(fontSize: 20))
            else
              Expanded(
                child: ListView.builder(
                  itemCount: listasDeCompras.length,
                  itemBuilder: (context, index) {
                    return listasDeCompras[index];
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
