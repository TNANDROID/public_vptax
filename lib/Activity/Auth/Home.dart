// ignore_for_file: non_constant_identifier_names, sort_child_properties_last, prefer_const_constructors, use_build_context_synchronously

import 'dart:io';
import 'dart:ui';

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
import 'package:public_vptax/Layout/customclip.dart';
import 'package:public_vptax/Layout/screen_size.dart';
import 'package:public_vptax/Layout/ui_helper.dart';
import 'package:public_vptax/Model/startup_model.dart';
import 'package:public_vptax/Resources/ColorsValue.dart' as c;
import 'package:public_vptax/Resources/ImagePath.dart' as imagePath;
import 'package:public_vptax/Resources/StringsKey.dart';
import 'package:public_vptax/Services/Preferenceservices.dart';
import 'package:public_vptax/Services/locator.dart';
import 'package:public_vptax/Utils/utils.dart';
import 'package:public_vptax/Utils/ContentInfo.dart';
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
    {'service_id': 0, 'service_name': 'your_tax_details', 'img_path': imagePath.currency_ic},
    {'service_id': 1, 'service_name': 'addedList', 'img_path': imagePath.add_user},
    {'service_id': 2, 'service_name': 'quickPay', 'img_path': imagePath.quick_pay1},
    {'service_id': 3, 'service_name': 'payment_transaction_history', 'img_path': imagePath.history},
    {'service_id': 4, 'service_name': 'view_receipt_details', 'img_path': imagePath.download_ic},
    /* {'service_id': 5, 'service_name': 'know_about_your_village', 'img_path': imagePath.village},
    {'service_id': 6, 'service_name': 'village_development_works', 'img_path': imagePath.village_development}, */
  ];
  int selected_index = -1;
  String langText = 'தமிழ்';
  String selectedLang = "";
  String userName = "";
  String mobile_number = "";
  bool flag = true;
  List sourceList = [];
  double property_total = 0.0;
  double water_total = 0.0;
  double professional_total = 0.0;
  double non_total = 0.0;
  double trade_total = 0.0;
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
    selectedLang = await preferencesService.getUserInfo("lang");
    userName = await preferencesService.getUserInfo(key_name);
    mobile_number = await preferencesService.getUserInfo(key_mobile_number);

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
    await getDemandList();
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

  Future getDemandList() async {
    property_total = 0.0;
    water_total = 0.0;
    professional_total = 0.0;
    non_total = 0.0;
    trade_total = 0.0;
    sourceList.clear();
    Utils().showProgress(context, 1);
    try {
      dynamic requestJson = {key_service_id: service_key_getAllTaxAssessmentList, key_mobile_number: mobile_number, key_language_name: selectedLang};
      var responce = await model.demandServicesAPIcall(context, requestJson);
      if (responce[key_data] != null && responce[key_data].length > 0) {
        sourceList = responce[key_data].toList();

        for (var item in sourceList) {
          switch (item[key_taxtypeid].toString()) {
            case '1':
              property_total = property_total + double.parse(item["totaldemand"]);
              break;
            case '2':
              water_total = water_total + double.parse(item["totaldemand"]);
              break;
            case '4':
              professional_total = professional_total + double.parse(item["totaldemand"]);
              break;
            case '5':
              non_total = non_total + double.parse(item["totaldemand"]);
              break;
            case '6':
              trade_total = trade_total + double.parse(item["totaldemand"]);
              break;
          }
        }
      }
      Utils().hideProgress(context);
    } catch (error) {
      Utils().hideProgress(context);
      debugPrint('error : $error has been caught');
    }
    setState(() {});
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
    double number = property_total + water_total + professional_total + non_total + trade_total;
    String totalAmountOfPayable = number.toStringAsFixed(2);
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
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: Screen.width(context) / 1.6,
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        decoration: UIHelper.GradientContainer(20, 0, 20, 0, [c.colorAccentlight, c.colorPrimaryDark]),
                        child: Text(
                          textAlign: TextAlign.center,
                          "appName".tr().toString(),
                          style: TextStyle(color: c.white, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      UIHelper.verticalSpaceSmall,
                      Container(margin: EdgeInsets.only(right: 20), child: UIHelper.titleTextStyle("Hi " + userName, c.text_color, 14, true, true)),
                      UIHelper.verticalSpaceTiny,
                    ],
                  )
                ]),
                if (taxTypeList.length > 0)
                  Container(
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
                                Expanded(flex: 2, child: UIHelper.titleTextStyle('tax_due'.tr().toString() + " : ", c.grey_10, 12, true, false)),
                                Expanded(flex: 1, child: UIHelper.titleTextStyle("\u{20B9} $totalAmountOfPayable", c.red_new, 18, true, false))
                              ],
                            )),
                        Stack(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.width / 2,
                              padding: EdgeInsets.only(left: 0, right: 0),
                              child: Transform.scale(
                                  scale: _animation.value,
                                  child: GestureDetector(
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
                                      String Taxamount = gettotal(taxTypeList[currentSelectedTax][key_taxtypeid].toString());
                                      double txtToDouAmt = double.parse(Taxamount);
                                      if (txtToDouAmt > 0) {
                                        Navigator.push(context, MaterialPageRoute(builder: (_) => AllYourTaxDetails(selectedTaxTypeData: taxTypeList[currentSelectedTax], isHome: true)));
                                      } else {
                                        utils.showAlert(context, ContentType.fail, 'no_pending_due'.tr().toString());
                                      }
                                    },
                                    child: Container(
                                        width: Screen.width(context) / 1.5,
                                        // decoration: BoxDecoration(
                                        //   color: c.white,
                                        //   borderRadius: BorderRadius.circular(20),
                                        //   border: Border.all(color: c.colorPrimaryDark, width: 2),
                                        // ),
                                        decoration: UIHelper.GradientContainer(20, 20, 20, 20, [c.white, c.white], borderColor: c.colorPrimaryDark, intwid: 2),
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.fromLTRB(30, 10, 30, 10),
                                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                        child: Column(
                                          children: [
                                            Container(
                                                // width: Screen.width(context),
                                                transform: Matrix4.translationValues(0.0, -10, 0.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    ClipPath(
                                                      clipper: LeftTriangleClipper1(),
                                                      child: Container(
                                                        width: 10,
                                                        height: 10,
                                                        color: c.red,
                                                      ),
                                                    ),
                                                    Container(
                                                      width: Screen.width(context) / 2,
                                                      height: 40,
                                                      // decoration: UIHelper.GradientContainer(0, 0, 20, 20, [c.pr, c.colorPrimaryDark], borderColor: c.colorPrimaryDark, intwid: 2),
                                                      decoration: UIHelper.roundedBorderWithColor(
                                                        0,
                                                        0,
                                                        20,
                                                        20,
                                                        c.colorPrimaryDark,
                                                      ),
                                                      child: Center(
                                                          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                        Image.asset(
                                                          taxTypeList[currentSelectedTax][key_img_path],
                                                          width: 30,
                                                        ),
                                                        UIHelper.horizontalSpaceTiny,
                                                        UIHelper.titleTextStyle(
                                                            selectedLang == 'en' ? taxTypeList[currentSelectedTax][key_taxtypedesc_en] : taxTypeList[currentSelectedTax][key_taxtypedesc_ta],
                                                            c.white,
                                                            12,
                                                            true,
                                                            true)
                                                      ])),
                                                    ),
                                                    ClipPath(
                                                      clipper: RightTriangleClipper1(),
                                                      child: Container(
                                                        width: 10,
                                                        height: 10,
                                                        color: c.red,
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                            UIHelper.verticalSpaceSmall,
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                UIHelper.titleTextStyle('pending_payment'.tr().toString(), c.text_color, 12, true, true),
                                                UIHelper.verticalSpaceSmall,
                                                Container(
                                                    margin: EdgeInsets.symmetric(horizontal: 30),
                                                    padding: EdgeInsets.all(10),
                                                    decoration: UIHelper.GradientContainer(10, 10, 10, 10, [c.primary_text_color2, c.primary_text_color2]),
                                                    alignment: Alignment.center,
                                                    child: UIHelper.titleTextStyle("\u{20B9} ${gettotal(taxTypeList[currentSelectedTax][key_taxtypeid].toString())}", c.white, 18, true, true)),
                                              ],
                                            ),
                                            UIHelper.verticalSpaceSmall,
                                            Container(
                                                alignment: Alignment.bottomRight, child: UIHelper.titleTextStyle("payTo".tr().toString(), c.green_new, selectedLang == "ta" ? 12 : 13, true, true)),
                                          ],
                                        )),
                                  )),
                            ),
                            Visibility(
                                visible: currentSelectedTax != 0,
                                child: Positioned(
                                  left: 1,
                                  child: InkWell(
                                    onTap: () {
                                      currentSelectedTax--;
                                      repeatOnce();
                                      setState(() {});
                                    },
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      color: c.full_transparent,
                                      margin: EdgeInsets.only(left: 0, right: 20, top: 80, bottom: 100),
                                      child: Image.asset(imagePath.left_arrow, height: 25, color: c.text_color),
                                    ),
                                  ),
                                )),
                            Visibility(
                                visible: currentSelectedTax != 4,
                                child: Positioned(
                                  right: 1,
                                  child: InkWell(
                                    onTap: () {
                                      currentSelectedTax++;
                                      repeatOnce();
                                      setState(() {});
                                    },
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      color: c.full_transparent,
                                      margin: EdgeInsets.only(left: 20, right: 0, top: 80, bottom: 100),
                                      child: Image.asset(imagePath.right_arrow, height: 25, color: c.text_color),
                                    ),
                                  ),
                                ))
                          ],
                        ),
                      ],
                    ),
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
                                    selected_index = servicesList[index][key_service_id];
                                    if (selected_index == 0) {
                                      Navigator.push(context, MaterialPageRoute(builder: (_) => AllYourTaxDetails(isHome: false))).then((value) => getDemandList());
                                    } else if (selected_index == 1) {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => FavouriteTaxDetails())).then((value) => getDemandList());
                                    } else if (selected_index == 2) {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => TaxCollectionView(appbarTitle: 'quickPay', flag: "2"))).then((value) => getDemandList());
                                    } else if (selected_index == 3) {
                                      await Navigator.push(context, MaterialPageRoute(builder: (context) => CheckTransaction())).then((value) => getDemandList());
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
                                    height: (Screen.height(context) / 4) - 10,
                                    width: (Screen.height(context) / 2) - 10,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.all(5),
                                    decoration: UIHelper.roundedBorderWithColorWithShadow(5, c.white, c.white, borderWidth: 0),
                                    child: Column(
                                      children: [
                                        Container(
                                          child: Image.asset(
                                            servicesList[index][key_img_path],
                                            color: c.colorPrimary,
                                          ),
                                          height: MediaQuery.of(context).size.width * 0.13,
                                          margin: EdgeInsets.only(
                                            left: MediaQuery.of(context).size.width / 20,
                                            right: MediaQuery.of(context).size.width / 20,
                                          ),
                                          padding: EdgeInsets.all(index==4?8:5),
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

  String gettotal(taxtypeid) {
    String total = '';
    switch (taxtypeid) {
      case '1':
        total = property_total.toString();
        break;
      case '2':
        total = water_total.toString();
        break;
      case '4':
        total = professional_total.toString();
        break;
      case '5':
        total = non_total.toString();
        break;
      case '6':
        total = trade_total.toString();
        break;
    }
    double number = double.parse(total);
    String formattedString = number.toStringAsFixed(2);
    return formattedString;
  }
}
