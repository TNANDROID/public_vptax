// ignore: file_names
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
  static const Widget verticalSpaceVeryLarge = SizedBox(height: 100.00);

// Horizontal Space provider
  static const Widget horizontalSpaceTiny = SizedBox(width: 2.0);
  static const Widget horizontalSpaceSmall = SizedBox(width: 10.0);
  static const Widget horizontalSpaceMedium = SizedBox(width: 20.0);
  static const Widget horizontalSpaceLarge = SizedBox(width: 40.0);

// Input Box Style Provider
  static OutlineInputBorder getInputBorder(double width,
      {double radius = 15, Color borderColor = Colors.transparent}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      borderSide: BorderSide(color: borderColor, width: width),
    );
  }

// Text and Style Provider
  static Widget titleTextStyle(String title, Color clr, double fntsize,
      bool isBold, bool isCenterAliignment) {
    return Text(
      title.tr().toString(),
      style: TextStyle(
          color: clr,
          fontSize: fntsize,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
      textAlign: isCenterAliignment ? TextAlign.center : TextAlign.left,
    );
  }

//Container Style Provider
  static BoxDecoration roundedBorderWithColorWithShadow(
      double radius, Color backgroundColor,
      {Color borderColor = Colors.transparent, double borderWidth = 1}) {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(width: borderWidth, color: borderColor),
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(5, 5),
            blurRadius: 3.0,
          )
        ]);
  }

//Gradient Container Style Provider
  static BoxDecoration GradientContainer(double topleft, double topright,
      double btmleft, double btmright, List<Color> c1,
      {Color borderColor = Colors.transparent}) {
    return BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.1, 0.8],
          colors: c1),
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(topright),
          topLeft: Radius.circular(topleft),
          bottomLeft: Radius.circular(btmleft),
          bottomRight: Radius.circular(btmright)),
    );
  }

//Neumorphic Container Style Provider
  static BoxDecoration NeumorphicContainer(double radius,
      {Color borderColor = Colors.transparent}) {
    return BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          const BoxShadow(
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

  //Uneven Container Widget Provider
  static Widget unEvenContainer(double radius) {
    return ClipPath(
      clipper: CustomClip(),
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: c.colorPrimary,
        ),
        child: Center(
          child: Text(
            'Uneven Width Containers',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
