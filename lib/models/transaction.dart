class Transaction {
  final int? id;
  final String title;
  final double amount;
  final String date;
  final String category;
  final bool isIncome;
  final String note;

  Transaction({
    this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.isIncome,
    this.note = '',
  });

  Map<String, dynamic> toMap({bool includeId = false}) {
    final map = <String, dynamic>{
      'title': title,
      'amount': amount,
      'date': date,
      'category': category,
      'is_income': isIncome ? 1 : 0,
      'note': note,
    };
    if (includeId && id != null) map['id'] = id;
    return map;
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      title: map['title'],
      amount: (map['amount'] as num).toDouble(),
      date: map['date'],
      category: map['category'],
      isIncome: (map['is_income'] ?? 0) == 1,
      note: map['note'] ?? '',
    );
  }
}
