import 'package:flutter/material.dart';

import 'package:untitled/database/database_helper.dart';
import 'package:untitled/models/transaction.dart';

class TransactionService {
  const TransactionService._();

  static Future<List<Transaction>> getAll() async {
    final rows = await DatabaseHelper.instance.getTransactions();
    return rows.map(Transaction.fromMap).toList();
  }

  static Future<int> save(Transaction transaction) {
    return DatabaseHelper.instance.insertTransaction(transaction.toMap());
  }

  static Future<int> update(Transaction transaction) {
    final id = transaction.id;
    if (id == null) {
      throw ArgumentError('A transaction id is required for update.');
    }
    return DatabaseHelper.instance.updateTransaction(id, transaction.toMap());
  }

  static Future<int> delete(int id) {
    return DatabaseHelper.instance.deleteTransaction(id);
  }

  static List<Transaction> filter(
    List<Transaction> transactions, {
    String query = '',
    String type = 'Tất cả',
    String category = 'Tất cả danh mục',
    DateTimeRange? range,
  }) {
    final normalizedQuery = query.trim().toLowerCase();
    return transactions.where((transaction) {
      final matchesQuery =
          normalizedQuery.isEmpty ||
          transaction.title.toLowerCase().contains(normalizedQuery) ||
          transaction.category.toLowerCase().contains(normalizedQuery) ||
          transaction.note.toLowerCase().contains(normalizedQuery);
      final matchesType =
          type == 'Tất cả' ||
          (type == 'Thu nhập' && transaction.isIncome) ||
          (type == 'Chi tiêu' && !transaction.isIncome);
      final matchesCategory =
          category == 'Tất cả danh mục' || transaction.category == category;
      final date = DateTime.tryParse(transaction.date);
      final matchesRange =
          range == null ||
          (date != null &&
              !date.isBefore(range.start) &&
              !date.isAfter(range.end));
      return matchesQuery && matchesType && matchesCategory && matchesRange;
    }).toList();
  }

  static double totalIncome(Iterable<Transaction> transactions) => transactions
      .where((transaction) => transaction.isIncome)
      .fold(0, (total, transaction) => total + transaction.amount);

  static double totalExpense(Iterable<Transaction> transactions) => transactions
      .where((transaction) => !transaction.isIncome)
      .fold(0, (total, transaction) => total + transaction.amount);
}
