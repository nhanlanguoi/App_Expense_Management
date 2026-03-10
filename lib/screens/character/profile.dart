import 'package:easy_localization/easy_localization.dart';
import 'package:expense_management/configs/theme/color.dart';
import 'package:expense_management/configs/theme/textstyles.dart';
import 'package:expense_management/screens/character/widget/LanguageSetting.dart';
import 'package:expense_management/screens/character/widget/BalanceSetting.dart';
import 'package:flutter/material.dart';
import '../../components/buttons/custombutton.dart';
import '../../components/buttons/settingiteam.dart';
import '../../data/service/authservice.dart';


class Character extends StatefulWidget {
  const Character({super.key});

  @override
  State<Character> createState() => _CharacterState();
}

class _CharacterState extends State<Character> {
  @override
  Widget build(BuildContext context) {
    final currentUser = AuthService().currentUser;

    return Scaffold(
      backgroundColor: AppColors.floor_background,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 10 ,left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Cài đặt".tr(),
                      style: TextStyles.h1.copyWith(color: Colors.black)
                    ),
                    const SizedBox(height: 30),
                    Container(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: CircleAvatar(
                              radius: 25,
                              backgroundColor: AppColors.floor_background,
                              child: const Icon(Icons.person, size: 30, color: Colors.blueAccent),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "profile.anonymous_user".tr(),
                                  style: TextStyles.nameuser.copyWith(color: Colors.black)
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  currentUser?.email ?? "profile.no_email".tr(),
                                  style: TextStyles.emailuser.copyWith(color: Colors.black)
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Divider(
            thickness: 1.5,
            indent: 20,
            endIndent: 20,
            color: Colors.grey.shade300,
          ),
          SizedBox(height: 10,),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  "profile.general_settings".tr(),
                  style: TextStyles.h2.copyWith(color: Colors.black)
                ),
                const SizedBox(height: 15),

                SettingItem(
                  icon: Icons.language,
                  title: "profile.language".tr(),
                  iconColor: Colors.blueAccent,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const LanguageSettingScreen()));
                  },
                ),

                SettingItem(
                  icon: Icons.account_balance_wallet,
                  title: "profile.balance_setup".tr(),
                  iconColor: Colors.blueAccent,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const BalanceSettingScreen()));
                  },
                ),

                custombutton(
                  label: "profile.logout".tr(),
                  backgroundColor: Colors.redAccent,
                  textColor: Colors.white,
                  height: 45,
                  width: 160,
                  borderRadius: 25,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}