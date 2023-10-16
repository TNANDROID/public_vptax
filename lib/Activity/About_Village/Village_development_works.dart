// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:public_vptax/Layout/customclip.dart';
import 'package:public_vptax/Layout/screen_size.dart';
import 'package:public_vptax/Layout/ui_helper.dart';
import 'package:public_vptax/Model/startup_model.dart';
import 'package:public_vptax/Resources/ColorsValue.dart' as c;
import 'package:public_vptax/Resources/ImagePath.dart' as imagePath;
import 'package:public_vptax/Services/Preferenceservices.dart';
import 'package:public_vptax/Services/locator.dart';
import 'package:public_vptax/Utils/utils.dart';
import 'package:stacked/stacked.dart';
import 'package:public_vptax/Resources/StringsKey.dart' as s;
import '../../Layout/Read_more_or_less.dart';
import '../../Resources/StringsKey.dart';

class Villagedevelopment extends StatefulWidget {
  @override
  State<Villagedevelopment> createState() => _VillagedevelopmentState();
}

class _VillagedevelopmentState extends State<Villagedevelopment> {
  PreferenceService preferencesService = locator<PreferenceService>();
  bool isAddressShow = false;
  dynamic selectedDistrict = {};
  dynamic selectedBlock = {};
  dynamic selectedVillage = {};
  dynamic selectedFinYear = {};

  final _controller = ScrollController();
  bool cardvisibility = false;
  int selectedIndex = 1;

  List colourList = [c.text_color, c.need_improvement3, c.white];

  List workitems = [
    {'id': 0, 'name': 'total_works'.tr().toString()},
    {'id': 1, 'name': 'not_started_work'.tr().toString()},
    {'id': 2, 'name': 'work_in_progress'.tr().toString()},
    {'id': 3, 'name': 'completed_work'.tr().toString()}
  ];
  List showFlag = [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.position.atEdge) {
        bool isTop = _controller.position.pixels == 0;
        setState(() {});
      }
    });
  }

//Custom Card Design
  Widget customCardDesign() {
    String address = "";
    if (preferencesService.selectedLanguage == "en") {
      address = selectedDistrict[key_dname] + ", " + selectedBlock[key_bname] + ", " + selectedVillage[key_pvname] + ". ( " + selectedFinYear[key_fin_year] + " )";
    } else {
      address = selectedDistrict[key_dname_ta].toString().trimRight() +
          ", " +
          selectedBlock[key_bname_ta].toString().trimRight() +
          ", " +
          selectedVillage[key_pvname_ta].toString().trimRight() +
          ". ( " +
          selectedFinYear[key_fin_year] +
          " )";
    }
    return Stack(children: [
      Container(
        color: c.colorPrimary,
        height: 45,
        width: 35,
      ),
      Stack(children: [
        Container(
          decoration: UIHelper.roundedBorderWithColor(10, 30, 10, 30, c.white, borderColor: c.colorPrimary, borderWidth: 2),
          height: 35,
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.only(left: 5),
          width: Screen.width(context),
          child: Row(children: [
            Icon(
              Icons.location_on,
              size: 25,
              color: c.colorPrimary,
            ),
            SizedBox(width: Screen.width(context) / 1.5, child: Text(address, overflow: TextOverflow.visible, style: TextStyle(color: c.text_color, fontSize: 10, fontWeight: FontWeight.normal))),
          ]),
        ),
        Positioned(
            right: 0,
            child: Container(
                margin: EdgeInsets.only(top: 5),
                decoration: UIHelper.roundedBorderWithColor(0, 30, 0, 30, c.colorPrimary),
                height: 35,
                width: 40,
                child: GestureDetector(
                  onTap: () {
                    isAddressShow = false;
                    setState(() {});
                  },
                  child: Icon(
                    Icons.restart_alt,
                    size: 25,
                    color: c.white,
                  ),
                )))
      ]),
    ]);
  }

  //Dropdown Input Field Widget
  Widget addInputDropdownField(int index, String inputHint, String fieldName, StartUpViewModel model) {
    List dropList = [];
    String titleText = "";
    String titleTextTamil = "";
    dynamic initValue = {};

    if (index == 1) {
      dropList = preferencesService.districtList;
      dropList.sort((a, b) {
        return a[preferencesService.selectedLanguage == 'en' ? key_dname : key_dname_ta].compareTo(b[preferencesService.selectedLanguage == 'en' ? key_dname : key_dname_ta]);
      });
      titleText = key_dname;
      titleTextTamil = key_dname_ta;
      initValue = selectedDistrict;
    } else if (index == 2) {
      dropList = model.selectedBlockList;
      dropList.sort((a, b) {
        return a[preferencesService.selectedLanguage == 'en' ? key_bname : key_bname_ta].compareTo(b[preferencesService.selectedLanguage == 'en' ? key_bname : key_bname_ta]);
      });
      titleText = key_bname;
      titleTextTamil = key_bname_ta;
      initValue = selectedBlock;
    } else if (index == 3) {
      dropList = model.selectedVillageList;
      dropList.sort((a, b) {
        return a[preferencesService.selectedLanguage == 'en' ? key_pvname : key_pvname_ta].compareTo(b[preferencesService.selectedLanguage == 'en' ? key_pvname : key_pvname_ta]);
      });
      titleText = key_pvname;
      titleTextTamil = key_pvname_ta;
      initValue = selectedVillage;
    } else if (index == 4) {
      dropList = preferencesService.finYearList;
      titleText = key_fin_year;
      titleTextTamil = key_fin_year;
      initValue = selectedFinYear;
    } else {
      debugPrint("End.....");
    }
    return FormBuilderDropdown(
      decoration: InputDecoration(
        labelText: inputHint,
        constraints: BoxConstraints(maxHeight: 35),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelStyle: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, color: c.grey_7),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: UIHelper.getInputBorder(1, borderColor: c.grey_7, radius: 5),
        focusedBorder: UIHelper.getInputBorder(1, borderColor: c.grey_7, radius: 5),
        focusedErrorBorder: UIHelper.getInputBorder(1, borderColor: Colors.red),
        errorBorder: UIHelper.getInputBorder(1, borderColor: Colors.red),
        errorStyle: const TextStyle(fontSize: 10),
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6), // Optional: Adjust padding
      ),
      name: fieldName,
      initialValue: initValue,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: "$inputHint ${'isEmpty'.tr()}"),
      ]),
      items: dropList
          .map((item) => DropdownMenuItem(
                value: item,
                child: Text(
                  preferencesService.selectedLanguage == "en" ? item[titleText].toString() : item[titleTextTamil].toString(),
                  style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, color: c.text_color),
                  overflow: TextOverflow.ellipsis,
                ),
              ))
          .toList(),
      onChanged: (value) async {
        Utils().showProgress(context, 1);
        if (index == 1) {
          model.selectedBlockList.clear();
          model.selectedVillageList.clear();
          selectedDistrict = value;
          selectedBlock = {};
          selectedVillage = {};
          Future.delayed(Duration(milliseconds: 500), () {
            model.loadUIBlock(selectedDistrict[key_dcode].toString());
            setState(() {});
            Utils().hideProgress(context);
          });
        } else if (index == 2) {
          model.selectedVillageList.clear();
          selectedVillage = {};
          selectedBlock = value;
          Future.delayed(Duration(milliseconds: 500), () {
            model.loadUIVillage(selectedDistrict[key_dcode].toString(), selectedBlock[key_bcode].toString());

            setState(() {});
            Utils().hideProgress(context);
          });
        } else if (index == 3) {
          selectedVillage = value;
          selectedFinYear = {};
          Future.delayed(Duration(milliseconds: 200), () {
            Utils().hideProgress(context);
          });
        } else if (index == 4) {
          selectedFinYear = value;
          isAddressShow = true;
          Future.delayed(Duration(milliseconds: 200), () {
            Utils().hideProgress(context);
          });
        } else {
          debugPrint("End.....");
        }
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UIHelper.getBar('village_development_works_title'),
      body: ViewModelBuilder<StartUpViewModel>.reactive(
          onViewModelReady: (model) async {},
          builder: (context, model, child) {
            return Container(
              padding: EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  isAddressShow
                      ? Container(padding: EdgeInsets.fromLTRB(10, 5, 10, 5), child: customCardDesign())
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            UIHelper.verticalSpaceSmall,
                            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                              Expanded(flex: 2, child: addInputDropdownField(1, 'districtName'.tr().toString(), "district", model)),
                              UIHelper.horizontalSpaceSmall,
                              Expanded(flex: 2, child: model.selectedBlockList.isNotEmpty ? addInputDropdownField(2, 'blockName'.tr().toString(), "block", model) : SizedBox()),
                            ]),
                            UIHelper.verticalSpaceSmall,
                            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                              Expanded(flex: 2, child: model.selectedVillageList.isNotEmpty ? addInputDropdownField(3, 'villageName'.tr().toString(), "village", model) : SizedBox()),
                              UIHelper.horizontalSpaceSmall,
                              Expanded(flex: 2, child: selectedVillage.isNotEmpty ? addInputDropdownField(4, 'financialYear'.tr().toString(), "finYear", model) : SizedBox()),
                            ]),
                            UIHelper.verticalSpaceSmall,
                          ],
                        ),
                  selectedFinYear.isNotEmpty
                      ? _workListType(context)
                      : Center(
                          child: Column(
                          children: [
                            UIHelper.verticalSpaceLarge,
                            Image.asset(imagePath.waiting1, fit: BoxFit.contain, height: Screen.width(context) / 2, width: Screen.width(context) / 2),
                            UIHelper.verticalSpaceMedium,
                            UIHelper.titleTextStyle('waiting_input'.tr().toString(), c.text_color, 12, true, true)
                          ],
                        )),
                  UIHelper.verticalSpaceSmall,
                  Visibility(visible: selectedFinYear.isNotEmpty, child: UIHelper.titleTextStyle(workitems[selectedIndex]['name'].toString(), c.primary_text_color2, 12, false, true)),
                  Expanded(
                      child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              UIHelper.verticalSpaceSmall,
                              Visibility(visible: selectedFinYear.isNotEmpty, child: workDetailsWidget()),
                            ],
                          )))
                ],
              ),
            );
          },
          viewModelBuilder: () => StartUpViewModel()),
    );
  }

  Widget rightArrowContainerWiget(int index) {
    return Container(
      decoration: UIHelper.roundedBorderWithColor(
          index == 1 ? 10 : 0,
          0,
          index == 1 ? 10 : 0,
          0,
          selectedIndex == index
              ? colourList[1]
              : selectedIndex == index + 1
                  ? colourList[0]
                  : colourList[2],
          borderWidth: 0),
      child: InkWell(
          onTap: () {
            selectedIndex = index;
            setState(() {});
          },
          child: Row(
            children: [
              Container(
                  height: 60,
                  width: Screen.width(context) / 3.6,
                  decoration: UIHelper.roundedBorderWithColor(
                      index == 1 ? 10 : 0,
                      0,
                      index == 1 ? 10 : 0,
                      0,
                      selectedIndex == index
                          ? colourList[0]
                          : selectedIndex == index + 1
                              ? colourList[2]
                              : colourList[1]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      UIHelper.titleTextStyle(workitems[index]['name'].toString(), selectedIndex == index ? c.white : c.black, 9, false, true),
                      UIHelper.titleTextStyle("10", selectedIndex == index ? c.white : c.black, 10, true, true)
                    ],
                  )),
              Container(
                  transform: Matrix4.translationValues(-1.0, 0.0, 0.0),
                  height: 60,
                  width: 15,
                  child: Image.asset(imagePath.rightarrow,
                      color: selectedIndex == index
                          ? colourList[0]
                          : selectedIndex == index + 1
                              ? colourList[2]
                              : colourList[1],
                      fit: BoxFit.fill))
            ],
          )),
    );
  }

  Widget _workListType(BuildContext context) {
    return Column(
      children: [
        InkWell(
            onTap: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                UIHelper.titleTextStyle(workitems[0]['name'].toString(), c.text_color, 12, true, false, isUnderline: true),
                UIHelper.titleTextStyle(" : 30", c.text_color, 14, true, false),
              ],
            )),
        UIHelper.verticalSpaceSmall,
        Container(
          height: 60,
          width: Screen.width(context),
          margin: EdgeInsets.all(5),
          decoration: UIHelper.roundedBorderWithColorWithShadow(10, c.white, c.white, borderWidth: 0),
          child: Row(
            children: [
              rightArrowContainerWiget(1),
              rightArrowContainerWiget(2),
              Expanded(
                child: InkWell(
                    onTap: () {
                      selectedIndex = workitems[3]['id'];
                      setState(() {});
                    },
                    child: Container(
                        height: 60,
                        decoration: UIHelper.roundedBorderWithColor(
                            0,
                            10,
                            0,
                            10,
                            selectedIndex == 3
                                ? colourList[0]
                                : selectedIndex == 1
                                    ? colourList[2]
                                    : colourList[1]),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            UIHelper.titleTextStyle(workitems[3]['name'].toString(), selectedIndex == 3 ? c.white : c.black, 9, false, true),
                            UIHelper.titleTextStyle("10", selectedIndex == 3 ? c.white : c.black, 10, true, true)
                          ],
                        ))),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget workDetailsWidget() {
    return Container(
      child: AnimationLimiter(
        key: ValueKey(selectedIndex),
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 5,
          itemBuilder: (BuildContext context, int index) {
            int siNo = index + 1;
            return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 800),
                child: SlideAnimation(
                    horizontalOffset: 200.0,
                    child: FlipAnimation(
                        child: Container(
                            margin: EdgeInsets.fromLTRB(0, 5, 0, 10),
                            decoration: UIHelper.roundedBorderWithColorWithShadow(25, c.need_improvement1, c.need_improvement1, borderColor: Colors.transparent, borderWidth: 0),
                            child: Column(
                              children: [
                                Stack(children: [
                                  GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (showFlag.contains(index)) {
                                            showFlag.remove(index);
                                          } else {
                                            showFlag.add(index);
                                          }
                                        });
                                      },
                                      child: Container(
                                        height: 110,
                                        padding: EdgeInsets.only(left: 8),
                                        decoration: UIHelper.roundedBorderWithColorWithShadow(25, c.white, c.white, borderColor: Colors.transparent, borderWidth: 0),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 50,
                                              decoration: BoxDecoration(color: c.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(25))),
                                              child: Text(
                                                siNo.toString().length == 1 ? "0$siNo" : "$siNo",
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Expanded(
                                                child: Container(
                                                    decoration: BoxDecoration(color: c.colorPrimary, borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(25))),
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          margin: EdgeInsets.only(top: 8),
                                                          transform: Matrix4.translationValues(-10, 0, 0),
                                                          alignment: Alignment.topLeft,
                                                          child: Image.asset(
                                                            imagePath.rightarrow,
                                                            height: 25,
                                                            width: 30,
                                                            color: c.white,
                                                          ),
                                                        ),
                                                        Container(
                                                          margin: EdgeInsets.only(top: 30, left: 15, right: 10),
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Row(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  UIHelper.titleTextStyle('scheme_name'.toString().tr() + ' : ', c.white, 12, false, false),
                                                                  UIHelper.titleTextStyle('MGNREGS', c.white, 12, true, false),
                                                                ],
                                                              ),
                                                              UIHelper.verticalSpaceSmall,
                                                              Row(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  UIHelper.titleTextStyle('work_type_name'.toString().tr() + ' : ', c.white, 12, false, false),
                                                                  Expanded(child: UIHelper.titleTextStyle('Library Building Repair and Toilet Construction', c.white, 12, true, false)),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                            margin: EdgeInsets.only(right: 5, bottom: 5),
                                                            alignment: Alignment.bottomRight,
                                                            child: Icon(
                                                              showFlag.contains(index) ? Icons.expand_less_outlined : Icons.expand_more_outlined,
                                                              color: c.white,
                                                            )),
                                                      ],
                                                    ))),
                                          ],
                                        ),
                                      )),
                                  Container(
                                    margin: EdgeInsets.all(10.0),
                                    color: c.full_transparent,
                                  ),
                                ]),
                                expandedCardWidget(context, index)
                              ],
                            )))));
          },
        ),
      ),
    );
  }

  Widget keyValueRowWidget(String key, String value) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 1, child: UIHelper.titleTextStyle(key, c.grey_8, 12, false, false)),
            Expanded(flex: 0, child: UIHelper.titleTextStyle(":", c.grey_8, 12, false, false)),
            UIHelper.horizontalSpaceSmall,
            Expanded(
              flex: 1,
              child: ExpandableText(value, trimLines: 2),
            ),
          ],
        ),
        UIHelper.verticalSpaceSmall
      ],
    );
  }

  Widget expandedCardWidget(BuildContext context, int index) {
    return Visibility(
      visible: showFlag.contains(index),
      child: AnimationLimiter(
          child: Container(
              child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 1,
        itemBuilder: (context, index) {
          return Container(
            child: AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 800),
              child: SlideAnimation(
                horizontalOffset: 200.0,
                child: FlipAnimation(
                  child: Container(
                      margin: EdgeInsets.all(15),
                      child: Column(
                        children: [
                          keyValueRowWidget('work_id'.tr().toString(), "123456"),
                          keyValueRowWidget('scheme_group_name'.tr().toString(), "New Housing Work Scheme for PMAY,Housing Scheme Under"),
                          keyValueRowWidget('financial_year'.tr().toString(), "2021-2022"),
                          keyValueRowWidget('as_value'.tr().toString(), "100000"),
                          keyValueRowWidget('scheme_name'.tr().toString(), "PMAY"),
                          keyValueRowWidget('amount_spent_so_far'.tr().toString(), "50000"),
                          keyValueRowWidget('status'.tr().toString(), "Completed"),
                        ],
                      )),
                ),
              ),
            ),
          );
        },
      ))),
    );
  }
}
