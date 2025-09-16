import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:appsorteiosenai/src/data/repositories/aluno_repository.dart';
import 'package:appsorteiosenai/src/data/repositories/atividade_repository.dart';
import 'package:appsorteiosenai/src/data/repositories/sorteio_repository.dart';
import 'package:appsorteiosenai/src/data/repositories/turma_repository.dart';
import 'package:appsorteiosenai/src/data/sqlite_service.dart';
import 'package:appsorteiosenai/src/pages/sorteio/sorteio_page.dart';
import 'package:appsorteiosenai/src/pages/turma/alunos_page.dart';
import 'package:appsorteiosenai/src/pages/turma/turmas_page.dart';

import 'src/pages/sorteio/atividades_page.dart';

void main() {
  getIt.registerSingleton(SqliteService());
  getIt.registerSingleton(
    AtividadeRepository(sqlite: getIt.get<SqliteService>()),
  );
  getIt.registerSingleton(
    SorteioRepository(sqlite: getIt.get<SqliteService>()),
  );
  getIt.registerSingleton(AlunoRepository(sqlite: getIt.get<SqliteService>()));
  getIt.registerSingleton(TurmaRepository(sqlite: getIt.get<SqliteService>()));
  runApp(const MyApp());
}

final getIt = GetIt.instance;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sorteio Senai',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      initialRoute: '/atividades',
      routes: {
        '/atividades': (context) => AtividadesPage(),
        '/turmas': (context) => TurmasPage(),
        '/alunos': (context) => AlunosPage(),
        '/sorteio': (context) => SorteioPage(),
      },
    );
  }
}
