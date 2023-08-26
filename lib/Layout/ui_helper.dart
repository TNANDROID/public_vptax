// ignore: file_names
// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, non_constant_identifier_names

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:public_vptax/Layout/customclip.dart';
import 'package:public_vptax/Resources/ColorsValue.dart' as c;

class UIHelper {
  // Vertically Space Provider
  static const Widget verticalSpaceTiny = SizedBox(height: 4.0);
  static const Widget verticalSpaceSmall = SizedBox(height: 10.0);
  static const Widget verticalSpaceMedium = SizedBox(height: 20.0);
  static const Widget verticalSpaceLarge = SizedBox(height: 60.0);
  static const Widget verticalSpaceVeryLarge = SizedBox(height: 80.00);

// Horizontal Space provider
  static const Widget horizontalSpaceTiny = SizedBox(width: 5.0);
  static const Widget horizontalSpaceSmall = SizedBox(width: 10.0);
  static const Widget horizontalSpaceMedium = SizedBox(width: 20.0);
  static const Widget horizontalSpaceLarge = SizedBox(width: 40.0);

// Input Box Style Provider
  static OutlineInputBorder getInputBorder(double width, {double radius = 15, Color borderColor = Colors.transparent}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      borderSide: BorderSide(color: borderColor, width: width),
    );
  }

// Text and Style Provider
  static Widget titleTextStyle(String title, Color clr, double fntsize, bool isBold, bool isCenterAliignment) {
    return Text(
      title.tr().toString(),
      style: TextStyle(
          color: clr,
          fontSize: fntsize,
          decoration: title == "swmUserCharges".tr().toString() ? TextDecoration.underline : TextDecoration.none,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
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
      {Color borderColor = Colors.transparent, double borderWidth = 1, stop1 = 0.0, double stop2 = 0.1}) {
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

//Neumorphic Container Style Provider
  static BoxDecoration NeumorphicContainer(double radius, Color clr, {Color borderColor = Colors.transparent}) {
    return BoxDecoration(color: clr, borderRadius: BorderRadius.circular(radius), boxShadow: [
      BoxShadow(
        //  color: Color(0xFFBEBEBE),
        color: Colors.black38,
        offset: Offset(8, 8),
        blurRadius: 30,
        spreadRadius: 1,
      ),
      const BoxShadow(
        color: Colors.white,
        offset: Offset(-10, -10),
        blurRadius: 30,
        spreadRadius: 5,
      ),
    ]);
  }

  //Container Style Provider with Background image
  static BoxDecoration roundedBorderWithColorWithbgImage(double radius, Color backgroundColor, String img_url,
      {Color borderColor = Colors.transparent, double borderWidth = 1, double imgOpacity = 0.2}) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(width: borderWidth, color: borderColor),
      color: backgroundColor,
      boxShadow: [
        BoxShadow(
          color: Colors.black26,
          offset: Offset(2, 2),
          blurRadius: 3.0,
        )
      ],
      image: DecorationImage(
        image: AssetImage(img_url), // Replace with your image path
        fit: BoxFit.cover, // Image fit mode
        colorFilter: ColorFilter.mode(
          Colors.white.withOpacity(imgOpacity), // Adjust opacity of the watermark
          BlendMode.dstATop,
        ),
      ),
    );
  }

//Container Style Provider with shadow
  static BoxDecoration leftBorderContainer(Color leftBorderclr, Color bottomBorderclr) {
    return BoxDecoration(
      border: Border(
        left: BorderSide(
          color: leftBorderclr, // Choose your desired border color here
          width: 5.0, // Choose your desired border width here
        ),
        bottom: BorderSide(color: bottomBorderclr, width: 2),
      ),
    );
  }

//small Line Style Provider
  static Widget tinyLinewidget({Color borderColor = const Color(0x88A5A5A5)}) {
    return Container(
      margin: EdgeInsets.only(top: 0, bottom: 6),
      color: borderColor,
      height: 1,
    );
  }
}
