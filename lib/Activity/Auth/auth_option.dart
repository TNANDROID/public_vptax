// ignore_for_file: use_build_context_synchronously, file_names, unused_field

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:public_vptax/Activity/Auth/signin_signup.dart';
import 'package:public_vptax/Activity/Tax_Collection/taxCollection_view_request_screen.dart';
import 'package:public_vptax/Layout/screen_size.dart';
import 'package:public_vptax/Layout/ui_helper.dart';
import 'package:public_vptax/Resources/ColorsValue.dart' as c;
import 'package:public_vptax/Resources/ImagePath.dart' as imagepath;
import 'package:public_vptax/Services/Preferenceservices.dart';
import 'package:public_vptax/Services/locator.dart';
import 'package:public_vptax/Utils/ContentInfo.dart';
import 'package:public_vptax/Utils/utils.dart';

class AuthModeView extends StatefulWidget {
  const AuthModeView({super.key});

  @override
  _AuthModeViewState createState() => _AuthModeViewState();
}

class _AuthModeViewState extends State<AuthModeView> with TickerProviderStateMixin {
  late AnimationController _rightToLeftAnimController, _topAnimationController;
  late Animation<Offset> _rightToLeftAnimation, _topAnimation;
  Utils utils = Utils();
  PreferenceService preferencesService = locator<PreferenceService>();
  FS fs = locator<FS>();
  String langText = 'தமிழ்';


  @override
  void initState() {
    super.initState();
    if (preferencesService.selectedLanguage == "en") {
      langText = 'English';
    } else {
      langText = 'தமிழ்';
    }
    _rightToLeftAnimController = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _rightToLeftAnimation = Tween<Offset>(begin: const Offset(1.0, 0.0), end: const Offset(0.0, 0.0)).animate(CurvedAnimation(parent: _rightToLeftAnimController, curve: Curves.easeInOut));
    _rightToLeftAnimController.forward();

    // Top-to-bottom slide animation
    _topAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _topAnimation = Tween<Offset>(
      begin: const Offset(0.0, -10.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _topAnimationController,
      curve: Curves.easeInOut,
    ));

    _topAnimationController.forward();
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
          margin: EdgeInsets.only(top: 15),
          width: Screen.width(context),
          height: Screen.height(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              PopupMenuButton<String>(
                color: c.white,
                child: Row(
                  children: [
                    Container(padding: EdgeInsets.only(left: 15), child: UIHelper.titleTextStyle(langText, c.text_color, fs.h3, true, false)),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.arrow_downward_rounded,
                        size: 15,
                        color: c.text_color,
                      ),
                    ),
                  ],
                ),
                onSelected: handleClick,
                itemBuilder: (BuildContext context) {
                  return {'தமிழ்', 'English'}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: UIHelper.titleTextStyle(choice, c.black, fs.h3, false, false),
                    );
                  }).toList();
                },
              ),
              //  UIHelper.verticalSpaceMedium,
              Expanded(
                child: Column(
                  children: [
                    Image.asset(imagepath.tamilnadu_logo, height: 80, width: 80),
                    UIHelper.verticalSpaceSmall,
                    UIHelper.titleTextStyle('rural_development'.tr().toString(), c.text_color, fs.h2, true, true),
                    UIHelper.verticalSpaceTiny,
                    UIHelper.titleTextStyle('gov_tamilnadu'.tr().toString(), c.text_color, fs.h2, true, true),
                    UIHelper.verticalSpaceLarge,
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Image.asset(imagepath.logo, fit: BoxFit.cover, height: 55, width: 50),
                      UIHelper.horizontalSpaceTiny,
                      UIHelper.titleTextStyle('appName'.tr().toString(), c.text_color, fs.h1, true, true),
                    ]),
                    UIHelper.verticalSpaceMedium,
                    SlideTransition(
                      position: _rightToLeftAnimation,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              actionButton(1, 'signIN'.tr().toString(), imagepath.login),
                              UIHelper.horizontalSpaceMedium,
                              actionButton(2, 'quickPay'.tr().toString(), imagepath.quick_pay1),
                            ],
                          ),
                          UIHelper.verticalSpaceMedium,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              UIHelper.titleTextStyle('signupText'.tr().toString(), c.text_color, fs.h2, true, true),
                              UIHelper.horizontalSpaceSmall,
                              InkWell(
                                onTap: () => {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpView(isSignup: true))),
                                },
                                child: UIHelper.titleTextStyle('signUP'.tr().toString(), c.sky_blue, fs.h2, true, true),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                height: MediaQuery.sizeOf(context).height / 2.8,
                width: Screen.width(context),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset(
                    width: Screen.width(context),
                    imagepath.taxes, // Replace with your image path
                    fit: BoxFit.fitWidth,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

//  ****************** Qucik Action Buttons Common Wdget  ****************** //

  Widget actionButton(int flag, String btnText, String imgPath) {
    return GestureDetector(
        onTap: () async {
          if (flag == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpView(isSignup: false)));
          } else if (flag == 2) {
            if (await utils.isOnline()) {
              await Utils().apiCalls(context);
              preferencesService.taxTypeList.isNotEmpty
                  ? Navigator.of(context).push(MaterialPageRoute(builder: (context) => TaxCollectionView(flag: "2")))
                  : utils.showAlert(context, ContentType.fail, "failed".tr().toString());
            } else {
              utils.showAlert(
                context,
                ContentType.fail,
                "noInternet".tr().toString(),
              );
            }
          }
        },
        child: Container(
            decoration: UIHelper.roundedBorderWithColorWithShadow(15, c.colorPrimary, c.colorPrimaryDark),
            padding: EdgeInsets.all(5),
            width: Screen.width(context) / 2.3,
            child: Row(
              children: [
                Image.asset(
                  imgPath,
                  width: 30,
                  height: 30,
                ),
                UIHelper.horizontalSpaceTiny,
                Expanded(child: UIHelper.titleTextStyle(btnText, c.white, btnText.length > 10 ? fs.h6 : fs.h5, true, false))
              ],
            )));
  }

  void handleClick(String value) {
    if (value != langText) {
      switch (value) {
        case 'தமிழ்':
          setState(() {
            langText = value;
            preferencesService.selectedLanguage = "ta";
            preferencesService.setString("lang", "ta");
            context.setLocale(Locale('ta', 'IN'));
          });
          break;
        case 'English':
          setState(() {
            langText = value;
            preferencesService.selectedLanguage = "en";
            preferencesService.setString("lang", "en");
            context.setLocale(Locale('en', 'US'));
          });
          break;
      }
    }
  }

}
