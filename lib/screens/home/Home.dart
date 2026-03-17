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

  @override
  void initState() {
    super.initState();
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
    if (_selectedGroupId == null) return 'Xem tất cả';
    final groups = _getGroupMaps();
    final found = groups.cast<Map<String, dynamic>?>().firstWhere(
      (g) => g?['id'] == _selectedGroupId,
      orElse: () => null,
    );
    return (found?['name'] ?? 'Xem tất cả').toString();
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
                      valueListenable: Hive.box('wallets').listenable(),
                      builder: (context, _, __) {
                        final myWallets = WalletService().getWallets(widget.users.email);
                        double totalBalance = 0;
                        double totalIncome = 0;
                        double totalExpense = 0;
                        final now = DateTime.now();

                        for (final wallet in myWallets) {
                          totalBalance += wallet.balance;
                          final transList = TransactionService().getTransactionsByWallet(wallet.id!);
                          for (final t in transList) {
                            if (t.date.month == now.month && t.date.year == now.year) {
                              if (t.type == 'income') totalIncome += t.amount;
                              if (t.type == 'expense') totalExpense += t.amount;
                            }
                          }
                        }

                        return CardGeneralTotal(total: totalBalance, income: totalIncome, expense: totalExpense);
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
                'Chi tiêu tháng này',
                style: TextStyle(fontSize: Responsive.sp(16), fontWeight: FontWeight.bold, fontFamily: 'BeVietnamPro'),
              ),
              PopupMenuButton<int>(
                initialValue: _selectedMonth,
                onSelected: (month) => setState(() => _selectedMonth = month),
                itemBuilder: (context) {
                  return List.generate(12, (index) => index + 1).map((month) {
                    return PopupMenuItem<int>(
                      value: month,
                      child: Text('Tháng $month', style: TextStyle(fontFamily: 'BeVietnamPro', fontSize: Responsive.sp(14))),
                    );
                  }).toList();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: Responsive.w(10), vertical: Responsive.h(6)),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(Responsive.r(12))),
                  child: Row(
                    children: [
                      Text(
                        'Tháng $_selectedMonth',
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
                  final myWallets = WalletService().getWallets(widget.users.email);
                  double monthlyExpense = 0;
                  final updatedUser = AuthService.instance.currentUser;
                  final currentTotalBalance = updatedUser?.totalBalance ?? widget.users.totalBalance;

                  for (final wallet in myWallets) {
                    final transList = TransactionService().getTransactionsByWallet(wallet.id!);
                    for (final t in transList) {
                      if (t.type == 'expense' && t.date.month == _selectedMonth && t.date.year == _selectedYear) {
                        monthlyExpense += t.amount;
                      }
                    }
                  }

                  return MonthlySpendingCard(collapsed: _collapsed, spent: monthlyExpense, total: currentTotalBalance);
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
                  'Phân loại chi tiêu',
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
                    valueListenable: Hive.box('transactions').listenable(),
                    builder: (context, _, __) {
                      final categories = _getCategoryMaps();
                      final allTransactions = TransactionService().getAllUserTransactions(widget.users.email);

                      final expenseTransactions = allTransactions.where((t) {
                        return t.type == 'expense' && t.date.month == _selectedMonth && t.date.year == _selectedYear;
                      }).toList();

                      final totalExpense = expenseTransactions.fold<double>(0, (sum, t) => sum + t.amount);

                      final rows = categories.map((category) {
                        final iconCode = (category['icon_code'] ?? Icons.category.codePoint) as int;
                        final colorValue = (category['color_value'] ?? const Color(0xFF7B61FF).value) as int;
                        final iconData = IconData(iconCode, fontFamily: 'MaterialIcons');

                        final matched = expenseTransactions.where((t) => t.icon == iconCode.toString()).toList();
                        final amount = matched.fold<double>(0, (sum, t) => sum + t.amount);
                        final percent = totalExpense > 0 ? amount / totalExpense : 0.0;

                        return {
                          'title': (category['name'] ?? 'Danh mục').toString(),
                          'icon': iconData,
                          'color': Color(colorValue),
                          'count': matched.length,
                          'amount': amount,
                          'percent': percent,
                        };
                      }).toList()
                        ..sort((a, b) => (b['amount'] as double).compareTo(a['amount'] as double));

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
                              'Chưa có danh mục. Hãy tạo trong trang Quản lý danh mục.',
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
                          return Padding(
                            padding: EdgeInsets.only(bottom: Responsive.h(12)),
                            child: Cardmanagerexpense(
                              title: row['title'] as String,
                              total: '${row['count']} giao dịch',
                              allmoney: (row['amount'] as double).toStringAsFixed(0),
                              percen: row['percent'] as double,
                              Icon: row['icon'] as IconData,
                              Iconcolor: row['color'] as Color,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => Categorymanager(users: widget.users)),
                                );
                              },
                            ),
                          );
                        }).toList(),
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