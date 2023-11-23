import 'package:flutter/material.dart';

class TransactionForm extends StatelessWidget {
  TransactionForm({required this.onSubmit, super.key});

  final titleController = TextEditingController();
  final valueController = TextEditingController();

  final Function(String, double) onSubmit;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Título'),
              controller: titleController,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Valor (R\$)'),
              controller: valueController,
            ),
            ElevatedButton(
                onPressed: () {
                  final title = titleController.text;
                  final value = double.tryParse(valueController.text) ?? 0;
                  onSubmit(title, value);
                },
                child: Text(
                  'Nova Transação',
                  style: TextStyle(color: Colors.purple),
                ))
          ],
        ),
      ),
    );
  }
}
