import 'package:flutter_test/flutter_test.dart';

import 'package:untitled/models/transaction.dart';
import 'package:untitled/services/transaction_service.dart';

void main() {
  final income = Transaction(
    id: 1,
    title: 'Lương',
    amount: 10000000,
    date: '2026-11-16T00:00:00.000',
    category: 'Thu nhập',
    isIncome: true,
    note: 'Lương tháng',
  );
  final expense = Transaction(
    id: 2,
    title: 'Ăn trưa',
    amount: 100000,
    date: '2026-11-15T00:00:00.000',
    category: 'Ăn uống',
    isIncome: false,
  );

  test('maps transaction fields without persisting an id on insert', () {
    final map = income.toMap();
    expect(map['id'], isNull);
    expect(map['is_income'], 1);
    expect(map['note'], 'Lương tháng');
    expect(Transaction.fromMap({...map, 'id': 5}).id, 5);
  });

  test('filters by type, category, query, and totals', () {
    final all = [income, expense];
    expect(TransactionService.filter(all, type: 'Thu nhập'), [income]);
    expect(TransactionService.filter(all, category: 'Ăn uống'), [expense]);
    expect(TransactionService.filter(all, query: 'trưa'), [expense]);
    expect(TransactionService.totalIncome(all), 10000000);
    expect(TransactionService.totalExpense(all), 100000);
  });
}
