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
import 'package:public_vptax/Utils/ContentInfo.dart';
import 'package:public_vptax/Utils/utils.dart';

import '../Tax_Collection/favourite_list.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  PreferenceService preferencesService = locator<PreferenceService>();
  StartUpViewModel model = StartUpViewModel();
  Utils utils = Utils();
  List taxTypeList = [];
  int currentSelectedTax = 0;
  List servicesList = [
    {'service_id': 0, 'service_name': 'your_tax_details', 'img_path': imagePath.vptax1},
    {'service_id': 1, 'service_name': 'addedList', 'img_path': imagePath.add_user},
    {'service_id': 2, 'service_name': 'quickPay', 'img_path': imagePath.quick_pay1},
    {'service_id': 3, 'service_name': 'payment_transaction_history', 'img_path': imagePath.history},
    {'service_id': 4, 'service_name': 'view_receipt_details', 'img_path': imagePath.download_ic},
    /* {'service_id': 5, 'service_name': 'know_about_your_village', 'img_path': imagePath.village},
    {'service_id': 6, 'service_name': 'village_development_works', 'img_path': imagePath.village_development}, */
  ];
  String langText = 'தமிழ்';
  String userName = "";
  late AnimationController _controller;
  late Animation<double> _animation;

// ***** initState ***********
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    // Create a curved animation with Curves.bounceOut
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOutCirc);

    // Add a listener to rebuild the widget when the animation value changes
    _animation.addListener(() {
      setState(() {});
    });

    // Start the animation
    _controller.forward();
    initialize();
  }

  void repeatOnce() {
    _controller.reset();
    _controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<void> initialize() async {
    userName = await preferencesService.getUserInfo(key_name);
    taxTypeList = preferencesService.taxTypeList;

    if (preferencesService.selectedLanguage == "en") {
      langText = 'English';
    } else {
      langText = 'தமிழ்';
    }
    apicalls();
    setState(() {});
  }

  apicalls() async {
    Utils().showProgress(context, 1);
    await model.getDemandList(context);
    Utils().hideProgress(context);
  }

// ********** Language Selection Function ***********\\
  void handleClick(String value) {
    if (value != langText) {
      switch (value) {
        case 'தமிழ்':
          setState(() {
            langText = value;
            preferencesService.selectedLanguage = "ta";
            preferencesService.setUserInfo("lang", "ta");
            context.setLocale(Locale('ta', 'IN'));
          });
          break;
        case 'English':
          setState(() {
            langText = value;
            preferencesService.selectedLanguage = "en";
            preferencesService.setUserInfo("lang", "en");
            context.setLocale(Locale('en', 'US'));
          });
          break;
      }
      apicalls();
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
                decoration: UIHelper.GradientContainer(0, 0, 30, 30, [c.colorPrimary, c.colorPrimaryDark]),
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
                Row(children: [
                  Container(
                    margin: EdgeInsets.all(20),
                    child: Image.asset(
                      imagePath.tamilnadu_logo,
                      height: MediaQuery.of(context).size.height / 10,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: Screen.width(context) / 1.6,
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          decoration: UIHelper.GradientContainer(20, 0, 20, 0, [c.colorPrimary, c.colorPrimaryDark]),
                          child: Text(
                            textAlign: TextAlign.center,
                            "appName".tr().toString(),
                            style: TextStyle(color: c.white, fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                        UIHelper.verticalSpaceSmall,
                        Container(
                            width: MediaQuery.of(context).size.width / 2,
                            margin: EdgeInsets.only(right: 20),
                            child:
                                // UIHelper.titleTextStyle("Hi " + "userName", c.text_color, 14, true, true)),
                                Text(
                              'hi'.tr().toString() + " " + userName + ",",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              textAlign: TextAlign.end,
                              style: TextStyle(color: c.text_color, fontSize: preferencesService.selectedLanguage == "ta" ? 13 : 14, fontWeight: FontWeight.bold),
                            )),
                      ],
                    ),
                  )
                ]),
                if (taxTypeList.length > 0)
                  StreamBuilder<Map<String, dynamic>?>(
                    stream: preferencesService.totalAmountStream!.outStream!,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        final data = snapshot.data;
                        if (data != null) {
                          return Container(
                            decoration: UIHelper.GradientContainer(20, 20, 20, 20, [c.white, c.white]),
                            margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
                            child: Column(
                              children: [
                                UIHelper.verticalSpaceSmall,
                                Container(
                                    padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: [
                                        Expanded(
                                            flex: 2, child: UIHelper.titleTextStyle('tax_due'.tr().toString() + " : ", c.grey_10, preferencesService.selectedLanguage == "ta" ? 12 : 13, true, false)),
                                        Expanded(flex: 1, child: UIHelper.titleTextStyle("\u{20B9} " + gettotal(data, 5), c.red_new, 17, true, false))
                                      ],
                                    )),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    InkWell(
                                      onTap: currentSelectedTax != 0
                                          ? () {
                                              currentSelectedTax--;
                                              repeatOnce();
                                              setState(() {});
                                            }
                                          : null,
                                      child: Container(
                                        color: c.full_transparent,
                                        child: Image.asset(imagePath.left_arrow, height: 25, color: currentSelectedTax != 0 ? c.text_color : c.white),
                                      ),
                                    ),
                                    Container(
                                        padding: EdgeInsets.only(left: 0, right: 0, bottom: 10),
                                        child: Transform.scale(
                                          scale: _animation.value,
                                          child: customCardDesign(data),
                                        )),
                                    InkWell(
                                      onTap: currentSelectedTax != 4
                                          ? () {
                                              currentSelectedTax++;
                                              repeatOnce();
                                              setState(() {});
                                            }
                                          : null,
                                      child: Container(
                                        color: c.full_transparent,
                                        child: Image.asset(imagePath.right_arrow, height: 25, color: currentSelectedTax != 4 ? c.text_color : c.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Text('No Data');
                        }
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
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
                      crossAxisCount: 3,
                      children: List.generate(
                        servicesList.length,
                        (int index) {
                          return AnimationConfiguration.staggeredGrid(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            columnCount: 3,
                            child: ScaleAnimation(
                              child: FadeInAnimation(
                                child: InkWell(
                                  onTap: () async {
                                    int selected_index = servicesList[index][key_service_id];
                                    if (selected_index == 0) {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => AllYourTaxDetails(isHome: false)));
                                    } else if (selected_index == 1) {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => FavouriteTaxDetails()));
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
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.fromLTRB(20, 5, 5, 20),
                                        decoration: UIHelper.roundedBorderWithColorWithShadow(10, c.colorPrimaryDark, c.colorAccent, borderWidth: 0),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.fromLTRB(5, 10, 10, 5),
                                        decoration: UIHelper.roundedBorderWithColorWithShadow(5, c.white, c.white, borderWidth: 0),
                                        child: Column(
                                          children: [
                                            Container(
                                              child: Image.asset(
                                                servicesList[index][key_img_path],
                                                color: c.colorPrimary,
                                              ),
                                              height: MediaQuery.of(context).size.width * 0.12,
                                              margin: EdgeInsets.only(
                                                left: MediaQuery.of(context).size.width / 20,
                                                right: MediaQuery.of(context).size.width / 20,
                                              ),
                                              padding: EdgeInsets.all(index == 4 ? 8 : 5),
                                              width: MediaQuery.of(context).size.width,
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                              child: Text(
                                                servicesList[index][key_service_name].toString().tr().toString(),
                                                style: TextStyle(fontSize: 11, height: 1.2, color: c.text_color),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: Container(
                                          height: 15,
                                          width: 15,
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.all(5),
                                          decoration: UIHelper.roundedBorderWithColorWithoutShadow(10, c.colorAccent, c.colorAccent, borderWidth: 0),
                                        ),
                                      ),
                                    ],
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

//Custom Card Design
  Widget customCardDesign(dynamic data) {
    String taxamount = gettotal(data, currentSelectedTax);
    return GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity == null) return;
          if (details.primaryVelocity! > 0) {
            if (currentSelectedTax != 0) {
              currentSelectedTax--;
            }
          } else if (details.primaryVelocity! < 0) {
            if (currentSelectedTax != 4) {
              currentSelectedTax++;
            }
          }
          repeatOnce();
          setState(() {});
        },
        onTap: () {
          double txtToDouAmt = double.parse(taxamount);
          if (txtToDouAmt > 0) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => AllYourTaxDetails(selectedTaxTypeData: taxTypeList[currentSelectedTax], isHome: true)));
          } else {
            utils.showAlert(context, ContentType.fail, 'no_pending_due'.tr().toString());
          }
        },
        child: Column(children: [
          Container(
            decoration: UIHelper.GradientContainer(20, 20, 20, 20, [c.grey_2, c.grey_1], borderColor: c.white, intwid: 4),
            height: Screen.height(context) / 3.5,
            width: Screen.width(context) / 1.6,
            child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
              UIHelper.verticalSpaceSmall,
              Container(
                height: 55,
                width: 55,
                padding: EdgeInsets.all(5),
                decoration: UIHelper.circleWithColorWithShadow(0, c.white, c.grey_3),
                child: Image.asset(taxTypeList[currentSelectedTax][key_img_path]),
              ),
              UIHelper.verticalSpaceSmall,
              UIHelper.titleTextStyle(preferencesService.selectedLanguage == 'en' ? taxTypeList[currentSelectedTax][key_taxtypedesc_en] : taxTypeList[currentSelectedTax][key_taxtypedesc_ta],
                  c.colorPrimaryDark, preferencesService.selectedLanguage == "ta" ? 16 : 18, true, true),
              UIHelper.verticalSpaceSmall,
              UIHelper.titleTextStyle('pending_payment'.tr().toString(), c.text_color, preferencesService.selectedLanguage == "ta" ? 12 : 14, true, true),
              UIHelper.verticalSpaceSmall,
              Container(
                width: Screen.width(context),
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                          width: Screen.width(context) / 3,
                          height: 45,
                          transform: Matrix4.skewX(-.3),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: c.grey,
                            ),
                            color: c.colorPrimaryDark,
                            borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                          ),
                          alignment: Alignment.center,
                          child: UIHelper.titleTextStyle("\u{20B9} ${taxamount}", c.white, 18, true, true)),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        margin: EdgeInsets.only(right: 20),
                        child: Image.asset(
                          imagePath.tap,
                          height: 30,
                          width: 25,
                          color: c.account_status_green_color,
                          // colorFilter: getColorFilter(hslDark.toColor(), ui.BlendMode.srcIn),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ]),
          ),
        ]));
  }

  String gettotal(dynamic data, int index) {
    List amount = [data['property_total'], data['water_total'], data['professional_total'], data['non_total'], data['trade_total'], data['totalAmount']];
    String total = amount[index].toString();
    if (total != "null" && total.isNotEmpty) {
      double number = double.parse(total);
      return number.toStringAsFixed(2);
    } else {
      return "0.00";
    }
  }
}
