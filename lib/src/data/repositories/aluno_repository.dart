import 'package:appsorteiosenai/src/models/aluno.dart';

import '../sqlite_service.dart';

class AlunoRepository {
  final SqliteService sqlite;

  AlunoRepository({required this.sqlite});

  Future<bool> create(String nome, String matricula, int idTurma) async {
    try {
      final database = await sqlite.open();

      await database.transaction((txn) async {
        await txn.rawInsert('''
          INSERT INTO aluno (nome, matricula, idTurma) VALUES
          (
            "$nome",
            "$matricula",
            $idTurma
          );
        ''');
      });
      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  Future<bool> delete(int id) async {
    try {
      final database = await sqlite.open();

      await database.transaction((txn) async {
        await txn.rawDelete('''
          DELETE FROM aluno
          WHERE id = $id;
        ''');
      });
      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  Future<List<AlunoModel>> read(int idTurma) async {
    try {
      final database = await sqlite.open();

      var alunos = <AlunoModel>[];

      await database.transaction((txn) async {
        final lista = await txn.rawQuery('''
          SELECT * FROM aluno WHERE idTurma = $idTurma;
        ''');
        for (var turma in lista) {
          alunos.add(AlunoModel.fromMap(turma));
        }
      });

      return alunos;
    } on Exception catch (_) {
      throw Exception('erro ao buscar alunos');
    }
  }

  Future<AlunoModel?> readById(int id) async {
    try {
      final database = await sqlite.open();

      var alunos = <AlunoModel>[];

      await database.transaction((txn) async {
        final listaAlunos = await txn.rawQuery('''
          SELECT * FROM aluno WHERE id = $id;
        ''');
        for (var aluno in listaAlunos) {
          alunos.add(AlunoModel.fromMap(aluno));
        }
      });

      return alunos.isEmpty ? null : alunos.first;
    } on Exception catch (_) {
      throw Exception('erro ao buscar aluno por ID');
    }
  }

  Future<bool> update(AlunoModel aluno) async {
    try {
      final database = await sqlite.open();

      await database.transaction((txn) async {
        await txn.rawUpdate('''
          UPDATE aluno SET
          nome = "${aluno.nome}",
          matricula = "${aluno.matricula}",
          idTurma = ${aluno.idTurma}
          WHERE id = ${aluno.id}
        ''');
      });
      return true;
    } on Exception catch (_) {
      return false;
    }
  }
}
