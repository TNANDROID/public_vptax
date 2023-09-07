// ignore_for_file: prefer_const_constructors

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:public_vptax/Layout/screen_size.dart';
import 'package:public_vptax/Layout/ui_helper.dart';
import 'package:public_vptax/Resources/ColorsValue.dart' as c;

class AssetDetailsView extends StatefulWidget {
  const AssetDetailsView({super.key});
  @override
  State<AssetDetailsView> createState() => _AssetDetailsViewState();
}

class _AssetDetailsViewState extends State<AssetDetailsView> {
  List<Color> colorsList = [c.followers, c.followingBg, c.red_new];
  List workdetailsList = [
    {"title": "Number Of EB Connection", "value": "0"},
    {"title": "Number Of OHT Tank (Oorani/MI Tank)", "value": "0/0"},
    {"title": "Number of Roads (PUR/ VPR)", "value": "0/0"}
  ];

//Card Design Widget
  Widget customizedCardDesign(int index) {
    Color borderclr = colorsList[index];
    dynamic getData = workdetailsList[index];
    return Stack(children: [
      Container(
        height: Screen.width(context) / 4,
        width: Screen.width(context) / 4,
        padding: EdgeInsets.all(3),
        decoration: UIHelper.GradientContainer(30, 0, 0, 30, [c.white, c.grey_2], borderColor: borderclr, intwid: 1, stop1: 0.5, stop2: 0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [UIHelper.titleTextStyle(getData['title'], c.text_color, 10, true, true), UIHelper.verticalSpaceTiny, UIHelper.titleTextStyle(getData['value'], c.text_color, 14, true, true)],
        ),
      ),
      Positioned(
          top: 0,
          right: 0,
          child: Container(
            transform: Matrix4.translationValues(3.0, -3.0, 0.0),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(width: 6, color: borderclr),
                right: BorderSide(width: 6, color: borderclr),
              ),
            ),
          )),
      Positioned(
          bottom: 0,
          left: 0,
          child: Container(
            transform: Matrix4.translationValues(-3.0, 3.0, 0.0),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 6, color: borderclr),
                left: BorderSide(width: 6, color: borderclr),
              ),
            ),
          )),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Screen.width(context),
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: UIHelper.roundedBorderWithColor(15, 15, 0, 0, c.need_improvement2, borderColor: c.text_color, borderWidth: 1),
      child: Column(
        children: [
          UIHelper.verticalSpaceSmall,
          Container(
            child: UIHelper.titleTextStyle('asset_details'.tr().toString(), c.text_color, 12, true, true),
          ),
          UIHelper.verticalSpaceMedium,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              customizedCardDesign(0),
              customizedCardDesign(1),
              customizedCardDesign(2),
            ],
          ),
          UIHelper.verticalSpaceMedium,
        ],
      ),
    );
  }
}
