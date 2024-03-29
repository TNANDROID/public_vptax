// ignore_for_file: use_build_context_synchronously, file_names, unused_field

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:public_vptax/Activity/Auth/Home.dart';
import 'package:public_vptax/Activity/Auth/signin_signup.dart';
import 'package:public_vptax/Layout/number_keyboard.dart';
import 'package:public_vptax/Layout/screen_size.dart';
import 'package:public_vptax/Layout/ui_helper.dart';
import 'package:public_vptax/Layout/verification.dart';
import 'package:public_vptax/Resources/ColorsValue.dart' as c;
import 'package:public_vptax/Resources/ImagePath.dart' as imagepath;
import 'package:public_vptax/Resources/StringsKey.dart';
import 'package:public_vptax/Services/Preferenceservices.dart';
import 'package:public_vptax/Services/locator.dart';
import 'package:public_vptax/Utils/utils.dart';

class SecretKeyView extends StatefulWidget {
  const SecretKeyView({super.key});

  @override
  _SecretKeyViewState createState() => _SecretKeyViewState();
}

class _SecretKeyViewState extends State<SecretKeyView> with TickerProviderStateMixin {
  PreferenceService preferencesService = locator<PreferenceService>();
  FS fs = locator<FS>();
  Utils utils = Utils();
  String getPreferKey = "";
  String secretPin = "";
  bool pinIsValid = true;
  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    getPreferKey = await preferencesService.getString(key_secretKey);
    setState(() {});
  }

  Future<bool> _onWillPop() async {
    print("cli");
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      exit(0);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Container(
          width: Screen.width(context),
          height: Screen.height(context),
          // margin: const EdgeInsets.only(top: 15),
          child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                UIHelper.verticalSpaceMedium,
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Image.asset(imagepath.logo, fit: BoxFit.cover, height: 55, width: 50),
                  UIHelper.horizontalSpaceSmall,
                  UIHelper.titleTextStyle('appName'.tr().toString(), c.text_color, fs.h1, true, true),
                ]),
                UIHelper.verticalSpaceSmall,
                UIHelper.titleTextStyle('enter_your_SecretPin'.tr().toString(), c.text_color, fs.h3, true, true),
                UIHelper.verticalSpaceSmall,
                VerificationView(fixedlength: 4, pinString: secretPin, secureText: true),
                if (!pinIsValid) UIHelper.verticalSpaceSmall,
                if (!pinIsValid) UIHelper.titleTextStyle('invalid_Pin'.tr().toString(), c.red_new, fs.h4, true, true),
                UIHelper.verticalSpaceMedium,
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpView(isSignup: false)));
                  },
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: EdgeInsets.only(
                        bottom: 2, // Space between underline and text
                      ),
                      margin: EdgeInsets.only(
                        right: 10, // Space between underline and text
                      ),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                        color: c.primary_text_color2,
                        width: 1.0, // Underline thickness
                      ))),
                      child: UIHelper.titleTextStyle('forgot_secret_Pin'.tr().toString(), c.primary_text_color2, fs.h4, true, true),
                    ),
                  ),
                )
              ],
            )),
            CustomNumberBoard(
              initialValue: secretPin,
              length: 4,
              onChanged: (value) {
                secretPin = value;
                setState(() {});
              },
              onCompleted: () {
                if (getPreferKey == secretPin) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const Home()));
                } else {
                  pinIsValid = false;
                  setState(() {});
                }
              },
            ),
          ]),
        ),
      ),
    );
  }
}
