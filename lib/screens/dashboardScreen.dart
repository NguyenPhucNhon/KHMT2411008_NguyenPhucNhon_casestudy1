import 'package:flutter/material.dart';

import 'package:untitled/models/transaction.dart';
import 'package:untitled/services/transaction_service.dart';

import 'Expense_Page.dart';
import 'profile_screen.dart';
import 'statistics_screen.dart';
import 'transactions_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không thể tải dữ liệu giao dịch')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    _buildHeader(),

                    const SizedBox(height: 14),

                    _buildBalanceCard(),

                    const SizedBox(height: 9),

                    _buildIncomeExpense(),

                    const SizedBox(height: 16),

                    _buildRecentTitle(),

                    const SizedBox(height: 7),

                    _buildTransactionList(),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTransactionScreen(),
            ),
          ).then((changed) {
            if (changed == true) _loadTransactions();
          });
        },
        backgroundColor: const Color(0xFF2878E8),
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),

      // THANH ĐIỀU HƯỚNG
      bottomNavigationBar: _buildBottomNavigation(context),
    );
  }

  String _formatDate(String value) {
    final date = DateTime.tryParse(value);
    if (date == null) return value;
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatAmount(double value) => value.round().toString();

  void _showMessage(BuildContext context, String title) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: const Text('Hiện chưa có nội dung mới.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }


  Widget _buildHeader() {
    return Row(
      children: [
        IconButton(
          onPressed: () => _showMessage(context, 'Menu'),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: const Icon(Icons.menu, size: 21, color: Color(0xFF172033)),
        ),

        const SizedBox(width: 17),

        const Expanded(
          child: Text(
            'Quản lý thu chi',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF172033),
            ),
          ),
        ),

        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              onPressed: () => _showMessage(context, 'Thông báo'),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(
                Icons.notifications_none_outlined,
                size: 22,
                color: Color(0xFF172033),
              ),
            ),

            Positioned(
              right: -1,
              top: -2,
              child: Container(
                width: 14,
                height: 14,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF3B30),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Text(
                  '3',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }


  Widget _buildBalanceCard() {
    final balance =
        5000000 +
        TransactionService.totalIncome(transactions) -
        TransactionService.totalExpense(transactions);
    return Container(
      width: double.infinity,
      height: 108,

      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4A8AF5), Color(0xFF1761DA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        borderRadius: BorderRadius.circular(10),

        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.20),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Stack(
        children: [
          Positioned(
            right: 10,
            bottom: 7,
            child: Icon(
              Icons.account_balance_wallet,
              size: 49,
              color: Colors.white.withOpacity(0.55),
            ),
          ),

          Positioned(
            right: 43,
            bottom: 7,
            child: Icon(Icons.monetization_on, size: 30, color: Colors.amber),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'SỐ DƯ HIỆN TẠI',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  SizedBox(width: 7),

                  Icon(
                    Icons.visibility_outlined,
                    size: 14,
                    color: Colors.white,
                  ),
                ],
              ),

              const SizedBox(height: 7),

              Text(
                '${_formatAmount(balance)} đ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          Positioned(
            bottom: 7,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 9,
                  height: 3,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),

                const SizedBox(width: 4),

                Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.45),
                    shape: BoxShape.circle,
                  ),
                ),

                const SizedBox(width: 4),

                Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.45),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildIncomeExpense() {
    final income = TransactionService.totalIncome(transactions);
    final expense = TransactionService.totalExpense(transactions);
    return Row(
      children: [
        Expanded(
          child: _buildMoneyCard(
            title: 'TỔNG THU NHẬP',
            amount: '${_formatAmount(income)} đ',
            icon: Icons.arrow_downward,
            iconColor: const Color(0xFF42B866),
            backgroundColor: const Color(0xFFEAF8EC),
            amountColor: const Color(0xFF21A642),
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: _buildMoneyCard(
            title: 'TỔNG CHI TIÊU',
            amount: '${_formatAmount(expense)} đ',
            icon: Icons.arrow_upward,
            iconColor: const Color(0xFFFF5862),
            backgroundColor: const Color(0xFFFFECEE),
            amountColor: const Color(0xFFFF3D49),
          ),
        ),
      ],
    );
  }

  Widget _buildMoneyCard({
    required String title,
    required String amount,
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required Color amountColor,
  }) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 8),

      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(7),
      ),

      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 15, color: iconColor),
          ),

          const SizedBox(width: 7),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 7,
                  color: Color(0xFF667085),
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                amount,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: amountColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildRecentTitle() {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Giao dịch gần đây',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Color(0xFF172033),
            ),
          ),
        ),

        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TransactionsScreen()),
            );
          },
          child: const Text(
            'Xem tất cả',
            style: TextStyle(
              fontSize: 8,
              color: Color(0xFF2878E8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildTransactionList() {
    final recent = transactions.take(5).toList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE9EDF2)),
      ),
      child: Column(
        children: List.generate(recent.length, (index) {
          final transaction = recent[index];

          return _buildTransactionItem(
            title: transaction.title,
            category: transaction.category,
            date: _formatDate(transaction.date),
            amount:
                '${transaction.isIncome ? '+' : '-'}${_formatAmount(transaction.amount)} đ',
            icon: transaction.isIncome
                ? Icons.account_balance_wallet
                : Icons.receipt_long,
            color: transaction.isIncome
                ? const Color(0xFF28A745)
                : const Color(0xFFFF6268),
            isIncome: transaction.isIncome,
            showDivider: index != recent.length - 1,
          );
        }),
      ),
    );
  }


  Widget _buildTransactionItem({
    required String title,
    required String category,
    required String date,
    required String amount,
    required IconData icon,
    required Color color,
    required bool isIncome,
    required bool showDivider,
  }) {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 7),

      decoration: BoxDecoration(
        border: showDivider
            ? const Border(bottom: BorderSide(color: Color(0xFFEAECEF)))
            : null,
      ),

      child: Row(
        children: [
          // ICON
          Container(
            width: 27,
            height: 27,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(icon, color: Colors.white, size: 15),
          ),

          const SizedBox(width: 8),

          // TÊN + DANH MỤC
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF172033),
                  ),
                ),

                const SizedBox(height: 2),

                Row(
                  children: [
                    Text(
                      category,
                      style: const TextStyle(
                        fontSize: 7,
                        color: Color(0xFF8993A4),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 7,
                        color: Color(0xFF8993A4),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // SỐ TIỀN
          Text(
            amount,
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.bold,
              color: isIncome
                  ? const Color(0xFF21A642)
                  : const Color(0xFFFF3947),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildBottomNavigation(BuildContext context) {
    return Container(
      height: 57,

      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE9EDF2))),
      ),

      child: Row(
        children: [
          _buildNavItem(icon: Icons.home, title: 'Trang chủ', active: true),

          _buildNavItem(
            icon: Icons.receipt_long_outlined,
            title: 'Giao dịch',
            active: false,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TransactionsScreen()),
              );
            },
          ),

          _buildNavItem(
            icon: Icons.pie_chart_outline,
            title: 'Thống kê',
            active: false,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StatisticsScreen()),
              );
            },
          ),

          _buildNavItem(
            icon: Icons.person_outline,
            title: 'Cá nhân',
            active: false,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String title,
    required bool active,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 19,
              color: active ? const Color(0xFF2878E8) : const Color(0xFF4D5665),
            ),

            const SizedBox(height: 2),

            Text(
              title,
              style: TextStyle(
                fontSize: 7,
                fontWeight: active ? FontWeight.bold : FontWeight.normal,
                color: active
                    ? const Color(0xFF2878E8)
                    : const Color(0xFF4D5665),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
