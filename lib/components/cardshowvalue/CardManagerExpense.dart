import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
        scale: _isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,

        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                spreadRadius: 10,
                offset: const Offset(4, 4),
              ),
            ],
          ),

          child: Material(
            color: Colors.transparent,
            child: Ink(
              decoration: BoxDecoration(
                color: Colors.grey[150],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.1), width: 2),
              ),
              child: InkWell(
                onTap: () {
                  if (widget.onPressed != null) {
                    Future.delayed(const Duration(milliseconds: 150), widget.onPressed);
                  }
                },
                borderRadius: BorderRadius.circular(15),
                splashColor: widget.Iconcolor?.withValues(alpha: 0.2) ??
                    Colors.orange[200],
                highlightColor: widget.Iconcolor?.withValues(alpha: 0.1) ??
                    Colors.orange[100],

                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsetsGeometry.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: widget.Iconcolor?.withValues(alpha: 0.2) ??
                                        Colors.orange[200],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Icon(
                                      widget.Icon ?? Icons.fastfood,
                                      size: 30,
                                      color: widget.Iconcolor ?? Colors.orange,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 3),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.title ?? "Ăn uống",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      (widget.total ?? "15") + " giao dịch",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  (widget.allmoney ?? "232,43243324.234")+" ₫",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  "${((widget.percen ?? 0.23) * 100).toInt()}%",
                                  style: TextStyle(fontSize: 14, color: Colors.red),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsGeometry.only(
                          left: 12,
                          right: 12,
                          top: 5,
                          bottom: 15,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: widget.percen ?? 0.4,
                            backgroundColor: Colors.grey[200],
                            color: widget.Iconcolor ?? Colors.orange,
                            minHeight: 8,
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