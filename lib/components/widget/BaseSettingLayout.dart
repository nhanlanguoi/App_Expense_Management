import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../buttons/custombutton.dart';

class BaseSettingLayout extends StatelessWidget {
  final String title;
  final Widget body;
  final VoidCallback onSave;

  const BaseSettingLayout({
    super.key,
    required this.title,
    required this.body,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'BeVietnamPro',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: body,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: custombutton(
                onPressed: onSave,
                label: "settings.save_change".tr(),
                backgroundColor: Colors.blueAccent,
                textColor: Colors.white,
                height: 50,
                width: double.infinity,
                borderRadius: 25,
              ),
            )
          ],
        ),
      ),
    );
  }
}