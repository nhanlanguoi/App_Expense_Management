import 'package:flutter/material.dart';
import 'package:expense_management/core/utils/responsive.dart';

class CategoryCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final void Function(IconData icon, Color color)? onSave;
  final VoidCallback? onDelete;

  const CategoryCard({
    super.key,
    required this.title,
    this.subtitle = '',
    required this.icon,
    required this.iconColor,
    this.onSave,
    this.onDelete,
  });

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard>
  with SingleTickerProviderStateMixin {
  static const Color _primaryPurple = Color(0xFF7B61FF);
  static const Color _deepPurple = Color(0xFF6C3CF5);

  final List<IconData> _iconOptions = const [
    Icons.home_rounded,
    Icons.receipt_long_rounded,
    Icons.restaurant_rounded,
    Icons.local_hospital_rounded,
    Icons.directions_car_rounded,
    Icons.shopping_bag_rounded,
    Icons.movie_rounded,
    Icons.school_rounded,
  ];

  final List<Color> _colorOptions = const [
    Color(0xFF7B61FF),
    Color(0xFF2E90FA),
    Color(0xFF12B76A),
    Color(0xFFF79009),
    Color(0xFFEE46BC),
    Color(0xFFF04438),
  ];

  late final AnimationController _controller;
  late final Animation<double> _size;
  late final Animation<double> _fade;
  bool isExpanded = false;
  late IconData _selectedIcon;
  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    _selectedIcon = widget.icon;
    _selectedColor = widget.iconColor;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _size = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  }

  @override
  void didUpdateWidget(covariant CategoryCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!isExpanded && (oldWidget.icon != widget.icon || oldWidget.iconColor != widget.iconColor)) {
      _selectedIcon = widget.icon;
      _selectedColor = widget.iconColor;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggle() {
    setState(() {
      isExpanded = !isExpanded;
      if (isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  void _cancelEdit() {
    setState(() {
      _selectedIcon = widget.icon;
      _selectedColor = widget.iconColor;
      isExpanded = false;
      _controller.reverse();
    });
  }

  void _saveEdit() {
    widget.onSave?.call(_selectedIcon, _selectedColor);
    setState(() {
      isExpanded = false;
      _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
      padding: EdgeInsets.symmetric(horizontal: Responsive.w(16), vertical: Responsive.h(14)),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F5FF),
        borderRadius: BorderRadius.circular(Responsive.r(20)),
        border: Border.all(
          color: isExpanded
              ? _primaryPurple.withOpacity(0.45)
              : _primaryPurple.withOpacity(0.18),
          width: Responsive.w(1.6),
        ),
        boxShadow: [
          BoxShadow(
            color: _primaryPurple.withOpacity(0.12),
            blurRadius: Responsive.r(12),
            offset: Offset(0, Responsive.h(6)),
          ),
        ],
      ),

      child: DefaultTextStyle(
        style: TextStyle(
          fontFamily: 'BeVietnamPro',
          fontSize: Responsive.sp(14),
          color: const Color(0xFF1D2939),
        ),
        child: Column(
          children: [

          GestureDetector(
            onTap: toggle,
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  width: Responsive.r(46),
                  height: Responsive.r(46),
                  decoration: BoxDecoration(
                    color: _selectedColor.withOpacity(isExpanded ? 0.25 : 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _selectedIcon,
                    color: _selectedColor,
                    size: Responsive.sp(22),
                  ),
                ),

                SizedBox(width: Responsive.w(16)),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: Responsive.sp(16),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'BeVietnamPro',
                        ),
                      ),

                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: isExpanded ? 1 : 0,
                        child: Text(
                          widget.subtitle.isEmpty ? "Đang chỉnh sửa..." : widget.subtitle,
                          style: TextStyle(
                            color: _primaryPurple,
                            fontSize: Responsive.sp(12),
                            fontFamily: 'BeVietnamPro',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                Row(
                  children: [
                    Icon(Icons.edit, color: _primaryPurple.withOpacity(0.75), size: Responsive.sp(18)),
                    if (widget.onDelete != null)
                      IconButton(
                        onPressed: widget.onDelete,
                        icon: Icon(Icons.delete_outline, color: _primaryPurple.withOpacity(0.75), size: Responsive.sp(18)),
                      ),
                  ],
                ),
              ],
            ),
          ),

          ClipRect(
            child: SizeTransition(
              sizeFactor: _size,
              axisAlignment: -1,
              child: FadeTransition(
                opacity: _fade,
                child: Column(
                children: [

                  SizedBox(height: Responsive.h(20)),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "CHỌN BIỂU TƯỢNG",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _primaryPurple.withOpacity(0.75),
                        fontSize: Responsive.sp(12),
                        fontFamily: 'BeVietnamPro',
                      ),
                    ),
                  ),

                  SizedBox(height: Responsive.h(10)),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _iconOptions.map((icon) {
                      final selected = _selectedIcon == icon;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedIcon = icon),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: Responsive.r(34),
                          height: Responsive.r(34),
                          decoration: BoxDecoration(
                            color: selected ? _selectedColor.withOpacity(0.16) : Colors.transparent,
                            borderRadius: BorderRadius.circular(Responsive.r(10)),
                          ),
                          child: Icon(icon, color: selected ? _selectedColor : _primaryPurple.withOpacity(0.55)),
                        ),
                      );
                    }).toList(),
                  ),

                  SizedBox(height: Responsive.h(20)),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "CHỌN MÀU SẮC",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _primaryPurple.withOpacity(0.75),
                        fontSize: Responsive.sp(12),
                        fontFamily: 'BeVietnamPro',
                      ),
                    ),
                  ),

                  SizedBox(height: Responsive.h(10)),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _colorOptions.map((color) {
                      final selected = _selectedColor.value == color.value;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedColor = color),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: Responsive.r(22),
                          height: Responsive.r(22),
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: selected ? Border.all(color: Colors.black87, width: 2) : null,
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  SizedBox(height: Responsive.h(20)),

                  Row(
                    children: [

                      Expanded(
                        child: GestureDetector(
                          onTap: _cancelEdit,
                          child: Container(
                            height: Responsive.h(42),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(Responsive.r(25)),
                            ),
                              child: Center(
                                child: Text(
                                  "Hủy",
                                  style: TextStyle(
                                    fontFamily: 'BeVietnamPro',
                                      fontSize: Responsive.sp(14),
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF475467),
                                  ),
                                ),
                              ),
                          ),
                        ),
                      ),

                      SizedBox(width: Responsive.w(12)),

                      Expanded(
                        child: GestureDetector(
                          onTap: _saveEdit,
                          child: Container(
                            height: Responsive.h(42),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  _primaryPurple,
                                  _deepPurple,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(Responsive.r(25)),
                            ),
                            child: Center(
                              child: Text(
                                "Lưu thay đổi",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'BeVietnamPro',
                                  fontSize: Responsive.sp(14),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
          )
          ],
        ),
      ),
    );
  }
}