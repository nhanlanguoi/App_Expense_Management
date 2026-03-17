import 'package:expense_management/core/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:expense_management/core/utils/responsive.dart';

class Cardmanagerexpense extends StatefulWidget {
  final VoidCallback? onPressed;
  final String? title;
  final String? total;
  final String? allmoney;
  final double? percen;
  final IconData? Icon;
  final Color? Iconcolor;

  const Cardmanagerexpense({
    super.key,
    this.title,
    this.total,
    this.allmoney,
    this.percen,
    this.Icon,
    this.Iconcolor,
    this.onPressed,
  });

  @override
  State<Cardmanagerexpense> createState() => _CardmanagerexpenseState();
}

class _CardmanagerexpenseState extends State<Cardmanagerexpense> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        setState(() => _isPressed = true);
        HapticFeedback.lightImpact();
      },
      onPointerUp: (_) {
        setState(() => _isPressed = false);
      },
      onPointerCancel: (_) {
        setState(() => _isPressed = false);
      },
      child: AnimatedScale(
        scale: _isPressed ? 0.985 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,

        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(Responsive.r(16)),
            border: Border.all(color: const Color(0xFFEAECEF), width: Responsive.w(1.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: Responsive.r(10),
                spreadRadius: 0,
                offset: Offset(0, Responsive.h(3)),
              ),
            ],
          ),

          child: Material(
            color: Colors.transparent,
            child: Ink(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Responsive.r(16)),
              ),
              child: InkWell(
                onTap: () {
                  if (widget.onPressed != null) {
                    Future.delayed(const Duration(milliseconds: 150), widget.onPressed);
                  }
                },
                borderRadius: BorderRadius.circular(Responsive.r(16)),
                splashColor: widget.Iconcolor?.withValues(alpha: 0.2) ??
                    Colors.orange[200],
                highlightColor: widget.Iconcolor?.withValues(alpha: 0.1) ??
                    Colors.orange[100],

                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Responsive.w(12), vertical: Responsive.h(10)),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  width: Responsive.r(44),
                                  height: Responsive.r(44),
                                  decoration: BoxDecoration(
                                    color: widget.Iconcolor?.withValues(alpha: 0.18) ?? Colors.orange[100],
                                    borderRadius: BorderRadius.circular(Responsive.r(12)),
                                  ),
                                  child: Icon(
                                    widget.Icon ?? Icons.fastfood,
                                    size: Responsive.sp(24),
                                    color: widget.Iconcolor ?? Colors.orange,
                                  ),
                                ),
                                SizedBox(width: Responsive.w(10)),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.title ?? "Ăn uống",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: 'BeVietnamPro',
                                          fontWeight: FontWeight.w700,
                                          fontSize: Responsive.sp(15),
                                          color: const Color(0xFF1D2939),
                                        ),
                                      ),
                                      SizedBox(height: Responsive.h(2)),
                                      Text(
                                        (widget.total ?? "15"),
                                        style: TextStyle(
                                          fontFamily: 'BeVietnamPro',
                                          fontSize: Responsive.sp(12),
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xFF98A2B3),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: Responsive.w(8)),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                (Format.formattext(widget.allmoney ?? "0")) + " ₫",
                                style: TextStyle(
                                  fontFamily: 'BeVietnamPro',
                                  fontWeight: FontWeight.w800,
                                  fontSize: Responsive.sp(15),
                                  color: const Color(0xFF1D2939),
                                ),
                              ),
                              SizedBox(height: Responsive.h(2)),
                              Text(
                                "${((widget.percen ?? 0.23) * 100).toInt()}%",
                                style: TextStyle(
                                  fontFamily: 'BeVietnamPro',
                                  fontSize: Responsive.sp(12),
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFFF97066),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: Responsive.h(10)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: Responsive.w(2)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(Responsive.r(10)),
                          child: LinearProgressIndicator(
                            value: widget.percen ?? 0.4,
                            backgroundColor: const Color(0xFFEAECEF),
                            color: widget.Iconcolor ?? Colors.orange,
                            minHeight: Responsive.h(6),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}