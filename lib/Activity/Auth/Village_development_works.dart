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

import '../../Layout/Read_more_or_less.dart';
import '../../Resources/StringsKey.dart';

class Villagedevelopment extends StatefulWidget {
  @override
  State<Villagedevelopment> createState() => _VillagedevelopmentState();
}

class _VillagedevelopmentState extends State<Villagedevelopment> {
  PreferenceService preferencesService = locator<PreferenceService>();
  String selectedLang = "";
  String selectedDistrict = "";
  String selectedBlock = "";
  String selectedVillage = "";
  String selectedFinYear = "";

  final _controller = ScrollController();
  bool cardvisibility = false;
  int selectedIndex = 0;
  List worklist = [];
  final List items = [
    '01',
    '02',
    '03',
    '04',
    '05',
  ];
  List workitems = [
    {'id': 0, 'name': 'total_works'.tr().toString()},
    {'id': 1, 'name': 'not_started_work'.tr().toString()},
    {'id': 2, 'name': 'work_in_progress'.tr().toString()},
    {'id': 3, 'name': 'completed_work'.tr().toString()},
  ];
  List showFlag = [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.position.atEdge) {
        bool isTop = _controller.position.pixels == 0;
        if (isTop) {
          setState(() {});
        } else {
          setState(() {});
        }
      }
    });
    worklist.addAll(workitems);
    print("worklist values>>>>" + worklist.toString());
  }

  //Dropdown Input Field Widget
  Widget addInputDropdownField(int index, String inputHint, String fieldName, StartUpViewModel model) {
    List dropList = [];
    String keyCode = "";
    String titleText = "";
    String titleTextTamil = "";
    String initValue = "";

    if (index == 1) {
      dropList = preferencesService.districtList;
      dropList.sort((a, b) {
        return a[selectedLang == 'en' ? key_dname : key_dname_ta].compareTo(b[selectedLang == 'en' ? key_dname : key_dname_ta]);
      });
      keyCode = key_dcode;
      titleText = key_dname;
      titleTextTamil = key_dname_ta;
      initValue = selectedDistrict;
    } else if (index == 2) {
      dropList = model.selectedBlockList;
      dropList.sort((a, b) {
        return a[selectedLang == 'en' ? key_bname : key_bname_ta].compareTo(b[selectedLang == 'en' ? key_bname : key_bname_ta]);
      });
      keyCode = key_bcode;
      titleText = key_bname;
      titleTextTamil = key_bname_ta;
      initValue = selectedBlock;
    } else if (index == 3) {
      dropList = model.selectedVillageList;
      dropList.sort((a, b) {
        return a[selectedLang == 'en' ? key_pvname : key_pvname_ta].compareTo(b[selectedLang == 'en' ? key_pvname : key_pvname_ta]);
      });
      keyCode = key_pvcode;
      titleText = key_pvname;
      titleTextTamil = key_pvname_ta;
      initValue = selectedVillage;
    } else if (index == 4) {
      dropList = preferencesService.finYearList;
      keyCode = key_fin_year;
      titleText = key_fin_year;
      titleTextTamil = key_fin_year;
      initValue = selectedFinYear;
    } else {
      print("End.....");
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
                value: item[keyCode],
                child: Text(
                  selectedLang == "en" ? item[titleText].toString() : item[titleTextTamil].toString(),
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
          selectedDistrict = value.toString();
          selectedBlock = "";
          selectedVillage = "";
          Future.delayed(Duration(milliseconds: 500), () {
            model.loadUIBlock(selectedDistrict);
            setState(() {});
            Utils().hideProgress(context);
          });
        } else if (index == 2) {
          model.selectedVillageList.clear();
          selectedVillage = "";
          selectedBlock = value.toString();
          Future.delayed(Duration(milliseconds: 500), () {
            model.loadUIVillage(selectedDistrict, selectedBlock);

            setState(() {});
            Utils().hideProgress(context);
          });
        } else if (index == 3) {
          selectedVillage = value.toString();
          Future.delayed(Duration(milliseconds: 200), () {
            Utils().hideProgress(context);
          });
        } else if (index == 4) {
          selectedFinYear = value.toString();
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
      appBar: AppBar(
        backgroundColor: c.colorPrimary,
        centerTitle: true,
        elevation: 2,
        title: Container(
          child: Text(
            'work_details'.tr().toString(),
            style: TextStyle(fontSize: 14),
          ),
        ),
      ),
      body: ViewModelBuilder<StartUpViewModel>.reactive(
          onViewModelReady: (model) async {},
          builder: (context, model, child) {
            return Container(
              padding: EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
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
                  Expanded(
                      child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              selectedFinYear.isNotEmpty
                                  ? _workListType(context)
                                  : Center(
                                      child: Column(
                                      children: [
                                        UIHelper.verticalSpaceLarge,
                                        Image.asset(imagePath.waitingImg, fit: BoxFit.contain, height: Screen.width(context) / 2, width: Screen.width(context) / 2),
                                        UIHelper.verticalSpaceMedium,
                                        UIHelper.titleTextStyle('waiting_input'.tr().toString(), c.text_color, 12, true, true)
                                      ],
                                    )),
                              UIHelper.verticalSpaceMedium,
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

  Widget _workListType(BuildContext context) {
    return Container(
        height: 58,
        decoration: UIHelper.roundedBorderWithColor(0, 0, 0, 0, c.colorPrimary, borderWidth: 1),
        width: Screen.width(context),
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: workitems.length,
            itemBuilder: (context, rowIndex) {
              int cnvasIndex = selectedIndex - 1;
              return Container(
                  decoration: BoxDecoration(
                    color: c.white,
                  ),
                  child: Row(children: [
                    InkWell(
                      onTap: () {
                        selectedIndex = rowIndex;
                        setState(() {
                          cardvisibility = true;
                        });
                      },
                      child: Container(
                          width: 150,
                          height: 58,
                          color: cnvasIndex == rowIndex ? c.colorPrimary : c.white,
                          child: CustomPaint(
                            foregroundPainter: BorderPainter(),
                            child: ClipPath(
                              clipper: RightTriangleClipper(),
                              child: Container(
                                  width: 150,
                                  height: 58,
                                  padding: EdgeInsets.only(top: 10, left: 0, right: 20),
                                  decoration: selectedIndex == rowIndex
                                      ? UIHelper.roundedBorderWithColorWithShadow(0, c.colorPrimary, c.colorPrimary)
                                      : UIHelper.roundedBorderWithColorWithShadow(0, c.white, c.white),
                                  child: UIHelper.titleTextStyle(workitems[rowIndex]['name'].toString() + "\n 10", selectedIndex == rowIndex ? c.white : c.primary_text_color2, 10, false, true)),
                            ),
                          )),
                    )
                  ]));
            }));
  }

  Widget workDetailsWidget() {
    return Column(
      children: [
        UIHelper.titleTextStyle(workitems[selectedIndex]['name'].toString(), c.primary_text_color2, 14, false, true),
        Container(
          child: AnimationLimiter(
            key: ValueKey(selectedIndex),
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 800),
                    child: SlideAnimation(
                        horizontalOffset: 200.0,
                        child: FlipAnimation(
                            child: Container(
                                margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
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
                                                    items[index],
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                Expanded(
                                                    child: Container(
                                                        decoration:
                                                            BoxDecoration(color: c.colorPrimary, borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(25))),
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
                                                                      UIHelper.titleTextStyle('Scheme Name : ', c.white, 12, false, false),
                                                                      UIHelper.titleTextStyle('MGNREGS', c.white, 12, true, false),
                                                                    ],
                                                                  ),
                                                                  UIHelper.verticalSpaceSmall,
                                                                  Row(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      UIHelper.titleTextStyle('Work Type Name : ', c.white, 12, false, false),
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
        )
      ],
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
              child: ExpandableText(value, trimLines: 2, txtcolor: "2"),
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
