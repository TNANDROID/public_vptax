// ignore_for_file: use_build_context_synchronously, file_names, unused_field

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:public_vptax/Activity/Auth/Login.dart';
import 'package:public_vptax/Layout/customgradientbutton.dart';
import 'package:public_vptax/Layout/ui_helper.dart';
import 'package:public_vptax/Resources/ColorsValue.dart' as c;
import 'package:public_vptax/Resources/ImagePath.dart' as imagepath;
import 'package:public_vptax/Utils/utils.dart';

import '../../Layout/screen_size.dart';
import '../../Resources/StringsKey.dart' as s;
import '../../Resources/StringsKey.dart';
import '../../Services/Preferenceservices.dart';
import '../../Services/locator.dart';
import '../../Utils/ContentInfo.dart';
import '../Tax_Collection/taxCollection_view_request_screen.dart';
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

  String? selectedLanguage;

  List langItems = [
    {s.key_langCode: '1', s.key_language: 'English'},
    {s.key_langCode: '2', s.key_language: 'தமிழ்'},
  ];

  @override
  void initState() {
    super.initState();

    // *************************** Future Functionality  *************************** //

    // _rightToLeftAnimController =
    //     AnimationController(vsync: this, duration: const Duration(seconds: 2));

    // _rightToLeftAnimation = Tween<Offset>(
    //         begin: const Offset(1.0, 0.0), end: const Offset(0.0, 0.0))
    //     .animate(CurvedAnimation(
    //         parent: _rightToLeftAnimController, curve: Curves.easeInOut));

    // _rightToLeftAnimController.forward();

    // initialize();

    // *************************** Future Functionality  *************************** //

    // Top-to-bottom slide animation
    /*_topAnimationController = AnimationController(
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

    _topAnimationController.forward();*/
    preferencesService.setUserInfo(key_isLogin,'no');
    Future.delayed(
      const Duration(seconds: 2, milliseconds: 350),
      () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => Home(isLogin: false),
            transitionDuration: const Duration(seconds: 2),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              // Slide transition
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
  }

  // *************************** Future Functionality  *************************** //

  // Future<void> initialize() async {
  //   preferencesService.getUserInfo("lang") == "en"
  //       ? preferencesService.setUserInfo("lang", "en")
  //       : preferencesService.setUserInfo("lang", "ta");
  //   selectedLanguage = await preferencesService.getUserInfo("lang") == "en"
  //       ? langItems[0][s.key_langCode]
  //       : langItems[1][s.key_langCode];

  //   setState(() {});
  // }

  // void handleClick(String value) async {
  //   switch (value) {
  //     case '2':
  //       setState(() {
  //         preferencesService.setUserInfo("lang", "ta");
  //         context.setLocale(const Locale('ta', 'IN'));
  //       });
  //       break;
  //     case '1':
  //       setState(() {
  //         preferencesService.setUserInfo("lang", "en");
  //         context.setLocale(const Locale('en', 'US'));
  //       });
  //       break;
  //   }
  // }

  // *************************** Future Functionality  *************************** //

/*
  @override
  void dispose() {
    // _rightToLeftAnimController.dispose();
    _topAnimationController.dispose();
    super.dispose();
  }
*/

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

              Visibility(
                visible: false,
                child: Container(
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
                            // handleClick(selectedLanguage!);
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),

              //  ****************** App Name  ****************** //

             /* SlideTransition(
                position: _topAnimation,
                child: */
                Column(children: [
                  UIHelper.verticalSpaceSmall,
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
                ]),
              // ),
              UIHelper.verticalSpaceSmall,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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

              // *************************** Future Functionality  *************************** //

              //  ****************** Qucik Action Buttons  ****************** //

              // SlideTransition(
              //   position: _rightToLeftAnimation,
              //   child: Column(
              //     children: [
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           actionButton(1, 'signIN'.tr().toString(), imagepath.login),
              //           UIHelper.horizontalSpaceMedium,
              //           actionButton(2, 'quickPay'.tr().toString(), imagepath.quick_pay1),
              //         ],
              //       ),
              //       UIHelper.verticalSpaceMedium,
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           Text(
              //             'signupText'.tr().toString(),
              //             style: TextStyle(
              //               color: c.text_color,
              //               fontSize: 16,
              //             ),
              //           ),
              //           UIHelper.horizontalSpaceSmall,
              //           InkWell(
              //             onTap: () => {
              //               Navigator.push(
              //                   context,
              //                   MaterialPageRoute(
              //                       builder: (context) => Home(
              //                             isLogin: "islogin",
              //                           ))),
              //             },
              //             child: Text(
              //               'signUP'.tr().toString(),
              //               style: TextStyle(
              //                 color: c.sky_blue,
              //                 fontSize: 16,
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),

              // *************************** Future Functionality  *************************** //

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

// *************************** Future Functionality  *************************** //

  Widget actionButton(int flag, String btnText, String imgPath) {
    return CustomGradientButton(
      topleft: 20,
      topright: 20,
      btmleft: 20,
      btmright: 20,
      elevation: 3,
      width: Screen.width(context) / 2.5,
      height: 45,
      child: TextButton.icon(
        onPressed: () async {
          if (flag == 1) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Login(),
            ));
          } else if (flag == 2) {
            if (await utils.isOnline()) {
              await Utils().apiCalls(context);
              preferencesService.taxTypeList.isNotEmpty
                  ? Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => TaxCollectionView(flag: "2",),
                    ))
                  : utils.showAlert(
                      context,
                      ContentType.fail,
                      "fail".tr().toString(),
                    );
            } else {
              utils.showAlert(
                context,
                ContentType.fail,
                "noInternet".tr().toString(),
              );
            }
/* utils.showAlert(context, ContentType.warning, "message",
                flag: 'openAppSetting');*/
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

  // *************************** Future Functionality  *************************** //
}
