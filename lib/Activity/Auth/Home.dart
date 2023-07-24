
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:public_vptax/Resources/ImagePath.dart' as imagePath;
import 'package:public_vptax/Resources/ColorsValue.dart' as c;
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


  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    prefs = await SharedPreferences.getInstance();
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
          appBar: PreferredSize(
            preferredSize: AppBar().preferredSize,
            child: Container(
              padding: EdgeInsets.only(top: 30,bottom: 10,right: 20),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                    topLeft: Radius.circular(0),
                    topRight: Radius.circular(0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 3.0,
                  ),
                ],
                gradient: LinearGradient(
                    colors: [
                      const Color(0xFF3366FF),
                      const Color(0xFF00CCFF),
                    ],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
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
                        return {'Tamil', 'English'}.map((String choice) {
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
            child: Column(children: [
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
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20)),
                gradient: LinearGradient(
                    colors: [
                      const Color(0xFF3366FF),
                      const Color(0xFF00CCFF),
                    ],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
              child:
            Text(
            textAlign: TextAlign.center,
            'appName'.tr().toString(),
            style: TextStyle(
                color: c.white,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          ),
          ),
          ]),
              Container(child: Text(
                textAlign: TextAlign.left,
                'lang'.tr().toString(),
                style: TextStyle(
                    color: c.grey_8,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),)
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
      case 'Tamil':
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
