
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:public_vptax/Layout/ui_helper.dart';
import 'package:public_vptax/Resources/ImagePath.dart' as imagePath;
import 'package:public_vptax/Resources/ColorsValue.dart' as c;
import 'package:public_vptax/Resources/StringsKey.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Utils/utils.dart';

class Home extends StatefulWidget {
  const Home({super.key, required isLogin});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Utils utils = Utils();
  late SharedPreferences prefs;
  List taxTypeList=[];
  int _index = 0;


  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    prefs = await SharedPreferences.getInstance();

    List list=[{'taxtypeid':'1','taxtypedesc_en':'House Tax','taxtypedesc_ta':'வீட்டு வரி'},
      {'taxtypeid':'2','taxtypedesc_en':'Water Tax','taxtypedesc_ta':'குடிநீர் கட்டணங்கள்'},
      {'taxtypeid':'3','taxtypedesc_en':'Professional Tax','taxtypedesc_ta':'தொழில் வரி'},
      {'taxtypeid':'4','taxtypedesc_en':'Non Tax','taxtypedesc_ta':'இதர வரவினங்கள்'},
      {'taxtypeid':'5','taxtypedesc_en':'Trade Licence','taxtypedesc_ta':'வர்த்தக உரிமம்'},
    ];
    taxTypeList.clear();
     for (var item in list) {
      switch (item['taxtypeid']) {
        case "1":
          item['img_path'] = imagePath.property;
          break;
        case "2":
          item['img_path'] = imagePath.water;
          break;
        case "3":
          item['img_path'] = imagePath.professional;
          break;
        case "4":
          item['img_path'] = imagePath.nontax;
          break;
        case "5":
          item['img_path'] = imagePath.trade;
          break;
        default:
          item['img_path'] = imagePath.property;
      }
    }
    taxTypeList.addAll(list);
     print("tax>>"+taxTypeList.toString());



    setState(() {
      prefs.getString("lang")!= null &&  prefs.getString("lang")!="" &&  prefs.getString("lang")=="en"?
      context.setLocale(Locale('en', 'US')):
      context.setLocale(Locale('ta', 'IN'));

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
              padding: EdgeInsets.only(top: 30,bottom: 10,right: 20),
              decoration: UIHelper.GradientContainer(
                  0, 0, 30, 30, [c.colorAccentlight, c.colorPrimaryDark]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child:PopupMenuButton<String>(
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
                        style: TextStyle(fontSize: 15,color: c.white,),
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
              )

            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            Row(
                children: [
            Container(
            margin: EdgeInsets.all(20),
            child: Image.asset(
              imagePath.tamilnadu_logo,
              height: MediaQuery.of(context).size.height/10,
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 10,bottom: 10),
              decoration: UIHelper.GradientContainer(
                  20, 0, 20, 0, [c.colorAccentlight,c.colorPrimaryDark]),
              child:
            Text(
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
                padding: EdgeInsets.only(left: 10,right: 10),
                alignment: Alignment.centerLeft,
                child: Text(
                'tax_types'.tr().toString(),
                style: TextStyle(
                    color: c.grey_8,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),),
                Container(
                  height: 150,
                    margin: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                  child: PageView.builder(
                  itemCount: taxTypeList == null ? 0 : taxTypeList.length,
                  controller: PageController(viewportFraction: 0.5),
                  padEnds: _index ==0?false:true,
                  onPageChanged: (int index) => setState(() => _index = index),
                  itemBuilder: (_, i) {
                    return   Transform.scale(
                      scale: i == _index ? 1 : 0.9,
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(10),
                        decoration: i == _index ?UIHelper.roundedBorderWithColorWithShadow(10,c.colorAccentverylight,c.colorPrimaryDark):UIHelper.roundedBorderWithColorWithShadow(10,c.white,c.white),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                          Image.asset(
                            taxTypeList[i][key_img_path],
                            height: 50,
                            width:50,
                          ),
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.all(10),
                              child: Text(
                            prefs.getString('lang')=='en'?taxTypeList[i][key_taxtypedesc_en]:taxTypeList[i][key_taxtypedesc_ta],
                            style: TextStyle(fontSize: 14,height: 1.5),
                            textAlign: TextAlign.center,
                          ),
                          ),
                        ],),
                      ),
                    );

                  },
                  )),

            ],),
          ),

        ));
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
