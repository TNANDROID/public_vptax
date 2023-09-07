// ignore_for_file: prefer_const_constructors

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:public_vptax/Layout/screen_size.dart';
import 'package:public_vptax/Layout/ui_helper.dart';
import 'package:public_vptax/Resources/ColorsValue.dart' as c;
import 'package:responsive_grid_list/responsive_grid_list.dart';

class habitationView extends StatefulWidget {
  const habitationView({super.key});
  @override
  State<habitationView> createState() => _habitationViewState();
}

class _habitationViewState extends State<habitationView> {
  List<dynamic> mainPopulationList = [
    {"title": "Number of Habitations", "value": "8"},
    {"title": "Number of Streets", "value": "5"},
    {"title": "Number of Wards", "value": "3"}
  ];

  Widget getPopulationIcon(int index) {
    return Container(
      padding: EdgeInsets.all(3),
      color: index == 0
          ? c.colorPrimaryDark
          : index == 1
              ? c.green_new
              : c.dot_dark_screen4,
      child: Icon(
        index == 0
            ? Icons.domain_add_outlined
            : index == 1
                ? Icons.add_road_outlined
                : Icons.home_outlined,
        size: 25,
        color: c.white,
      ),
    );
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
            child: UIHelper.titleTextStyle('habitation_details'.tr().toString(), c.text_color, 12, true, true),
          ),
          UIHelper.verticalSpaceMedium,
          Container(
              height: 130,
              child: ResponsiveGridList(
                  listViewBuilderOptions: ListViewBuilderOptions(physics: NeverScrollableScrollPhysics()),
                  horizontalGridMargin: 0,
                  verticalGridMargin: 0,
                  minItemWidth: Screen.width(context) / 5,
                  children: List.generate(
                    mainPopulationList.length,
                    (index) {
                      dynamic getData = mainPopulationList[index];
                      return Stack(children: [
                        Column(children: [
                          SizedBox(height: 15),
                          Container(
                            decoration: UIHelper.roundedBorderWithColorWithShadow(10, c.white, c.white, borderColor: c.grey_2),
                            height: 85,
                            child: Container(
                                padding: EdgeInsets.all(5),
                                child: Row(children: [
                                  Expanded(
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [UIHelper.titleTextStyle(getData['title'], c.grey_8, 12, false, true), UIHelper.titleTextStyle(getData['value'], c.grey_9, 14, true, true)]),
                                  ),
                                ])),
                          )
                        ]),
                        Positioned(top: 0, left: 10, child: ClipRRect(borderRadius: BorderRadius.circular(5.0), child: getPopulationIcon(index))),
                      ]);
                    },
                  ))),
        ],
      ),
    );
  }
}
