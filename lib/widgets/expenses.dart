import 'package:expense_tracker/widgets/new_expense.dart';
import "package:flutter/material.dart";

import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';

import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/chart.dart';
// import 'package:expense_tracker/widgets/chart_bar.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
      amount: 499,
      title: 'Flutter Course',
      date: DateTime.now(),
      categaory: Categaory.work,
    ),
    Expense(
      amount: 299,
      title: 'Spider Man lost the home',
      date: DateTime.now(),
      categaory: Categaory.entertainment,
    ),
  ];

  // Chart myChart = Chart(expenses: _registeredExpenses);
  void _openAddExpenseOverlay() {
    //....
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: _addExpense),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        content: const Text("Expenses Deleted..."),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = (MediaQuery.of(context).size.width);
    print(width);
    Widget mainContent = const Center(
      child: Text("No expenses found, Start tracking you Expenses"),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Expense Tracker",
            style: TextStyle(color: Colors.black),
          ),
        ),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
            color: Colors.black,
          )
        ],
      ),
      body: width < 700
          ? Column(
              children: [
                Chart(
                  expenses: _registeredExpenses,
                ),
                Expanded(
                  child: mainContent,
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: Chart(
                    expenses: _registeredExpenses,
                  ),
                ),
                Expanded(
                  child: mainContent,
                ),
              ],
            ),

      //The Belowo code is written by me :)
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            label: "Home",
            icon: OutlinedButton(
              onPressed: () {},
              child: const Icon(Icons.home),
            ),
          ),
          BottomNavigationBarItem(
            label: "Add Expense",
            icon: OutlinedButton(
              onPressed: _openAddExpenseOverlay,
              child: const Icon(Icons.add),
            ),
          ),
          BottomNavigationBarItem(
            label: "Profile",
            icon: OutlinedButton(
              onPressed: () {},
              child: const Icon(Icons.person_sharp),
            ),
          )
        ],
        currentIndex: 0,
        fixedColor: Colors.black,
      ),
    );
  }
}
//tool bar with add button
