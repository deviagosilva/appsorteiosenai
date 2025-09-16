import 'package:flutter/material.dart';
import 'package:appsorteiosenai/main.dart';
import 'package:appsorteiosenai/src/data/repositories/aluno_repository.dart';
import 'package:appsorteiosenai/src/data/repositories/atividade_repository.dart';
import 'package:appsorteiosenai/src/data/repositories/sorteio_repository.dart';
import 'package:appsorteiosenai/src/data/repositories/turma_repository.dart';
import 'package:appsorteiosenai/src/models/aluno.dart';
import 'package:appsorteiosenai/src/models/atividade.dart';
import 'package:appsorteiosenai/src/models/turma_model.dart';

class SorteioPage extends StatefulWidget {
  const SorteioPage({super.key});

  @override
  State<SorteioPage> createState() => _SorteioPageState();
}

class _SorteioPageState extends State<SorteioPage> {
  List<AlunoModel> alunos = [];
  List<TurmaModel> turmas = [];
  TurmaModel? selectedTurma;
  late AtividadeModel atividade;
  List<List<AlunoModel>> grupos = [];
  bool sorteado = false;

  final rep = getIt.get<SorteioRepository>();
  final repAlunos = getIt.get<AlunoRepository>();
  final repTurma = getIt.get<TurmaRepository>();
  final repAtividade = getIt.get<AtividadeRepository>();
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      atividade = ModalRoute.of(context)!.settings.arguments as AtividadeModel;
      _initialized = true;
    }
    if (atividade.sorteado) {
      readSorteados();
    } else {
      readTurmas();
    }
  }

  Future<void> readAlunos(int idTurma) async {
    alunos.clear();
    alunos = await repAlunos.read(idTurma);
    setState(() {});
  }

  Future<void> readTurmas() async {
    turmas.clear();
    turmas = await repTurma.read();
    setState(() {});
  }

  void sortear() {
    grupos.clear();
    final alunosEmbaralhados = List.of(alunos)..shuffle();
    for (var i = 0; i < alunosEmbaralhados.length; i += atividade.qntGrupo) {
      final fim = (i + atividade.qntGrupo < alunosEmbaralhados.length)
          ? i + atividade.qntGrupo
          : alunosEmbaralhados.length;

      grupos.add(alunosEmbaralhados.sublist(i, fim));
    }
    sorteado = true;
    setState(() {});
  }

  Future<void> deleteAluno(int index) async {
    alunos.removeAt(index);
    setState(() {});
  }

  Future<void> salvarSorteio() async {
    for (var i = 0; i < grupos.length; i++) {
      await rep.create(grupos[i], atividade.id, i);
    }
    atividade.sorteado = true;
    repAtividade.update(atividade);
  }

  Future<void> readSorteados() async {
    final sorteados = await rep.readByAtividade(atividade.id);
    final Map<int, List<AlunoModel>> mapaDeGrupos = {};

    for (final sorteio in sorteados) {
      final aluno = await repAlunos.readById(sorteio.idAluno);
      if (aluno != null) {
        mapaDeGrupos.putIfAbsent(sorteio.numeroGrupo, () => []);
        mapaDeGrupos[sorteio.numeroGrupo]!.add(aluno);
      }
    }
    final gruposPorNumero = mapaDeGrupos.keys.toList()..sort();
    grupos = gruposPorNumero.map((g) => mapaDeGrupos[g]!).toList();
    sorteado = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return sorteado
        ? Scaffold(
            appBar: AppBar(title: Text('Grupos de atividade')),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (!atividade.sorteado) salvarSorteio();
              },
              child: Text('Salvar'),
            ),
            body: ListView.builder(
              itemCount: grupos.length,
              itemBuilder: (context, grupoIndex) {
                final grupo = grupos[grupoIndex];

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Grupo ${grupoIndex + 1}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: grupo.length,
                          itemBuilder: (context, alunoIndex) {
                            final aluno = grupo[alunoIndex];
                            return ListTile(
                              leading: const Icon(Icons.person),
                              title: Text(aluno.nome),
                              subtitle: Text("ID: ${aluno.matricula}"),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        : Scaffold(
            appBar: AppBar(title: Text('Sortear grupos para atividade')),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                sortear();
              },
              child: Text('Sortear'),
            ),
            body: Column(
              children: [
                DropdownButton<TurmaModel>(
                  value: selectedTurma,
                  items: turmas.map((TurmaModel turma) {
                    return DropdownMenuItem<TurmaModel>(
                      value: turma,
                      child: Text(turma.apelido ?? turma.codigo),
                    );
                  }).toList(),
                  onChanged: (TurmaModel? newValue) {
                    setState(() {
                      selectedTurma = newValue!;
                      readAlunos(selectedTurma!.id);
                    });
                  },
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: alunos.length,
                    itemBuilder: (_, index) => Card(
                      child: ListTile(
                        title: Text(alunos[index].nome),
                        subtitle: Text(alunos[index].matricula),
                        leading: IconButton(
                          onPressed: () {
                            deleteAluno(index);
                          },
                          icon: Icon(Icons.delete),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
