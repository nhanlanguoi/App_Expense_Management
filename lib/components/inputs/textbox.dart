import 'package:flutter/material.dart';
import 'package:expense_management/core/utils/responsive.dart';

class textbox extends StatefulWidget {
  final String? label;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? hintText;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
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
            style: widget.labelStyle ??
                TextStyle(
                  fontSize: Responsive.sp(15),
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontFamily: 'BeVietnamPro',
                ),
          ),

        SizedBox(height: Responsive.h(widget.labelGap)),

        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          validator: widget.validator,
          onChanged: widget.onChanged,
          maxLines: widget.maxLines,
          style: TextStyle(
            fontSize: Responsive.sp(14),
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: Responsive.sp(13),
            ),
            prefixIcon: Padding(
              padding: EdgeInsets.only(
                left: Responsive.w(20),
                right: Responsive.w(5),
              ),
              child: widget.prefixIcon,
            ),
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding: EdgeInsets.symmetric(
              vertical: Responsive.h(10),
              horizontal: Responsive.w(10),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Responsive.w(40)),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Responsive.w(40)),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Responsive.w(40)),
              borderSide: BorderSide(
                color: Colors.purple,
                width: Responsive.w(2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}