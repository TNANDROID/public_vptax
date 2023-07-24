// ignore: file_names
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

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
}
