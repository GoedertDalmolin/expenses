import 'dart:math';
import 'dart:io';

import 'package:expenses/components/chart.dart';
import 'package:expenses/components/transaction_form.dart';
import 'package:expenses/components/transaction_list.dart';
import 'package:expenses/models/transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
        bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Colors.white, surfaceTintColor: Colors.transparent),
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

  final iconList = Platform.isIOS ? CupertinoIcons.list_bullet : Icons.list;
  final iconChart = Platform.isIOS ? CupertinoIcons.chart_bar_square : Icons.show_chart;

  List<Transaction> get _recentTransactions {
    return _transactions.where((element) {
      return element.date.isAfter(DateTime.now().subtract(const Duration(days: 7)));
    }).toList();
  }

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(10),
          ),
        ),
        isScrollControlled: true,
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

  Widget _getIconButton(IconData icon, Function() fn) {
    return Platform.isIOS ? GestureDetector(onTap: fn, child: Icon(icon)) : IconButton(icon: Icon(icon), onPressed: fn);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    bool isLandscape = mediaQuery.orientation == Orientation.landscape;

    final actions = [
      if (isLandscape)
        _getIconButton(
          _showChart ? iconList : iconChart,
          () {
            setState(() {
              _showChart = !_showChart;
            });
          },
        ),
      _getIconButton(
        Platform.isIOS ? CupertinoIcons.add : Icons.add,
        () {
          _openTransactionFormModal(context);
        },
      ),
    ];

    final appBar = AppBar(
      title: Text(
        'Despesas Pessoais',
        style: TextStyle(
          fontSize: mediaQuery.textScaler.scale(20),
        ),
      ),
      actions: actions,
      backgroundColor: Theme.of(context).colorScheme.primary,
    );

    final sizeAppBar = appBar.preferredSize.height;
    final availableHeight = mediaQuery.size.height - sizeAppBar - mediaQuery.padding.top;

    final bodyPage = SafeArea(
      child: SingleChildScrollView(
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
                height: availableHeight * (isLandscape ? 1 : 0.75),
                child: TransactionList(
                  transactions: _transactions,
                  onRemove: _removeTransaction,
                ),
              )
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: const Text('Despesas Pessoais'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: actions,
              ),
            ),
            child: bodyPage,
          )
        : Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            appBar: appBar,
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? null
                : FloatingActionButton(
                    child: const Icon(Icons.add),
                    onPressed: () {
                      _openTransactionFormModal(context);
                    },
                  ),
            body: bodyPage,
          );
  }
}
