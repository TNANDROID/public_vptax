import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:public_tax/Activity/Auth/Splash.dart';
import 'package:public_tax/Services/locator.dart';

Future<void> main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en', 'US'), Locale('ta', 'IN')],
      path: 'assets/translations',
      fallbackLocale: Locale('ta', 'IN'),
      startLocale: Locale('ta', 'IN'),
      saveLocale: true,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: Splash(),
    );
  }
}
