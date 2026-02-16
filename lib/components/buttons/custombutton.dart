import 'package:flutter/material.dart';

class custombutton extends StatefulWidget {
  final String label;
  final TextStyle? labelStyle;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutline; // Biến xác định là nút viền hay nút đặc
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
    final primaryColor = widget.backgroundColor ?? Colors.purple; // Màu mặc định giống viền focus của bạn
    final onPrimaryColor = widget.textColor ?? Colors.white;
    return SizedBox(
      width: widget.width, // Luôn full chiều ngang
      height: widget.height,
      child: widget.isOutline
          ? _buildOutlineButton(primaryColor)
          : _buildElevatedButton(primaryColor, onPrimaryColor),
    );
  }




  Widget _buildElevatedButton(Color bgColor, Color textColor) {
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

      ), child: _buildChild(textColor),

    );

  }
  Widget _buildOutlineButton(Color color) {
    return OutlinedButton(
      onPressed: widget.isLoading ? null : widget.onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color, width: 1.5), // Độ dày viền
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        padding: EdgeInsets.zero,
      ),
      child: _buildChild(color),
    );
  }
  Widget _buildChild(Color color) {
    if(widget.isLoading){
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.icon != null)...[
          widget.icon!,
          const SizedBox(width: 8),
        ],
        Text(
            widget.label,
            style: widget.labelStyle ?? TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'BeVietnamPro',
              color: color,
            )
        ),
      ],
    );
  }


}