import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String type = 'Tất cả';
  String period = 'Hôm nay';
  String category = 'Tất cả danh mục';

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
          ...['Hôm nay', '7 ngày qua', 'Tháng này', 'Tùy chỉnh'].map(
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
              onPressed: () => Navigator.pop(context, type),
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
