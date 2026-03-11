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


  final double? height;
  final double? width;
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
    this.height,
    this.width,
    this.borderRadius = 12.0,
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

    Widget button = widget.isOutline
        ? _buildOutlineButton(primaryColor)
        : _buildElevatedButton(primaryColor, onPrimaryColor);
    if (widget.width != null || widget.height != null) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: button,
      );
    }
    return button;
  }

  Widget _buildElevatedButton(Color bgColor, Color textColor) {
    Responsive.init(context);
    final bool isIconOnly = widget.icon != null && widget.label.isEmpty;

    return ElevatedButton(
      onPressed: widget.isLoading ? null : widget.onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: textColor,
        elevation: 0,
        padding: isIconOnly
            ? EdgeInsets.zero
            : const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        minimumSize: (isIconOnly && widget.width != null && widget.height != null)
            ? Size(widget.width!, widget.height!)
            : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        disabledBackgroundColor: Colors.grey[300],
      ),
      child: _buildChild(textColor),
    );
  }

  Widget _buildOutlineButton(Color color) {
    final bool isIconOnly = widget.icon != null && widget.label.isEmpty;

    return OutlinedButton(
      onPressed: widget.isLoading ? null : widget.onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(
          color: color,
          width: Responsive.w(1.5),
        ),
        padding: isIconOnly
            ? EdgeInsets.zero
            : const EdgeInsets.symmetric(horizontal: 24, vertical: 12),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
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
    if (widget.icon != null && widget.label.isEmpty) {
      return Center(child: widget.icon);
    }
    Widget labelWidget = const SizedBox();
    if (widget.label.isNotEmpty) {
      labelWidget = Text(
        widget.label,
        style: widget.labelStyle ??
            TextStyle(
              fontSize: Responsive.sp(16),
              fontWeight: FontWeight.bold,
              fontFamily: 'BeVietnamPro',
              color: color,
            ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.icon != null) ...[
          widget.icon!,
          SizedBox(width: Responsive.w(8)),
        ],
        labelWidget,
      ],
    );
  }
}