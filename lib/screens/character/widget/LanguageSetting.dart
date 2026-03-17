import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../components/widget/BaseSettingLayout.dart';
import 'package:expense_management/core/utils/responsive.dart';

class LanguageSettingScreen extends StatefulWidget {
  const LanguageSettingScreen({super.key});

  @override
  State<LanguageSettingScreen> createState() => _LanguageSettingScreenState();
}

class _LanguageSettingScreenState extends State<LanguageSettingScreen> {
  late String selectedLang;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    selectedLang = context.locale.languageCode;
  }

  @override
  Widget build(BuildContext context) {
    return BaseSettingLayout(
      title: "settings.lang_title".tr(),
      onSave: () {
        if (selectedLang == 'vi') {
          context.setLocale(const Locale('vi', 'VN'));
        } else {
          context.setLocale(const Locale('en', 'US'));
        }

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("settings.lang_saved".tr())));
        Navigator.pop(context);
      },
      body: Column(
        children: [
          LangOption('vi', 'settings.vietnamese'.tr(), '🇻🇳'),
          SizedBox(height: Responsive.h(15)),
          LangOption('en', 'settings.english'.tr(), '🇬🇧'),
        ],
      ),
    );
  }
  Widget LangOption(String code, String name, String flag) {
    bool isSelected = selectedLang == code;
    return GestureDetector(
      onTap: () => setState(() => selectedLang = code),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Responsive.r(16)),
        ),
        child: Row(
          children: [
            Text(flag, style: TextStyle(fontSize: Responsive.sp(24))),
            SizedBox(width: Responsive.w(15)),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: Responsive.sp(16),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontFamily: 'BeVietnamPro',
                ),
              ),
            ),
            if (isSelected) const Icon(Icons.check_circle, color: Colors.blueAccent),
          ],
        ),
      ),
    );
  }
}