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
  List imageUrl = ["assets/images/lamp.png", "assets/images/waterTank.png", "assets/images/road.png"];

  List workdetailsList = [
    {"title": "Number Of EB Connection", "value": "0"},
    {"title": "Number Of OHT Tank (Oorani/MI Tank)", "value": "0/0"},
    {"title": "Number of Roads (PUR/ VPR)", "value": "0/0"}
  ];

//Card Design Widget
  Widget customizedCardDesign(int index) {
    dynamic getData = workdetailsList[index];
    return Container(
      height: Screen.width(context) / 4,
      width: Screen.width(context) / 4,
      padding: EdgeInsets.all(10),
      decoration: UIHelper.roundedBorderWithColorWithbgImage(50, c.white, imageUrl[index], borderColor: c.grey_5, borderWidth: 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [UIHelper.titleTextStyle(getData['title'], c.text_color, 12, true, true), UIHelper.titleTextStyle(getData['value'], c.black, 14, true, true)],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Screen.width(context),
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(10),
      decoration: UIHelper.roundedBorderWithColor(15, 15, 0, 0, c.need_improvement2, borderColor: c.text_color, borderWidth: 1),
      child: Column(
        children: [
          UIHelper.verticalSpaceSmall,
          Container(
            child: UIHelper.titleTextStyle("Asset Details", c.text_color, 14, true, true),
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
