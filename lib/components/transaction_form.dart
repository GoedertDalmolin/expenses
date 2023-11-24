import 'package:flutter/material.dart';

class TransactionForm extends StatelessWidget {
  TransactionForm({required this.onSubmit, super.key});

  final titleController = TextEditingController();
  final valueController = TextEditingController();

  final Function(String, double) onSubmit;

  _submitForm() {
    final title = titleController.text;
    final value = double.tryParse(valueController.text) ?? 0;

    if (title.isEmpty || value <= 0) {
      return;
    }

    debugPrint('Submited');
    onSubmit(title, value);
  }

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
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onSubmitted: (value) {
                _submitForm();
              },
            ),
            ElevatedButton(
                onPressed: _submitForm,
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
