import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../components/widget/BaseSettingLayout.dart';

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
          const SizedBox(height: 15),
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
          color: isSelected ? Colors.blueAccent.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.blueAccent : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 16,
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