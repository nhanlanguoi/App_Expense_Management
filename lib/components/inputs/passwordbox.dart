import 'package:flutter/material.dart';
import '../../core/utils/responsive.dart';

class passwordbox extends StatefulWidget {
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
            style: widget.labelStyle ??
                TextStyle(
                  fontSize: Responsive.sp(15),
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                  fontFamily: 'BeVietnamPro',
                ),
          ),

        SizedBox(height: Responsive.h(widget.labelGap)),

        TextFormField(
          textAlignVertical: TextAlignVertical.center,
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: _isObscure,
          textInputAction: widget.textInputAction,
          validator: widget.validator,
          onChanged: widget.onChanged,
          maxLines: 1,
          style: TextStyle(
            fontSize: Responsive.sp(14),
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(
              letterSpacing: Responsive.w(2.5),
              fontSize: Responsive.sp(7),
              color: Colors.grey,
            ),
            prefixIcon: Padding(
              padding: EdgeInsets.only(
                left: Responsive.w(20),
                right: Responsive.w(5),
              ),
              child: widget.prefixIcon,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _isObscure ? Icons.visibility_off : Icons.visibility,
                size: Responsive.w(20),
              ),
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                });
              },
            ),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: EdgeInsets.symmetric(
              vertical: Responsive.h(10),
              horizontal: Responsive.w(10),
            ),
            border: OutlineInputBorder(
              borderRadius:
              BorderRadius.circular(Responsive.w(40)),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius:
              BorderRadius.circular(Responsive.w(40)),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius:
              BorderRadius.circular(Responsive.w(40)),
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