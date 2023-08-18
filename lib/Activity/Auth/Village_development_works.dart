import 'dart:async';
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:public_vptax/Layout/ui_helper.dart';
import 'package:public_vptax/Resources/ColorsValue.dart' as c;
import 'package:public_vptax/Resources/ImagePath.dart' as imagePath;
import 'package:public_vptax/Resources/StringsKey.dart' as s;
import 'package:public_vptax/Services/Preferenceservices.dart';
import 'package:public_vptax/Services/locator.dart';
import 'package:public_vptax/Utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import '../../Layout/customgradientbutton.dart';
import '../../Model/startup_model.dart';
import '../../Services/Apiservices.dart';
import '../../Utils/ContentInfo.dart';

class Villagedevelopment extends StatefulWidget {
  @override
  State<Villagedevelopment> createState() => _VillagedevelopmentState();
}
class _VillagedevelopmentState extends State<Villagedevelopment> {
  @override
  void initState() {
    super.initState();
  }
  Future<bool> _onWillPop() async {
    Navigator.of(context, rootNavigator: true).pop(context);
    return true;
  }
  @override
  Widget build (BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
      appBar: AppBar(
      backgroundColor: c.colorPrimary,
      centerTitle: true,
      elevation: 2,
      title:Container(
        child: Text(
          'work_details'.tr().toString(),
          style: TextStyle(fontSize: 14),
        ),
      ),
    ),
    body:Container()
    )
    );
}
}