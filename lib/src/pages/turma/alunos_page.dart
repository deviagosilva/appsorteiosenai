import 'package:flutter/material.dart';
import 'package:appsorteiosenai/main.dart';
import 'package:appsorteiosenai/src/data/repositories/aluno_repository.dart';
import 'package:appsorteiosenai/src/models/aluno.dart';
import 'package:appsorteiosenai/src/models/turma_model.dart';
import 'package:appsorteiosenai/src/pages/turma/modal_aluno.dart';

class AlunosPage extends StatefulWidget {
  const AlunosPage({super.key});

  @override
  State<AlunosPage> createState() => _AlunosPageState();
}

class _AlunosPageState extends State<AlunosPage> {
  final rep = getIt.get<AlunoRepository>();
  var alunos = <AlunoModel>[];
  late final TurmaModel turma;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      turma = ModalRoute.of(context)!.settings.arguments as TurmaModel;
      _initialized = true;
    }
    readAlunos();
  }

  Future<void> readAlunos() async {
    alunos.clear();
    alunos = await rep.read(turma.id);
    setState(() {});
  }

  Future<void> createAluno(String nome, String mat) async {
    final result = await rep.create(nome, mat, turma.id);
    if (result) readAlunos();
  }

  Future<void> deleteAluno(int id) async {
    final result = await rep.delete(id);
    if (result) readAlunos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alunos da turma ${turma.apelido ?? turma.codigo}'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet<Map>(
            context: context,
            builder: (_) => ModalAluno(),
          ).then((value) {
            if (value != null) {
              createAluno(value['nome'], value['mat']);
            }
          });
        },
      ),
      body: ListView.builder(
        itemCount: alunos.length,
        itemBuilder: (_, index) => Card(
          child: ListTile(
            title: Text(alunos[index].nome),
            subtitle: Text(alunos[index].matricula),
            leading: IconButton(
              onPressed: () {
                deleteAluno(alunos[index].id);
              },
              icon: Icon(Icons.delete),
            ),
          ),
        ),
      ),
    );
  }
}
