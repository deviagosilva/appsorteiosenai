import 'package:appsorteiosenai/src/models/atividade.dart';

import '../sqlite_service.dart';

class AtividadeRepository {
  final SqliteService sqlite;

  AtividadeRepository({required this.sqlite});

  Future<bool> create(String descricao, int qntGrupo) async {
    try {
      final database = await sqlite.open();

      await database.transaction((txn) async {
        await txn.rawInsert('''
          INSERT INTO atividade (descricao, data, sorteado, qntGrupo) VALUES
          (
            "$descricao",
            "${DateTime.now().toIso8601String()}",
            0,
            $qntGrupo
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
          DELETE FROM atividade
          WHERE id = $id;
        ''');
      });
      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  Future<List<AtividadeModel>> read() async {
    try {
      final database = await sqlite.open();

      var atividades = <AtividadeModel>[];

      await database.transaction((txn) async {
        final listaAtividades = await txn.rawQuery('''
          SELECT * FROM atividade;
        ''');
        for (var atividade in listaAtividades) {
          atividades.add(AtividadeModel.fromMap(atividade));
        }
      });

      return atividades;
    } on Exception catch (_) {
      throw Exception('erro ao buscar atividades');
    }
  }

  Future<AtividadeModel?> readById(int id) async {
    try {
      final database = await sqlite.open();

      var atividades = <AtividadeModel>[];

      await database.transaction((txn) async {
        final listaAtividades = await txn.rawQuery('''
          SELECT * FROM atividade WHERE id = $id;
        ''');
        for (var turma in listaAtividades) {
          atividades.add(AtividadeModel.fromMap(turma));
        }
      });

      return atividades.isEmpty ? null : atividades.first;
    } on Exception catch (_) {
      throw Exception('erro ao buscar turma por ID');
    }
  }

  Future<bool> update(AtividadeModel atividade) async {
    try {
      final database = await sqlite.open();

      await database.transaction((txn) async {
        await txn.rawUpdate('''
          UPDATE atividade SET
          data = "${atividade.data}",
          qntGrupo = ${atividade.qntGrupo},
          sorteado = ${atividade.sorteado},
          descricao = "${atividade.descricao}"
          WHERE id = ${atividade.id}
        ''');
      });
      return true;
    } on Exception catch (_) {
      return false;
    }
  }
}
