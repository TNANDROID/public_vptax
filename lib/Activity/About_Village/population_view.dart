import 'package:flutter/material.dart';
import 'package:public_vptax/Layout/screen_size.dart';
import 'package:public_vptax/Layout/ui_helper.dart';
import 'package:public_vptax/Resources/ColorsValue.dart' as c;
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:stacked/stacked.dart';

import '../../Model/startup_model.dart';

class PopulationView extends StatefulWidget {
  const PopulationView({super.key});
  @override
  State<PopulationView> createState() => _PopulationViewState();
}

class _PopulationViewState extends State<PopulationView> {
  List selectedIndexes = [];
  List<dynamic> mainPopulationList = [
    {"title": "Number of Habitations", "value": "8"},
    {"title": "Number of Streets", "value": "5"},
    {"title": "Number of Wards", "value": "3"}
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
    // TODO: implement initState
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

  Widget getPopulationDetailsIcon(int index) {
    return Container(
      padding: EdgeInsets.all(3),
      color: index == 0
          ? c.colorPrimaryDark
          : index == 1
              ? c.green_new
              : c.dot_dark_screen4,
      child: Icon(
        Icons.groups_outlined,
        size: 35,
        color: c.white,
      ),
    );
  }

  Widget keyValueRowWidget(String key, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        UIHelper.titleTextStyle("$key : ", c.grey_9, 13, false, true),
        UIHelper.titleTextStyle("$value", c.grey_9, 14, true, true),
      ],
    );
  }

  Widget populationOfScStWidsget(dynamic data) {
    return Container(
        width: Screen.width(context) / 3,
        margin: EdgeInsets.all(10),
        decoration: UIHelper.roundedBorderWithColorWithShadow(10, c.white, c.white),
        child: Column(
          children: [
            Container(
                width: Screen.width(context),
                height: 40,
                decoration: UIHelper.roundedBorderWithColor(10, 10, 0, 0, Colors.blue),
                child: Center(
                  child: UIHelper.titleTextStyle(data["title"], c.white, 14, true, true),
                )),
            Container(
                width: Screen.width(context),
                padding: EdgeInsets.all(5),
                child: Column(children: [keyValueRowWidget("Total", data['total']), keyValueRowWidget("Male", data['male']), keyValueRowWidget("Female", data['female'])])),
          ],
        ));
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
          Container(
              transform: Matrix4.translationValues(0.0, -20.0, 0.0),
              height: populationList.length * 35,
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: populationList.length,
                itemBuilder: (context, rowIndex) {
                  int siNo = rowIndex + 1;
                  dynamic habitationGetData = populationList[rowIndex];
                  return Container(
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
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(10),
      decoration: UIHelper.roundedBorderWithColor(15, 15, 0, 0, c.white, borderColor: c.text_color, borderWidth: 1),
      child: Column(
        children: [
          UIHelper.verticalSpaceSmall,
          Container(
            child: UIHelper.titleTextStyle("Habitation Details", c.grey_8, 14, true, true),
          ),
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
                                  Expanded(child: Center(child: UIHelper.titleTextStyle(getData['title'] + "\n" + getData['value'], c.grey_8, 12, false, true))),
                                ])),
                          )
                        ]),
                        Positioned(top: 0, left: 10, child: ClipRRect(borderRadius: BorderRadius.circular(5.0), child: getPopulationIcon(index))),
                      ]);
                    },
                  ))),
          UIHelper.verticalSpaceSmall,
          expandViewWidget(0, "Population Details"),
          if (selectedIndexes.contains(0))
            Container(
                width: Screen.width(context),
                padding: EdgeInsets.all(10),
                decoration: UIHelper.GradientContainer(0, 0, 10, 10, [c.grey_3, c.white]),
                child: Column(
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                      ClipRRect(borderRadius: BorderRadius.circular(5.0), child: getPopulationDetailsIcon(0)),
                      UIHelper.horizontalSpaceSmall,
                      Column(children: [
                        keyValueRowWidget("Number of Population", "1998"),
                        UIHelper.verticalSpaceTiny,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            keyValueRowWidget("Male", "1000"),
                            UIHelper.horizontalSpaceMedium,
                            keyValueRowWidget("Female", "998"),
                          ],
                        ),
                        UIHelper.verticalSpaceSmall,
                      ])
                    ]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [populationOfScStWidsget(numberPopulationList[1]), populationOfScStWidsget(numberPopulationList[2])],
                    )
                  ],
                )),
          UIHelper.verticalSpaceSmall,
          expandViewWidget(1, "Habitation Wise Population List"),
          if (selectedIndexes.contains(1)) habitationWiseTableList(),
        ],
      ),
    );
  }
}
