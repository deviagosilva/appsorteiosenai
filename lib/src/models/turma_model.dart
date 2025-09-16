class TurmaModel {
  int id;
  String codigo;
  String? apelido;
  TurmaModel({required this.codigo, this.apelido, required this.id});

  factory TurmaModel.fromMap(Map<String, dynamic> map) {
    return TurmaModel(
      codigo: map['codigo'] as String,
      id: map['id'] as int,
      apelido: map['apelido'] != null ? map['apelido'] as String : null,
    );
  }

  @override
  bool operator ==(covariant TurmaModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.codigo == codigo && other.apelido == apelido;
  }

  @override
  int get hashCode => id.hashCode ^ codigo.hashCode ^ apelido.hashCode;
}
