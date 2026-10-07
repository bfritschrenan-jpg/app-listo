class Lista {
  final int id;
  String nome;
  Lista({required this.id, required this.nome});

  factory Lista.fromMap(Map<String, dynamic> mapa) {
    return Lista(id: mapa['id'], nome: mapa['nome']);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'nome': nome};
  }
}
