// ignore_for_file: use_build_context_synchronously, file_names, unused_field

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:public_vptax/Activity/Auth/auth_option.dart';
import 'package:public_vptax/Activity/Auth/secrectKey.dart';
import 'package:public_vptax/Layout/screen_size.dart';
import 'package:public_vptax/Layout/ui_helper.dart';
import 'package:public_vptax/Resources/ColorsValue.dart' as c;
import 'package:public_vptax/Resources/ImagePath.dart' as imagepath;
import 'package:public_vptax/Resources/StringsKey.dart';
import 'package:public_vptax/Services/Preferenceservices.dart';
import 'package:public_vptax/Services/locator.dart';
import 'package:public_vptax/Utils/ContentInfo.dart';
import 'package:public_vptax/Utils/utils.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  PreferenceService preferencesService = locator<PreferenceService>();
  Utils utils = Utils();
  FS fs = locator<FS>();
  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    String getPrefesecrectKey = await preferencesService.getUserInfo(key_secretKey);

    if (await preferencesService.getUserInfo("lang") != '') {
      preferencesService.selectedLanguage = await preferencesService.getUserInfo("lang");
    }

    if (getPrefesecrectKey.isNotEmpty) {
      await preferencesService.setUserInfo(key_isLogin, "yes");
    }
    ////********************  Need to Remove ********************************************////
    ////*******/ await preferencesService.setUserInfo(key_mobile_number, "9875235654"); //**////
    ////*******/ await preferencesService.setUserInfo(key_secretKey, "9999"); //**////
    // /*******/ await preferencesService.setUserInfo(key_name, "Test"); //**////
    // /*******/ await preferencesService.setUserInfo(key_email, "Test@gmail.com"); //**////
    ////*********************************************************************************////

    if (await utils.isOnline()) {
      if (getPrefesecrectKey.isNotEmpty) {
        await Utils().apiCalls(context);
      }

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => getPrefesecrectKey.isNotEmpty ? const SecretKeyView() : const AuthModeView(),
          transitionDuration: const Duration(seconds: 2),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0); // Start position
            const end = Offset.zero; // End position
            const curve = Curves.easeInOut; // Transition curve
            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        ),
      );
    } else {
      utils.showAlert(context, ContentType.fail, 'No Internet');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        body: Container(
          width: Screen.width(context),
          height: Screen.height(context),
          margin: const EdgeInsets.all(5),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
            //  ****************** App Name  ****************** //
            Image.asset(
              imagepath.tamilnadu_logo,
              height: 80,
              width: 80,
            ),
            UIHelper.verticalSpaceSmall,
            UIHelper.titleTextStyle('gov_tamilnadu'.tr().toString(), c.text_color, fs.h2, true, true),
            UIHelper.verticalSpaceSmall,
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Image.asset(
                imagepath.logo,
                fit: BoxFit.cover,
                height: 55,
                width: 50,
              ),
              UIHelper.horizontalSpaceSmall,
              UIHelper.titleTextStyle('appName'.tr().toString(), c.text_color, fs.h1, true, true),
            ])
          ]),
        ),
      ),
    );
  }
}
