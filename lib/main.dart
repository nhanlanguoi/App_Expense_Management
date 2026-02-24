
import 'package:easy_localization/easy_localization.dart';
import 'package:expense_management/screens/home/widgets/catrgoryDetail.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'screens/home/Home.dart';
import 'package:expense_management/configs/routes/routes.dart';
import 'package:expense_management/configs/routes/routesname.dart';
import 'package:expense_management/data/hiveconfig.dart';
import 'package:expense_management/data/dataseeder.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await HiveConfig.init();
  await DataSeeder.seedusers();
  await DataSeeder.seedwallet();

  await DataSeeder.seedTransactions();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('vi', 'VN'), Locale('en', 'US')],
      path: 'lib/assets/translations',
      fallbackLocale: const Locale('vi', 'VN'),
      startLocale: const Locale('vi', 'VN'),
      useOnlyLangCode: true,
      child: const Main(),
    ),
  );
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      initialRoute: Routesname.auth,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}