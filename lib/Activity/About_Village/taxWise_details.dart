// ignore_for_file: file_names, prefer_const_constructors

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:public_vptax/Layout/screen_size.dart';
import 'package:public_vptax/Layout/ui_helper.dart';
import 'package:public_vptax/Resources/ColorsValue.dart' as c;
import 'package:public_vptax/Resources/StringsKey.dart';
import 'package:public_vptax/Services/Preferenceservices.dart';
import 'package:public_vptax/Services/locator.dart';
import 'package:public_vptax/Resources/ImagePath.dart' as imagepath;

class DCBView extends StatefulWidget {
  const DCBView({super.key});
  @override
  State<DCBView> createState() => _DCBViewState();
}

class _DCBViewState extends State<DCBView> {
  PreferenceService preferencesService = locator<PreferenceService>();
  List<Color> colorsList = [c.followers, c.need_improvement_color, c.followingBg, c.colorPrimaryDark, c.dot_light_screen1];
  List imgList = [imagepath.house, imagepath.water, imagepath.professional, imagepath.nontax1, imagepath.trade];

  String selectedFinYear = "";

  List taxDetailList = [
    {"title": "Property Tax", "demand": "1000", "collection": "700", "balance": "300"},
    {"title": "Water Charges", "demand": "1500", "collection": "1100", "balance": "400"},
    {"title": "Professional Tax", "demand": "2000", "collection": "1500", "balance": "500"},
    {"title": "Non Tax", "demand": "3000", "collection": "2400", "balance": "600"},
    {"title": "Trade License", "demand": "5000", "collection": "4300", "balance": "700"}
  ];

  //Dropdown Input Field Widget
  Widget addInputDropdownField() {
    List dropList = [];
    dropList = preferencesService.finYearList;
    return FormBuilderDropdown(
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.never,
        constraints: BoxConstraints(maxHeight: 35),
        labelText: 'financialYear'.tr().toString(),
        labelStyle: TextStyle(fontSize: 10.0, fontWeight: FontWeight.w400, color: c.grey_7),
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
      autovalidateMode: AutovalidateMode.onUserInteraction,
      items: dropList
          .map((item) => DropdownMenuItem(
                value: item[key_fin_year],
                child: Text(
                  item[key_fin_year].toString(),
                  style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.w400, color: c.grey_9),
                ),
              ))
          .toList(),
      onChanged: (value) async {
        selectedFinYear = value.toString();
      },
    );
  }

  Widget keyValueRowWidget(String key, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        UIHelper.titleTextStyle("$key : ", c.white, 11, false, true),
        UIHelper.titleTextStyle(value, c.white, 11, true, true),
      ],
    );
  }

//Card Design Widget
  Widget customizedCardDesign(int index, dynamic data) {
    Color borderclr = colorsList[index];
    String imgUrl = imgList[index];
    return Stack(children: [
      Container(
          height: 100,
          width: Screen.width(context),
          padding: EdgeInsets.all(4),
          decoration: UIHelper.roundedBorderWithColor(120, 15, 120, 15, c.white, borderColor: c.grey_4, borderWidth: 3),
          child: Container(
            height: 100,
            width: Screen.width(context),
            padding: EdgeInsets.fromLTRB(60, 5, 15, 5),
            decoration: UIHelper.roundedBorderWithColor(120, 15, 120, 15, borderclr),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                UIHelper.titleTextStyle(data['title'], c.white, 12, true, true),
                UIHelper.verticalSpaceSmall,
                SizedBox(
                    width: Screen.width(context) / 3,
                    child: Column(
                      children: [
                        keyValueRowWidget("Demand", data['demand']),
                        keyValueRowWidget("Collection", data['collection']),
                        keyValueRowWidget("Balance", data['balance']),
                      ],
                    ))
              ],
            ),
          )),
      ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Container(
              color: c.white,
              padding: EdgeInsets.all(5),
              width: 100,
              height: 100,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                      color: borderclr,
                      padding: EdgeInsets.all(5),
                      width: 100,
                      height: 100,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Container(
                              color: c.white,
                              width: 100,
                              height: 100,
                              padding: EdgeInsets.all(10),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.asset(
                                    imgUrl,
                                    fit: BoxFit.contain,
                                    height: 80,
                                    width: 80,
                                  )))))))),
    ]);
  }

  Widget taxDetailListWidget() {
    return SizedBox(
        height: taxDetailList.length * 110,
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: taxDetailList.length,
          itemBuilder: (context, rowIndex) {
            return Column(
              children: [
                customizedCardDesign(rowIndex, taxDetailList[rowIndex]),
                UIHelper.verticalSpaceSmall,
              ],
            );
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Screen.width(context),
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: UIHelper.roundedBorderWithColor(15, 15, 0, 0, c.need_improvement2, borderColor: c.text_color, borderWidth: 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UIHelper.verticalSpaceSmall,
          Center(
              child: Container(
            child: UIHelper.titleTextStyle('financial_situation'.tr().toString(), c.text_color, 12, true, true),
          )),
          UIHelper.verticalSpaceMedium,
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Expanded(flex: 2, child: SizedBox()),
            Expanded(flex: 2, child: addInputDropdownField()),
          ]),
          UIHelper.verticalSpaceSmall,
          taxDetailListWidget(),
        ],
      ),
    );
  }
}
