import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:public_vptax/Activity/Auth/View_receipt.dart';
import 'package:public_vptax/Layout/screen_size.dart';
import 'package:public_vptax/Layout/ui_helper.dart';
import 'package:public_vptax/Resources/ImagePath.dart' as imagePath;
import 'package:public_vptax/Resources/ColorsValue.dart' as c;
import 'package:public_vptax/Resources/StringsKey.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Utils/utils.dart';
import '../Tax_Collection/taxCollection_details.dart';
import '../Tax_Collection/taxCollection_view.dart';
import 'Download_receipt.dart';

class Home extends StatefulWidget {
  const Home({super.key, required isLogin});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Utils utils = Utils();
  late SharedPreferences prefs;
  List taxTypeList = [];
  List servicesList = [];
  int index_val = -1;
  int selected_index = -1;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    prefs = await SharedPreferences.getInstance();
    index_val = -1;
    selected_index = -1;
    List list = [
      {
        'taxtypeid': 1,
        'taxtypedesc_en': 'House Tax',
        'taxtypedesc_ta': 'வீட்டு வரி'
      },
      {
        'taxtypeid': 2,
        'taxtypedesc_en': 'Water Tax',
        'taxtypedesc_ta': 'குடிநீர் கட்டணங்கள்'
      },
      {
        'taxtypeid': 3,
        'taxtypedesc_en': 'Professional Tax',
        'taxtypedesc_ta': 'தொழில் வரி'
      },
      {
        'taxtypeid': 4,
        'taxtypedesc_en': 'Non Tax',
        'taxtypedesc_ta': 'இதர வரவினங்கள்'
      },
      {
        'taxtypeid': 5,
        'taxtypedesc_en': 'Trade Licence',
        'taxtypedesc_ta': 'வர்த்தக உரிமம்'
      },
    ];
    taxTypeList.clear();
    for (var item in list) {
      switch (item['taxtypeid']) {
        case 1:
          item['img_path'] = imagePath.house;
          break;
        case 2:
          item['img_path'] = imagePath.water;
          break;
        case 3:
          item['img_path'] = imagePath.professional1;
          break;
        case 4:
          item['img_path'] = imagePath.nontax1;
          break;
        case 5:
          item['img_path'] = imagePath.trade;
          break;
        default:
          item['img_path'] = imagePath.property;
      }
    }
    taxTypeList.addAll(list);
    print("tax>>" + taxTypeList.toString());

    List s_list = [
      {
        'service_id': 0,
        'service_name': 'check_your_dues',
        'img_path': imagePath.due4
      },
      {
        'service_id': 1,
        'service_name': 'quickPay',
        'img_path': imagePath.quick_pay1
      },
      {
        'service_id': 2,
        'service_name': 'view_receipt_details',
        'img_path': imagePath.reciept
      },
      {
        'service_id': 3,
        'service_name': 'download_receipt',
        'img_path': imagePath.download_receipt
      },
    ];
    servicesList.clear();
    servicesList.addAll(s_list);

    setState(() {
      prefs.getString("lang") != null &&
              prefs.getString("lang") != "" &&
              prefs.getString("lang") == "en"
          ? context.setLocale(Locale('en', 'US'))
          : context.setLocale(Locale('ta', 'IN'));
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
                padding: EdgeInsets.only(top: 30, bottom: 10, right: 20),
                decoration: UIHelper.GradientContainer(
                    0, 0, 30, 30, [c.colorAccentlight, c.colorPrimaryDark]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: PopupMenuButton<String>(
                        color: c.white,
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
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          'home'.tr().toString(),
                          style: TextStyle(
                            fontSize: 15,
                            color: c.white,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                          child: Image.asset(
                            imagePath.logout,
                            color: c.white,
                            fit: BoxFit.contain,
                            height: 25,
                            width: 25,
                          ),
                          onTap: () async {
                            // logout();
                          }),
                    )
                  ],
                )),
          ),
          body: RefreshIndicator(
            onRefresh: initialize,
            child: SingleChildScrollView(
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
                        decoration: UIHelper.GradientContainer(20, 0, 20, 0,
                            [c.colorAccentlight, c.colorPrimaryDark]),
                        child: Text(
                          textAlign: TextAlign.center,
                          'appName'.tr().toString(),
                          style: TextStyle(
                              color: c.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ]),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'tax_types'.tr().toString(),
                      style: TextStyle(
                          color: c.grey_8,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                      height: MediaQuery.of(context).size.height / 5,
                      margin: EdgeInsets.only(left: 15, right: 15),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: taxTypeList == null ? 0 : taxTypeList.length,
                        itemBuilder: (context, i) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                index_val = i;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            TaxCollectionDetailsView()));
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.fromLTRB(2, 20, 2, 10),
                              // decoration: i == index_val ?UIHelper.circleWithColorWithShadow(360,c.colorAccentverylight,c.colorPrimaryDark):UIHelper.circleWithColorWithShadow(360,c.white,c.white),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: i == index_val
                                        ? UIHelper.circleWithColorWithShadow(
                                            360,
                                            c.colorAccentverylight,
                                            c.colorPrimaryDark)
                                        : UIHelper.circleWithColorWithShadow(
                                            360, c.white, c.white),
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(top: 0),
                                    padding: EdgeInsets.all(10),
                                    child: Image.asset(
                                      taxTypeList[i][key_img_path],
                                      height:
                                          (MediaQuery.of(context).size.height /
                                                  4) /
                                              4,
                                      width:
                                          (MediaQuery.of(context).size.height /
                                                  4) /
                                              4,
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.all(10),
                                    child: Text(
                                      prefs.getString('lang') == 'en'
                                          ? taxTypeList[i][key_taxtypedesc_en]
                                          : taxTypeList[i][key_taxtypedesc_ta],
                                      style: TextStyle(
                                          fontSize: 12,
                                          height: 1.5,
                                          color: c.grey_9),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 5),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'services'.tr().toString(),
                      style: TextStyle(
                          color: c.grey_8,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
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
                                    onTap: () {
                                      setState(() {
                                        selected_index = index;
                                        if (selected_index == 0) {
                                        } else if (selected_index == 1) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      TaxCollectionView()));
                                        } else if (selected_index == 2) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ViewReceipt()));
                                        } else if (selected_index == 3) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DownloadReceipt()));
                                        }
                                      });
                                    },
                                    child: Container(
                                      height: (Screen.height(context) / 2) - 10,
                                      width: (Screen.height(context) / 2) - 10,
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.all(10),
                                      decoration: index == selected_index
                                          ? UIHelper
                                              .roundedBorderWithColorWithShadow(
                                                  5,
                                                  c.colorAccentverylight,
                                                  c.colorPrimaryDark,
                                                  borderWidth: 0)
                                          : UIHelper
                                              .roundedBorderWithColorWithShadow(
                                                  5,
                                                  c.need_improvement2,
                                                  c.need_improvement2,
                                                  borderWidth: 0),
                                      child: Column(
                                        children: [
                                          Container(
                                            child: Image.asset(
                                              servicesList[index][key_img_path],
                                            ),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            margin: EdgeInsets.only(
                                                left: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    20,
                                                right: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    20,
                                                top: 10),
                                            padding: EdgeInsets.all(5),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            /*decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                                colors: [
                                                  index == selected_index ?c.white:c.colorPrimary,
                                                  index == selected_index ?c.white:c.colorAccentlight,
                                                ],
                                                begin: const FractionalOffset(0.0, 0.0),
                                                end: const FractionalOffset(0.0, 0.0),
                                                stops: [1.0, 0.0],
                                                tileMode: TileMode.clamp),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(2),
                                              topRight: Radius.circular(2),
                                              bottomRight: Radius.circular(150),
                                              bottomLeft: Radius.circular(150),
                                            ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black26,
                                                  offset: Offset(0.5, 0.5),
                                                  blurRadius: 0.5,
                                                )
                                              ]
                                          ),*/
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.fromLTRB(
                                                5, 10, 5, 10),
                                            child: Text(
                                              getServiceName(servicesList[index]
                                                  [key_service_name]),
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  height: 1.5,
                                                  color: index == selected_index
                                                      ? c.white
                                                      : c.grey_9),
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
            title: Text('exit_app'.tr().toString()),
            content: Text('do_you_want_to_exit_an_app'.tr().toString()),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                //return false when click on "NO"
                child: Text('no'.tr().toString()),
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
                child: Text('yes'.tr().toString()),
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
          prefs.setString("lang", "ta");
          context.setLocale(Locale('ta', 'IN'));
        });
        break;
      case 'English':
        setState(() {
          prefs.setString("lang", "en");
          context.setLocale(Locale('en', 'US'));
        });
        break;
    }
  }
}
