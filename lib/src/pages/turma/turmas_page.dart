import 'package:flutter/material.dart';
import 'package:appsorteiosenai/main.dart';
import 'package:appsorteiosenai/src/data/repositories/turma_repository.dart';
import 'package:appsorteiosenai/src/models/turma_model.dart';
import 'package:appsorteiosenai/src/pages/turma/modal_turma.dart';

class TurmasPage extends StatefulWidget {
  const TurmasPage({super.key});

  @override
  State<TurmasPage> createState() => _TurmasPageState();
}

class _TurmasPageState extends State<TurmasPage> {
  final rep = getIt.get<TurmaRepository>();
  var turmas = <TurmaModel>[];

  @override
  void initState() {
    super.initState();
    readTurmas();
  }

  Future<void> readTurmas() async {
    turmas.clear();
    turmas = await rep.read();
    setState(() {});
  }

  Future<void> createTurma(String cod, String? apelido) async {
    final result = await rep.create(cod, apelido);
    if (result) readTurmas();
  }

  Future<void> deleteTurma(int id) async {
    final result = await rep.delete(id);
    if (result) readTurmas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Turmas')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet<Map>(
            context: context,
            builder: (_) => ModalTurma(),
          ).then((value) {
            if (value != null) {
              createTurma(value['cod'], value['apelido']);
            }
          });
        },
      ),
      body: ListView.builder(
        itemCount: turmas.length,
        itemBuilder: (_, index) => Card(
          child: ListTile(
            title: Text(turmas[index].codigo),
            subtitle: Text(turmas[index].apelido ?? 'sem apelido'),
            leading: IconButton(
              onPressed: () {
                deleteTurma(turmas[index].id);
              },
              icon: Icon(Icons.delete),
            ),
            trailing: IconButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/alunos',
                  arguments: turmas[index],
                );
              },
              icon: Icon(Icons.open_in_new),
            ),
          ),
        ),
      ),
    );
  }
}
