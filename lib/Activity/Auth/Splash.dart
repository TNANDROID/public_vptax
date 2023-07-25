// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:public_vptax/Layout/ui_helper.dart';
import '../../Resources/StringsKey.dart' as s;
import 'package:public_vptax/Resources/ColorsValue.dart' as c;
import 'package:public_vptax/Resources/ImagePath.dart' as imagepath;
import 'package:public_vptax/Utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Layout/screen_size.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Utils utils = Utils();
  late SharedPreferences prefs;
  final LocalAuthentication auth = LocalAuthentication();

  String selectedLanguage = s.selectLang;

  var langItems = [
    s.selectLang,
    'English',
    'தமிழ்',
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              height: Screen.height(context) / 4,
              padding: const EdgeInsets.all(15),
              child: Align(
                alignment: Alignment.topRight,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    elevation: 0,
                    isExpanded: false,
                    value: selectedLanguage,
                    icon: const Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Icon(
                          Icons.arrow_downward_rounded,
                          size: 15,
                        )),
                    style: TextStyle(
                      color: c.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    items: langItems.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedLanguage = newValue!;
                      });
                    },
                  ),
                ),
              ),
            ),

            //  ****************** App Name  ****************** //

            Text(
              s.appName,
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
                color: c.grey_10,
                fontStyle: FontStyle.normal,
                decorationColor: Colors.red,
                decorationStyle: TextDecorationStyle.wavy,
              ),
            ),
            UIHelper.verticalSpaceMedium,

            //  ****************** Qucik Action Buttons  ****************** //

            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () => {print("Sign in Tapped ")},
                      child: Container(
                        width: Screen.width(context) / 2.5,
                        height: 50,
                        decoration: BoxDecoration(
                          color: c.splashBtn,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset(
                                imagepath.login,
                                width: 30,
                                height: 30,
                              ),
                              Text(
                                s.signIn,
                                style: TextStyle(
                                  color: c.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  decorationStyle: TextDecorationStyle.wavy,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    UIHelper.horizontalSpaceMedium,
                    InkWell(
                      onTap: () => {print("Quick Pay Tapped ")},
                      child: Container(
                        width: Screen.width(context) / 2.5,
                        height: 50,
                        decoration: BoxDecoration(
                          color: c.splashBtn,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset(
                                imagepath.pay,
                                width: 30,
                                height: 30,
                              ),
                              Text(
                                s.pay,
                                style: TextStyle(
                                  color: c.white,
                                  fontWeight: FontWeight.bold,
                                  decorationStyle: TextDecorationStyle.wavy,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                UIHelper.verticalSpaceMedium,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      s.signupText,
                      style: TextStyle(
                        color: c.text_color,
                        fontSize: 16,
                      ),
                    ),
                    UIHelper.horizontalSpaceSmall,
                    InkWell(
                      onTap: () => {print("Sign in Tapped ")},
                      child: Text(
                        s.signIn,
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

            //  ****************** Image Container  ****************** //

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
    );
  }
}
