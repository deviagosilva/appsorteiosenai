class SorteioModel {
  int id;
  int idAluno;
  int idAtividade;
  int numeroGrupo;
  SorteioModel({
    required this.id,
    required this.idAluno,
    required this.idAtividade,
    required this.numeroGrupo,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'idAluno': idAluno,
      'idAtividade': idAtividade,
      'numeroGrupo': numeroGrupo,
    };
  }

  factory SorteioModel.fromMap(Map<String, dynamic> map) {
    return SorteioModel(
      id: map['id'] as int,
      idAluno: map['idAluno'] as int,
      idAtividade: map['idAtividade'] as int,
      numeroGrupo: map['numeroGrupo'] as int,
    );
  }
}
