class AlunoModel {
  int id;
  String nome;
  String matricula;
  int idTurma;
  AlunoModel({
    required this.id,
    required this.nome,
    required this.matricula,
    required this.idTurma,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
      'matricula': matricula,
      'idTurma': idTurma,
    };
  }

  factory AlunoModel.fromMap(Map<String, dynamic> map) {
    return AlunoModel(
      id: map['id'] as int,
      nome: map['nome'] as String,
      matricula: map['matricula'] as String,
      idTurma: map['idTurma'] as int,
    );
  }
}
