import 'package:flutter/material.dart';

import 'Expense_Page.dart';
import 'filter_screen.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  String filter = 'Tất cả';

  final transactions = const [
    ('Ăn uống', 'Ăn trưa', '12/04/2025', '-100.000 đ', Icons.restaurant, false),
    (
      'Mua sắm',
      'Mua sắm',
      '10/04/2025',
      '-500.000 đ',
      Icons.shopping_cart,
      false,
    ),
    (
      'Thu nhập',
      'Lương',
      '05/04/2025',
      '+10.000.000 đ',
      Icons.account_balance_wallet,
      true,
    ),
    (
      'Di chuyển',
      'Xăng xe',
      '03/04/2025',
      '-200.000 đ',
      Icons.directions_car,
      false,
    ),
    ('Học tập', 'Học phí', '01/04/2025', '-300.000 đ', Icons.menu_book, false),
  ];

  @override
  Widget build(BuildContext context) {
    final visible = filter == 'Tất cả'
        ? transactions
        : transactions
              .where((item) => filter == 'Thu nhập' ? item.$6 : !item.$6)
              .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Giao dịch'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF18243A),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm giao dịch...',
                      prefixIcon: const Icon(Icons.search, size: 20),
                      filled: true,
                      fillColor: const Color(0xFFF3F6FA),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Lọc dữ liệu',
                  onPressed: () async {
                    final result = await Navigator.push<String>(
                      context,
                      MaterialPageRoute(builder: (_) => const FilterScreen()),
                    );
                    if (result != null) setState(() => filter = result);
                  },
                  icon: const Icon(Icons.tune),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: ['Tất cả', 'Thu nhập', 'Chi tiêu'].map((value) {
                final selected = filter == value;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: OutlinedButton(
                      onPressed: () => setState(() => filter = value),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: selected
                            ? const Color(0xFF2878E8)
                            : Colors.white,
                        foregroundColor: selected
                            ? Colors.white
                            : const Color(0xFF475467),
                        side: BorderSide(
                          color: selected
                              ? const Color(0xFF2878E8)
                              : const Color(0xFFDDE3EA),
                        ),
                      ),
                      child: Text(value),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: visible.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = visible[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: item.$6
                        ? const Color(0xFFEAF8EC)
                        : const Color(0xFFFFECEE),
                    child: Icon(
                      item.$5,
                      color: item.$6
                          ? const Color(0xFF21A642)
                          : const Color(0xFFFF3947),
                    ),
                  ),
                  title: Text(item.$2),
                  subtitle: Text('${item.$1} • ${item.$3}'),
                  trailing: Text(
                    item.$4,
                    style: TextStyle(
                      color: item.$6
                          ? const Color(0xFF21A642)
                          : const Color(0xFFFF3947),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const EditTransactionScreen(),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
