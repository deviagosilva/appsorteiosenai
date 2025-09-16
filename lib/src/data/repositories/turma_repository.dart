import 'package:appsorteiosenai/src/models/turma_model.dart';

import '../sqlite_service.dart';

class TurmaRepository {
  final SqliteService sqlite;

  TurmaRepository({required this.sqlite});

  Future<bool> create(String codigo, String? apelido) async {
    try {
      final database = await sqlite.open();

      await database.transaction((txn) async {
        await txn.rawInsert('''
          INSERT INTO turma (codigo, apelido) VALUES
          (
            "$codigo",
            "$apelido"
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
          DELETE FROM turma
          WHERE id = $id;
        ''');
      });
      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  Future<List<TurmaModel>> read() async {
    try {
      final database = await sqlite.open();

      var turmas = <TurmaModel>[];

      await database.transaction((txn) async {
        final listaTurmas = await txn.rawQuery('''
          SELECT * FROM turma;
        ''');
        for (var turma in listaTurmas) {
          turmas.add(TurmaModel.fromMap(turma));
        }
      });

      return turmas;
    } on Exception catch (_) {
      throw Exception('erro ao buscar turmas');
    }
  }

  Future<TurmaModel?> readById(int id) async {
    try {
      final database = await sqlite.open();

      var turmas = <TurmaModel>[];

      await database.transaction((txn) async {
        final listaTurmas = await txn.rawQuery('''
          SELECT * FROM turma WHERE id = $id;
        ''');
        for (var turma in listaTurmas) {
          turmas.add(TurmaModel.fromMap(turma));
        }
      });

      return turmas.isEmpty ? null : turmas.first;
    } on Exception catch (_) {
      throw Exception('erro ao buscar turma por ID');
    }
  }

  Future<bool> update(TurmaModel turma) async {
    try {
      final database = await sqlite.open();

      await database.transaction((txn) async {
        await txn.rawUpdate('''
          UPDATE turma SET
          codigo = "${turma.codigo}",
          apelido = "${turma.apelido}"
          WHERE id = ${turma.id}
        ''');
      });
      return true;
    } on Exception catch (_) {
      return false;
    }
  }
}
