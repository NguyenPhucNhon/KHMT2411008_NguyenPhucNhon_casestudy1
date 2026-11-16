import 'package:flutter/material.dart';

import 'package:untitled/models/transaction.dart';
import 'package:untitled/services/transaction_service.dart';

import 'Expense_Page.dart';
import 'filter_screen.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final searchController = TextEditingController();
  List<Transaction> transactions = [];
  String filter = 'Tất cả';
  String category = 'Tất cả danh mục';
  DateTimeRange? range;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
    searchController.addListener(_refresh);
  }

  @override
  void dispose() {
    searchController
      ..removeListener(_refresh)
      ..dispose();
    super.dispose();
  }

  Future<void> _loadTransactions() async {
    try {
      final result = await TransactionService.getAll();
      if (mounted) {
        setState(() {
          transactions = result;
          isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không thể tải giao dịch')),
        );
      }
    }
  }

  void _refresh() => setState(() {});

  Future<void> _openEditor([Transaction? transaction]) async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => transaction == null
            ? const AddTransactionScreen()
            : EditTransactionScreen(transaction: transaction),
      ),
    );
    if (changed == true) _loadTransactions();
  }

  List<Transaction> get visible => TransactionService.filter(
    transactions,
    query: searchController.text,
    type: filter,
    category: category,
    range: range,
  );

  @override
  Widget build(BuildContext context) {
    final items = visible;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giao dịch'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF18243A),
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Thêm giao dịch',
            onPressed: () => _openEditor(),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm giao dịch...',
                      prefixIcon: const Icon(Icons.search, size: 20),
                      suffixIcon: searchController.text.isEmpty
                          ? null
                          : IconButton(
                              onPressed: searchController.clear,
                              icon: const Icon(Icons.clear),
                            ),
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
                    final result = await Navigator.push<TransactionFilter>(
                      context,
                      MaterialPageRoute(builder: (_) => const FilterScreen()),
                    );
                    if (result != null) {
                      setState(() {
                        filter = result.type;
                        category = result.category;
                        range = result.range;
                      });
                    }
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
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : items.isEmpty
                ? const Center(child: Text('Chưa có giao dịch phù hợp'))
                : RefreshIndicator(
                    onRefresh: _loadTransactions,
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: items.length,
                      separatorBuilder: (_, index) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundColor: item.isIncome
                                ? const Color(0xFFEAF8EC)
                                : const Color(0xFFFFECEE),
                            child: Icon(
                              item.isIncome
                                  ? Icons.account_balance_wallet
                                  : Icons.remove,
                              color: item.isIncome
                                  ? const Color(0xFF21A642)
                                  : const Color(0xFFFF3947),
                            ),
                          ),
                          title: Text(item.title),
                          subtitle: Text(
                            '${item.category} • ${_formatDate(item.date)}',
                          ),
                          trailing: Text(
                            '${item.isIncome ? '+' : '-'}${_formatAmount(item.amount)} đ',
                            style: TextStyle(
                              color: item.isIncome
                                  ? const Color(0xFF21A642)
                                  : const Color(0xFFFF3947),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () => _openEditor(item),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openEditor(),
        child: const Icon(Icons.add),
      ),
    );
  }

  String _formatDate(String value) {
    final date = DateTime.tryParse(value);
    if (date == null) return value;
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatAmount(double value) => value.round().toString();
}
