import 'package:expense_management/configs/theme/color.dart';
import 'package:expense_management/core/data/service/authservice.dart';
import 'package:expense_management/core/model/users.dart';
import 'package:expense_management/core/utils/format.dart';
import 'package:expense_management/core/utils/responsive.dart';
import 'package:expense_management/screens/home/categorymanager.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BudgetAllocationScreen extends StatefulWidget {
  final Users user;

  const BudgetAllocationScreen({super.key, required this.user});

  @override
  State<BudgetAllocationScreen> createState() => _BudgetAllocationScreenState();
}

class _BudgetAllocationScreenState extends State<BudgetAllocationScreen> {
  Box? _budgetBox;
  Box? _groupBox;
  Box? _categoryBox;

  bool _ready = false;
  final Map<String, double> _amountByCategoryId = <String, double>{};
  List<Map<String, dynamic>> _groups = <Map<String, dynamic>>[];
  final Map<String, List<Map<String, dynamic>>> _categoriesByGroupId = <String, List<Map<String, dynamic>>>{};

  String _currentMonthKey() {
    final now = DateTime.now();
    final month = now.month.toString().padLeft(2, '0');
    return '${now.year}-$month';
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    if (!Hive.isBoxOpen('budget_allocations')) {
      await Hive.openBox('budget_allocations');
    }
    if (!Hive.isBoxOpen('category_groups')) {
      await Hive.openBox('category_groups');
    }
    if (!Hive.isBoxOpen('categories')) {
      await Hive.openBox('categories');
    }

    _budgetBox = Hive.box('budget_allocations');
    _groupBox = Hive.box('category_groups');
    _categoryBox = Hive.box('categories');

    await AuthService.instance.reconcileMonthlyBalance(widget.user.email);

    _loadFromDatabase();

    if (mounted) {
      setState(() {
        _ready = true;
      });
    }
  }

  double _safeDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  int _safeInt(dynamic value, int fallback) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }

  void _loadFromDatabase() {
    final budgetBox = _budgetBox;
    final groupBox = _groupBox;
    final categoryBox = _categoryBox;
    if (budgetBox == null || groupBox == null || categoryBox == null) return;

    final userEmail = widget.user.email;

    final groups = <Map<String, dynamic>>[];
    for (final key in groupBox.keys) {
      final raw = groupBox.get(key);
      if (raw is Map) {
        final map = Map<String, dynamic>.from(raw);
        if ((map['user_email'] ?? '').toString() == userEmail) {
          groups.add({
            ...map,
            'id': key.toString(),
          });
        }
      }
    }

    groups.sort((a, b) =>
        (a['created_at'] ?? '').toString().compareTo((b['created_at'] ?? '').toString()));

    final categoriesByGroup = <String, List<Map<String, dynamic>>>{};
    for (final g in groups) {
      categoriesByGroup[(g['id'] ?? '').toString()] = <Map<String, dynamic>>[];
    }

    for (final key in categoryBox.keys) {
      final raw = categoryBox.get(key);
      if (raw is Map) {
        final map = Map<String, dynamic>.from(raw);
        if ((map['user_email'] ?? '').toString() == userEmail) {
          final groupId = (map['group_id'] ?? '').toString();
          if (categoriesByGroup.containsKey(groupId)) {
            categoriesByGroup[groupId]!.add({
              ...map,
              'id': key.toString(),
            });
          }
        }
      }
    }

    for (final entry in categoriesByGroup.entries) {
      entry.value.sort((a, b) =>
          (a['created_at'] ?? '').toString().compareTo((b['created_at'] ?? '').toString()));
    }

    _groups = groups;
    _categoriesByGroupId
      ..clear()
      ..addAll(categoriesByGroup);

    _amountByCategoryId.clear();
    final rawBudget = budgetBox.get(userEmail);
    if (rawBudget is Map) {
      final monthKey = _currentMonthKey();
      final months = rawBudget['months'];
      if (months is Map) {
        final monthRaw = months[monthKey];
        if (monthRaw is Map && monthRaw['amounts'] is Map) {
          final amounts = Map<String, dynamic>.from(monthRaw['amounts'] as Map);
          for (final e in amounts.entries) {
            _amountByCategoryId[e.key.toString()] = _safeDouble(e.value);
          }
        }
      } else if (rawBudget['amounts'] is Map) {
        final amounts = Map<String, dynamic>.from(rawBudget['amounts'] as Map);
        for (final e in amounts.entries) {
          _amountByCategoryId[e.key.toString()] = _safeDouble(e.value);
        }
      }
    }

    setState(() {});
  }

  double get _totalBalance {
    final updated = AuthService.instance.currentUser;
    return updated?.totalBalance ?? widget.user.totalBalance;
  }

  double _groupTotal(String groupId) {
    double total = 0;
    final list = _categoriesByGroupId[groupId] ?? const <Map<String, dynamic>>[];
    for (final c in list) {
      total += _amountByCategoryId[(c['id'] ?? '').toString()] ?? 0;
    }
    return total;
  }

  double get _allocatedAmount {
    double total = 0;
    for (final g in _groups) {
      total += _groupTotal((g['id'] ?? '').toString());
    }
    return total;
  }

  double get _remainingAmount {
    final value = _totalBalance - _allocatedAmount;
    return value < 0 ? 0 : value;
  }

  Future<void> _saveData({bool showSnack = true}) async {
    final budgetBox = _budgetBox;
    if (budgetBox == null) return;

    final monthKey = _currentMonthKey();
    final existingRaw = budgetBox.get(widget.user.email);
    final existing = existingRaw is Map
        ? Map<String, dynamic>.from(existingRaw)
        : <String, dynamic>{'user_email': widget.user.email};

    final monthsRaw = existing['months'];
    final months = monthsRaw is Map ? Map<String, dynamic>.from(monthsRaw) : <String, dynamic>{};
    final monthRaw = months[monthKey];
    final monthData = monthRaw is Map ? Map<String, dynamic>.from(monthRaw) : <String, dynamic>{};
    monthData['amounts'] = Map<String, dynamic>.from(_amountByCategoryId);
    months[monthKey] = monthData;

    await budgetBox.put(widget.user.email, {
      'user_email': widget.user.email,
      'months': months,
      'updated_at': DateTime.now().toIso8601String(),
    });

    if (showSnack && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã lưu phân bổ ngân sách'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _showEditAmountDialog(Map<String, dynamic> category) async {
    final categoryId = (category['id'] ?? '').toString();
    final currentAmount = _amountByCategoryId[categoryId] ?? 0;
    final controller = TextEditingController(
      text: currentAmount > 0 ? currentAmount.toInt().toString() : '',
    );

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Responsive.r(16)),
          ),
          title: Text(
            (category['name'] ?? 'Danh mục').toString(),
            style: TextStyle(
              fontFamily: 'BeVietnamPro',
              fontSize: Responsive.sp(15),
              fontWeight: FontWeight.w700,
            ),
          ),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: 'Số tiền phân bổ'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _amountByCategoryId[categoryId] = 0;
                });
                Navigator.pop(context);
              },
              child: const Text('Xóa'),
            ),
            ElevatedButton(
              onPressed: () {
                final amount = _safeDouble(controller.text.trim());
                setState(() {
                  _amountByCategoryId[categoryId] = amount;
                });
                Navigator.pop(context);
              },
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );
  }

  Widget _summaryCard({required String title, required double amount, required bool filled}) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(Responsive.w(12)),
        decoration: BoxDecoration(
          gradient: filled
              ? const LinearGradient(colors: [Color(0xFF7E45EC), Color(0xFF8C68E8)])
              : null,
          color: filled ? null : Colors.white,
          borderRadius: BorderRadius.circular(Responsive.r(18)),
          border: filled ? null : Border.all(color: const Color(0xFFE4D8FB)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: Responsive.w(32),
              height: Responsive.w(32),
              decoration: BoxDecoration(
                color: filled ? Colors.white.withOpacity(0.2) : const Color(0xFFF0EAFE),
                shape: BoxShape.circle,
              ),
              child: Icon(
                filled ? Icons.account_balance_wallet_rounded : Icons.task_alt_rounded,
                color: filled ? Colors.white : const Color(0xFF6E43DF),
                size: Responsive.sp(18),
              ),
            ),
            SizedBox(height: Responsive.h(8)),
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'BeVietnamPro',
                fontSize: Responsive.sp(12),
                color: filled ? Colors.white70 : const Color(0xFF667085),
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: Responsive.h(4)),
            Text(
              '${Format.formatnumber(amount)} đ',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'BeVietnamPro',
                fontSize: Responsive.sp(14),
                color: filled ? Colors.white : const Color(0xFF6E43DF),
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _budgetItem(Map<String, dynamic> category) {
    final categoryId = (category['id'] ?? '').toString();
    final amount = _amountByCategoryId[categoryId] ?? 0;

    final iconCode = _safeInt(category['icon_code'], Icons.category_rounded.codePoint);
    final colorValue = _safeInt(category['color_value'], const Color(0xFF6E43DF).value);

    return InkWell(
      onTap: () => _showEditAmountDialog(category),
      borderRadius: BorderRadius.circular(Responsive.r(22)),
      child: Container(
        margin: EdgeInsets.only(bottom: Responsive.h(10)),
        padding: EdgeInsets.symmetric(horizontal: Responsive.w(14), vertical: Responsive.h(12)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Responsive.r(22)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF111827).withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: Responsive.w(46),
              height: Responsive.w(46),
              decoration: const BoxDecoration(
                color: Color(0xFFF0EAFE),
                shape: BoxShape.circle,
              ),
              child: Icon(
                IconData(iconCode, fontFamily: 'MaterialIcons'),
                color: Color(colorValue),
                size: Responsive.sp(22),
              ),
            ),
            SizedBox(width: Responsive.w(12)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (category['name'] ?? 'Danh mục').toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'BeVietnamPro',
                      fontSize: Responsive.sp(14),
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF101828),
                    ),
                  ),
                  SizedBox(height: Responsive.h(2)),
                  Text(
                    'Chạm để sửa số tiền',
                    style: TextStyle(
                      fontFamily: 'BeVietnamPro',
                      fontSize: Responsive.sp(11),
                      color: const Color(0xFF98A2B3),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${Format.formatnumber(amount)} đ',
              style: TextStyle(
                fontFamily: 'BeVietnamPro',
                fontSize: Responsive.sp(13),
                color: const Color(0xFF6E43DF),
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _groupHeader(String name, double totalAmount) {
    return Row(
      children: [
        Expanded(
          child: Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'BeVietnamPro',
              fontSize: Responsive.sp(15),
              fontWeight: FontWeight.w800,
              color: const Color(0xFF111827),
            ),
          ),
        ),
        SizedBox(width: Responsive.w(8)),
        Text(
          '${Format.formatnumber(totalAmount)}đ',
          style: TextStyle(
            fontFamily: 'BeVietnamPro',
            fontSize: Responsive.sp(14),
            fontWeight: FontWeight.w800,
            color: const Color(0xFF6E43DF),
          ),
        ),
      ],
    );
  }

  Widget _manageCategoryButton() {
    return InkWell(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => Categorymanager(users: widget.user)),
        );
        _loadFromDatabase();
      },
      borderRadius: BorderRadius.circular(Responsive.r(24)),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: Responsive.h(14)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Responsive.r(24)),
          border: Border.all(color: const Color(0xFFCDB7F8), width: 2),
        ),
        child: Center(
          child: Text(
            '+ THÊM DANH MỤC',
            style: TextStyle(
              fontFamily: 'BeVietnamPro',
              fontSize: Responsive.sp(14),
              color: const Color(0xFF6E43DF),
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);

    if (!_ready) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(Responsive.w(14), Responsive.h(6), Responsive.w(14), Responsive.h(10)),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Color(0xFF111827)),
                  ),
                  Expanded(
                    child: Text(
                      'Phân bổ ngân sách',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'BeVietnamPro',
                        fontSize: Responsive.sp(18),
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF111827),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: _saveData,
                    borderRadius: BorderRadius.circular(Responsive.r(24)),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: Responsive.w(16), vertical: Responsive.h(8)),
                      decoration: BoxDecoration(
                        gradient: AppColors.gradientcard,
                        borderRadius: BorderRadius.circular(Responsive.r(24)),
                      ),
                      child: Text(
                        'LƯU',
                        style: TextStyle(
                          fontFamily: 'BeVietnamPro',
                          fontSize: Responsive.sp(14),
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: Responsive.w(14), vertical: Responsive.h(6)),
                children: [
                  Row(
                    children: [
                      _summaryCard(title: 'Tiền chưa có việc', amount: _remainingAmount, filled: true),
                      SizedBox(width: Responsive.w(10)),
                      _summaryCard(title: 'Tiền đã phân bổ', amount: _allocatedAmount, filled: false),
                    ],
                  ),
                  SizedBox(height: Responsive.h(16)),
                  if (_groups.isEmpty)
                    Container(
                      padding: EdgeInsets.symmetric(vertical: Responsive.h(24)),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(Responsive.r(20)),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.category_outlined, color: Color(0xFFB8C4D6), size: 30),
                          SizedBox(height: Responsive.h(8)),
                          Text(
                            'Chưa có nhóm danh mục nào',
                            style: TextStyle(
                              fontFamily: 'BeVietnamPro',
                              fontSize: Responsive.sp(13),
                              color: const Color(0xFF94A3B8),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ..._groups.map((group) {
                      final groupId = (group['id'] ?? '').toString();
                      final categories = _categoriesByGroupId[groupId] ?? const <Map<String, dynamic>>[];
                      final groupTotal = _groupTotal(groupId);

                      return Padding(
                        padding: EdgeInsets.only(bottom: Responsive.h(14)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _groupHeader((group['name'] ?? 'Nhóm danh mục').toString(), groupTotal),
                            SizedBox(height: Responsive.h(8)),
                            if (categories.isEmpty)
                              Container(
                                padding: EdgeInsets.symmetric(vertical: Responsive.h(16)),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(Responsive.r(14)),
                                  border: Border.all(color: const Color(0xFFE4E7EC)),
                                ),
                                child: Text(
                                  'Nhóm này chưa có danh mục',
                                  style: TextStyle(
                                    fontFamily: 'BeVietnamPro',
                                    fontSize: Responsive.sp(12),
                                    color: const Color(0xFF98A2B3),
                                  ),
                                ),
                              )
                            else
                              ...categories.map(_budgetItem),
                          ],
                        ),
                      );
                    }),
                  _manageCategoryButton(),
                  SizedBox(height: Responsive.h(18)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
