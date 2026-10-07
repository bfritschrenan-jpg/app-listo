class Item {
  final int id;
  final int idLista;
  final String nome;
  final bool marcado;

  Item({
    required this.id,
    required this.idLista,
    required this.nome,
    required this.marcado,
  });

  factory Item.fromMap(Map<String, dynamic> mapa) {
    return Item(
      id: mapa['id'],
      idLista: mapa['lista_id'],
      nome: mapa['nome'],
      marcado: mapa['marcado'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'lista_id': idLista,
      'nome': nome,
      'marcado': marcado ? 1 : 0,
    };
  }
}
