import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expense_management/core/utils/responsive.dart';

class CardInfo extends StatelessWidget {
  final String? username;

  const CardInfo({super.key, this.username});

  @override
  Widget build(BuildContext context) {
    return Container(

      alignment: Alignment.topLeft,
      padding: const EdgeInsets.only(top: 10),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "hello".tr(),
            style: TextStyle(fontSize: Responsive.sp(14), color: Colors.white70),
          ),
          SizedBox(height: Responsive.h(4)),
          Text(
            username ??"User",
            style: TextStyle(fontSize: Responsive.sp(15), fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
