class AtividadeModel {
  int id;
  String descricao;
  DateTime data;
  int qntGrupo;
  bool sorteado;
  AtividadeModel({
    required this.id,
    required this.descricao,
    required this.data,
    required this.qntGrupo,
    required this.sorteado,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'descricao': descricao,
      'data': data.toIso8601String(),
      'qntGrupo': qntGrupo,
      'sorteado': sorteado ? 1 : 0,
    };
  }

  factory AtividadeModel.fromMap(Map<String, dynamic> map) {
    return AtividadeModel(
      id: map['id'] as int,
      descricao: map['descricao'] as String,
      data: DateTime.parse(map['data'] as String),
      qntGrupo: map['qntGrupo'] as int,
      sorteado: (map['qntGrupo'] as int) == 1 ? true : false,
    );
  }
}
