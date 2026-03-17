import 'package:expense_management/core/utils/responsive.dart';
import 'package:flutter/material.dart';

class CategoryGroupFilterSheet extends StatelessWidget {
  static const String allGroupValue = '__all__';

  final List<Map<String, dynamic>> groups;
  final String? selectedGroupId;

  const CategoryGroupFilterSheet({
    super.key,
    required this.groups,
    required this.selectedGroupId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        Responsive.w(16),
        Responsive.h(10),
        Responsive.w(16),
        Responsive.h(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: Responsive.w(64),
            height: Responsive.h(6),
            decoration: BoxDecoration(
              color: const Color(0xFFD0D5DD),
              borderRadius: BorderRadius.circular(Responsive.r(20)),
            ),
          ),
          SizedBox(height: Responsive.h(14)),
          Text(
            'Lọc theo nhóm danh mục',
            style: TextStyle(
              fontFamily: 'BeVietnamPro',
              fontSize: Responsive.sp(16),
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: Responsive.h(10)),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: Responsive.w(4)),
            leading: Icon(
              Icons.apps_rounded,
              color: const Color(0xFF7B61FF),
              size: Responsive.sp(20),
            ),
            title: Text(
              'Xem tất cả',
              style: TextStyle(
                fontFamily: 'BeVietnamPro',
                fontSize: Responsive.sp(14),
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: selectedGroupId == null
                ? Icon(Icons.check_rounded, color: const Color(0xFF7B61FF), size: Responsive.sp(20))
                : null,
            onTap: () => Navigator.pop(context, allGroupValue),
          ),
          const Divider(height: 1),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: groups.length,
              itemBuilder: (context, index) {
                final group = groups[index];
                final groupId = (group['id'] ?? '').toString();
                final selected = selectedGroupId == groupId;
                return ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: Responsive.w(4)),
                  leading: Icon(
                    Icons.folder_rounded,
                    color: const Color(0xFF7B61FF),
                    size: Responsive.sp(20),
                  ),
                  title: Text(
                    (group['name'] ?? '').toString(),
                    style: TextStyle(
                      fontFamily: 'BeVietnamPro',
                      fontSize: Responsive.sp(14),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    '${group['count'] ?? 0} danh mục',
                    style: TextStyle(
                      fontFamily: 'BeVietnamPro',
                      fontSize: Responsive.sp(12),
                      color: const Color(0xFF667085),
                    ),
                  ),
                  trailing: selected
                      ? Icon(Icons.check_rounded, color: const Color(0xFF7B61FF), size: Responsive.sp(20))
                      : null,
                  onTap: () => Navigator.pop(context, groupId),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
