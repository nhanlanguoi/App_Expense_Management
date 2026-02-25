import 'package:expense_management/core/utils/responsive.dart';
import 'package:flutter/material.dart';

class custombutton extends StatefulWidget {
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

  const custombutton({
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
  });

  @override
  State<custombutton> createState() => _custombuttonState();
}

class _custombuttonState extends State<custombutton> {
  @override
  Widget build(BuildContext context) {
    final primaryColor = widget.backgroundColor ?? Colors.purple;
    final onPrimaryColor = widget.textColor ?? Colors.white;

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: widget.isOutline
          ? _buildOutlineButton(primaryColor)
          : _buildElevatedButton(primaryColor, onPrimaryColor),
    );
  }

  Widget _buildElevatedButton(Color bgColor, Color textColor) {
    Responsive.init(context);

    return ElevatedButton(
      onPressed: widget.isLoading ? null : widget.onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: textColor,
        elevation: 0,
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

        side: BorderSide(
          color: color,
          width: Responsive.w(1.5),
        ),

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