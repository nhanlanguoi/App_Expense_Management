import 'package:flutter/material.dart';

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

  // 1. Thêm thuộc tính Gradient
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
    this.gradient, // 2. Nhận vào từ constructor
  });

  @override
  State<gradientbutton> createState() => _gradientbuttonState();
}

class _gradientbuttonState extends State<gradientbutton> {
  @override
  Widget build(BuildContext context) {
    final primaryColor = widget.backgroundColor ?? Colors.purple;
    final onPrimaryColor = widget.textColor ?? Colors.white;

    // Nếu là nút Outline thì giữ nguyên logic cũ
    if (widget.isOutline) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: _buildOutlineButton(primaryColor),
      );
    }

    // Nếu là nút thường (hoặc Gradient), ta bọc trong Container
    return Container(
      width: widget.width,
      height: widget.height,
      // 3. Trang trí Container (Gradient nằm ở đây)
      decoration: BoxDecoration(
        gradient: widget.gradient,
        // Nếu không có gradient thì dùng màu backgroundColor, nếu có thì null
        color: widget.gradient == null ? primaryColor : null,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        // Thêm bóng đổ nhẹ nếu muốn đẹp hơn
        boxShadow: [
          BoxShadow(
            color: (widget.gradient != null ? Colors.black : primaryColor).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      // 4. Gọi hàm build nút (nhưng với màu trong suốt)
      child: _buildElevatedButton(Colors.transparent, onPrimaryColor),
    );
  }

  Widget _buildElevatedButton(Color bgColor, Color textColor) {
    return ElevatedButton(
      onPressed: widget.isLoading ? null : widget.onPressed,
      style: ElevatedButton.styleFrom(
        // QUAN TRỌNG: Màu nền phải trong suốt để lộ Gradient của Container
        backgroundColor: bgColor,
        shadowColor: Colors.transparent, // Tắt bóng đổ mặc định của nút để dùng bóng của Container
        foregroundColor: textColor,
        elevation: 0,
        padding: EdgeInsets.zero, // Xóa padding để nút full container
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
        side: BorderSide(color: color, width: 1.5),
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
        if (widget.icon != null) ...[
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
          ),
        ),
      ],
    );
  }
}