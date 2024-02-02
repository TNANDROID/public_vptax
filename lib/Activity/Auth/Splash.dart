// ignore_for_file: use_build_context_synchronously, file_names, unused_field

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:public_vptax/Activity/Auth/auth_option.dart';
import 'package:public_vptax/Activity/Auth/secrectKey.dart';
import 'package:public_vptax/Layout/screen_size.dart';
import 'package:public_vptax/Layout/ui_helper.dart';
import 'package:public_vptax/Resources/ColorsValue.dart' as c;
import 'package:public_vptax/Resources/StringsKey.dart' as s;
import 'package:public_vptax/Resources/ImagePath.dart' as imagepath;
import 'package:public_vptax/Resources/StringsKey.dart';
import 'package:public_vptax/Services/Preferenceservices.dart';
import 'package:public_vptax/Services/locator.dart';
import 'package:public_vptax/Utils/ContentInfo.dart';
import 'package:public_vptax/Utils/utils.dart';

import '../../Services/Apiservices.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  PreferenceService preferencesService = locator<PreferenceService>();
  Utils utils = Utils();
  FS fs = locator<FS>();
  String getPrefesecrectKey="";
  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    await preferencesService.setString('userPassKey', '45af1c702e5c46acb5f4192cbeaba27c');
    getPrefesecrectKey = await preferencesService.getString(key_secretKey);
/* preferencesService.selectedLanguage = "en";
    preferencesService.setString("lang", "en");
    context.setLocale(Locale('en', 'US'));*/
    if (await preferencesService.getString("lang") != '') {
      preferencesService.selectedLanguage = await preferencesService.getString("lang");
    }

    if (getPrefesecrectKey.isNotEmpty) {
      await preferencesService.setString(key_isLogin, "yes");
    }
    ////********************  Need to Remove ********************************************////
    ////*******/ await preferencesService.setString(key_mobile_number, "9875235654"); //**////
    ////*******/ await preferencesService.setString(key_secretKey, "9999"); //**////
    // /*******/ await preferencesService.setString(key_name, "Test"); //**////
    // /*******/ await preferencesService.setString(key_email, "Test@gmail.com"); //**////
    ////*********************************************************************************////
    if (await utils.isOnline()) {
      gotoLogin();

      // checkVersion(context);
    } else {
  utils.showAlert(context, ContentType.fail, 'No Internet');
  }
    // gotoLogin();
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
            UIHelper.verticalSpaceMedium,
            HeartbeatProgressIndicator(
                duration: Duration(milliseconds: 250),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Image.asset(
                    imagepath.logo,
                    fit: BoxFit.cover,
                    height: 30,
                    width: 26,
                  ),
                  UIHelper.horizontalSpaceSmall,
                  UIHelper.titleTextStyle('appName'.tr().toString(), c.text_color, fs.h4, true, true),
                ]))
          ]),
        ),
      ),
    );
  }

  Future<void> gotoLogin() async {
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
  Future<dynamic> checkVersion(BuildContext context) async {
    try {
      var request = {
        s.key_service_id: s.service_key_version_check,
        s.key_app_code: s.service_key_appcode,
      };
      var decodedData = await ApiServices().loginServiceFunction("checkVersion", request);
      if (decodedData != null && decodedData != "" && decodedData[s.key_status]==s.key_success) {
        var data=decodedData[s.key_data];
        String version = data['version'];
        version = containsNDots(version);
        // print("app__api_version>>" + api_version.toString());

        String app_version = await utils.getVersion();
        // String v1 = '1.2.3', v2 = '1.2.11';
        int v1Number = getExtendedVersionNumber(version); // return 102003
        int v2Number = getExtendedVersionNumber(app_version); // return 102011
        // print(v1Number >= v2Number);
        // print("app_version>>" + app_version.toString());
        print("v1Number>>" + v1Number.toString());
        print("v2Number>>" + v2Number.toString());

        if (data[s.key_app_code] == "OG" && (v1Number > v2Number)) {
          await preferencesService.setString(s.key_apk, data['apk_path'].toString());
          utils.showAlert(context, ContentType.fail, 'update_msg'.tr().toString(),btnText: 'update'.tr().toString(),btnmsg:"apk" ,btnCount: "1");
        } else {
          gotoLogin();
        }
      } else {
        // If the server did not return a 201 CREATED response,
        // then throw an exception.
        throw Exception('Failed');
      }
    } catch (e) {
      utils.showToast(context, 'Something Went Wrong',"W");
    } finally {
      setState(() {});
    }
  }
  int getExtendedVersionNumber(String version) {
    List versionCells = version.split('.');
    versionCells = versionCells.map((i) => int.parse(i)).toList();
    return versionCells[0] * 100000 + versionCells[1] * 1000 + versionCells[2];
  }

  String containsNDots(String input) {
    int charCount = 0;

    for (int i = 0; i < input.length; i++) {
      input[i] == '.' ? charCount++ : null;
    }
    charCount == 0
        ? input = "$input.0.0"
        : charCount == 1
        ? input = "$input.0"
        : null;
    return input;
  }
}
