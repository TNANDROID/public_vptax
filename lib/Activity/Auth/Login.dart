// ignore_for_file: unused_local_variable, non_constant_identifier_names, file_names, camel_case_types, prefer_typing_uninitialized_variables, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, avoid_print, library_prefixes, prefer_const_constructors, prefer_interpolation_to_compose_strings, use_build_context_synchronously, avoid_unnecessary_containers, no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:public_tax/Layout/ui_helper.dart';
import 'package:public_tax/Resources/ColorsValue.dart' as c;
import 'package:public_tax/Resources/ImagePath.dart' as imagePath;
import 'package:public_tax/Services/Apiservices.dart';
import 'package:public_tax/Services/Preferenceservices.dart';
import 'package:public_tax/Services/locator.dart';
import 'package:public_tax/Utils/utils.dart';

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
  String userPassKey = "";
  String version = "";
  bool _passwordVisible = true;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    version = 'version'.tr().toString() + " " + await utils.getVersion();
  }

  Widget addInputFieldWidget(int index, String title) {
    return Container(
      height: 60,
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        margin: EdgeInsets.all(20),
        child: TextField(
          obscureText: index == 1 ? _passwordVisible : false,
          textAlignVertical: TextAlignVertical.center,
          controller: index == 1 ? user_password : user_name,
          style: TextStyle(fontSize: 17),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            isDense: true,
            hintText: title.tr().toString(),
            hintStyle: TextStyle(fontSize: 17.0, color: c.grey_6),
            border: InputBorder.none,
            prefixIcon: Image.asset(
              index == 1 ? imagePath.lock : imagePath.user,
              color: c.colorPrimary,
              height: 20,
              width: 20,
            ),
            prefixIconConstraints: BoxConstraints(
              minHeight: 20,
              minWidth: 30,
            ),
            suffixIcon: index == 1
                ? IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: c.grey_8,
                    ),
                    onPressed: () {
                      // Update the state i.e. toogle the state of passwordVisible variable
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  )
                : null,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: c.colorAccentverylight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                      hasScrollBody: false,
                      child: Column(children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          child: Container(
                            alignment: Alignment.center,
                            color: c.colorPrimary,
                            padding: EdgeInsets.fromLTRB(30, 40, 30, 30),
                            width: MediaQuery.of(context).size.width,
                            child: UIHelper.titleTextStyle(
                                'login', c.white, 18, true, false),
                          ),
                        ),
                        UIHelper.verticalSpaceLarge,
                        Container(
                          margin: EdgeInsets.all(20),
                          child: Image.asset(
                            imagePath.logo,
                            height: 50,
                          ),
                        ),
                        UIHelper.verticalSpaceMedium,
                        Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(16),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  UIHelper.titleTextStyle('mobileNumber',
                                      c.grey_8, 15, false, false),
                                  UIHelper.verticalSpaceTiny,
                                  addInputFieldWidget(0, 'mobileNumber'),
                                  UIHelper.verticalSpaceMedium,
                                  UIHelper.titleTextStyle(
                                      'password', c.grey_8, 15, false, false),
                                  UIHelper.verticalSpaceTiny,
                                  addInputFieldWidget(1, 'password'),
                                  Container(
                                    margin: EdgeInsets.all(20),
                                    alignment: Alignment.center,
                                    child: ElevatedButton(
                                      onPressed: () async {},
                                      child: UIHelper.titleTextStyle(
                                          'submit', c.white, 18, true, false),
                                    ),
                                  )
                                ])),
                      ])),
                ],
              ),
            ),
            Container(
                alignment: AlignmentDirectional.bottomCenter,
                child: Column(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                    child: UIHelper.titleTextStyle(
                        version, c.d_grey2, 14, true, false),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: UIHelper.titleTextStyle(
                        "software_designed_and", c.grey_8, 16, true, true),
                  ),
                ]))
          ],
        ),
      ),
    );
  }
}
