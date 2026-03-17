import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:expense_management/components/inputs/CustomTextField.dart';
import 'package:expense_management/components/buttons/custombutton.dart';
import 'package:expense_management/configs/theme/color.dart';
import 'package:expense_management/configs/theme/icon.dart';
import 'package:expense_management/core/data/service/authservice.dart';
import '../../../core/data/service/transactionservice.dart';
import '../../../core/data/service/walletservice.dart';
import '../../../core/model/transactions.dart';
import '../../../core/model/users.dart';
import '../../../core/model/wallet.dart';
import 'package:expense_management/core/utils/responsive.dart';

class AddTransaction extends StatefulWidget {
  final String? walletId;
  final Users users;

  const AddTransaction({super.key, this.walletId, required this.users});

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  String _selectedType = 'expense';
  DateTime _selectedDate = DateTime.now();

  List<Map<String, dynamic>> _categories = <Map<String, dynamic>>[];
  String? _selectedCategoryId;

  List<Wallet> _myWallets = <Wallet>[];
  String? _selectedWalletId;

  @override
  void initState() {
    super.initState();
    _myWallets = WalletService().getWallets(widget.users.email);

    if (widget.walletId != null) {
      _selectedWalletId = widget.walletId;
    } else if (_myWallets.isNotEmpty) {
      _selectedWalletId = _myWallets.first.id;
    }

    _loadCategories();
  }

  void _loadCategories() {
    final box = Hive.box('categories');
    final list = <Map<String, dynamic>>[];

    for (final key in box.keys) {
      final raw = box.get(key);
      if (raw is Map) {
        final map = Map<String, dynamic>.from(raw);
        if ((map['user_email'] ?? '').toString() == widget.users.email) {
          list.add({
            ...map,
            'id': key.toString(),
          });
        }
      }
    }

    list.sort((a, b) =>
        (a['created_at'] ?? '').toString().compareTo((b['created_at'] ?? '').toString()));

    setState(() {
      _categories = list;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _showCategoryPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(Responsive.r(24))),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Chọn danh mục',
                  style: TextStyle(
                    fontSize: Responsive.sp(18),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'BeVietnamPro',
                  ),
                ),
              ),
              Expanded(
                child: _categories.isEmpty
                    ? Center(
                        child: Text(
                          'Bạn chưa có danh mục nào!',
                          style: TextStyle(
                            fontFamily: 'BeVietnamPro',
                            fontSize: Responsive.sp(14),
                            color: const Color(0xFF98A2B3),
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _categories.length + (_selectedType == 'income' ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (_selectedType == 'income' && index == 0) {
                            final isSelected = _selectedCategoryId == null;
                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                              leading: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF12B76A).withOpacity(0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.help_outline_rounded, color: Color(0xFF12B76A)),
                              ),
                              title: Text(
                                'Không xác định (chưa phân bổ)',
                                style: TextStyle(
                                  fontSize: Responsive.sp(16),
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                  color: isSelected ? Colors.blueAccent : Colors.black87,
                                  fontFamily: 'BeVietnamPro',
                                ),
                              ),
                              trailing: isSelected
                                  ? const Icon(Icons.check_circle, color: Colors.blueAccent)
                                  : null,
                              onTap: () {
                                setState(() {
                                  _selectedCategoryId = null;
                                });
                                Navigator.pop(context);
                              },
                            );
                          }

                          final dataIndex = _selectedType == 'income' ? index - 1 : index;
                          final category = _categories[dataIndex];
                          final categoryId = (category['id'] ?? '').toString();
                          final isSelected = categoryId == _selectedCategoryId;
                          final iconCode = (category['icon_code'] ?? Icons.category.codePoint) as int;
                          final colorValue = (category['color_value'] ?? const Color(0xFF7B61FF).value) as int;

                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                            leading: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Color(colorValue).withOpacity(0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                IconData(iconCode, fontFamily: 'MaterialIcons'),
                                color: Color(colorValue),
                              ),
                            ),
                            title: Text(
                              (category['name'] ?? 'Danh mục').toString(),
                              style: TextStyle(
                                fontSize: Responsive.sp(16),
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                color: isSelected ? Colors.blueAccent : Colors.black87,
                                fontFamily: 'BeVietnamPro',
                              ),
                            ),
                            trailing: isSelected
                                ? const Icon(Icons.check_circle, color: Colors.blueAccent)
                                : null,
                            onTap: () {
                              setState(() {
                                _selectedCategoryId = categoryId;
                              });
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickTransactionDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = DateTime(
          picked.year,
          picked.month,
          picked.day,
          DateTime.now().hour,
          DateTime.now().minute,
        );
      });
    }
  }

  void _saveTransaction() async {
    final isIncome = _selectedType == 'income';

    if (!isIncome && _selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn danh mục trước!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_titleController.text.isEmpty || _amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('add_transaction.error_empty'.tr(), style: const TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('add_transaction.error_invalid_amount'.tr(), style: const TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final selectedCategory = _categories.firstWhere(
      (c) => (c['id'] ?? '').toString() == _selectedCategoryId,
      orElse: () => {},
    );

    final hasCategory = _selectedCategoryId != null && selectedCategory.isNotEmpty;
    final categoryIconCode = hasCategory
        ? (selectedCategory['icon_code'] ?? Icons.category.codePoint) as int
        : (isIncome ? Icons.help_outline_rounded.codePoint : Icons.category.codePoint);
    final categoryColor = hasCategory
        ? Color((selectedCategory['color_value'] ?? const Color(0xFF7B61FF).value) as int)
        : (isIncome ? const Color(0xFF12B76A) : const Color(0xFF7B61FF));

    final fallbackWalletId = _selectedWalletId ?? (_myWallets.isNotEmpty ? _myWallets.first.id : null) ?? 'general';

    final newTrans = TransactionRecord(
      id: 't_${DateTime.now().millisecondsSinceEpoch}',
      walletId: fallbackWalletId,
      userEmail: widget.users.email,
      categoryId: _selectedCategoryId,
      title: _titleController.text.trim(),
      amount: amount,
      date: _selectedDate,
      type: _selectedType,
      icon: categoryIconCode.toString(),
      color: AppColors.colorToHex(categoryColor),
    );

    await TransactionService().addTransaction(newTrans);

    // Income without category is treated as unallocated money of that month.
    if (isIncome && _selectedCategoryId == null) {
      final now = DateTime.now();
      final isCurrentMonth = _selectedDate.month == now.month && _selectedDate.year == now.year;
      if (isCurrentMonth) {
        final current = AuthService.instance.currentUser?.totalBalance ?? widget.users.totalBalance;
        await AuthService.instance.updateUserBalance(widget.users.email, current + amount);
      }
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeThemeColor = _selectedType == 'income' ? Colors.green : Colors.red;

    Map<String, dynamic>? selectedCategory;
    if (_selectedCategoryId != null) {
      try {
        selectedCategory = _categories.firstWhere((c) => (c['id'] ?? '').toString() == _selectedCategoryId);
      } catch (_) {
        selectedCategory = null;
      }
    }

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        top: 24,
        left: 24,
        right: 24,
      ),
      decoration: const BoxDecoration(color: Colors.white),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'add_transaction.title'.tr(),
                style: TextStyle(
                  fontSize: Responsive.sp(22),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'BeVietnamPro',
                ),
              ),
            ),
            SizedBox(height: Responsive.h(20)),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedType = 'expense';
                        if (_selectedCategoryId == null && _categories.isNotEmpty) {
                          _selectedCategoryId = (_categories.first['id'] ?? '').toString();
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _selectedType == 'expense' ? Colors.red : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(Responsive.r(12)),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'add_transaction.expense'.tr(),
                        style: TextStyle(
                          color: _selectedType == 'expense' ? Colors.white : Colors.grey.shade600,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: Responsive.w(12)),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedType = 'income'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _selectedType == 'income' ? Colors.green : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(Responsive.r(12)),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'add_transaction.income'.tr(),
                        style: TextStyle(
                          color: _selectedType == 'income' ? Colors.white : Colors.grey.shade600,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: Responsive.h(20)),
            Text(
              'Chọn danh mục',
              style: TextStyle(fontSize: Responsive.sp(14), fontWeight: FontWeight.w600, color: Colors.grey),
            ),
            SizedBox(height: Responsive.h(8)),
            GestureDetector(
              onTap: _showCategoryPicker,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(Responsive.r(15)),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    if (selectedCategory != null) ...[
                      Icon(
                        IconData((selectedCategory['icon_code'] ?? Icons.category.codePoint) as int, fontFamily: 'MaterialIcons'),
                        color: Color((selectedCategory['color_value'] ?? const Color(0xFF7B61FF).value) as int),
                        size: 24,
                      ),
                      SizedBox(width: Responsive.w(12)),
                      Expanded(
                        child: Text(
                          (selectedCategory['name'] ?? 'Danh mục').toString(),
                          style: TextStyle(
                            fontSize: Responsive.sp(16),
                            fontWeight: FontWeight.bold,
                            fontFamily: 'BeVietnamPro',
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ] else ...[
                      const Icon(Icons.category_outlined, color: Colors.grey, size: 24),
                      SizedBox(width: Responsive.w(12)),
                      Expanded(
                        child: Text(
                          _selectedType == 'income'
                              ? 'Không xác định (chưa phân bổ)'
                              : (_categories.isEmpty ? 'Bạn chưa có danh mục nào!' : 'Vui lòng chọn danh mục...'),
                          style: TextStyle(fontSize: Responsive.sp(16), color: Colors.grey, fontFamily: 'BeVietnamPro'),
                        ),
                      ),
                    ],
                    const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
                  ],
                ),
              ),
            ),
            SizedBox(height: Responsive.h(16)),
            Text(
              'Ngày giao dịch',
              style: TextStyle(fontSize: Responsive.sp(14), fontWeight: FontWeight.w600, color: Colors.grey),
            ),
            SizedBox(height: Responsive.h(8)),
            GestureDetector(
              onTap: _pickTransactionDate,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(Responsive.r(15)),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded, color: Colors.grey, size: 20),
                    SizedBox(width: Responsive.w(12)),
                    Expanded(
                      child: Text(
                        '${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}',
                        style: TextStyle(
                          fontSize: Responsive.sp(15),
                          fontWeight: FontWeight.w600,
                          fontFamily: 'BeVietnamPro',
                          color: const Color(0xFF1D2939),
                        ),
                      ),
                    ),
                    const Icon(Icons.edit_calendar_rounded, color: Colors.grey),
                  ],
                ),
              ),
            ),
            SizedBox(height: Responsive.h(16)),
            Text(
              'add_transaction.transaction_name'.tr(),
              style: TextStyle(fontSize: Responsive.sp(14), fontWeight: FontWeight.w600, color: Colors.grey),
            ),
            SizedBox(height: Responsive.h(8)),
            CustomTextField(
              controller: _titleController,
              hintText: 'add_transaction.transaction_name_hint'.tr(),
              suffixIcon: Icons.edit_note,
            ),
            SizedBox(height: Responsive.h(16)),
            Text(
              'add_transaction.amount'.tr(),
              style: TextStyle(fontSize: Responsive.sp(14), fontWeight: FontWeight.w600, color: Colors.grey),
            ),
            SizedBox(height: Responsive.h(8)),
            CustomTextField(
              controller: _amountController,
              hintText: '0',
              suffixIcon: Icons.monetization_on_outlined,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: Responsive.h(28)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'add_transaction.cancel_btn'.tr(),
                    style: TextStyle(color: Colors.grey, fontSize: Responsive.sp(16), fontWeight: FontWeight.bold),
                  ),
                ),
                custombutton(
                  onPressed: _saveTransaction,
                  label: 'add_transaction.save_btn'.tr(),
                  backgroundColor: activeThemeColor,
                  textColor: Colors.white,
                  height: 45,
                  borderRadius: 25,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
