import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:expense_management/components/inputs/CustomTextField.dart';
import 'package:expense_management/components/buttons/custombutton.dart';
import 'package:expense_management/configs/theme/color.dart';
import 'package:expense_management/configs/theme/icon.dart';
import '../../../core/data/service/transactionservice.dart';
import '../../../core/model/transactions.dart';

class AddTransaction extends StatefulWidget {
  final String walletId;
  const AddTransaction({super.key, required this.walletId});
  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  String _selectedType = 'expense';
  IconData selectedIcon = AppIcons.defaultWalletIcons[0];
  List<IconData> displayIcons = [];

  @override
  void initState() {
    super.initState();
    displayIcons = List.from(AppIcons.defaultWalletIcons.take(4));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }
  void showIconPicker() {
    Color activeThemeColor = _selectedType == 'income' ? Colors.green : Colors.red;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Chọn biểu tượng", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'BeVietnamPro')),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 15,
                  runSpacing: 15,
                  children: AppIcons.extendedWalletIcons.map((icon) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIcon = icon;
                          // Đưa icon mới chọn lên đầu danh sách hiển thị
                          if (!displayIcons.contains(icon)) {
                            displayIcons.insert(0, icon);
                            displayIcons.removeLast();
                          }
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: selectedIcon == icon ? activeThemeColor.withOpacity(0.1) : Colors.grey[100],
                            border: Border.all(
                              color: selectedIcon == icon ? activeThemeColor : Colors.transparent,
                            )
                        ),
                        child: Icon(icon, color: selectedIcon == icon ? activeThemeColor : Colors.black87),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _saveTransaction() async {
    if (_titleController.text.isEmpty || _amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("add_transaction.error_empty".tr(), style: const TextStyle(color: Colors.white)), backgroundColor: Colors.red),
      );
      return;
    }

    double? amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("add_transaction.error_invalid_amount".tr(), style: const TextStyle(color: Colors.white)), backgroundColor: Colors.red),
      );
      return;
    }

    Color typeColor = _selectedType == 'income' ? Colors.green : Colors.red;

    TransactionRecord newTrans = TransactionRecord(
      id: "t_${DateTime.now().millisecondsSinceEpoch}",
      walletId: widget.walletId,
      title: _titleController.text,
      amount: amount,
      date: DateTime.now(),
      type: _selectedType,
      icon: selectedIcon.codePoint.toString(),
      color: AppColors.colorToHex(typeColor),
    );

    await TransactionService().addTransaction(newTrans);

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {

    Color activeThemeColor = _selectedType == 'income' ? Colors.green : Colors.red;

    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10.0, offset: Offset(0.0, 10.0))],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text("add_transaction.title".tr(), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'BeVietnamPro')),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedType = 'expense'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _selectedType == 'expense' ? Colors.red : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text("add_transaction.expense".tr(), style: TextStyle(color: _selectedType == 'expense' ? Colors.white : Colors.grey.shade600, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedType = 'income'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _selectedType == 'income' ? Colors.green : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text("add_transaction.income".tr(), style: TextStyle(color: _selectedType == 'income' ? Colors.white : Colors.grey.shade600, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text("add_transaction.transaction_name".tr(), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey)),
              const SizedBox(height: 8),
              CustomTextField(
                controller: _titleController,
                hintText: "add_transaction.transaction_name_hint".tr(),
                suffixIcon: Icons.edit_note,
              ),
              const SizedBox(height: 16),
              Text("add_transaction.amount".tr(), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey)),
              const SizedBox(height: 8),
              CustomTextField(
                controller: _amountController,
                hintText: "0",
                suffixIcon: Icons.monetization_on_outlined,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              Text("add_transaction.choose_icon".tr(), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.grey)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ...displayIcons.map((icon) {
                    bool isSelected = selectedIcon == icon;
                    return GestureDetector(
                      onTap: () => setState(() => selectedIcon = icon),
                      child: Container(
                        width: 48, height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? activeThemeColor : Colors.grey.withOpacity(0.2),
                            width: 1.5,
                          ),
                          color: isSelected ? activeThemeColor.withOpacity(0.05) : Colors.transparent,
                        ),
                        child: Icon(icon, color: isSelected ? activeThemeColor : Colors.black87),
                      ),
                    );
                  }).toList(),

                  // Nút mở bảng Icon Picker
                  GestureDetector(
                    onTap: showIconPicker,
                    child: Container(
                      width: 48, height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1.5),
                      ),
                      child: const Icon(Icons.grid_view_outlined, color: Colors.black87),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("add_transaction.cancel_btn".tr(), style: const TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  custombutton(
                    onPressed: _saveTransaction,
                    label: "add_transaction.save_btn".tr(),
                    backgroundColor: activeThemeColor,
                    textColor: Colors.white,
                    height: 45,
                    width: 160,
                    borderRadius: 25,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}