import 'package:flutter/material.dart';

class ModalTurma extends StatefulWidget {
  const ModalTurma({super.key});

  @override
  State<ModalTurma> createState() => _ModalTurmaState();
}

class _ModalTurmaState extends State<ModalTurma> {
  final codigoEC = TextEditingController();
  final apelidoEC = TextEditingController();

  @override
  void dispose() {
    codigoEC.dispose();
    apelidoEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        spacing: 10,
        children: [
          TextField(
            controller: codigoEC,
            textInputAction: TextInputAction.next,
          ),
          TextField(
            controller: apelidoEC,
            textInputAction: TextInputAction.done,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, {
                'cod': codigoEC.text,
                'apelido': apelidoEC.text,
              });
            },
            child: Text('Salvar'),
          ),
        ],
      ),
    );
  }
}
