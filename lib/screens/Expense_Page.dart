import 'package:flutter/material.dart';

import 'package:untitled/models/transaction.dart';
import 'package:untitled/services/transaction_service.dart';

class TransactionForm extends StatefulWidget {
  final bool isEdit;
  final Transaction? transaction;

  const TransactionForm({super.key, required this.isEdit, this.transaction});

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  bool isExpense = true;

  String category = 'Ăn uống';

  DateTime selectedDate = DateTime.now();
  bool isSaving = false;

  final TextEditingController amountController = TextEditingController();

  final TextEditingController noteController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final transaction = widget.transaction;
    if (transaction != null) {
      isExpense = !transaction.isIncome;
      category = transaction.category;
      amountController.text = transaction.amount.toStringAsFixed(0);
      noteController.text = transaction.note.isEmpty
          ? transaction.title
          : transaction.note;
      selectedDate = DateTime.tryParse(transaction.date) ?? selectedDate;
    }
  }

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  Future<void> selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: Color(0xFF18243A),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.isEdit ? 'Sửa giao dịch' : 'Thêm giao dịch',
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color(0xFF18243A),
          ),
        ),
        centerTitle: true,
        actions: [
          if (widget.isEdit && widget.transaction?.id != null)
            IconButton(
              tooltip: 'Xóa giao dịch',
              icon: const Icon(Icons.delete_outline),
              onPressed: _deleteTransaction,
            ),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              buildTypeSelector(),

              const SizedBox(height: 20),

              buildLabel('Danh mục'),

              const SizedBox(height: 7),

              buildCategoryDropdown(),

              const SizedBox(height: 20),

              buildLabel('Số tiền'),

              const SizedBox(height: 7),

              buildAmountField(),

              const SizedBox(height: 20),

              buildLabel('Ngày giao dịch'),

              const SizedBox(height: 7),

              buildDateField(),

              const SizedBox(height: 20),

              buildLabel('Ghi chú'),

              const SizedBox(height: 7),

              buildNoteField(),

              const SizedBox(height: 24),

              buildSaveButton(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color(0xFF18243A),
      ),
    );
  }


  Widget buildTypeSelector() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE1E5EB)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isExpense = true;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isExpense ? const Color(0xFFFF6268) : Colors.white,
                  borderRadius: BorderRadius.circular(7),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Chi tiêu',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isExpense ? Colors.white : const Color(0xFF18243A),
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isExpense = false;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: !isExpense ? const Color(0xFF3B82F6) : Colors.white,
                  borderRadius: BorderRadius.circular(7),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Thu nhập',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: !isExpense ? Colors.white : const Color(0xFF18243A),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget buildCategoryDropdown() {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFDDE3EA)),
        borderRadius: BorderRadius.circular(7),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: category,
          isExpanded: true,

          icon: const Icon(
            Icons.keyboard_arrow_down,
            size: 20,
            color: Color(0xFF687386),
          ),

          items: const [
            DropdownMenuItem(
              value: 'Ăn uống',
              child: Row(
                children: [
                  Icon(Icons.restaurant, size: 17, color: Color(0xFFFF6268)),
                  SizedBox(width: 10),
                  Text('Ăn uống', style: TextStyle(fontSize: 13)),
                ],
              ),
            ),

            DropdownMenuItem(
              value: 'Di chuyển',
              child: Text('Di chuyển', style: TextStyle(fontSize: 13)),
            ),

            DropdownMenuItem(
              value: 'Mua sắm',
              child: Text('Mua sắm', style: TextStyle(fontSize: 13)),
            ),

            DropdownMenuItem(
              value: 'Học tập',
              child: Text('Học tập', style: TextStyle(fontSize: 13)),
            ),
          ],

          onChanged: (value) {
            if (value != null) {
              setState(() {
                category = value;
              });
            }
          },
        ),
      ),
    );
  }


  Widget buildAmountField() {
    return TextField(
      controller: amountController,
      keyboardType: TextInputType.number,

      decoration: InputDecoration(
        hintText: 'Nhập số tiền',
        hintStyle: const TextStyle(color: Color(0xFFB0B8C4), fontSize: 12),

        suffixText: 'đ',
        suffixStyle: const TextStyle(color: Color(0xFF687386), fontSize: 12),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(color: Color(0xFFDDE3EA)),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(color: Color(0xFFDDE3EA)),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(color: Color(0xFF2878E8)),
        ),
      ),
    );
  }


  Widget buildDateField() {
    return GestureDetector(
      onTap: selectDate,
      child: Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFDDE3EA)),
          borderRadius: BorderRadius.circular(7),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                formatDate(selectedDate),
                style: const TextStyle(fontSize: 13, color: Color(0xFF3E4A5C)),
              ),
            ),

            const Icon(
              Icons.calendar_month_outlined,
              size: 18,
              color: Color(0xFF687386),
            ),
          ],
        ),
      ),
    );
  }


  Widget buildNoteField() {
    return TextField(
      controller: noteController,
      maxLines: 3,

      decoration: InputDecoration(
        hintText: 'Nhập ghi chú (tùy chọn)',
        hintStyle: const TextStyle(color: Color(0xFFB0B8C4), fontSize: 12),

        contentPadding: const EdgeInsets.all(12),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(color: Color(0xFFDDE3EA)),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(color: Color(0xFFDDE3EA)),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(color: Color(0xFF2878E8)),
        ),
      ),
    );
  }


  Widget buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 44,

      child: ElevatedButton(
        onPressed: isSaving ? null : _saveTransaction,

        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2878E8),
          foregroundColor: Colors.white,

          elevation: 0,

          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        ),

        child: const Text(
          'Lưu',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Future<void> _saveTransaction() async {
    final amount = double.tryParse(
      amountController.text.replaceAll(RegExp(r'[^0-9]'), ''),
    );
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập số tiền hợp lệ')),
      );
      return;
    }

    setState(() => isSaving = true);
    final existing = widget.transaction;
    final transaction = Transaction(
      id: existing?.id,
      title: noteController.text.trim().isEmpty
          ? category
          : noteController.text.trim(),
      amount: amount,
      date: selectedDate.toIso8601String(),
      category: category,
      isIncome: !isExpense,
      note: noteController.text.trim(),
    );

    try {
      if (widget.isEdit) {
        await TransactionService.update(transaction);
      } else {
        await TransactionService.save(transaction);
      }
      if (mounted) Navigator.pop(context, true);
    } catch (_) {
      if (mounted) {
        setState(() => isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không thể lưu giao dịch')),
        );
      }
    }
  }

  Future<void> _deleteTransaction() async {
    final id = widget.transaction?.id;
    if (id == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa giao dịch?'),
        content: const Text('Giao dịch này sẽ bị xóa vĩnh viễn.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await TransactionService.delete(id);
      if (mounted) Navigator.pop(context, true);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không thể xóa giao dịch')),
        );
      }
    }
  }
}

class AddTransactionScreen extends StatelessWidget {
  const AddTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TransactionForm(isEdit: false);
  }
}

class EditTransactionScreen extends StatelessWidget {
  final Transaction transaction;

  const EditTransactionScreen({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return TransactionForm(isEdit: true, transaction: transaction);
  }
}
