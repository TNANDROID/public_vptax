import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:public_vptax/Layout/screen_size.dart';
import 'package:public_vptax/Layout/ui_helper.dart';
import 'package:public_vptax/Resources/ColorsValue.dart' as c;
import 'package:public_vptax/Resources/StringsKey.dart';
import 'package:public_vptax/Services/Preferenceservices.dart';
import 'package:public_vptax/Services/locator.dart';

class WorkDetailsView extends StatefulWidget {
  const WorkDetailsView({super.key});
  @override
  State<WorkDetailsView> createState() => _WorkDetailsViewState();
}

class _WorkDetailsViewState extends State<WorkDetailsView> {
  PreferenceService preferencesService = locator<PreferenceService>();
  List<Color> colorsList = [c.followers, c.followingBg, c.colorAccentveryverylight, c.red_new];
  String selectedFinYear = "";

  List workdetailsList = [
    {"title": "Total Work", "value": "3"},
    {"title": "Not Started Work", "value": "5"},
    {"title": "Work In Progress", "value": "0"},
    {"title": "Completed Work", "value": "10"}
  ];

  //Dropdown Input Field Widget
  Widget addInputDropdownField() {
    List dropList = [];
    dropList = preferencesService.finYearList;
    return FormBuilderDropdown(
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelText: 'financialYear'.tr().toString(),
        labelStyle: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, color: c.grey_7),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: UIHelper.getInputBorder(1, borderColor: c.grey_7, radius: 3),
        focusedBorder: UIHelper.getInputBorder(1, borderColor: c.grey_7, radius: 3),
        focusedErrorBorder: UIHelper.getInputBorder(1, borderColor: Colors.red, radius: 3),
        errorBorder: UIHelper.getInputBorder(1, borderColor: Colors.red, radius: 3),
        errorStyle: TextStyle(fontSize: 10),
        contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 12), // Optional: Adjust padding
      ),
      name: 'financial_year',
      initialValue: selectedFinYear,
      iconSize: 30,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      items: dropList
          .map((item) => DropdownMenuItem(
                value: item[key_fin_year],
                child: Text(
                  item[key_fin_year].toString(),
                  style: TextStyle(fontSize: 11.0, fontWeight: FontWeight.w400, color: c.grey_9),
                ),
              ))
          .toList(),
      onChanged: (value) async {
        selectedFinYear = value.toString();
      },
    );
  }

//Card Design Widget
  Widget customizedCardDesign(int index) {
    Color borderclr = colorsList[index];
    dynamic getData = workdetailsList[index];
    return Stack(children: [
      Container(
        height: Screen.width(context) / 3.5,
        width: Screen.width(context) / 3.5,
        decoration: UIHelper.GradientContainer(30, 0, 0, 30, [c.white, c.grey_2], borderColor: borderclr, intwid: 3, stop1: 0.5, stop2: 0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [UIHelper.titleTextStyle(getData['value'], borderclr, 16, true, true), UIHelper.titleTextStyle(getData['title'], borderclr, 13, true, true)],
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
                top: BorderSide(width: 9, color: borderclr), // Top border
                right: BorderSide(width: 9, color: borderclr), // Right border
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
                bottom: BorderSide(width: 9, color: borderclr), // Top border
                left: BorderSide(width: 9, color: borderclr), // Right border
              ),
            ),
          )),
    ]);
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
            child: UIHelper.titleTextStyle("Work Details", c.text_color, 14, true, true),
          ),
          UIHelper.verticalSpaceMedium,
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Expanded(flex: 2, child: SizedBox()),
            Expanded(flex: 2, child: addInputDropdownField()),
          ]),
          UIHelper.verticalSpaceSmall,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              customizedCardDesign(0),
              customizedCardDesign(1),
            ],
          ),
          UIHelper.verticalSpaceMedium,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              customizedCardDesign(2),
              customizedCardDesign(3),
            ],
          ),
          UIHelper.verticalSpaceMedium,
        ],
      ),
    );
  }
}
