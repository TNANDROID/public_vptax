// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_key_in_widget_constructors, must_be_immutable

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:public_vptax/Activity/Auth/Splash.dart';
import 'package:public_vptax/Layout/screen_size.dart';
import 'package:public_vptax/Services/locator.dart';
import 'package:public_vptax/Utils/utils.dart';
import 'Services/KeyStorage.dart';

Future<void> main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await EasyLocalization.ensureInitialized();
  final storageUtil = SecureStorageUtil();
  // Storing data
  await storageUtil.write('userPassKey', '45af1c702e5c46acb5f4192cbeaba27c');
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
  Utils utils = Utils();

  @override
  Widget build(BuildContext context) {
    utils.getResponsiveFontSize(context, Screen.width(context));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: Splash(),
    );
  }
}
