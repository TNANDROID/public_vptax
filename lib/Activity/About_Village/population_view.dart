// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:public_vptax/Layout/screen_size.dart';
import 'package:public_vptax/Layout/ui_helper.dart';
import 'package:public_vptax/Resources/ColorsValue.dart' as c;

class PopulationView extends StatefulWidget {
  const PopulationView({super.key});
  @override
  State<PopulationView> createState() => _PopulationViewState();
}

class _PopulationViewState extends State<PopulationView> {
  List selectedIndexes = [];
  List colourList = [
    {"c1": Color(0xFF2E3192), "c2": Color(0xFF1BFFFF)},
    {"c1": Color(0xFFD4145A), "c2": Color(0xFFFBB03B)},
    {"c1": Color(0xFF11998E), "c2": Color(0xFF38EF7D)},
    {"c1": Color(0xFF662D8C), "c2": Color(0xFFED1E79)},
    {"c1": Color(0xFF596164), "c2": Color(0xFFEE9CA7)},
    {"c1": Color(0xFF614385), "c2": Color(0xFF516395)},
    {"c1": Color(0xFFFF5F6D), "c2": Color(0xFFFFC371)},
    {"c1": Color(0xFF1EAE98), "c2": Color(0xFFD8B5FF)},
    {"c1": Color(0xFF09203F), "c2": Color(0xFF537895)}
  ];
  List<dynamic> numberPopulationList = [
    {"title": "Number of Population", "total": "1000", "male": "600", "female": "400"},
    {"title": "SC Population", "total": "600", "male": "400", "female": "200"},
    {"title": "ST Population", "total": "400", "male": "250", "female": "150"}
  ];

  List<dynamic> populationList = [
    {"habitation": "Kavarangulam", "total": "1000", "male": "600", "female": "400"},
    {"habitation": "Paappakudi", "total": "600", "male": "400", "female": "200"},
    {"habitation": "Thoruvaloor", "total": "400", "male": "250", "female": "150"}
  ];

  @override
  void initState() {
    super.initState();
    int total = 0;
    int maleTotal = 0;
    int femaleTotal = 0;
    for (var item in populationList) {
      total = total + int.parse(item['total']);
      maleTotal = maleTotal + int.parse(item['male']);
      femaleTotal = femaleTotal + int.parse(item['female']);
    }
    dynamic totalData = {'habitation': "", 'total': "$total", 'male': '$maleTotal', 'female': '$femaleTotal'};
    populationList.add(totalData);
  }

  Widget expandViewWidget(int index, String title) {
    return GestureDetector(
        onTap: () {
          if (selectedIndexes.contains(index)) {
            selectedIndexes.remove(index);
          } else {
            selectedIndexes.add(index);
          }
          setState(() {});
        },
        child: Container(
          color: c.text_color,
          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            UIHelper.titleTextStyle(title, c.white, 14, true, true),
            Icon(
              selectedIndexes.contains(index) ? Icons.expand_less_outlined : Icons.expand_more_outlined,
              color: c.white,
            )
          ]),
        ));
  }

  Widget customCardDesign(int index, String title, String Value) {
    return Column(children: [
      Opacity(
          opacity: 0.7, // Set the desired opacity here
          child: Container(
            decoration: UIHelper.roundedBorderWithColorWithShadow(15, colourList[index]['c1'], colourList[index]['c2']),
            height: 85,
            width: Screen.width(context) / 3.8,
            child: Row(children: [
              Expanded(
                child: UIHelper.titleTextStyle(title, c.white, 14, true, true),
              ),
            ]),
          )),
      Container(
        transform: Matrix4.translationValues(0.0, -20.0, 0.0),
        decoration: UIHelper.roundedBorderWithColorWithShadow(10, c.white, c.white, borderColor: colourList[index]['c2'], borderWidth: 2),
        height: 45,
        width: Screen.width(context) / 4.8,
        child: Row(children: [
          Expanded(
            child: UIHelper.titleTextStyle(Value, colourList[index]['c1'], 14, true, true),
          ),
        ]),
      )
    ]);
  }

  Widget habitationWiseTableList() {
    return Container(
        decoration: UIHelper.GradientContainer(0, 0, 10, 10, [c.white, c.grey_3]),
        child: Column(children: [
          SizedBox(
              child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(padding: EdgeInsets.all(5), child: Center(child: UIHelper.titleTextStyle("SI No", c.grey_9, 12, true, true))),
              ),
              Expanded(flex: 2, child: Container(padding: EdgeInsets.all(5), child: Center(child: UIHelper.titleTextStyle("Habitation\nName", c.grey_9, 12, true, false)))),
              Expanded(flex: 1, child: Container(padding: EdgeInsets.all(5), child: Center(child: UIHelper.titleTextStyle("Total", c.grey_9, 12, true, true)))),
              Expanded(flex: 1, child: Container(padding: EdgeInsets.all(5), child: Center(child: UIHelper.titleTextStyle("Male", c.grey_9, 12, true, true)))),
              Expanded(flex: 1, child: Container(padding: EdgeInsets.all(5), child: Center(child: UIHelper.titleTextStyle("Female", c.grey_9, 12, true, true)))),
            ],
          )),
          UIHelper.verticalSpaceMedium,
          Container(
              transform: Matrix4.translationValues(0.0, -20.0, 0.0),
              height: populationList.length * 35,
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: populationList.length,
                itemBuilder: (context, rowIndex) {
                  int siNo = rowIndex + 1;
                  dynamic habitationGetData = populationList[rowIndex];
                  return SizedBox(
                      height: 30,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(padding: EdgeInsets.all(3), child: Center(child: UIHelper.titleTextStyle(populationList.length == siNo ? "" : "$siNo", c.grey_8, 12, false, true))),
                          ),
                          Expanded(flex: 2, child: Container(padding: EdgeInsets.all(3), child: Center(child: UIHelper.titleTextStyle(habitationGetData['habitation'], c.grey_8, 12, false, true)))),
                          Expanded(flex: 1, child: Container(padding: EdgeInsets.all(3), child: Center(child: UIHelper.titleTextStyle(habitationGetData['total'], c.grey_8, 12, true, true)))),
                          Expanded(flex: 1, child: Container(padding: EdgeInsets.all(3), child: Center(child: UIHelper.titleTextStyle(habitationGetData['male'], c.grey_8, 12, true, true)))),
                          Expanded(flex: 1, child: Container(padding: EdgeInsets.all(3), child: Center(child: UIHelper.titleTextStyle(habitationGetData['female'], c.grey_8, 12, true, true)))),
                        ],
                      ));
                },
              ))
        ]));
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
            child: UIHelper.titleTextStyle('population_details'.tr().toString(), c.text_color, 14, true, true),
          ),
          UIHelper.verticalSpaceMedium,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              customCardDesign(0, numberPopulationList[0]['title'], numberPopulationList[0]['total']),
              customCardDesign(1, "Male", numberPopulationList[0]['male']),
              customCardDesign(2, "Female", numberPopulationList[0]['female']),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              customCardDesign(3, numberPopulationList[1]['title'], numberPopulationList[1]['total']),
              customCardDesign(4, "Male", numberPopulationList[1]['male']),
              customCardDesign(5, "Female", numberPopulationList[1]['female']),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              customCardDesign(6, numberPopulationList[2]['title'], numberPopulationList[2]['total']),
              customCardDesign(7, "Male", numberPopulationList[2]['male']),
              customCardDesign(8, "Female", numberPopulationList[2]['female']),
            ],
          ),
          UIHelper.verticalSpaceMedium,
          expandViewWidget(1, 'population_list'.tr().toString()),
          if (selectedIndexes.contains(1)) habitationWiseTableList(),
          UIHelper.verticalSpaceMedium,
        ],
      ),
    );
  }
}
