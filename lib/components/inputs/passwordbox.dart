import 'package:flutter/material.dart';

class passwordbox extends StatefulWidget {
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
  const passwordbox({
    super.key,
    this.label,
    this.controller,
    this.keyboardType,
    this.hintText,
    this.textInputAction,
    this.validator,
    this.onChanged,
    this.maxLines,
    this.prefixIcon,
    this.labelStyle,
    this.labelGap = 8.0,
  });

  @override
  State<passwordbox> createState() => _passwordboxState();
}

class _passwordboxState extends State<passwordbox> {
  bool _isObscure = true;
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
              fontWeight: FontWeight.normal,
              color: Colors.black,
              fontFamily: 'BeVietnamPro',
            ),
          ),
        SizedBox(height: widget.labelGap ),
        TextFormField(
          textAlignVertical: TextAlignVertical.center,
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: _isObscure,
          textInputAction: widget.textInputAction,
          validator: widget.validator,
          onChanged: widget.onChanged,
          maxLines: 1,
          style: const TextStyle(fontSize: 14,),
          decoration: InputDecoration(

            hintText: widget.hintText,
            hintStyle: TextStyle(
              letterSpacing: 2.5,
                fontSize: 7,
                color: Colors.grey),
            prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 20, right: 5),
                child: widget.prefixIcon
            ),
            suffixIcon: IconButton(
              icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility) ,
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                });
              },
            ),
            filled: true,
            fillColor: Colors.grey[50],
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
