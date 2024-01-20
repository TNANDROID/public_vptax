// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_key_in_widget_constructors, must_be_immutable

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:public_vptax/Activity/Auth/Splash.dart';
import 'package:public_vptax/Layout/screen_size.dart';
import 'package:public_vptax/Services/locator.dart';
import 'package:public_vptax/Utils/utils.dart';
import 'package:public_vptax/Resources/ImagePath.dart' as imagePath;
import 'package:public_vptax/Resources/ColorsValue.dart' as c;



Future<void> main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await EasyLocalization.ensureInitialized();
  EasyLocalization.logger.enableBuildModes = [];

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

class MyApp extends StatefulWidget {

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Utils utils = Utils();
  bool jailbroken = false;
  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    try {
      jailbroken = await FlutterJailbreakDetection.jailbroken;
    } on PlatformException {
      jailbroken = true;
    }
    // print("Rooted>>"+jailbroken.toString());
  }
  @override
  Widget build(BuildContext context) {
    utils.getResponsiveFontSize(context, Screen.width(context));
    if (jailbroken) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Container(
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  imagePath.warning_png,
                  width: 80,
                  height: 80,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Your Device is Rooted!",
                  style: TextStyle(
                      fontSize: 18,
                      color: c.subscription_type_red_color,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "This app cannot run on rooted devices.",
                  style: TextStyle(fontSize: 16, color: c.text_color),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                    onTap: () {
                      // Exit the app (this may not work on all devices)
                      if (Platform.isIOS) {
                        try {
                          exit(0);
                        } catch (e) {
                          SystemNavigator
                              .pop(); // for IOS, not true this, you can make comment this :)
                        }
                      } else {
                        try {
                          SystemNavigator.pop(); // sometimes it cant exit app
                        } catch (e) {
                          exit(0); // so i am giving crash to app ... sad :(
                        }
                      }
                    },
                    child: Container(
                        padding: EdgeInsets.fromLTRB(40, 15, 40, 15),
                        decoration: BoxDecoration(
                            color: c.subscription_type_red_color,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0.0, 1.0), //(x,y)
                                blurRadius: 5.0,
                              ),
                            ]),
                        child: Text(
                          "Ok",
                          style: TextStyle(
                              fontSize: 18,
                              color: c.white,
                              fontWeight: FontWeight.bold),
                        ))),
              ],
            ),
          ),
        ),
      );
    } else {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        home: Splash(),
      );
    }
  }
}
