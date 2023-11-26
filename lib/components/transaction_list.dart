import 'package:expenses/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({super.key, required this.transactions, required this.onRemove});

  final Function(String) onRemove;
  final List<Transaction> transactions;

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(builder: (context, constraints) {
            return Column(
              children: [
                SizedBox(
                  height: constraints.maxHeight * 0.01,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    height: constraints.maxHeight * 0.1,
                    child: FittedBox(
                      child: Text(
                        'Nenhuma Transação Cadastrada!',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: constraints.maxHeight * 0.1,
                ),
                SizedBox(
                  height: constraints.maxHeight * 0.6,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: constraints.maxHeight * 0.19,
                ),
              ],
            );
          })
        : ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (ctx, index) {
              final mediaQuery = MediaQuery.of(context);
              return Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 5,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: FittedBox(child: Text('R\$${transactions[index].value}')),
                    ),
                  ),
                  title: Text(
                    transactions[index].title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  subtitle: Text(DateFormat('dd/MM/y').format(transactions[index].date)),
                  trailing: mediaQuery.size.width > 480
                      ? ElevatedButton.icon(
                          style: ButtonStyle(elevation: MaterialStateProperty.all(5), surfaceTintColor: MaterialStateProperty.all(Colors.white)),
                          onPressed: () {
                            onRemove(transactions[index].id);
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          label: Text(
                            'Excluir',
                            style: TextStyle(color: Theme.of(context).colorScheme.error),
                          ),
                        )
                      : IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            onRemove(transactions[index].id);
                          },
                          color: Theme.of(context).colorScheme.error,
                        ),
                ),
              );
            },
          );
  }
}
