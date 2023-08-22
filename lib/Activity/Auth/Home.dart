// ignore_for_file: non_constant_identifier_names, sort_child_properties_last, prefer_const_constructors, use_build_context_synchronously

import 'dart:ffi';
import 'dart:io';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:public_vptax/Activity/Auth/View_receipt.dart';
import 'package:public_vptax/Activity/Transaction/CheckTransaction.dart';
import 'package:public_vptax/Layout/customgradientbutton.dart';
import 'package:public_vptax/Layout/screen_size.dart';
import 'package:public_vptax/Layout/ui_helper.dart';
import 'package:public_vptax/Model/transaction_model.dart';
import 'package:public_vptax/Resources/ImagePath.dart' as imagePath;
import 'package:public_vptax/Resources/ColorsValue.dart' as c;
import 'package:public_vptax/Resources/StringsKey.dart';
import 'package:public_vptax/Utils/ContentInfo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Services/Preferenceservices.dart';
import '../../Services/locator.dart';
import '../../Utils/utils.dart';
import '../About_Village/know_your_village.dart';
import '../Tax_Collection/taxCollection_details.dart';
import '../Tax_Collection/taxCollection_view_request_screen.dart';
import 'Download_receipt.dart';
import 'Splash.dart';
import 'Village_development_works.dart';

class Home extends StatefulWidget {
  final isLogin;
  const Home({super.key, this.isLogin});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Utils utils = Utils();
  List taxTypeList = [];
  List servicesList = [];
  int index_val = -1;
  int selected_index = -1;
  final _controller = ScrollController();
  PreferenceService preferencesService = locator<PreferenceService>();
  bool flag = true;
  bool flagMobileActive = true;
  String langText = 'தமிழ்';
  String islogin = 'no';
  String selectedLang = "";

  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  final TransactionModel transactionModel = TransactionModel();

  @override
  void initState() {
    super.initState();
    initialize();
    // Setup the listener.
    _controller.addListener(() {
      if (_controller.position.atEdge) {
        bool isTop = _controller.position.pixels == 0;
        if (isTop) {
          setState(() {
            flag = true;
          });
        } else {
          setState(() {
            flag = false;
          });
        }
      }
    });
  }

  Future<void> initialize() async {
    index_val = -1;
    selected_index = -1;
    langText = 'தமிழ்';
    selectedLang = await preferencesService.getUserInfo("lang");
    widget.isLogin == true ? await Utils().apiCalls(context) : null;
    List s_list = [
      {'service_id': 0, 'service_name': 'check_your_dues', 'img_path': imagePath.due4},
      {'service_id': 1, 'service_name': 'quickPay', 'img_path': imagePath.quick_pay1},
      {'service_id': 2, 'service_name': 'view_receipt_details', 'img_path': imagePath.download_receipt},
      {'service_id': 3, 'service_name': 'know_about_your_village', 'img_path': imagePath.village},
      {'service_id': 4, 'service_name': 'village_development_works', 'img_path': imagePath.village_development},
      {'service_id': 5, 'service_name': 'check_transaction_status', 'img_path': imagePath.check_transaction_status},
    ];
    servicesList.clear();
    servicesList.addAll(s_list);

    taxTypeList.clear();
    taxTypeList = preferencesService.taxTypeList;
    islogin = await preferencesService.getUserInfo(key_isLogin);
    print("islogin>>" + islogin.toString());
    print("tax>>" + taxTypeList.toString());
    setState(() {
      if (selectedLang != null && selectedLang != "" && selectedLang == "en") {
        context.setLocale(Locale('en', 'US'));
      } else {
        preferencesService.setUserInfo("lang", "ta");
        context.setLocale(Locale('ta', 'IN'));
      }
    });
  }

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
                        visible: islogin == "no",
                        child: InkWell(
                          onTap: () async {
                            await preferencesService.setUserInfo(key_isLogin, 'yes');
                            await preferencesService.setUserInfo(key_mobile_number, '9875235654');
                            islogin = "yes";
                            print("islogin>>" + islogin.toString());
                            print("login successful");
                            setState(() {});
                          },
                          child: Text(
                            'login'.tr().toString(),
                            style: TextStyle(
                              fontSize: 15,
                              color: c.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 15,
                      child: Visibility(
                        visible: islogin == "yes",
                        child: InkWell(
                          onTap: () {
                            logout();
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

                    // SizedBox(width: Screen.width(context) * 0.11)

                    // *************************** Future Functionality  *************************** //

                    // Container(
                    //   alignment: Alignment.centerRight,
                    //   child: InkWell(
                    //       child: Image.asset(
                    //         imagePath.logout,
                    //         color: c.white,
                    //         fit: BoxFit.contain,
                    //         height: 25,
                    //         width: 25,
                    //       ),
                    //       onTap: () async {
                    //         logout();
                    //       }),
                    // )

                    // *************************** Future Functionality  *************************** //
                  ],
                )),
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Container(
                    margin: EdgeInsets.all(20),
                    child: Image.asset(
                      imagePath.tamilnadu_logo,
                      height: MediaQuery.of(context).size.height / 10,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      decoration: UIHelper.GradientContainer(20, 0, 20, 0, [c.colorAccentlight, c.colorPrimaryDark]),
                      child: Text(
                        textAlign: TextAlign.center,
                        'appName'.tr().toString(),
                        style: TextStyle(color: c.white, fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ]),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'tax_types'.tr().toString(),
                    style: TextStyle(color: c.grey_8, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.width * 0.3,
                      margin: EdgeInsets.only(left: 15),
                      child: ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context).copyWith(
                            dragDevices: {
                              PointerDeviceKind.touch,
                              PointerDeviceKind.mouse,
                            },
                          ),
                          child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            shrinkWrap: true, // new
                            controller: _controller,
                            scrollDirection: Axis.horizontal,
                            itemCount: taxTypeList == null ? 0 : taxTypeList.length,
                            itemBuilder: (context, i) {
                              return InkWell(
                                onTap: () async {
                                  index_val = i;
                                  if (await preferencesService.getUserInfo(key_isLogin) == "yes") {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => TaxCollectionDetailsView(
                                                  selectedTaxTypeData: taxTypeList[i],
                                                  isTaxDropDown: false,
                                                  isHome: true,
                                                  mobile: preferencesService.getUserInfo(key_mobile_number).toString(),
                                                  selectedEntryType: 1,
                                                )));
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => TaxCollectionView(
                                                  selectedTaxTypeData: taxTypeList[i],
                                                  flag: "1",
                                                )));
                                  }

                                  setState(() {});
                                },
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                                  // decoration: i == index_val ?UIHelper.circleWithColorWithShadow(360,c.colorAccentverylight,c.colorPrimaryDark):UIHelper.circleWithColorWithShadow(360,c.white,c.white),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: i == index_val
                                            ? UIHelper.circleWithColorWithShadow(360, c.colorAccentverylight, c.colorPrimaryDark)
                                            : UIHelper.circleWithColorWithShadow(360, c.white, c.white),
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(top: 0),
                                        padding: EdgeInsets.all(10),
                                        child: Image.asset(
                                          taxTypeList[i][key_img_path],
                                          height: (MediaQuery.of(context).size.height / 4) / 4,
                                          width: (MediaQuery.of(context).size.height / 4) / 4,
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.all(10),
                                        child: Text(
                                          selectedLang == 'en' ? taxTypeList[i][key_taxtypedesc_en] : taxTypeList[i][key_taxtypedesc_ta],
                                          style: TextStyle(fontSize: 12, height: 1.5, color: c.grey_9),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )),
                    ),
                    Visibility(
                        visible: flag,
                        child: InkWell(
                          onTap: () {
                            _controller.animateTo(500, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                          },
                          child: Container(
                            alignment: Alignment.bottomRight,
                            color: c.full_transparent,
                            margin: EdgeInsets.only(top: 0, right: 10),
                            child: Image.asset(
                              imagePath.right_arrow,
                              height: 25,
                              color: c.grey_9,
                            ),
                          ),
                        ))
                  ],
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
                      crossAxisCount: 2,
                      children: List.generate(
                        servicesList == null ? 0 : servicesList.length,
                        (int index) {
                          return AnimationConfiguration.staggeredGrid(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            columnCount: 2,
                            child: ScaleAnimation(
                              child: FadeInAnimation(
                                child: InkWell(
                                  onTap: () async {
                                    selected_index = index;
                                    if (selected_index == 0) {
                                      if (islogin == "yes") {
                                        print(islogin);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => TaxCollectionDetailsView(
                                                      selectedTaxTypeData: taxTypeList[0],
                                                      isTaxDropDown: true,
                                                      isHome: true,
                                                      mobile: preferencesService.getUserInfo(key_mobile_number),
                                                      selectedEntryType: 1,
                                                    )));
                                      } else {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => TaxCollectionView(
                                                      flag: "2",
                                                    )));
                                      }
                                    } else if (selected_index == 1) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => TaxCollectionView(
                                                    flag: "2",
                                                  )));
                                    } else if (selected_index == 2) {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => ViewReceipt()));
                                    } else if (selected_index == 3) {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => KYVDashboard()));
                                    } else if (selected_index == 4) {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => Villagedevelopment()));
                                    } else if (selected_index == 5) {
                                      _settingModalBottomSheet(context);
                                    }

                                    setState(() {});
                                  },
                                  child: Container(
                                    height: (Screen.height(context) / 2) - 10,
                                    width: (Screen.height(context) / 2) - 10,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.all(10),
                                    decoration: index == selected_index
                                        ? UIHelper.roundedBorderWithColorWithShadow(5, c.colorAccentverylight, c.colorPrimaryDark, borderWidth: 0)
                                        : UIHelper.roundedBorderWithColorWithShadow(5, c.need_improvement2, c.need_improvement2, borderWidth: 0),
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
                                            getServiceName(servicesList[index][key_service_name]),
                                            style: TextStyle(fontSize: 11, height: 1.5, color: index == selected_index ? c.white : c.grey_9),
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

  String getServiceName(String name) {
    String s = "";
    print(name);
    s = name.tr().toString();
    print(s);
    return s;
  }

  Future<bool> showExitPopup() async {
    return await showDialog(
          //show confirm dialogue
          //the return value will be from "Yes" or "No" options
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'exit_app'.tr().toString(),
              style: TextStyle(fontSize: 14),
            ),
            content: Text(
              'do_you_want_to_exit_an_app'.tr().toString(),
              style: TextStyle(fontSize: 13),
            ),
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
                onPressed: () {
                  if (Platform.isAndroid) {
                    SystemNavigator.pop();
                  } else if (Platform.isIOS) {
                    exit(0);
                  }
                },
                //return true when click on "Yes"
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

  void logout() {
    preferencesService.cleanAllPreferences();
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      exit(0);
    }
    // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Splash()), (route) => false);
  }

  void _settingModalBottomSheet(context) {
    mobileController.text = '';
    emailController.text = '';
    showModalBottomSheet(
        context: context,
        backgroundColor: c.full_transparent,
        builder: (BuildContext bc) {
          return StatefulBuilder(builder: (context, setState) {
            return Container(
                decoration: UIHelper.GradientContainer(30.0, 30, 0, 0, [c.white, c.white]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'payment_transaction_history'.tr().toString(),
                        style: TextStyle(color: c.text_color, fontWeight: FontWeight.w500, fontSize: 15, decorationStyle: TextDecorationStyle.wavy),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          badge(
                            context,
                            flagMobileActive,
                            () => {utils.closeKeypad(context), FocusScope.of(context).unfocus(), flagMobileActive = !flagMobileActive, setState(() {})},
                          ),
                          badge(context, !flagMobileActive, () => {FocusScope.of(context).unfocus(), flagMobileActive = !flagMobileActive, setState(() {})}, isMobileActive: false)
                        ],
                      ),
                    ),
                    SizedBox(
                      width: Screen.width(context) * 0.8,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          flagMobileActive
                              ? BottomText(context, mobileController, 'mobile', 'Mobile Number', TextInputType.number, isMobile: true)
                              : BottomText(context, emailController, 'email', 'Email', TextInputType.emailAddress),
                        ],
                      ),
                    ),
                    UIHelper.verticalSpaceSmall,
                    UIHelper.verticalSpaceSmall,
                    UIHelper.verticalSpaceSmall,
                    Container(
                        width: Screen.width(context) * 0.8,
                        alignment: Alignment.center,
                        height: 40,
                        padding: EdgeInsets.all(5),
                        decoration: UIHelper.roundedBorderWithColorWithShadow(10, c.colorAccentlight, c.colorAccentlight, borderColor: Colors.transparent, borderWidth: 0),
                        child: InkWell(
                          child: Center(
                            child: Text(
                              'get_status'.tr().toString(),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: c.white, fontWeight: FontWeight.w500, fontSize: 11, decorationStyle: TextDecorationStyle.wavy),
                            ),
                          ),
                          onTap: () async {
                            utils.closeKeypad(context);
                            mobileController.text = "9876543210";
                            bool resFlag = await transactionModel.getTransactionStatus(context, mobileController.text, emailController.text);
                            if (resFlag) {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => CheckTransaction()));
                            } else {
                              utils.showAlert(context, ContentType.fail, 'message');
                            }
                          },
                        ))
                  ],
                ));
          });
        });
  }

  Card badge(BuildContext context, bool isActive, Function onPressed, {isMobileActive = true}) {
    return Card(
      elevation: isActive ? 3 : 0,
      color: isActive ? c.green_new : c.inputGrey,
      shadowColor: isActive ? c.account_status_green_color : c.black,
      child: SizedBox(
        width: 80,
        height: 30, // Adjust the height as needed
        child: TextButton(
          onPressed: () {
            onPressed();
          },
          style: ButtonStyle(
            shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isMobileActive ? Icons.mobile_screen_share_rounded : Icons.email_rounded,
                size: 13,
                color: isActive ? c.white : Colors.black,
              ),
              SizedBox(width: 4),
              Text(
                isMobileActive ? 'Mobile' : 'Email',
                style: TextStyle(color: isActive ? c.white : Colors.black, fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    );
  }

  FormBuilderTextField BottomText(BuildContext context, TextEditingController controller, String nameText, String labelText, TextInputType type, {bool isMobile = false}) {
    List<TextInputFormatter> inputFormatters = isMobile
        ? [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ]
        : [];
    return FormBuilderTextField(
      name: nameText,
      textAlign: TextAlign.left,
      controller: controller,
      keyboardType: type,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(fontSize: 11.0, fontWeight: FontWeight.w400, color: Colors.black),
        hintText: labelText,
        hintStyle: TextStyle(fontSize: 11),
        enabledBorder: UIHelper.getInputBorder(1, borderColor: c.grey_7),
        focusedBorder: UIHelper.getInputBorder(1, borderColor: c.grey_7),
        filled: true,
        contentPadding: EdgeInsets.all(10),
        fillColor: c.inputGrey,
      ),
    );
  }
}
