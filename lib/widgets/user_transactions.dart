import 'package:flutter/material.dart';
import 'package:personal_expenses/models/transaction.dart';
import 'package:personal_expenses/widgets/new_transactions.dart';
import 'package:personal_expenses/widgets/transaction_list.dart';

class UserTransactions extends StatefulWidget {
  const UserTransactions({super.key});

  @override
  State<UserTransactions> createState() => _UserTransactionsState();
}

class _UserTransactionsState extends State<UserTransactions> {
  final List<Transaction> _userTransactions = [
    Transaction(
        id: "t1", title: "New Shoes", amount: 69.99, date: DateTime.now()),
    Transaction(
        id: "t1", title: "Groceries", amount: 69.99, date: DateTime.now()),
    Transaction(
        id: "t1", title: "Monitor", amount: 69.99, date: DateTime.now()),
    Transaction(
        id: "t1", title: "App fees", amount: 69.99, date: DateTime.now()),
  ];

  void _addNewTransaction(String txTitle, double txAmount) {
    final newTx = Transaction(
        title: txTitle,
        amount: txAmount,
        date: DateTime.now(),
        id: DateTime.now().toString());

    setState(
      () => _userTransactions.add(newTx),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NewTransactions(_addNewTransaction),
        TransactionList(_userTransactions,),
      ],
    );
  }
}
