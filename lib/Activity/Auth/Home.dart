// ignore_for_file: non_constant_identifier_names, sort_child_properties_last, prefer_const_constructors, use_build_context_synchronously

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:public_vptax/Activity/About_Village/Village_development_works.dart';
import 'package:public_vptax/Activity/About_Village/know_your_village.dart';
import 'package:public_vptax/Activity/Auth/Splash.dart';
import 'package:public_vptax/Activity/Tax_Collection/AllYourTaxDetails.dart';
import 'package:public_vptax/Activity/Tax_Collection/taxCollection_view_request_screen.dart';
import 'package:public_vptax/Activity/Transaction/CheckTransaction.dart';
import 'package:public_vptax/Activity/Transaction/View_receipt.dart';
import 'package:public_vptax/Layout/screen_size.dart';
import 'package:public_vptax/Layout/ui_helper.dart';
import 'package:public_vptax/Model/startup_model.dart';
import 'package:public_vptax/Resources/ColorsValue.dart' as c;
import 'package:public_vptax/Resources/ImagePath.dart' as imagePath;
import 'package:public_vptax/Resources/StringsKey.dart';
import 'package:public_vptax/Services/Preferenceservices.dart';
import 'package:public_vptax/Services/locator.dart';
import 'package:public_vptax/Utils/utils.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PreferenceService preferencesService = locator<PreferenceService>();
  StartUpViewModel model = StartUpViewModel();
  Utils utils = Utils();
  List taxTypeList = [];
  List servicesList = [
    {'service_id': 0, 'service_name': 'your_tax_details', 'img_path': imagePath.due4},
    {'service_id': 2, 'service_name': 'quickPay', 'img_path': imagePath.quick_pay1},
    {'service_id': 3, 'service_name': 'payment_transaction_history', 'img_path': imagePath.transaction_history},
    {'service_id': 4, 'service_name': 'view_receipt_details', 'img_path': imagePath.download_receipt},
    /* {'service_id': 5, 'service_name': 'know_about_your_village', 'img_path': imagePath.village},
    {'service_id': 6, 'service_name': 'village_development_works', 'img_path': imagePath.village_development}, */
  ];
  int selected_index = -1;
  String langText = 'தமிழ்';
  String selectedLang = "";
  String userName = "";

// ***** initState ***********
  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    selectedLang = await preferencesService.getUserInfo("lang");
    userName = await preferencesService.getUserInfo(key_name);
    await Utils().apiCalls(context);
    taxTypeList = preferencesService.taxTypeList;

    if (selectedLang != "" && selectedLang == "en") {
      context.setLocale(Locale('en', 'US'));
      langText = 'English';
    } else {
      preferencesService.setUserInfo("lang", "ta");
      context.setLocale(Locale('ta', 'IN'));
      langText = 'தமிழ்';
    }
    setState(() {});
  }

// ********** Language Selection Function ***********\\
  void handleClick(String value) {
    switch (value) {
      case 'தமிழ்':
        setState(() {
          langText = value;
          selectedLang = "ta";
          preferencesService.setUserInfo("lang", "ta");
          context.setLocale(Locale('ta', 'IN'));
        });
        break;
      case 'English':
        setState(() {
          langText = value;
          selectedLang = "en";
          preferencesService.setUserInfo("lang", "en");
          context.setLocale(Locale('en', 'US'));
        });
        break;
    }
  }

// ********** App Exit and Logout Widget ***********\\
  Future<bool> showExitPopup({isLogout = false}) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: UIHelper.titleTextStyle(isLogout ? 'logout'.tr().toString() : 'exit_app'.tr().toString(), c.black, 14, false, false),
            content: UIHelper.titleTextStyle(isLogout ? 'confirm_logout'.tr().toString() : 'do_you_want_to_exit_an_app'.tr().toString(), c.black, 13, false, false),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                //return false when click on "NO"
                child: Text(
                  'no'.tr().toString(),
                  style: TextStyle(fontSize: 12),
                ),
              ),
              ElevatedButton(
                onPressed: isLogout
                    ? () {
                        //preferencesService.cleanAllPreferences();
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Splash()), (route) => false);
                      }
                    : () {
                        if (Platform.isAndroid) {
                          SystemNavigator.pop();
                        } else if (Platform.isIOS) {
                          exit(0);
                        }
                      },
                child: Text(
                  'yes'.tr().toString(),
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ) ??
        false; //if showDialouge had returned null, then return false
  }

// ********** Main Build Widget ***********\\
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: showExitPopup,
        child: Scaffold(
          backgroundColor: c.white,
          appBar: PreferredSize(
            preferredSize: AppBar().preferredSize,
            child: Container(
                padding: EdgeInsets.only(top: 20),
                height: 70,
                decoration: UIHelper.GradientContainer(0, 0, 30, 30, [c.colorAccentlight, c.colorPrimaryDark]),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      left: 0,
                      child: PopupMenuButton<String>(
                        color: c.white,
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 15),
                              child: Text(
                                langText,
                                style: TextStyle(
                                  color: c.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.arrow_downward_rounded,
                                size: 15,
                                color: c.white,
                              ),
                            ),
                          ],
                        ),
                        onSelected: handleClick,
                        itemBuilder: (BuildContext context) {
                          return {'தமிழ்', 'English'}.map((String choice) {
                            return PopupMenuItem<String>(
                              value: choice,
                              child: Text(choice),
                            );
                          }).toList();
                        },
                      ),
                    ),
                    Positioned(
                      child: Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Text(
                          'home'.tr().toString(),
                          style: TextStyle(
                            fontSize: 15,
                            color: c.white,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 15,
                      child: Visibility(
                        visible: true,
                        child: InkWell(
                          onTap: () {
                            showExitPopup(isLogout: true);
                          },
                          child: Image.asset(
                            imagePath.logout,
                            color: c.white,
                            fit: BoxFit.contain,
                            height: 25,
                            width: 25,
                          ),
                        ),
                      ),
                    )
                  ],
                )),
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //  Text()
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Container(
                    margin: EdgeInsets.all(20),
                    child: Image.asset(
                      imagePath.tamilnadu_logo,
                      height: MediaQuery.of(context).size.height / 10,
                    ),
                  ),
                  Column(
                    children: [
                      /* UIHelper.titleTextStyle(userName, c.text_color, 14, true, true),
                      UIHelper.verticalSpaceTiny, */
                      Container(
                        width: Screen.width(context) / 1.6,
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        decoration: UIHelper.GradientContainer(20, 0, 20, 0, [c.colorAccentlight, c.colorPrimaryDark]),
                        child: Text(
                          textAlign: TextAlign.center,
                          userName,
                          style: TextStyle(color: c.white, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  )
                ]),

                Container(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'services'.tr().toString(),
                    style: TextStyle(color: c.grey_8, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: AnimationLimiter(
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      children: List.generate(
                        servicesList.length,
                        (int index) {
                          return AnimationConfiguration.staggeredGrid(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            columnCount: 2,
                            child: ScaleAnimation(
                              child: FadeInAnimation(
                                child: InkWell(
                                  onTap: () async {
                                    selected_index = servicesList[index][key_service_id];
                                    if (selected_index == 0) {
                                      Navigator.push(context, MaterialPageRoute(builder: (_) => AllYourTaxDetails()));
                                    } else if (selected_index == 2) {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => TaxCollectionView(appbarTitle: 'quickPay', flag: "2")));
                                    } else if (selected_index == 3) {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => CheckTransaction()));
                                    } else if (selected_index == 4) {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => ViewReceipt()));
                                    } else if (selected_index == 5) {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => KYVDashboard()));
                                    } else if (selected_index == 6) {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => Villagedevelopment()));
                                    }
                                    setState(() {});
                                  },
                                  child: Container(
                                    height: (Screen.height(context) / 2) - 10,
                                    width: (Screen.height(context) / 2) - 10,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.all(10),
                                    decoration: UIHelper.roundedBorderWithColorWithShadow(5, c.need_improvement2, c.need_improvement2, borderWidth: 0),
                                    child: Column(
                                      children: [
                                        Container(
                                          child: Image.asset(
                                            servicesList[index][key_img_path],
                                          ),
                                          height: MediaQuery.of(context).size.width * 0.2,
                                          margin: EdgeInsets.only(
                                            left: MediaQuery.of(context).size.width / 20,
                                            right: MediaQuery.of(context).size.width / 20,
                                          ),
                                          padding: EdgeInsets.all(5),
                                          width: MediaQuery.of(context).size.width,
                                        ),
                                        Container(
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
                                          child: Text(
                                            servicesList[index][key_service_name].toString().tr().toString(),
                                            style: TextStyle(fontSize: 11, height: 1.5, color: c.grey_9),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
