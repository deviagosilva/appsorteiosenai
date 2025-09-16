import 'package:flutter/material.dart';

class ModalAluno extends StatefulWidget {
  const ModalAluno({super.key});

  @override
  State<ModalAluno> createState() => _ModalAlunoState();
}

class _ModalAlunoState extends State<ModalAluno> {
  final nomeEC = TextEditingController();
  final matriculaEC = TextEditingController();

  @override
  void dispose() {
    nomeEC.dispose();
    matriculaEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        spacing: 10,
        children: [
          TextField(controller: nomeEC, textInputAction: TextInputAction.next),
          TextField(
            controller: matriculaEC,
            textInputAction: TextInputAction.send,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, {
                'nome': nomeEC.text,
                'mat': matriculaEC.text,
              });
            },
            child: Text('Salvar'),
          ),
        ],
      ),
    );
  }
}
