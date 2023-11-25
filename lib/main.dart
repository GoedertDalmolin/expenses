import 'dart:math';

import 'package:expenses/components/chart.dart';
import 'package:expenses/components/transaction_form.dart';
import 'package:expenses/components/transaction_list.dart';
import 'package:expenses/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

main() => runApp(const ExpensesApp());

class ExpensesApp extends StatelessWidget {
  const ExpensesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(),
      theme: ThemeData(
        useMaterial3: true,
        cardTheme: const CardTheme(
          surfaceTintColor: Colors.white,
        ),
        datePickerTheme: const DatePickerThemeData(surfaceTintColor: Colors.white),
        fontFamily: GoogleFonts.getFont('Quicksand').fontFamily,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
          backgroundColor: Colors.white,
          cardColor: Colors.white,
        ),
        switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.resolveWith(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)) {
                return Colors.purple;
              }
              return Colors.grey.withOpacity(.9);
            },
          ),
          trackColor: MaterialStateProperty.resolveWith(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)) {
                return Colors.white;
              }
              return Colors.white.withOpacity(.1);
            },
          ),
          overlayColor: MaterialStateProperty.resolveWith(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return Colors.grey;
              }
              return Colors.grey.withOpacity(.1);
            },
          ),
          trackOutlineColor: MaterialStateProperty.resolveWith(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)) {
                return Colors.purple;
              }
              return Colors.grey;
            },
          ),
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Colors.white,
        ),
        textTheme: ThemeData.light().textTheme.copyWith(
              titleLarge: TextStyle(
                fontFamily: GoogleFonts.getFont('Quicksand').fontFamily,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
        appBarTheme: AppBarTheme(
          iconTheme: ThemeData.light().iconTheme.copyWith(color: Colors.white),
          titleTextStyle: TextStyle(
            fontFamily: GoogleFonts.getFont('Quicksand').fontFamily,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _transactions = <Transaction>[];
  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _transactions.where((element) {
      return element.date.isAfter(DateTime.now().subtract(const Duration(days: 7)));
    }).toList();
  }

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return TransactionForm(onSubmit: _addTransaction);
        });
  }

  _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
    );

    setState(() {
      _transactions.add(newTransaction);
    });

    Navigator.pop(context);
  }

  _removeTransaction(String id) {
    setState(() {
      _transactions.removeWhere((element) => element.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape = MediaQuery.orientationOf(context) == Orientation.landscape;

    final appBar = AppBar(
      title: Text(
        'Despesas Pessoais',
        style: TextStyle(
          fontSize: MediaQuery.textScalerOf(context).scale(20),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              _showChart = !_showChart;
            });
          },
          icon: Icon(_showChart ? Icons.list : Icons.show_chart),
        ),
        IconButton(
          onPressed: () {
            _openTransactionFormModal(context);
          },
          icon: const Icon(Icons.add),
        ),
      ],
      backgroundColor: Theme.of(context).colorScheme.primary,
    );

    final sizeAppBar = appBar.preferredSize.height;
    final availableHeight = MediaQuery.sizeOf(context).height - sizeAppBar - MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: appBar,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _openTransactionFormModal(context);
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_showChart || !isLandscape)
              SizedBox(
                height: availableHeight * (isLandscape ? 0.82 : 0.25),
                child: Chart(recentTransaction: _recentTransactions),
              ),
            if (!_showChart || !isLandscape)
              SizedBox(
                height: availableHeight *  (isLandscape ? 0.90 : 0.75) ,
                child: TransactionList(
                  transactions: _transactions,
                  onRemove: _removeTransaction,
                ),
              )
          ],
        ),
      ),
    );
  }
}
