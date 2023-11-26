import 'package:expenses/components/adaptative_button.dart';
import 'package:expenses/components/adaptative_textfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionForm extends StatefulWidget {
  const TransactionForm({required this.onSubmit, super.key});

  final Function(String, double, DateTime) onSubmit;

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _titleController = TextEditingController();
  final _valueController = TextEditingController();
  var _selectedDate = DateTime.now();

  _submitForm() {
    final title = _titleController.text;
    final value = double.tryParse(_valueController.text) ?? 0;

    if (title.isEmpty || value <= 0) {
      return;
    }

    widget.onSubmit(title, value, _selectedDate);
  }

  _showDatePicker() async {
    _selectedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2019),
          lastDate: DateTime.now(),
        ) ??
        DateTime.now();

    setState(() {
      _selectedDate;
    });
  }

  // Iphone 1000
  // Pizza 100
  // Apple Watch 700

  // Airpods 350
  // Skate 200
  // Mouse 400

  // Keyboard 300

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding:  EdgeInsets.only(right: 16, top: 16, left: 16.0, bottom: MediaQuery.of(context).viewInsets.bottom + 16),
        child: Column(
          children: [
            AdaptativeTextField(
              labelText: 'Título',
              controller: _titleController,
            ),
            AdaptativeTextField(
              labelText: 'Valor (R\$)',
              controller: _valueController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onSubmitted: (value) {
                _submitForm();
              },
            ),
            SizedBox(
              height: 70,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Data Selecionada: ${DateFormat('dd/MM/y').format(_selectedDate)}",
                    ),
                  ),
                  TextButton(
                    onPressed: _showDatePicker,
                    child: Text(
                      "Selecionar Data",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AdaptativeButton(
                  onPressed: _submitForm,
                  label: 'Nova Transação',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
