import 'package:flutter/material.dart';

class ModalAtividade extends StatefulWidget {
  const ModalAtividade({super.key});

  @override
  State<ModalAtividade> createState() => _ModalAtividadeState();
}

class _ModalAtividadeState extends State<ModalAtividade> {
  final descricaoEC = TextEditingController();

  final qntGrupoEC = TextEditingController();

  @override
  void dispose() {
    descricaoEC.dispose();
    qntGrupoEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        TextField(
          controller: descricaoEC,
          textInputAction: TextInputAction.next,
        ),
        TextField(
          controller: qntGrupoEC,
          textInputAction: TextInputAction.done,
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, {
              'desc': descricaoEC.text,
              'qnt': qntGrupoEC.text,
            });
          },
          child: Text('Salvar'),
        ),
      ],
    );
  }
}
