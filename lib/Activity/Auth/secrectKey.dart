// ignore_for_file: use_build_context_synchronously, file_names, unused_field

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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
    getPreferKey = await preferencesService.getUserInfo(key_secretKey);
    setState(() {});
  }

  Future<bool> _onWillPop() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          body: Container(
            width: Screen.width(context),
            height: Screen.height(context),
            margin: const EdgeInsets.all(5),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
              UIHelper.verticalSpaceMedium,
              UIHelper.verticalSpaceMedium,
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
              ]),
              UIHelper.verticalSpaceMedium,
              UIHelper.titleTextStyle('enter_your_SecretPin'.tr().toString(), c.text_color, 14, true, true),
              UIHelper.verticalSpaceMedium,
              VerificationView(fixedlength: 4, pinString: secretPin, secureText: true),
              if (!pinIsValid) UIHelper.verticalSpaceSmall,
              if (!pinIsValid) UIHelper.titleTextStyle('invalid_Pin'.tr().toString(), c.red_new, 12, true, true),
              UIHelper.verticalSpaceMedium,
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpView(isSignup: false)));
                },
                child: Container(
                  width: Screen.width(context),
                  margin: const EdgeInsets.only(right: 15),
                  alignment: Alignment.centerRight,
                  child: UIHelper.titleTextStyle('forgot_secret_Pin'.tr().toString(), c.primary_text_color2, 12, true, false),
                ),
              ),
              const Expanded(child: SizedBox()),
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
              // UIHelper.verticalSpaceMedium,
            ]),
          ),
        ),
      ),
    );
  }
}
