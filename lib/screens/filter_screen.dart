import 'package:flutter/material.dart';

class TransactionFilter {
  final String type;
  final String category;
  final DateTimeRange? range;

  const TransactionFilter({
    required this.type,
    required this.category,
    this.range,
  });
}

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String type = 'Tất cả';
  String period = 'Hôm nay';
  String category = 'Tất cả danh mục';

  DateTimeRange? get selectedRange {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    switch (period) {
      case 'Hôm nay':
        return DateTimeRange(
          start: today,
          end: today.add(const Duration(days: 1)),
        );
      case '7 ngày qua':
        return DateTimeRange(
          start: today.subtract(const Duration(days: 6)),
          end: today.add(const Duration(days: 1)),
        );
      case 'Tháng này':
        return DateTimeRange(
          start: DateTime(now.year, now.month),
          end: DateTime(now.year, now.month + 1),
        );
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bộ lọc'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF18243A),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Loại giao dịch',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          ...['Tất cả', 'Thu nhập', 'Chi tiêu'].map(
            (value) => RadioListTile<String>(
              contentPadding: EdgeInsets.zero,
              title: Text(value),
              value: value,
              groupValue: type,
              onChanged: (value) => setState(() => type = value!),
            ),
          ),
          const SizedBox(height: 12),
          const Text('Danh mục', style: TextStyle(fontWeight: FontWeight.bold)),
          DropdownButtonFormField<String>(
            value: category,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            items: const ['Tất cả danh mục', 'Ăn uống', 'Mua sắm', 'Di chuyển']
                .map(
                  (value) => DropdownMenuItem(value: value, child: Text(value)),
                )
                .toList(),
            onChanged: (value) => setState(() => category = value!),
          ),
          const SizedBox(height: 20),
          const Text(
            'Khoảng thời gian',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          ...['Tất cả thời gian', 'Hôm nay', '7 ngày qua', 'Tháng này'].map(
            (value) => RadioListTile<String>(
              contentPadding: EdgeInsets.zero,
              title: Text(value),
              value: value,
              groupValue: period,
              onChanged: (value) => setState(() => period = value!),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 46,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(
                context,
                TransactionFilter(
                  type: type,
                  category: category,
                  range: selectedRange,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2878E8),
                foregroundColor: Colors.white,
              ),
              child: const Text('Áp dụng'),
            ),
          ),
        ],
      ),
    );
  }
}
