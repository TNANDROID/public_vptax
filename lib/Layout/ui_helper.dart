// ignore: file_names
// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, non_constant_identifier_names

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:public_vptax/Resources/ColorsValue.dart' as c;
import 'package:public_vptax/Resources/StringsKey.dart';
import 'package:public_vptax/Services/Preferenceservices.dart';
import 'package:public_vptax/Services/locator.dart';

class UIHelper {
  // Vertically Space Provider
  static const Widget verticalSpaceTiny = SizedBox(height: 4.0);
  static const Widget verticalSpaceSmall = SizedBox(height: 10.0);
  static const Widget verticalSpaceMedium = SizedBox(height: 20.0);
  static const Widget verticalSpaceLarge = SizedBox(height: 60.0);
  static const Widget verticalSpaceVeryLarge = SizedBox(height: 130.00);

// Horizontal Space provider
  static const Widget horizontalSpaceTiny = SizedBox(width: 5.0);
  static const Widget horizontalSpaceSmall = SizedBox(width: 10.0);
  static const Widget horizontalSpaceMedium = SizedBox(width: 20.0);
  static const Widget horizontalSpaceLarge = SizedBox(width: 40.0);

// AppBar Provider
  static AppBar getBar(String title) {
    FS fs = locator<FS>();
    return AppBar(backgroundColor: c.colorPrimary, centerTitle: true, elevation: 2, title: UIHelper.titleTextStyle(title.tr().toString(), c.white, fs.h3, true, false));
  }

// Input Box Style Provider
  static OutlineInputBorder getInputBorder(double width, {double radius = 15, Color borderColor = Colors.transparent}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      borderSide: BorderSide(color: borderColor, width: width),
    );
  }

// Text and Style Provider
  static Widget titleTextStyle(String title, Color clr, double fntsize, bool isBold, bool isCenterAliignment, {bool isUnderline = false, bool isellipsis = false}) {
    return Text(
      title.tr().toString(),
      overflow: isellipsis ? TextOverflow.ellipsis : null,
      style: TextStyle(
        color: clr,
        fontSize: fntsize,
        decoration: isUnderline ? TextDecoration.underline : TextDecoration.none,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        fontFamily: 'RobotoSlab',
      ),
      textAlign: isCenterAliignment
          ? TextAlign.center
          : title.contains("\u{20B9}")
              ? TextAlign.right
              : TextAlign.left,
    );
  }

//Container Style Provider with shadow
  static BoxDecoration roundedBorderWithColor(double topleft, double topright, double btmleft, double btmright, Color backgroundColor,
      {Color borderColor = Colors.transparent, double borderWidth = 1}) {
    return BoxDecoration(
      borderRadius: BorderRadius.only(topRight: Radius.circular(topright), topLeft: Radius.circular(topleft), bottomLeft: Radius.circular(btmleft), bottomRight: Radius.circular(btmright)),
      border: Border.all(width: borderWidth, color: borderColor),
      color: backgroundColor,
    );
  }

  static TextStyle textDecoration(double fontSize, Color fontColor, {bool bold = false}) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      color: fontColor,
      fontStyle: FontStyle.normal,
      decoration: TextDecoration.none,
      fontFamily: 'RobotoSlab',
    );
  }

//Container Style Provider with shadow
  static BoxDecoration roundedBorderWithColorWithShadow(double radius, Color backgroundColor, Color backgroundColor2,
      {Color borderColor = Colors.transparent, double borderWidth = 1, stop1 = 0.0, double stop2 = 0.7}) {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(width: borderWidth, color: borderColor),
        gradient: LinearGradient(
            colors: [
              backgroundColor,
              backgroundColor2,
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [stop1, stop2],
            tileMode: TileMode.clamp),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(2, 2),
            blurRadius: 3.0,
          )
        ]);
  }

  //Container Style Provider with shadow
  static BoxDecoration roundedBorderWithColorWithoutShadow(double radius, Color backgroundColor, Color backgroundColor2,
      {Color borderColor = Colors.transparent, double borderWidth = 1, stop1 = 0.0, double stop2 = 0.7}) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(width: borderWidth, color: borderColor),
      gradient: LinearGradient(
          colors: [
            backgroundColor,
            backgroundColor2,
          ],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(1.0, 0.0),
          stops: [stop1, stop2],
          tileMode: TileMode.clamp),
    );
  }

  static BoxDecoration circleWithColorWithShadow(double radius, Color backgroundColor, Color backgroundColor2, {Color borderColor = Colors.transparent, double borderWidth = 1}) {
    return BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(width: borderWidth, color: borderColor),
        gradient: LinearGradient(
            colors: [
              backgroundColor,
              backgroundColor2,
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(2, 2),
            blurRadius: 3.0,
          )
        ]);
  }

//Gradient Container Style Provider
  static BoxDecoration GradientContainer(double topleft, double topright, double btmleft, double btmright, List<Color> c1,
      {Color borderColor = Colors.transparent, double intwid = 0, double stop1 = 0.4, double stop2 = 0.6}) {
    return BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [
              stop1,
              stop2,
            ],
            colors: c1),
        border: Border.all(color: borderColor, width: intwid),
        borderRadius: BorderRadius.only(topRight: Radius.circular(topright), topLeft: Radius.circular(topleft), bottomLeft: Radius.circular(btmleft), bottomRight: Radius.circular(btmright)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 2),
            blurRadius: 3.0,
          )
        ]);
  }

//Container Style Provider with shadow
  static BoxDecoration BottomBorderContainer(Color bottomBorderclr) {
    return BoxDecoration(
      border: Border(
        bottom: BorderSide(color: bottomBorderclr, width: 3),
      ),
    );
  }

// *************** Sticky Header Widget ***********
  static Widget stickyHeader(var taxTypeId, String selectedLang, List data, double marginSpace) {
    PreferenceService preferencesService = locator<PreferenceService>();
    FS fs = locator<FS>();
    var TaxList = preferencesService.taxTypeList;
    String TaxHeader = '';
    for (var list in TaxList) {
      if (list[key_taxtypeid].toString() == taxTypeId) {
        TaxHeader = selectedLang == 'en' ? list[key_taxtypedesc_en] : list[key_taxtypedesc_ta];
      }
    }
    int totalCount = data.where((item) => item[key_taxtypeid] == taxTypeId).length;

    return Container(
      margin: EdgeInsets.fromLTRB(marginSpace, 10, marginSpace, 5.0),
      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      decoration: UIHelper.roundedBorderWithColor(20, 20, 20, 20, c.colorPrimary),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: UIHelper.titleTextStyle(TaxHeader, c.white, fs.h4, true, true)),
          Container(
            width: 25,
            height: 25,
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(color: c.white, border: Border.all(width: 1, color: c.white), borderRadius: BorderRadius.circular(20)),
            child: Center(
              child: UIHelper.titleTextStyle("$totalCount", c.grey_10, fs.h4, true, false),
            ),
          )
        ],
      ),
    );
  }
}
