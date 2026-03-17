import 'package:easy_localization/easy_localization.dart';
import 'package:expense_management/components/avatar/CircleAvatar.dart';
import 'package:expense_management/components/avatar/InfoAvatar.dart';
import 'package:expense_management/components/cardshowvalue/CardGeneralTotal.dart';
import 'package:expense_management/components/cardshowvalue/CardManagerExpense.dart';
import 'package:expense_management/components/widget/purple_header.dart';
import 'package:expense_management/configs/theme/color.dart';
import 'package:expense_management/configs/theme/icon.dart';
import 'package:expense_management/core/data/service/authservice.dart';
import 'package:expense_management/core/data/service/transactionservice.dart';
import 'package:expense_management/core/data/service/walletservice.dart';
import 'package:expense_management/core/model/users.dart';
import 'package:expense_management/core/utils/responsive.dart';
import 'package:expense_management/screens/home/widgets/MonthlySpendingCard.dart';
import 'package:expense_management/screens/home/budget_allocation_screen.dart';
import 'package:expense_management/screens/home/widgets/catrgoryDetail.dart';
import 'package:expense_management/screens/home/widgets/category_group_filter_sheet.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'categorymanager.dart';

class MyHome extends StatefulWidget {
  final Users users;
  const MyHome({super.key, required this.users});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  final ScrollController _scrollController = ScrollController();
  bool _collapsed = false;
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;
  String? _selectedGroupId;

  String _currentMonthKey() {
    final now = DateTime.now();
    final month = now.month.toString().padLeft(2, '0');
    return '${now.year}-$month';
  }

  String _selectedMonthKey() {
    final month = _selectedMonth.toString().padLeft(2, '0');
    return '$_selectedYear-$month';
  }

  double _safeDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  Map<String, double> _getAllocationByCategoryForSelectedMonth() {
    final raw = Hive.box('budget_allocations').get(widget.users.email);
    if (raw is! Map) return <String, double>{};

    final monthKey = _selectedMonthKey();
    final result = <String, double>{};

    final months = raw['months'];
    if (months is Map) {
      final monthRaw = months[monthKey];
      if (monthRaw is Map && monthRaw['amounts'] is Map) {
        final amounts = Map<String, dynamic>.from(monthRaw['amounts'] as Map);
        for (final entry in amounts.entries) {
          result[entry.key.toString()] = _safeDouble(entry.value);
        }
        return result;
      }
    }

    if (raw['amounts'] is Map) {
      final legacy = Map<String, dynamic>.from(raw['amounts'] as Map);
      for (final entry in legacy.entries) {
        result[entry.key.toString()] = _safeDouble(entry.value);
      }
    }
    return result;
  }

  double _getAllocatedCurrentMonth() {
    final budgetMap = Hive.box('budget_allocations').get(widget.users.email);
    if (budgetMap is! Map) return 0;

    final monthKey = _currentMonthKey();
    final months = budgetMap['months'];
    if (months is Map) {
      final monthRaw = months[monthKey];
      if (monthRaw is Map && monthRaw['amounts'] is Map) {
        final amounts = Map<String, dynamic>.from(monthRaw['amounts'] as Map);
        return amounts.values.fold<double>(0, (sum, value) {
          if (value is num) return sum + value.toDouble();
          if (value is String) return sum + (double.tryParse(value) ?? 0);
          return sum;
        });
      }
    }

    // Backward compatibility for legacy payload.
    if (budgetMap['amounts'] is Map) {
      final amounts = Map<String, dynamic>.from(budgetMap['amounts'] as Map);
      return amounts.values.fold<double>(0, (sum, value) {
        if (value is num) return sum + value.toDouble();
        if (value is String) return sum + (double.tryParse(value) ?? 0);
        return sum;
      });
    }

    return 0;
  }

  Future<void> _ensureMonthlySalaryApplied() async {
    await AuthService.instance.applyMonthlySalaryIfNeeded(widget.users.email);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _ensureMonthlySalaryApplied();
    _scrollController.addListener(() {
      if (_scrollController.offset > Responsive.h(40) && !_collapsed) {
        setState(() => _collapsed = true);
      } else if (_scrollController.offset <= Responsive.h(40) && _collapsed) {
        setState(() => _collapsed = false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _getGroupMaps() {
    final box = Hive.box('category_groups');
    final groups = <Map<String, dynamic>>[];

    for (final key in box.keys) {
      final raw = box.get(key);
      if (raw is Map) {
        final map = Map<String, dynamic>.from(raw);
        if (map['user_email'] == widget.users.email) {
          map['id'] = key.toString();
          groups.add(map);
        }
      }
    }

    groups.sort((a, b) => (a['created_at'] ?? '').toString().compareTo((b['created_at'] ?? '').toString()));
    return groups;
  }

  List<Map<String, dynamic>> _getCategoryMaps() {
    final box = Hive.box('categories');
    final categories = <Map<String, dynamic>>[];

    for (final key in box.keys) {
      final raw = box.get(key);
      if (raw is Map) {
        final map = Map<String, dynamic>.from(raw);
        if (map['user_email'] == widget.users.email) {
          map['id'] = key.toString();
          categories.add(map);
        }
      }
    }

    if (_selectedGroupId != null) {
      return categories.where((e) => e['group_id'] == _selectedGroupId).toList();
    }
    return categories;
  }

  String _selectedGroupLabel() {
    if (_selectedGroupId == null) return 'home.view_all'.tr();
    final groups = _getGroupMaps();
    final found = groups.cast<Map<String, dynamic>?>().firstWhere(
      (g) => g?['id'] == _selectedGroupId,
      orElse: () => null,
    );
    return (found?['name'] ?? 'home.view_all'.tr()).toString();
  }

  Future<void> _showGroupFilterSheet() async {
    final groups = _getGroupMaps();
    final categoryBox = Hive.box('categories');

    final groupsWithCount = groups.map((g) {
      final groupId = (g['id'] ?? '').toString();
      int count = 0;
      for (final key in categoryBox.keys) {
        final raw = categoryBox.get(key);
        if (raw is Map) {
          final map = Map<String, dynamic>.from(raw);
          if (map['user_email'] == widget.users.email && map['group_id'] == groupId) {
            count += 1;
          }
        }
      }
      return {
        ...g,
        'count': count,
      };
    }).toList();

    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(Responsive.r(20))),
      ),
      builder: (_) {
        return CategoryGroupFilterSheet(
          groups: groupsWithCount,
          selectedGroupId: _selectedGroupId,
        );
      },
    );

    if (!mounted || result == null) return;
    setState(() {
      if (result == CategoryGroupFilterSheet.allGroupValue) {
        _selectedGroupId = null;
      } else {
        _selectedGroupId = result;
      }
    });
  }

  Future<void> _deleteCategoryFromHome({
    required String categoryId,
    required String categoryName,
  }) async {
    await Hive.box('categories').delete(categoryId);

    final budgetBox = Hive.box('budget_allocations');
    final raw = budgetBox.get(widget.users.email);
    if (raw is Map) {
      final updated = Map<String, dynamic>.from(raw);

      final monthsRaw = updated['months'];
      if (monthsRaw is Map) {
        final months = Map<String, dynamic>.from(monthsRaw);
        for (final entry in months.entries) {
          final monthRaw = entry.value;
          if (monthRaw is! Map) continue;
          final monthData = Map<String, dynamic>.from(monthRaw);
          final amountsRaw = monthData['amounts'];
          if (amountsRaw is Map) {
            final amounts = Map<String, dynamic>.from(amountsRaw);
            amounts.remove(categoryId);
            monthData['amounts'] = amounts;
            months[entry.key] = monthData;
          }
        }
        updated['months'] = months;
      }

      final legacyAmountsRaw = updated['amounts'];
      if (legacyAmountsRaw is Map) {
        final legacyAmounts = Map<String, dynamic>.from(legacyAmountsRaw);
        legacyAmounts.remove(categoryId);
        updated['amounts'] = legacyAmounts;
      }

      updated['updated_at'] = DateTime.now().toIso8601String();
      await budgetBox.put(widget.users.email, updated);
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('home.deleted_category'.tr(namedArgs: {'name': categoryName})),
        backgroundColor: const Color(0xFF344054),
      ),
    );
  }

  Widget _homeHeader() {
    return Stack(
      children: [
        PurpleHeader(height: Responsive.h(245)),
        SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Responsive.w(15), vertical: Responsive.h(10)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Circleavatar(),
                    SizedBox(width: Responsive.w(15)),
                    Expanded(child: CardInfo(username: widget.users.username)),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => Categorymanager(users: widget.users)),
                        );
                      },
                      child: Icon(Icons.edit, color: Colors.white, size: Responsive.sp(20)),
                    ),
                  ],
                ),
                SizedBox(height: Responsive.h(20)),
                ValueListenableBuilder(
                  valueListenable: Hive.box('transactions').listenable(),
                  builder: (context, _, __) {
                    return ValueListenableBuilder(
                      valueListenable: Hive.box('users').listenable(),
                      builder: (context, _, __) {
                        return ValueListenableBuilder(
                          valueListenable: Hive.box('budget_allocations').listenable(),
                          builder: (context, _, __) {
                            final allocatedAmount = _getAllocatedCurrentMonth();
                            final updatedUser = AuthService.instance.currentUser;
                            final currentTotalBalance = updatedUser?.totalBalance ?? widget.users.totalBalance;
                            final double remainingAmount = (currentTotalBalance - allocatedAmount) < 0
                                ? 0.0
                                : (currentTotalBalance - allocatedAmount).toDouble();

                            return CardGeneralTotal(
                              total: currentTotalBalance,
                              income: remainingAmount,
                              expense: allocatedAmount,
                              onBudgetPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BudgetAllocationScreen(user: widget.users),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _monthlySpending() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Responsive.w(15)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'home.monthly_spending_title'.tr(),
                style: TextStyle(fontSize: Responsive.sp(16), fontWeight: FontWeight.bold, fontFamily: 'BeVietnamPro'),
              ),
              PopupMenuButton<int>(
                initialValue: _selectedMonth,
                onSelected: (month) => setState(() => _selectedMonth = month),
                itemBuilder: (context) {
                  return List.generate(12, (index) => index + 1).map((month) {
                    return PopupMenuItem<int>(
                      value: month,
                      child: Text('${'home.month_label'.tr()} $month', style: TextStyle(fontFamily: 'BeVietnamPro', fontSize: Responsive.sp(14))),
                    );
                  }).toList();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: Responsive.w(10), vertical: Responsive.h(6)),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(Responsive.r(12))),
                  child: Row(
                    children: [
                      Text(
                        '${'home.month_label'.tr()} $_selectedMonth',
                        style: TextStyle(
                          fontFamily: 'BeVietnamPro',
                          fontSize: Responsive.sp(14),
                          color: const Color(0xFF7B3FE4),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: Responsive.w(2)),
                      Icon(Icons.keyboard_arrow_down_rounded, color: const Color(0xFF7B3FE4), size: Responsive.sp(18)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          ValueListenableBuilder(
            valueListenable: Hive.box('transactions').listenable(),
            builder: (context, _, __) {
              return ValueListenableBuilder(
                valueListenable: Hive.box('users').listenable(),
                builder: (context, _, __) {
                  return ValueListenableBuilder(
                    valueListenable: Hive.box('budget_allocations').listenable(),
                    builder: (context, _, __) {
                      final allTransactions = TransactionService().getAllUserTransactions(widget.users.email);
                      double monthlyExpense = 0;
                      double unallocatedIncome = 0;
                      final updatedUser = AuthService.instance.currentUser;
                      final monthlySalary = updatedUser?.monthlySalary ?? widget.users.monthlySalary;

                      for (final t in allTransactions) {
                        if (t.type == 'expense' && t.date.month == _selectedMonth && t.date.year == _selectedYear) {
                          monthlyExpense += t.amount;
                        }
                        if (t.type == 'income' && t.date.month == _selectedMonth && t.date.year == _selectedYear) {
                          final noCategory = (t.categoryId ?? '').trim().isEmpty;
                          if (noCategory) {
                            unallocatedIncome += t.amount;
                          }
                        }
                      }

                      final effectiveMonthlySalary = monthlySalary + unallocatedIncome;

                      return MonthlySpendingCard(
                        collapsed: _collapsed,
                        spent: monthlyExpense,
                        total: effectiveMonthlySalary,
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _expenseByCategorySection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Responsive.w(10)),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Responsive.w(6), vertical: Responsive.h(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'home.expense_by_category'.tr(),
                  style: TextStyle(fontSize: Responsive.sp(16), fontWeight: FontWeight.bold, fontFamily: 'BeVietnamPro'),
                ),
                InkWell(
                  onTap: _showGroupFilterSheet,
                  child: Row(
                    children: [
                      Text(
                        _selectedGroupLabel(),
                        style: TextStyle(
                          fontSize: Responsive.sp(13),
                          color: const Color(0xFF7B3FE4),
                          fontWeight: FontWeight.w700,
                          fontFamily: 'BeVietnamPro',
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_down_rounded, size: Responsive.sp(17), color: const Color(0xFF7B3FE4)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ValueListenableBuilder(
            valueListenable: Hive.box('category_groups').listenable(),
            builder: (context, _, __) {
              return ValueListenableBuilder(
                valueListenable: Hive.box('categories').listenable(),
                builder: (context, _, __) {
                  return ValueListenableBuilder(
                    valueListenable: Hive.box('budget_allocations').listenable(),
                    builder: (context, _, __) {
                      return ValueListenableBuilder(
                        valueListenable: Hive.box('transactions').listenable(),
                        builder: (context, _, __) {
                          final categories = _getCategoryMaps();
                          final allTransactions = TransactionService().getAllUserTransactions(widget.users.email);
                          final allocationByCategoryId = _getAllocationByCategoryForSelectedMonth();

                          final expenseTransactions = allTransactions.where((t) {
                            return t.type == 'expense' && t.date.month == _selectedMonth && t.date.year == _selectedYear;
                          }).toList();

                          final rows = categories.map((category) {
                            final categoryId = (category['id'] ?? '').toString();
                            final iconCode = (category['icon_code'] ?? Icons.category.codePoint) as int;
                            final colorValue = (category['color_value'] ?? const Color(0xFF7B61FF).value) as int;
                            final iconData = IconData(iconCode, fontFamily: 'MaterialIcons');

                            // Support both new category_id mapping and legacy icon-based mapping.
                            final matched = expenseTransactions.where((t) {
                              if ((t.categoryId ?? '').isNotEmpty) {
                                return t.categoryId == categoryId;
                              }
                              return t.icon == iconCode.toString();
                            }).toList();

                            final spent = matched.fold<double>(0, (sum, t) => sum + t.amount);
                            final allocated = allocationByCategoryId[categoryId] ?? 0.0;
                            final remaining = (allocated - spent) < 0 ? 0.0 : (allocated - spent);
                            final percent = allocated > 0 ? (spent / allocated) : 0.0;

                            return {
                              'id': categoryId,
                              'title': (category['name'] ?? 'Danh mục').toString(),
                              'icon': iconData,
                              'iconCode': iconCode,
                              'color': Color(colorValue),
                              'count': matched.length,
                              'spent': spent,
                              'allocated': allocated,
                              'remaining': remaining,
                              'percent': percent,
                            };
                          }).toList()
                            ..sort((a, b) {
                              final bAllocated = (b['allocated'] as double) > 0 ? 1 : 0;
                              final aAllocated = (a['allocated'] as double) > 0 ? 1 : 0;
                              if (bAllocated != aAllocated) return bAllocated - aAllocated;
                              return (b['spent'] as double).compareTo(a['spent'] as double);
                            });

                          if (rows.isEmpty) {
                            return Container(
                              margin: EdgeInsets.only(top: Responsive.h(8)),
                              padding: EdgeInsets.all(Responsive.w(14)),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(Responsive.r(16)),
                              ),
                              child: Center(
                                child: Text(
                                  'home.no_category_message'.tr(),
                                  style: TextStyle(
                                    fontFamily: 'BeVietnamPro',
                                    fontSize: Responsive.sp(13),
                                    color: const Color(0xFF667085),
                                  ),
                                ),
                              ),
                            );
                          }

                          return Column(
                            children: rows.map((row) {
                              final categoryId = row['id'] as String;
                              final categoryName = row['title'] as String;

                              return Dismissible(
                                key: ValueKey('home_category_$categoryId'),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  margin: EdgeInsets.only(bottom: Responsive.h(12)),
                                  padding: EdgeInsets.symmetric(horizontal: Responsive.w(18)),
                                  alignment: Alignment.centerRight,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF04438),
                                    borderRadius: BorderRadius.circular(Responsive.r(16)),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.delete_forever_rounded, color: Colors.white, size: Responsive.sp(20)),
                                      SizedBox(width: Responsive.w(6)),
                                      Text(
                                        'common.delete'.tr(),
                                        style: TextStyle(
                                          fontFamily: 'BeVietnamPro',
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: Responsive.sp(14),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                confirmDismiss: (_) async {
                                  return await showDialog<bool>(
                                        context: context,
                                        builder: (dialogContext) => AlertDialog(
                                          title: Text('home.delete_category_title'.tr()),
                                          content: Text('home.delete_category_confirm'.tr(namedArgs: {'name': categoryName})),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(dialogContext, false),
                                              child: Text('common.cancel'.tr()),
                                            ),
                                            TextButton(
                                              onPressed: () => Navigator.pop(dialogContext, true),
                                              child: Text('common.delete'.tr()),
                                            ),
                                          ],
                                        ),
                                      ) ??
                                      false;
                                },
                                onDismissed: (_) {
                                  _deleteCategoryFromHome(
                                    categoryId: categoryId,
                                    categoryName: categoryName,
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: Responsive.h(12)),
                                  child: Cardmanagerexpense(
                                    title: categoryName,
                                    transactionCount: row['count'] as int,
                                    spentAmount: row['spent'] as double,
                                    allocatedAmount: row['allocated'] as double,
                                    remainingAmount: row['remaining'] as double,
                                    progressPercent: row['percent'] as double,
                                    Icon: row['icon'] as IconData,
                                    Iconcolor: row['color'] as Color,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => CategoryDetailScreen(
                                            user: widget.users,
                                            categoryName: categoryName,
                                            categoryIconCode: row['iconCode'] as int,
                                            headerColor: row['color'] as Color,
                                            month: _selectedMonth,
                                            year: _selectedYear,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);

    return Scaffold(
      body: Column(
        children: [
          _homeHeader(),
          SizedBox(height: Responsive.h(1)),
          _monthlySpending(),
          SizedBox(height: Responsive.h(6)),
          Expanded(
            child: ListView(
              controller: _scrollController,
              padding: EdgeInsets.only(bottom: Responsive.h(90)),
              children: [
                _expenseByCategorySection(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}