// ignore_for_file: file_names, library_private_types_in_public_api, unrelated_type_equality_checks

import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:public_vptax/Activity/Auth/Login.dart';
import 'package:public_vptax/Activity/Tax_Collection/taxCollection_view.dart';
import 'package:public_vptax/Layout/customgradientbutton.dart';
import 'package:public_vptax/Layout/ui_helper.dart';
import '../../Model/startup_model.dart';
import '../../Resources/StringsKey.dart' as s;
import 'package:public_vptax/Resources/ColorsValue.dart' as c;
import 'package:public_vptax/Resources/ImagePath.dart' as imagepath;
import 'package:public_vptax/Utils/utils.dart';
import '../../Layout/screen_size.dart';
import '../../Services/Preferenceservices.dart';
import '../../Services/locator.dart';
import 'Home.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  late AnimationController _rightToLeftAnimController, _topAnimationController;
  late Animation<Offset> _rightToLeftAnimation, _topAnimation;

  Utils utils = Utils();
  PreferenceService preferencesService = locator<PreferenceService>();
  final LocalAuthentication auth = LocalAuthentication();

  String? selectedLanguage;

  List langItems = [
    {s.key_langCode: '1', s.key_language: 'English'},
    {s.key_langCode: '2', s.key_language: 'தமிழ்'},
  ];

  @override
  void initState() {
    super.initState();

    _rightToLeftAnimController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));

    _rightToLeftAnimation = Tween<Offset>(
        begin: const Offset(1.0, 0.0), end: const Offset(0.0, 0.0))
        .animate(CurvedAnimation(
        parent: _rightToLeftAnimController, curve: Curves.easeInOut));

    // Top-to-bottom slide animation
    _topAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _topAnimation = Tween<Offset>(
      begin: const Offset(0.0, -10.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _topAnimationController,
      curve: Curves.easeInOut,
    ));

    _topAnimationController.forward();
    _rightToLeftAnimController.forward();
    initialize();
  }

  Future<void> initialize() async {
    selectedLanguage = await preferencesService.getUserInfo("lang") == "en"
        ? langItems[0][s.key_langCode]
        : langItems[1][s.key_langCode];

    setState(() {});
  }
  Future<void> apiCalls() async {
    Utils().showProgress(context, 1);
    await StartUpViewModel().getOpenServiceList("District");
    await StartUpViewModel().getOpenServiceList("Block");
    await StartUpViewModel().getOpenServiceList("Village");
    Utils().hideProgress(context);
  }

  void handleClick(String value) async {
    switch (value) {
      case '2':
        setState(() {
          preferencesService.setUserInfo("lang", "ta");
          context.setLocale(const Locale('ta', 'IN'));
        });
        break;
      case '1':
        setState(() {
          preferencesService.setUserInfo("lang", "en");
          context.setLocale(const Locale('en', 'US'));
        });
        break;
    }
  }

  @override
  void dispose() {
    _rightToLeftAnimController.dispose();
    _topAnimationController.dispose();
    super.dispose();
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //  ****************** Choose Language Conatiner with fixed Height ****************** //

              Container(
                width: Screen.width(context),
                height: Screen.height(context) / 6,
                padding: const EdgeInsets.all(15),
                child: Align(
                  alignment: Alignment.topRight,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      elevation: 0,
                      isExpanded: false,
                      value: selectedLanguage,
                      icon: const Padding(
                          padding: EdgeInsets.all(15),
                          child: Icon(
                            Icons.arrow_downward_rounded,
                            size: 15,
                          )),
                      style: TextStyle(
                        color: c.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      items: langItems
                          .map((item) => DropdownMenuItem<String>(
                        value: item[s.key_langCode],
                        child: Text(item[s.key_language]),
                      ))
                          .toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedLanguage = newValue.toString();
                          handleClick(selectedLanguage!);
                        });
                      },
                    ),
                  ),
                ),
              ),

              //  ****************** App Name  ****************** //

              SlideTransition(
                position: _topAnimation,
                child: Column(children: [
                  Image.asset(
                    imagepath.logo,
                    fit: BoxFit.cover,
                    height: 100,
                    width: 100,
                  ),
                  Text(
                    'appName'.tr().toString(),
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                      color: c.text_color,
                      fontStyle: FontStyle.normal,
                      decorationStyle: TextDecorationStyle.wavy,
                    ),
                  ),
                ]),
              ),
              UIHelper.verticalSpaceMedium,

              //  ****************** Qucik Action Buttons  ****************** //

              SlideTransition(
                position: _rightToLeftAnimation,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        actionButton(
                            1, 'signIN'.tr().toString(), imagepath.login),
                        UIHelper.horizontalSpaceMedium,
                        actionButton(
                            2, 'quickPay'.tr().toString(), imagepath.pay),
                      ],
                    ),
                    UIHelper.verticalSpaceMedium,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'signupText'.tr().toString(),
                          style: TextStyle(
                            color: c.text_color,
                            fontSize: 16,
                          ),
                        ),
                        UIHelper.horizontalSpaceSmall,
                        InkWell(
                          onTap: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Home(isLogin: "islogin"))),
                            print("Sign in Tapped ")},
                          child: Text(
                            'signUP'.tr().toString(),
                            style: TextStyle(
                              color: c.sky_blue,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              //  ****************** Image Container ****************** //

              Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset(
                  imagepath.splash, // Replace with your image path
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //  ****************** Qucik Action Buttons Common Wdget  ****************** //

  Widget actionButton(int flag, String btnText, String imgPath) {
    return CustomGradientButton(
      topleft: 20,
      topright: 20,
      btmleft: 20,
      btmright: 20,
      width: Screen.width(context) / 2.5,
      height: 45,
      child: TextButton.icon(
        onPressed: () async {
          if (flag == 1) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Login(),
            ));
          } else if (flag == 2) {
            await apiCalls();
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => TaxCollectionView(),
            ));
          }
        },
        style: ButtonStyle(
          side: MaterialStateProperty.all(BorderSide.none),
        ),
        icon: Image.asset(
          imgPath,
          width: 30,
          height: 30,
        ),
        label: Center(
          child: Text(
            btnText,
            style: TextStyle(
              color: c.white,
              fontWeight: FontWeight.bold,
              decorationStyle: TextDecorationStyle.wavy,
              fontSize: btnText.length > 10 ? 10 : 12,
            ),
          ),
        ),
      ),
    );
  }
}
