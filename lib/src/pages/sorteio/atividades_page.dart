import 'package:flutter/material.dart';
import 'package:appsorteiosenai/main.dart';
import 'package:appsorteiosenai/src/data/repositories/atividade_repository.dart';
import 'package:appsorteiosenai/src/models/atividade.dart';
import 'package:appsorteiosenai/src/pages/sorteio/modal_atividade.dart';

class AtividadesPage extends StatefulWidget {
  const AtividadesPage({super.key});

  @override
  State<AtividadesPage> createState() => _AtividadesPageState();
}

class _AtividadesPageState extends State<AtividadesPage> {
  final repAtividade = getIt.get<AtividadeRepository>();
  var atividades = <AtividadeModel>[];

  @override
  void initState() {
    super.initState();
    readAtividades();
  }

  Future<void> readAtividades() async {
    atividades.clear();
    atividades = await repAtividade.read();
    setState(() {});
  }

  Future<void> createAtividade(String desc, int qnt) async {
    final result = await repAtividade.create(desc, qnt);
    if (result) readAtividades();
  }

  Future<void> deleteAtividade(int id) async {
    final result = await repAtividade.delete(id);
    if (result) readAtividades();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Atividades'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/turmas');
            },
            child: Text('Turmas'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet<Map>(
            context: context,
            builder: (_) => ModalAtividade(),
          ).then((value) {
            if (value != null) {
              createAtividade(value['desc'], int.parse(value['qnt']));
            }
          });
        },
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: atividades.length,
        itemBuilder: (_, index) => Card(
          child: ListTile(
            title: Text(atividades[index].descricao),
            subtitle: Text(atividades[index].data.toString()),
            leading: IconButton(
              onPressed: () {
                deleteAtividade(atividades[index].id);
              },
              icon: Icon(Icons.delete),
            ),
            trailing: IconButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/sorteio',
                  arguments: atividades[index],
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
