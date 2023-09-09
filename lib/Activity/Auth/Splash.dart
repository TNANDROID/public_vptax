// ignore_for_file: use_build_context_synchronously, file_names, unused_field

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:public_vptax/Activity/Auth/Home.dart';
import 'package:public_vptax/Activity/Auth/auth_option.dart';
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
  String selectedLang = "en";

  @override
  void initState() {
    super.initState();
    initialize();
  }

  // Future<void> initialize() async {
  //   selectedLang == "en" ? preferencesService.setUserInfo("lang", "en") : preferencesService.setUserInfo("lang", "ta");
  //   selectedLanguage = await selectedLang == "en" ? langItems[0][s.key_langCode] : langItems[1][s.key_langCode];
  //   setState(() {});
  // }

  Future<void> initialize() async {
    String getPreferMobile = await preferencesService.getUserInfo(key_mobile_number);
    if (await utils.isOnline()) {
      Future.delayed(
        const Duration(seconds: 2, milliseconds: 350),
        () {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => getPreferMobile.isNotEmpty ? Home() : AuthModeView(),
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
        },
      );
    } else {
      utils.showAlert(context, ContentType.fail, 'No Internet');
    }
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
            Text(
              'gov_tamilnadu'.tr().toString(),
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: c.text_color,
                fontStyle: FontStyle.normal,
                decorationStyle: TextDecorationStyle.wavy,
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Image.asset(
                imagepath.logo,
                fit: BoxFit.cover,
                height: 70,
                width: 70,
              ),
              Text(
                'appName'.tr().toString(),
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  color: c.text_color,
                  fontStyle: FontStyle.normal,
                  decorationStyle: TextDecorationStyle.wavy,
                ),
              ),
            ])
          ]),
        ),
      ),
    );
  }
}
