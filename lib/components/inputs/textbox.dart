import 'package:flutter/material.dart';

class textbox extends StatefulWidget {
  final String? label;
  final TextEditingController? controller;
  final TextInputType? keyboardType; // Thêm thuộc tính kiểu bàn phím

  final String? hintText;
  final TextInputAction? textInputAction; // Hành động nút ( ấn vào là sang ô nhập mới
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged; // kiểm tra dữ liệu nhập vào realtime
  final int? maxLines;
  final Widget? prefixIcon;
  final TextStyle? labelStyle;
  final double labelGap;
  const textbox({
    super.key,
    this.label,
    this.controller,
    this.hintText,
    this.textInputAction,
    this.validator,
    this.onChanged,
    this.maxLines = 1,
    this.prefixIcon,
    this.keyboardType,
    this.labelStyle,
    this.labelGap = 8.0,
  });

  @override
  State<textbox> createState() => _textboxState();
}

class _textboxState extends State<textbox> {



  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Text(
            widget.label!,
            style: widget.labelStyle ?? const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontFamily: 'BeVietnamPro',
            ),
          ),
        SizedBox(height: widget.labelGap ?? 10),
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          validator: widget.validator,
          onChanged: widget.onChanged,
          maxLines: widget.maxLines,
          style: const TextStyle(fontSize: 14,),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(color: Colors.grey),
            prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 20, right: 5),
                child: widget.prefixIcon
            ),
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: const BorderSide(color: Colors.purple,width: 2),
            ),
          ),

        ),
      ],

    );
  }
}
