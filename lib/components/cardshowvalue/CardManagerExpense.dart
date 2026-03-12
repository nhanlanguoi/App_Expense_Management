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
            color: const Color(0xFFF4F6F8),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.grey.withOpacity(0.2),
              width: 1
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),

          child: Material(
            color: Colors.transparent,
            child: Ink(
              decoration: BoxDecoration(
                color: Colors.grey[150],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.1), width: 1),
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
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 17),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      /// LEFT
                      Row(
                        children: [
                          Container(
                            width: 43,
                            height: 43,
                            decoration: BoxDecoration(
                              color: widget.Iconcolor?.withOpacity(0.15) ?? Colors.orange.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              widget.Icon ?? Icons.fastfood,
                              size: 20,
                              color: widget.Iconcolor ?? Colors.orange,
                            ),
                          ),

                          const SizedBox(width: 10),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.title ?? "Ăn uống",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                widget.total ?? "15 giao dịch",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      /// RIGHT
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "${widget.allmoney ?? "0"} ₫",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "${((widget.percen ?? 0.23) * 100).toInt()}%",
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  /// PROGRESS BAR
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Stack(
                      children: [

                        /// background
                        Container(
                          height: 6,
                          color: Colors.grey[200],
                        ),

                        /// progress
                        FractionallySizedBox(
                          widthFactor: widget.percen ?? 0.4,
                          child: Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: widget.Iconcolor ?? Colors.orange,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ],
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