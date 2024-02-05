import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

const uuid = Uuid();
final formatter = DateFormat.yMd();

enum Categaory { food, work, entertainment, travel, fitness }

const categaoryIcons = {
  Categaory.food: Icons.lunch_dining_sharp,
  Categaory.work: Icons.work,
  Categaory.entertainment: Icons.movie,
  Categaory.travel: Icons.flight,
  Categaory.fitness: Icons.fitness_center_sharp,
};

class Expense {
  Expense({
    required this.amount,
    required this.title,
    required this.date,
    required this.categaory,
  }) : id = uuid.v4();

  final String id;
  final String title;
  final DateTime date;
  final int amount;
  final Categaory categaory;

  String get formattedDate {
    return formatter.format(date);
  }
}

class ExpenseBucket {
  const ExpenseBucket({
    required this.category,
    required this.expenses,
  });

  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
      : expenses = allExpenses
            .where((expense) => expense.categaory == category)
            .toList();

  final Categaory category;
  final List<Expense> expenses;

  double get totalExpenses {
    double sum = 0;

    for (final expense in expenses) {
      sum += expense.amount;
    }
    return sum;
  }
}
