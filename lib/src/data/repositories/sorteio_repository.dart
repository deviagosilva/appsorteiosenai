import 'package:appsorteiosenai/src/models/aluno.dart';
import 'package:appsorteiosenai/src/models/sorteio.dart';

import '../sqlite_service.dart';

class SorteioRepository {
  final SqliteService sqlite;

  SorteioRepository({required this.sqlite});

  Future<bool> create(
    List<AlunoModel> alunos,
    int idAtividade,
    int numeroGrupo,
  ) async {
    try {
      final database = await sqlite.open();
      for (var aluno in alunos) {
        await database.transaction((txn) async {
          await txn.rawInsert('''
          INSERT INTO sorteio (idAluno, idAtividade, numeroGrupo) VALUES
          (
            ${aluno.id},
            $idAtividade,
            $numeroGrupo
          );
        ''');
        });
      }

      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  Future<bool> delete(int idAtividade) async {
    try {
      final database = await sqlite.open();

      await database.transaction((txn) async {
        await txn.rawDelete('''
          DELETE FROM sorteio
          WHERE idAtividade = $idAtividade;
        ''');
      });
      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  Future<List<SorteioModel>> readByAtividade(int idAtividade) async {
    try {
      final database = await sqlite.open();

      var sorteios = <SorteioModel>[];

      await database.transaction((txn) async {
        final listaSorteios = await txn.rawQuery('''
          SELECT * FROM sorteio WHERE idAtividade = $idAtividade;
        ''');
        for (var sorteio in listaSorteios) {
          sorteios.add(SorteioModel.fromMap(sorteio));
        }
      });

      return sorteios;
    } on Exception catch (_) {
      throw Exception('erro ao buscar sorteios da atividade');
    }
  }
}
