// ignore_for_file: unused_local_variable, non_constant_identifier_names, file_names, camel_case_types, prefer_typing_uninitialized_variables, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, avoid_print, library_prefixes, prefer_const_constructors, prefer_interpolation_to_compose_strings, use_build_context_synchronously, avoid_unnecessary_containers, no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:public_vptax/Layout/customgradientbutton.dart';
import 'package:public_vptax/Layout/screen_size.dart';
import 'package:public_vptax/Layout/ui_helper.dart';
import 'package:public_vptax/Resources/ColorsValue.dart' as c;
// import 'package:public_vptax/Resources/StringsKey.dart' as s;
import 'package:public_vptax/Services/Apiservices.dart';
import 'package:public_vptax/Services/Preferenceservices.dart';
import 'package:public_vptax/Services/locator.dart';
import 'package:public_vptax/Utils/utils.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => LoginState();
}

class LoginState extends State<Login> {
  Utils utils = Utils();
  ApiServices apiServices = ApiServices();
  PreferenceService preferencesService = locator<PreferenceService>();
  TextEditingController user_name = TextEditingController();
  TextEditingController user_password = TextEditingController();

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                    width: Screen.width(context),
                    height: Screen.height(context),
                    color: c.dashboard_line_light),
                Positioned(
                  bottom: Screen.height(context) * 0.08,
                  left: Screen.width(context) * 0.05,
                  right: Screen.width(context) * 0.05,
                  child: Container(
                      width: Screen.width(context) - 50,
                      height: Screen.width(context) - 50,
                      decoration: UIHelper.roundedBorderWithColorWithShadow(
                          30.0, c.white),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          inputContainer('userName'.tr().toString(),
                              TextInputType.text, user_name),
                          CustomGradientButton(
                            onPressed: () {
                              print("Btn clk");
                            },
                            width: Screen.width(context) - 100,
                            height: 50,
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                'signIN'.tr().toString(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            'signupText'.tr().toString(),
                            style: TextStyle(
                              color: c.text_color,
                              fontSize: 16,
                            ),
                          ),
                          UIHelper.verticalSpaceSmall,
                          InkWell(
                            onTap: () => {print("Sign in Tapped ")},
                            child: Text(
                              'signUP'.tr().toString(),
                              style: TextStyle(
                                color: c.sky_blue,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          UIHelper.verticalSpaceSmall,
                        ],
                      )),
                ),
              ],
            ),
          )),
    );
  }

  Widget inputContainer(String textHint, TextInputType textInputType,
      TextEditingController Controllers) {
    return Container(
      margin: EdgeInsets.all(15),
      width: Screen.width(context) - 100,
      height: 50,
      child: TextField(
        textAlign: TextAlign.center,
        controller: Controllers,
        keyboardType: textInputType,
        decoration: InputDecoration(
          hintText: textHint,
          hintStyle: TextStyle(fontSize: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
          filled: true,
          contentPadding: EdgeInsets.all(16),
          fillColor: c.inputGrey,
        ),
      ),
    );
  }
}
