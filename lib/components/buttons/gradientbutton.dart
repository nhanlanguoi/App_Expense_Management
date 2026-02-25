import 'package:flutter/material.dart';
import '../../core/utils/responsive.dart';

// Đổi tên thành PascalCase theo chuẩn Flutter
class gradientbutton extends StatefulWidget {
  final String label;
  final TextStyle? labelStyle;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutline;
  final Color? backgroundColor;
  final Color? textColor;
  final Widget? icon;
  final double height;
  final double width;
  final double borderRadius;

  final Gradient? gradient;

  const gradientbutton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isOutline = false,
    this.backgroundColor,
    this.textColor,
    this.icon,
    required this.height,
    required this.borderRadius,
    required this.width,
    this.labelStyle,
    this.gradient,
  });

  @override
  State<gradientbutton> createState() => _gradientbuttonState();
}

class _gradientbuttonState extends State<gradientbutton> {
  @override
  Widget build(BuildContext context) {
    final primaryColor = widget.backgroundColor ?? Colors.purple;
    final onPrimaryColor = widget.textColor ?? Colors.white;

    if (widget.isOutline) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: _buildOutlineButton(primaryColor),
      );
    }

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        gradient: widget.gradient,
        color: widget.gradient == null ? primaryColor : null,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        boxShadow: [
          BoxShadow(
            color: (widget.gradient != null ? Colors.black : primaryColor)
                .withOpacity(0.3),
            blurRadius: Responsive.w(8),
            offset: Offset(0, Responsive.h(4)),
          )
        ],
      ),
      child: _buildElevatedButton(Colors.transparent, onPrimaryColor),
    );
  }

  Widget _buildElevatedButton(Color bgColor, Color textColor) {
    return ElevatedButton(
      onPressed: widget.isLoading ? null : widget.onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        shadowColor: Colors.transparent,
        foregroundColor: textColor,
        elevation: 0,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        disabledBackgroundColor: Colors.grey[300],
      ),
      child: _buildChild(textColor),
    );
  }

  Widget _buildOutlineButton(Color color) {
    return OutlinedButton(
      onPressed: widget.isLoading ? null : widget.onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color, width: Responsive.w(1.5)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        padding: EdgeInsets.zero,
      ),
      child: _buildChild(color),
    );
  }

  Widget _buildChild(Color color) {
    if (widget.isLoading) {
      return SizedBox(
        height: Responsive.w(20),
        width: Responsive.w(20),
        child: CircularProgressIndicator(
          strokeWidth: Responsive.w(2),
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.icon != null) ...[
          widget.icon!,
          SizedBox(width: Responsive.w(8)),
        ],
        Text(
          widget.label,
          style: widget.labelStyle ??
              TextStyle(
                fontSize: Responsive.sp(16),
                fontWeight: FontWeight.bold,
                fontFamily: 'BeVietnamPro',
                color: color,
              ),
        ),
      ],
    );
  }
}