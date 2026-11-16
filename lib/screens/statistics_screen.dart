import 'package:flutter/material.dart';

import 'package:untitled/models/transaction.dart';
import 'package:untitled/services/transaction_service.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final periods = ['Tháng này', 'Tháng trước', 'Năm nay'];
  String selectedPeriod = 'Tháng này';
  List<Transaction> transactions = [];

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    try {
      final result = await TransactionService.getAll();
      if (mounted) setState(() => transactions = result);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Không thể tải thống kê')));
      }
    }
  }

  DateTimeRange get _periodRange {
    final now = DateTime.now();
    if (selectedPeriod == 'Năm nay') {
      return DateTimeRange(
        start: DateTime(now.year),
        end: DateTime(now.year + 1),
      );
    }
    final month = selectedPeriod == 'Tháng trước' ? now.month - 1 : now.month;
    final year = month == 0 ? now.year - 1 : now.year;
    final normalizedMonth = month == 0 ? 12 : month;
    return DateTimeRange(
      start: DateTime(year, normalizedMonth),
      end: DateTime(year, normalizedMonth + 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = TransactionService.filter(
      transactions,
      type: 'Chi tiêu',
      range: _periodRange,
    );
    final total = TransactionService.totalExpense(filtered);
    final grouped = <String, double>{};
    for (final transaction in filtered) {
      grouped.update(
        transaction.category,
        (value) => value + transaction.amount,
        ifAbsent: () => transaction.amount,
      );
    }
    final categories = grouped.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final colors = [
      const Color(0xFFFF6268),
      const Color(0xFF2878E8),
      const Color(0xFF42B866),
      const Color(0xFF8B5CF6),
      const Color(0xFFF59E0B),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thống kê'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF18243A),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: periods.map((label) {
              final selected = label == selectedPeriod;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: OutlinedButton(
                    onPressed: () => setState(() => selectedPeriod = label),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: selected
                          ? const Color(0xFF2878E8)
                          : Colors.white,
                      foregroundColor: selected
                          ? Colors.white
                          : const Color(0xFF687386),
                    ),
                    child: Text(label, style: const TextStyle(fontSize: 11)),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          Center(
            child: SizedBox(
              height: 210,
              width: 210,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: const Size.square(210),
                    painter: _StatisticsChartPainter(
                      values: categories.map((entry) => entry.value).toList(),
                      colors: colors,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${total.round()} đ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'Tổng chi tiêu',
                        style: TextStyle(color: Color(0xFF8993A4)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          if (categories.isEmpty)
            const Center(
              child: Text('Chưa có dữ liệu trong khoảng thời gian này'),
            )
          else
            ...categories.asMap().entries.map((entry) {
              final amount = entry.value.value;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 5,
                      backgroundColor: colors[entry.key % colors.length],
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: Text(entry.value.key)),
                    Text('${amount.round()} đ'),
                    const SizedBox(width: 16),
                    Text(
                      total == 0 ? '0%' : '${(amount / total * 100).round()}%',
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}

class _StatisticsChartPainter extends CustomPainter {
  final List<double> values;
  final List<Color> colors;

  const _StatisticsChartPainter({required this.values, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final total = values.fold<double>(0, (sum, value) => sum + value);
    if (total == 0) return;
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - 8;
    var start = -1.5708;
    for (var i = 0; i < values.length; i++) {
      final sweep = values[i] / total * 6.2832;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        sweep,
        false,
        Paint()
          ..color = colors[i % colors.length]
          ..style = PaintingStyle.stroke
          ..strokeWidth = 28,
      );
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _StatisticsChartPainter oldDelegate) =>
      oldDelegate.values != values;
}
