import 'package:easy_localization/easy_localization.dart';
import 'package:expense_management/components/buttons/custombutton.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../components/widget/purple_header.dart';
import '../../core/model/users.dart';
import 'package:expense_management/core/utils/responsive.dart';
import 'widgets/CategoryCard.dart';

class Categorymanager extends StatefulWidget {
  final Users users;

  const Categorymanager({super.key, required this.users});

  @override
  State<Categorymanager> createState() => _CategorymanagerState();
}

class _CategorymanagerState extends State<Categorymanager> {
  static const String _groupBoxName = 'category_groups';
  static const String _categoryBoxName = 'categories';

  final List<IconData> _iconOptions = const [
    Icons.folder_rounded,
    Icons.star_rounded,
    Icons.favorite_rounded,
    Icons.label_rounded,
    Icons.account_balance_wallet_rounded,
    Icons.shopping_cart_rounded,
    Icons.home_rounded,
    Icons.person_rounded,
  ];

  final List<Color> _colorOptions = const [
    Color(0xFF7B61FF),
    Color(0xFF2E90FA),
    Color(0xFF12B76A),
    Color(0xFFF79009),
    Color(0xFFEE46BC),
    Color(0xFFF04438),
  ];

  Box get _groupBox => Hive.box(_groupBoxName);
  Box get _categoryBox => Hive.box(_categoryBoxName);

  String get _userEmail => widget.users.email;
  Future<void>? _boxesReady;

  @override
  void initState() {
    super.initState();
    _boxesReady = _ensureBoxesOpen();
  }

  Future<void> _ensureBoxesOpen() async {
    if (!Hive.isBoxOpen(_groupBoxName)) {
      await Hive.openBox(_groupBoxName);
    }
    if (!Hive.isBoxOpen(_categoryBoxName)) {
      await Hive.openBox(_categoryBoxName);
    }
  }

  List<Map<String, dynamic>> _getGroups() {
    final results = <Map<String, dynamic>>[];
    for (final key in _groupBox.keys) {
      final value = _groupBox.get(key);
      if (value is Map) {
        final map = Map<String, dynamic>.from(value);
        if (map['user_email'] == _userEmail) {
          map['id'] = key.toString();
          results.add(map);
        }
      }
    }
    results.sort((a, b) => (a['created_at'] ?? '').toString().compareTo((b['created_at'] ?? '').toString()));
    return results;
  }

  List<Map<String, dynamic>> _getCategoriesByGroup(String groupId) {
    final results = <Map<String, dynamic>>[];
    for (final key in _categoryBox.keys) {
      final value = _categoryBox.get(key);
      if (value is Map) {
        final map = Map<String, dynamic>.from(value);
        if (map['user_email'] == _userEmail && map['group_id'] == groupId) {
          map['id'] = key.toString();
          results.add(map);
        }
      }
    }
    results.sort((a, b) => (a['created_at'] ?? '').toString().compareTo((b['created_at'] ?? '').toString()));
    return results;
  }

  Future<void> _addGroup(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    await _groupBox.put(id, {
      'name': trimmed,
      'user_email': _userEmail,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> _addCategory({
    required String groupId,
    required String name,
    required int iconCode,
    required int colorValue,
  }) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    await _categoryBox.put(id, {
      'group_id': groupId,
      'name': trimmed,
      'icon_code': iconCode,
      'color_value': colorValue,
      'user_email': _userEmail,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> _deleteGroup(String groupId) async {
    final categories = _getCategoriesByGroup(groupId);
    for (final c in categories) {
      await _categoryBox.delete(c['id']);
    }
    await _groupBox.delete(groupId);
  }

  Future<void> _deleteCategory(String categoryId) async {
    await _categoryBox.delete(categoryId);
  }

  Future<void> _updateCategoryStyle({
    required String categoryId,
    required IconData icon,
    required Color color,
  }) async {
    final raw = _categoryBox.get(categoryId);
    if (raw is! Map) return;
    final map = Map<String, dynamic>.from(raw);
    map['icon_code'] = icon.codePoint;
    map['color_value'] = color.value;
    map['updated_at'] = DateTime.now().toIso8601String();
    await _categoryBox.put(categoryId, map);
  }

  Future<void> _showCreateGroupDialog() async {
    final controller = TextEditingController();
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(Responsive.r(32))),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            Responsive.w(24),
            Responsive.h(10),
            Responsive.w(24),
            MediaQuery.of(context).viewInsets.bottom + Responsive.h(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: Responsive.w(64),
                  height: Responsive.h(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD0D5DD),
                    borderRadius: BorderRadius.circular(Responsive.r(50)),
                  ),
                ),
              ),
              SizedBox(height: Responsive.h(20)),
              Text(
                'Tạo nhóm danh mục mới',
                style: TextStyle(
                  fontFamily: 'BeVietnamPro',
                  fontSize: Responsive.sp(18),
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF101828),
                ),
              ),
              SizedBox(height: Responsive.h(8)),
              Text(
                'Phân loại chi tiêu của bạn để quản lý tốt hơn.',
                style: TextStyle(
                  fontFamily: 'BeVietnamPro',
                  fontSize: Responsive.sp(15),
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF667085),
                ),
              ),
              SizedBox(height: Responsive.h(26)),
              Text(
                'Tên nhóm danh mục',
                style: TextStyle(
                  fontFamily: 'BeVietnamPro',
                  fontSize: Responsive.sp(15),
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1D2939),
                ),
              ),
              SizedBox(height: Responsive.h(10)),
              TextField(
                controller: controller,
                style: TextStyle(fontFamily: 'BeVietnamPro', fontSize: Responsive.sp(16), fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.folder_rounded, color: const Color(0xFF7B61FF), size: Responsive.sp(22)),
                  hintText: 'Ví dụ: Ăn uống, Di chuyển...',
                  hintStyle: TextStyle(fontFamily: 'BeVietnamPro', fontSize: Responsive.sp(16), color: const Color(0xFF98A2B3), fontWeight: FontWeight.w600),
                  filled: true,
                  fillColor: const Color(0xFFF2F4F7),
                  contentPadding: EdgeInsets.symmetric(vertical: Responsive.h(16), horizontal: Responsive.w(14)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Responsive.r(22)),
                    borderSide: BorderSide(color: const Color(0xFFE4E7EC), width: Responsive.w(1.2)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Responsive.r(22)),
                    borderSide: BorderSide(color: const Color(0xFF7B61FF), width: Responsive.w(1.4)),
                  ),
                ),
              ),
              SizedBox(height: Responsive.h(26)),
              GestureDetector(
                onTap: () async {
                  await _addGroup(controller.text);
                  if (mounted) Navigator.pop(context);
                },
                child: Container(
                  width: double.infinity,
                  height: Responsive.h(54),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF8B5CF6), Color(0xFF5E60E7)]),
                    borderRadius: BorderRadius.circular(Responsive.r(22)),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF7B61FF).withOpacity(0.28),
                        blurRadius: Responsive.r(16),
                        offset: Offset(0, Responsive.h(7)),
                      )
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Lưu nhóm danh mục',
                    style: TextStyle(
                      fontFamily: 'BeVietnamPro',
                      fontSize: Responsive.sp(16),
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              SizedBox(height: Responsive.h(14)),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Hủy bỏ',
                    style: TextStyle(
                      fontFamily: 'BeVietnamPro',
                      fontSize: Responsive.sp(15),
                      color: const Color(0xFF667085),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showAddCategorySheet(String groupId) async {
    final nameController = TextEditingController();
    int selectedIconCode = _iconOptions.first.codePoint;
    int selectedColorValue = _colorOptions.first.value;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFF7F7FB),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(Responsive.r(34))),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                Responsive.w(24),
                Responsive.h(10),
                Responsive.w(24),
                MediaQuery.of(context).viewInsets.bottom + Responsive.h(26),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: Responsive.w(90),
                      height: Responsive.h(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFBEC7D4),
                        borderRadius: BorderRadius.circular(Responsive.r(50)),
                      ),
                    ),
                  ),
                  SizedBox(height: Responsive.h(18)),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Thêm danh mục mới',
                          style: TextStyle(fontSize: Responsive.sp(18), fontWeight: FontWeight.w800, fontFamily: 'BeVietnamPro', color: const Color(0xFF101828)),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close_rounded, size: Responsive.sp(28), color: const Color(0xFF98A2B3)),
                      ),
                    ],
                  ),
                  SizedBox(height: Responsive.h(12)),
                  Text(
                    'TÊN DANH MỤC',
                    style: TextStyle(
                      fontFamily: 'BeVietnamPro',
                      fontSize: Responsive.sp(15),
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF475467),
                    ),
                  ),
                  SizedBox(height: Responsive.h(10)),
                  TextField(
                    controller: nameController,
                    style: TextStyle(fontFamily: 'BeVietnamPro', fontSize: Responsive.sp(15), fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      hintText: 'VD: Gia đình, Công việc...',
                      hintStyle: TextStyle(fontFamily: 'BeVietnamPro', fontSize: Responsive.sp(15), color: const Color(0xFF667085), fontWeight: FontWeight.w600),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(vertical: Responsive.h(16), horizontal: Responsive.w(16)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Responsive.r(30)),
                        borderSide: BorderSide(color: const Color(0xFFD0D5DD), width: Responsive.w(1.2)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Responsive.r(30)),
                        borderSide: BorderSide(color: const Color(0xFFD0D5DD), width: Responsive.w(1.2)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Responsive.r(30)),
                        borderSide: BorderSide(color: const Color(0xFF7B61FF), width: Responsive.w(1.4)),
                      ),
                    ),
                  ),
                  SizedBox(height: Responsive.h(18)),
                  Text('MÀU SẮC DANH MỤC', style: TextStyle(fontFamily: 'BeVietnamPro', fontSize: Responsive.sp(15), fontWeight: FontWeight.w700, color: const Color(0xFF475467))),
                  SizedBox(height: Responsive.h(10)),
                  Wrap(
                    spacing: Responsive.w(8),
                    runSpacing: Responsive.h(8),
                    children: _colorOptions.map((color) {
                      final selected = selectedColorValue == color.value;
                      return GestureDetector(
                        onTap: () => setModalState(() => selectedColorValue = color.value),
                        child: Container(
                          width: Responsive.r(42),
                          height: Responsive.r(42),
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: selected ? Border.all(color: const Color(0xFF7B61FF), width: Responsive.w(3)) : null,
                            boxShadow: selected
                                ? [
                                    BoxShadow(
                                      color: const Color(0xFF7B61FF).withOpacity(0.18),
                                      blurRadius: Responsive.r(10),
                                      offset: Offset(0, Responsive.h(4)),
                                    ),
                                  ]
                                : null,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: Responsive.h(18)),
                  Text('CHỌN BIỂU TƯỢNG', style: TextStyle(fontFamily: 'BeVietnamPro', fontSize: Responsive.sp(15), fontWeight: FontWeight.w700, color: const Color(0xFF475467))),
                  SizedBox(height: Responsive.h(10)),
                  Wrap(
                    spacing: Responsive.w(14),
                    runSpacing: Responsive.h(14),
                    children: _iconOptions.map((icon) {
                      final selected = selectedIconCode == icon.codePoint;
                      return GestureDetector(
                        onTap: () => setModalState(() => selectedIconCode = icon.codePoint),
                        child: Container(
                          width: Responsive.r(64),
                          height: Responsive.r(64),
                          decoration: BoxDecoration(
                            gradient: selected
                                ? const LinearGradient(colors: [Color(0xFF8B5CF6), Color(0xFF5E60E7)])
                                : null,
                            color: selected ? null : Colors.white,
                            borderRadius: BorderRadius.circular(Responsive.r(26)),
                            border: Border.all(color: const Color(0xFFD0D5DD), width: Responsive.w(1.2)),
                            boxShadow: selected
                                ? [
                                    BoxShadow(
                                      color: const Color(0xFF7B61FF).withOpacity(0.25),
                                      blurRadius: Responsive.r(12),
                                      offset: Offset(0, Responsive.h(5)),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Icon(
                            icon,
                            size: Responsive.sp(24),
                            color: selected ? Colors.white : const Color(0xFF667085),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: Responsive.h(22)),
                  GestureDetector(
                    onTap: () async {
                      await _addCategory(
                        groupId: groupId,
                        name: nameController.text,
                        iconCode: selectedIconCode,
                        colorValue: selectedColorValue,
                      );
                      if (mounted) Navigator.pop(context);
                    },
                    child: Container(
                      width: double.infinity,
                      height: Responsive.h(54),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFF8B5CF6), Color(0xFF5E60E7)]),
                        borderRadius: BorderRadius.circular(Responsive.r(28)),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF7B61FF).withOpacity(0.24),
                            blurRadius: Responsive.r(14),
                            offset: Offset(0, Responsive.h(7)),
                          )
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Thêm danh mục',
                        style: TextStyle(
                          fontFamily: 'BeVietnamPro',
                          fontSize: Responsive.sp(18),
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCategoryItem(Map<String, dynamic> category) {
    final iconCode = (category['icon_code'] ?? Icons.category.codePoint) as int;
    final colorValue = (category['color_value'] ?? const Color(0xFF7B61FF).value) as int;
    final color = Color(colorValue);
    final createdAt = DateTime.tryParse((category['created_at'] ?? '').toString());
    final createdText = createdAt == null
        ? 'Danh mục do bạn tạo'
        : 'Tạo ngày ${createdAt.day.toString().padLeft(2, '0')}/${createdAt.month.toString().padLeft(2, '0')}/${createdAt.year}';

    return Padding(
      padding: EdgeInsets.only(bottom: Responsive.h(10)),
      child: CategoryCard(
        title: (category['name'] ?? 'Danh mục').toString(),
        subtitle: createdText,
        icon: IconData(iconCode, fontFamily: 'MaterialIcons'),
        iconColor: color,
        onDelete: () => _deleteCategory(category['id'].toString()),
        onSave: (icon, color) {
          _updateCategoryStyle(
            categoryId: category['id'].toString(),
            icon: icon,
            color: color,
          );
        },
      ),
    );
  }

  Widget _buildGroupSection(Map<String, dynamic> group) {
    final groupId = group['id'].toString();
    final categories = _getCategoriesByGroup(groupId);

    return Container(
      margin: EdgeInsets.only(bottom: Responsive.h(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  (group['name'] ?? '').toString().toUpperCase(),
                  style: TextStyle(
                    fontSize: Responsive.sp(12),
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF667085),
                    fontFamily: 'BeVietnamPro',
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _deleteGroup(groupId),
                icon: const Icon(Icons.delete_outline, color: Color(0xFF7B61FF)),
              ),
            ],
          ),
          ...categories.map(_buildCategoryItem),
          GestureDetector(
            onTap: () => _showAddCategorySheet(groupId),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: Responsive.h(12)),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF7B61FF).withOpacity(0.06),
                    const Color(0xFF6C3CF5).withOpacity(0.06),
                  ],
                ),
                borderRadius: BorderRadius.circular(Responsive.r(14)),
                border: Border.all(color: const Color(0xFF7B61FF).withOpacity(0.4), style: BorderStyle.solid),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_circle_outline, color: Color(0xFF7B61FF)),
                  SizedBox(width: Responsive.w(6)),
                  Text(
                    'Thêm danh mục mới',
                    style: TextStyle(
                      fontSize: Responsive.sp(14),
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF7B61FF),
                      fontFamily: 'BeVietnamPro',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _boxesReady ??= _ensureBoxesOpen(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          return DefaultTextStyle(
            style: TextStyle(
              fontFamily: 'BeVietnamPro',
              fontSize: Responsive.sp(14),
              color: const Color(0xFF1D2939),
            ),
            child: Column(
              children: [
          Stack(
            children: [
              PurpleHeader(height: Responsive.h(140)),
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.w(20),
                    vertical: Responsive.h(20),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: custombutton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          label: "",
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 25,
                          ),
                          width: Responsive.w(44),
                          height: Responsive.h(44),
                          borderRadius: Responsive.r(50),
                          backgroundColor: Colors.white.withOpacity(0.2),
                        ),
                      ),

                      Text(
                        "Quản lý danh mục",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Responsive.sp(23),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'BeVietnamPro',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.h(20)),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Responsive.w(20)),
              child: Column(
                children: [
                  custombutton(
                    onPressed: _showCreateGroupDialog,
                    label: 'Tạo nhóm danh mục',
                    height: Responsive.h(56),
                    borderRadius: Responsive.r(28),
                    width: double.infinity,
                    icon: Icon(
                      Icons.create_new_folder_rounded,
                      color: Colors.white,
                      size: Responsive.sp(24),
                    ),
                    labelStyle: TextStyle(
                      fontSize: Responsive.sp(16),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'BeVietnamPro',
                    ),
                    backgroundColor: const Color(0xFF7B61FF),
                  ),
                  SizedBox(height: Responsive.h(20)),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: Responsive.w(2)),
                      child: ValueListenableBuilder(
                        valueListenable: _groupBox.listenable(),
                        builder: (context, Box box, _) {
                          return ValueListenableBuilder(
                            valueListenable: _categoryBox.listenable(),
                            builder: (context, Box _, __) {
                              final groups = _getGroups();
                              if (groups.isEmpty) {
                                return Center(
                                  child: Text(
                                    'Chưa có nhóm danh mục. Hãy tạo nhóm đầu tiên.',
                                    style: TextStyle(fontSize: Responsive.sp(14), color: const Color(0xFF667085), fontFamily: 'BeVietnamPro'),
                                  ),
                                );
                              }

                              return ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: groups.length,
                                itemBuilder: (context, index) {
                                  return _buildGroupSection(groups[index]);
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
              ],
            ),
          );
        },
      ),
    );
  }
}
