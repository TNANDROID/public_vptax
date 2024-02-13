// ignore_for_file: library_prefixes, prefer_const_constructors_in_immutables, library_private_types_in_public_api, prefer_typing_uninitialized_variables, prefer_const_constructors, avoid_print, deprecated_member_use, use_build_context_synchronously, file_names, non_constant_identifier_names, use_key_in_widget_constructors, prefer_adjacent_string_concatenation, avoid_function_literals_in_foreach_calls

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:public_vptax/Layout/custom_dropdown.dart' as custom;
import 'package:grouped_list/grouped_list.dart';
import 'package:public_vptax/Activity/Tax_Collection/taxCollection_view_request_screen.dart';
import 'package:public_vptax/Activity/Transaction/CheckTransaction.dart';
import 'package:public_vptax/Layout/screen_size.dart';
import 'package:public_vptax/Layout/ui_helper.dart';
import 'package:public_vptax/Model/startup_model.dart';
import 'package:public_vptax/Resources/ColorsValue.dart' as c;
import 'package:public_vptax/Resources/ImagePath.dart' as imagePath;
import 'package:public_vptax/Resources/StringsKey.dart';
import 'package:public_vptax/Services/Preferenceservices.dart';
import 'package:public_vptax/Services/locator.dart';
import 'package:public_vptax/Utils/ContentInfo.dart';
import 'package:public_vptax/Utils/utils.dart';
import 'package:public_vptax/stream/extended_asyncwidgets.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:stacked/stacked.dart';

class AllYourTaxDetails extends StatefulWidget {
  final isHome;
  final selectedTaxTypeData;
  AllYourTaxDetails({this.selectedTaxTypeData, this.isHome});

  @override
  _AllYourTaxDetailsState createState() => _AllYourTaxDetailsState();
}

class _AllYourTaxDetailsState extends State<AllYourTaxDetails> with TickerProviderStateMixin {
  //Animation
  late AnimationController _controller;
  late Animation<double> _animation;
  PreferenceService preferencesService = locator<PreferenceService>();
  FS fs = locator<FS>();
  dynamic requestJson = {key_service_id: service_key_getAllTaxAssessmentList};
  List isSelectAll = [];
  List isShowFlag = [];
  List mainList = [];
  List sourceList = [];
  List taxTypeList = [];
  var selectedTaxTypeData;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    if (widget.isHome) {
      selectedTaxTypeData = widget.selectedTaxTypeData;
    } else {
      dynamic val = {key_taxtypeid: 0, key_taxtypedesc_en: "All Taxes", key_taxtypedesc_ta: "அனைத்து வரிகள்", key_img_path: imagePath.all};
      taxTypeList.add(val);
      taxTypeList.addAll(preferencesService.taxTypeList);
      selectedTaxTypeData = taxTypeList[0];
    }

    // Create a curved animation with Curves.bounceOut
    _animation = CurvedAnimation(parent: _controller, curve: Curves.bounceOut);

    // Add a listener to rebuild the widget when the animation value changes
    _animation.addListener(() {
      setState(() {});
    });

    // Start the animation
    _controller.forward();
    initialize();
  }

  void repeatOnce() {
    _controller.reset();
    _controller.forward();
  }

  Future<void> initialize() async {
    requestJson[key_mobile_number] = await preferencesService.getString(key_mobile_number);
    print(">>>${requestJson[key_mobile_number]}");
    requestJson[key_language_name] = preferencesService.selectedLanguage;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  // ********* Main Widget for this Class **********
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: c.white,
        appBar: UIHelper.getBar('tax_details_yours'),
        body: ViewModelBuilder<StartUpViewModel>.reactive(
            onModelReady: (model) async {},
            builder: (context, model, child) {
              return Container(
                  color: c.need_improvement2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Visibility(
                                visible: false,
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => TaxCollectionView(selectedTaxTypeData: selectedTaxTypeData, flag: "3")));
                                      },
                                      child: Container(
                                        width: MediaQuery.of(context).size.width / 2.5,
                                        margin: EdgeInsets.only(top: 10, bottom: 15, left: 15),
                                        decoration: UIHelper.GradientContainer(5, 5, 5, 5, [c.grey_8, c.grey_8]),
                                        padding: EdgeInsets.fromLTRB(5, 8, 0, 8),
                                        child: Row(
                                          // Wrap with Row to add the plus icon
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.add, // Use the icon you prefer (e.g., Icons.add, Icons.add_circle, etc.)
                                              color: c.white,
                                              size: 15,
                                            ),
                                            SizedBox(width: 3),
                                            Flexible(
                                                child: UIHelper.titleTextStyle(
                                              "new".tr().toString() +
                                                  (preferencesService.selectedLanguage == "en" ? selectedTaxTypeData["taxtypedesc_en"] : selectedTaxTypeData["taxtypedesc_ta"]) +
                                                  "new2".tr().toString(),
                                              c.white,
                                              10,
                                              true,
                                              true,
                                            )) // Add a small space between the icon and the text
                                            ,
                                          ],
                                        ),
                                      ),
                                    )),
                              ),
                            ),
                            Visibility(
                              visible: !widget.isHome,
                              child: Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(right: 15),
                                  decoration: UIHelper.roundedBorderWithColorWithShadow(5, c.white, c.white),
                                  child: Row(
                                    children: [
                                      Container(
                                          width: 30,
                                          height: 30,
                                          padding: EdgeInsets.all(5),
                                          decoration: UIHelper.roundedBorderWithColor(5, 5, 5, 5, c.colorPrimary),
                                          child: Image.asset(
                                            selectedTaxTypeData[key_img_path].toString(),
                                            fit: BoxFit.contain,
                                            color: selectedTaxTypeData[key_taxtypeid].toString() == "2" || selectedTaxTypeData[key_taxtypeid].toString() == "5" ? c.white : null,
                                            height: 15,
                                            width: 15,
                                          )),
                                      UIHelper.horizontalSpaceSmall,
                                      Expanded(child: addInputDropdownField()),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      StreamedWidget<List<dynamic>?>(
                          stream: preferencesService.taxListStream!.outStream!,
                          builder: (context, snapshot) {
                            if (widget.isHome) {
                              sourceList = preferencesService.taxListStream!.value!
                                  .where((item) => item[key_taxtypeid].toString() == selectedTaxTypeData['taxtypeid'].toString() && double.parse(item['totaldemand']) != 0)
                                  .toList();
                            } else {
                              sourceList = preferencesService.taxListStream!.value!.where((item) => item["is_favourite"] != "Y").toList();
                            }

                            if (selectedTaxTypeData['taxtypeid'].toString() == "0") {
                              mainList = sourceList;
                            } else {
                              mainList = sourceList.where((element) => element[key_taxtypeid].toString() == selectedTaxTypeData['taxtypeid'].toString()).toList();
                              print('mainList: $mainList');
                            }
                            double marginSpace = Screen.width(context) / 4;
                            return mainList.isNotEmpty
                                ? Expanded(
                                    child: GroupedListView<dynamic, String>(
                                    elements: mainList,
                                    useStickyGroupSeparators: true,
                                    floatingHeader: true,
                                    shrinkWrap: true,
                                    groupBy: (element) => element[key_taxtypeid].toString(),
                                    groupSeparatorBuilder: (element) => UIHelper.stickyHeader(element, preferencesService.selectedLanguage, mainList, marginSpace),
                                    indexedItemBuilder: (context, dynamic element, mainIndex) => Container(
                                        margin: EdgeInsets.only(top: 5),
                                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                        child: AnimatedContainer(
                                          padding: EdgeInsets.only(bottom: 5),
                                          duration: const Duration(milliseconds: 500),
                                          child: Container(
                                            padding: EdgeInsets.only(bottom: 5),
                                            width: Screen.width(context),
                                            decoration: BoxDecoration(
                                                color: mainList[mainIndex][key_DEMAND_DETAILS] == "Empty"
                                                    ? c.yellow_new
                                                    : mainList[mainIndex][key_DEMAND_DETAILS] == "Pending"
                                                        ? c.red_new
                                                        : c.green_new,
                                                borderRadius: BorderRadius.circular(20)),
                                            child: Stack(
                                              children: [
                                                Positioned(
                                                  top: 0,
                                                  right: 0,
                                                  child: Container(
                                                    constraints: const BoxConstraints(maxWidth: 130, maxHeight: 80),
                                                    decoration: BoxDecoration(
                                                        color: mainList[mainIndex][key_DEMAND_DETAILS] == "Empty"
                                                            ? c.yellow_new_light
                                                            : mainList[mainIndex][key_DEMAND_DETAILS] == "Pending"
                                                                ? c.red_new_light
                                                                : c.light_green_new,
                                                        borderRadius: BorderRadius.circular(20)),
                                                  ),
                                                ),
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                        margin: const EdgeInsets.all(0),
                                                        child: Container(
                                                            padding: EdgeInsets.fromLTRB(15, 15, 5, 0),
                                                            decoration: BoxDecoration(
                                                              color: c.white,
                                                              borderRadius: BorderRadius.circular(20),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors.grey.withOpacity(0.5), // Shadow color
                                                                  spreadRadius: 3, // Spread radius
                                                                  blurRadius: 5, // Blur radius
                                                                  offset: Offset(3, 3), // Offset from the top-left corner
                                                                ),
                                                              ],
                                                            ),
                                                            width: Screen.width(context) - 40,
                                                            child: headerCardUIWidget(mainIndex, mainList[mainIndex], model))),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        )),
                                    itemComparator: (item1, item2) => item1[key_assessment_no].compareTo(item2[key_assessment_no]), // optional
                                  ))
                                : Expanded(
                                    child: Center(child: Container(margin: EdgeInsets.only(top: 30), child: UIHelper.titleTextStyle("no_record".tr().toString(), c.grey_9, fs.h3, true, true))),
                                  );
                          }),
                    ],
                  ));
            },
            viewModelBuilder: () => StartUpViewModel()));
  }

// *************** Blue Color Main Card Widget ***********
  Widget headerCardUIWidget(int mainIndex, dynamic getData, StartUpViewModel model) {
    return Column(
      children: [
        Stack(
          children: [
            //************************** Basic Details ***************************/

            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UIHelper.verticalSpaceSmall,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      imagePath.user,
                      color: c.grey_8,
                      height: 15,
                      width: 15,
                    ),
                    UIHelper.horizontalSpaceTiny,
                    SizedBox(
                      width: Screen.width(context) / 2,
                      child: Flex(
                        direction: Axis.horizontal,
                        children: [Flexible(child: UIHelper.titleTextStyle(getData[key_name] ?? '', c.grey_9, fs.h4, true, false))],
                      ),
                    ),
                    UIHelper.horizontalSpaceSmall,
                  ],
                ),
                UIHelper.verticalSpaceSmall,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on,
                      color: c.grey_8,
                      size: 18,
                    ),
                    UIHelper.horizontalSpaceTiny,
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          UIHelper.titleTextStyle(Utils().getDoorAndStreetName(getData, preferencesService.selectedLanguage).trim(), c.grey_9, fs.h5, false, false),
                          UIHelper.titleTextStyle(Utils().getvillageAndBlockName(getData).trim(), c.grey_9, fs.h5, false, false),
                          UIHelper.titleTextStyle(getData[key_district_name].trim() ?? '', c.grey_9, fs.h5, false, false)
                        ],
                      ),
                    ),
                  ],
                ),
                Container(alignment: Alignment.centerLeft, child: Utils().taxWiseReturnDataWidget(getData, c.grey_10)),
                Row(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width / 2,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 0, right: 10),
                        child: UIHelper.titleTextStyle(("${'pending_payment'.tr()} : "), c.grey_10, fs.h4, true, false)),
                    Expanded(
                        child: Container(
                            decoration: UIHelper.GradientContainer(10, 10, 10, 10, [c.need_improvement2, c.need_improvement2]),
                            padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                            child: UIHelper.titleTextStyle(("\u{20B9} ${getData['totaldemand']}"), c.text_color, fs.h3, true, true))),
                  ],
                ),
                UIHelper.verticalSpaceSmall,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Visibility(
                          visible: getData[key_DEMAND_DETAILS] != "Empty" && getData[key_DEMAND_DETAILS] != "Pending",
                          child: Container(
                            alignment: Alignment.topLeft,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  if (isShowFlag.contains(mainIndex)) {
                                    isShowFlag.remove(mainIndex);
                                  } else {
                                    isShowFlag.add(mainIndex);
                                  }
                                });
                              },
                              child: Icon(
                                isShowFlag.contains(mainIndex) ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                                size: 30,
                              ),
                            ),
                          )),
                    ),
                    Visibility(
                      visible: !isShowFlag.contains(mainIndex) && getData[key_DEMAND_DETAILS] != "Empty" && getData[key_DEMAND_DETAILS] != "Pending",
                      child: InkWell(
                        onTap: () {
                          isShowFlag.add(mainIndex);
                          for (int i = 0; i < mainList.length; i++) {
                            if (mainList[i][key_DEMAND_DETAILS] != "Empty" && mainList[i][key_DEMAND_DETAILS] != "Pending") {
                              if (i == mainIndex) {
                                for (var item in mainList[i][key_DEMAND_DETAILS]) {
                                  item[key_flag] = true;
                                  isSelectAll.add(i);
                                }
                              } else {
                                for (var item in mainList[i][key_DEMAND_DETAILS]) {
                                  item[key_flag] = false;
                                  isSelectAll.remove(i);
                                }
                              }
                            }
                          }
                          setState(() {});
                          Utils().settingModalBottomSheet(context, [getData], "Favourite Pay");
                        },
                        child: Container(
                            margin: EdgeInsets.only(top: 5, right: 0, bottom: 10),
                            decoration: UIHelper.GradientContainer(5, 5, 5, 5, [c.account_status_green_color, c.account_status_green_color]),
                            padding: EdgeInsets.fromLTRB(10, 5, 10, 7),
                            child: UIHelper.titleTextStyle("pay".tr().toString(), c.white, fs.h4, true, true)),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
        UIHelper.verticalSpaceSmall,
        getData[key_DEMAND_DETAILS] == "Empty" || getData[key_DEMAND_DETAILS] == null
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                child: UIHelper.titleTextStyle('no_demand'.tr().toString(), c.warningYellow, fs.h4, true, false),
              )
            : getData[key_DEMAND_DETAILS] == "Pending" || getData[key_DEMAND_DETAILS] == null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                    child: InkWell(
                        onTap: () async {
                          if(await preferencesService.getString(key_isLogin) == "yes"){
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => CheckTransaction(flag: "Pending",),
                            ));
                          }

                        },
                        child: UIHelper.titleTextStyle('transaction_warning_hint'.tr().toString(), c.red, fs.h4, true, true)),
                  )
                : AnimatedSize(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.linear,
                    child: Visibility(
                      visible: isShowFlag.contains(mainIndex),
                      child: propertyTaxCollectionWidget(mainIndex, getData),
                    ),
                  ),
      ],
    );
  }

  Widget propertyTaxCollectionWidget(int mainIndex, dynamic demandData) {
    List taxData = demandData[key_DEMAND_DETAILS];
    dynamic calcOfHeight = taxData.length / 2;
    int roundedValueOfHeight = calcOfHeight.ceil();
    double selectedAmount = 0;
    List selectedList = taxData.where((item) => item[key_flag] == true).toList();
    for (var taxItem in selectedList) {
      String getAmount = Utils().getDemadAmount(taxItem, demandData[key_taxtypeid]);
      selectedAmount = selectedAmount + double.parse(getAmount);
    }
    demandData[key_tax_total] = selectedAmount;

    return Column(
      children: [
        Container(
            margin: EdgeInsets.only(top: 0, bottom: 15, right: 5),
            padding: EdgeInsets.only(top: 5),
            decoration: UIHelper.GradientContainer(5, 5, 5, 5, [c.need_improvement2, c.need_improvement2]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Visibility(
                    visible: taxData.isNotEmpty,
                    child: Row(
                      children: [Expanded(child: selectAllWidget('select_All', mainIndex, taxData))],
                    )),
                UIHelper.verticalSpaceSmall,
                SizedBox(
                    height: roundedValueOfHeight * 72,
                    child: ResponsiveGridList(
                        listViewBuilderOptions: ListViewBuilderOptions(physics: NeverScrollableScrollPhysics()),
                        horizontalGridMargin: 15,
                        verticalGridMargin: 0,
                        minItemWidth: Screen.width(context) / 4,
                        children: List.generate(
                          taxData.length,
                          (index) {
                            String finYearStr = "";
                            if (demandData[key_taxtypeid].toString() == "4") {
                              finYearStr = taxData[index]['financialyear'];
                            } else {
                              finYearStr = taxData[index][key_fin_year];
                            }
                            String durationStr = taxData[index][key_installment_group_name].toString().trim();
                            bool isStatus = taxData[index][key_flag] ?? false;
                            return GestureDetector(
                                onTap: () {
                                  isSelectAll.clear();
                                  for (int i = 0; i < mainList.length; i++) {
                                    if (mainList[i][key_DEMAND_DETAILS] != "Empty" && mainList[i][key_DEMAND_DETAILS] != "Pending") {
                                      if (i != mainIndex) {
                                        for (var item in mainList[i][key_DEMAND_DETAILS]) {
                                          item[key_flag] = false;
                                        }
                                      }
                                    }
                                  }

                                  if (index == 0 || taxData[index - 1][key_flag] == true) {
                                    if (taxData[index][key_flag] == true) {
                                      for (int i = 0; i < taxData.length; i++) {
                                        if (i >= index) {
                                          taxData[i][key_flag] = false;
                                        }
                                      }
                                    } else {
                                      taxData[index][key_flag] = true;
                                    }
                                  } else {
                                    Utils().showAlert(context, ContentType.fail, 'pay_pending_year'.tr().toString());
                                  }

                                  int countActiveItems = taxData.where((item) => item[key_flag] == true).length;
                                  if (countActiveItems == taxData.length) {
                                    isSelectAll.add(mainIndex);
                                  } else {
                                    isSelectAll.remove(mainIndex);
                                  }
                                  repeatOnce();
                                  setState(() {});
                                },
                                child: Stack(
                                  children: [
                                    Column(
                                      children: [
                                        SizedBox(height: 5),
                                        Container(
                                            padding: EdgeInsets.all(5.0),
                                            decoration: isStatus
                                                ? UIHelper.roundedBorderWithColorWithShadow(5, c.need_improvement, c.need_improvement)
                                                : UIHelper.roundedBorderWithColorWithShadow(5, c.white, c.white),
                                            height: 50,
                                            child: Column(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "$finYearStr ( $durationStr )",
                                                    style: TextStyle(fontSize: fs.h4, fontWeight: FontWeight.normal, color: isStatus ? c.white : c.grey_8),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                      padding: EdgeInsets.all(0),
                                                      child: Center(
                                                          child: UIHelper.titleTextStyle("\u{20B9} ${Utils().getDemadAmount(taxData[index], mainList[mainIndex][key_taxtypeid].toString())}",
                                                              isStatus ? c.white : c.grey_10, fs.h4, false, false))),
                                                ),
                                              ],
                                            ))
                                      ],
                                    ),
                                    Positioned(
                                        right: 5,
                                        child: Container(
                                            decoration: isStatus
                                                ? UIHelper.circleWithColorWithShadow(0, c.green_new, c.satisfied, borderColor: c.white, borderWidth: 2)
                                                : UIHelper.circleWithColorWithShadow(0, c.yello, c.unsatisfied1, borderColor: c.white, borderWidth: 2),
                                            height: 14,
                                            width: 14))
                                  ],
                                ));
                          },
                        ))),

                demandCalculationWidget(mainIndex, demandData),
                // Visibility(
                //     visible: swmData.isNotEmpty && mainList[mainIndex][key_taxtypeid].toString() == "1",
                //     child: Column(
                //       children: [
                //         UIHelper.verticalSpaceSmall,
                //         UIHelper.titleTextStyle("swmUserCharges".tr().toString(), c.grey_9, 11, false, true),
                //         UIHelper.verticalSpaceSmall,
                //         Container(
                //             margin: EdgeInsets.only(top: 5),
                //             height: swmHeight + 0.02,
                //             child: ListView.builder(
                //               physics: NeverScrollableScrollPhysics(),
                //               itemCount: swmData.length,
                //               itemBuilder: (context, rowIndex) {
                //                 int siNo = rowIndex + 1;
                //                 return SizedBox(
                //                     height: 30,
                //                     child: Row(
                //                       children: [
                //                         Expanded(
                //                           flex: 1,
                //                           child: Container(padding: EdgeInsets.all(8.0), child: Center(child: UIHelper.titleTextStyle("$siNo", c.grey_8, 12, false, true))),
                //                         ),
                //                         Expanded(
                //                             flex: 3,
                //                             child: Container(padding: EdgeInsets.all(8.0), child: Center(child: UIHelper.titleTextStyle(swmData[rowIndex]['fin_year'], c.grey_8, 12, false, true)))),
                //                         Expanded(
                //                           flex: 2,
                //                           child: Container(
                //                               padding: EdgeInsets.all(8.0),
                //                               child: Center(
                //                                   child: UIHelper.titleTextStyle(Utils().getDemadAmount(swmData[rowIndex], mainList[mainIndex][key_taxtypeid].toString()), c.grey_8, 12, false, true))),
                //                         ),
                //                         rowIndex == 0 || taxData[rowIndex - 1][key_flag] == true
                //                             ? Expanded(
                //                                 flex: 1,
                //                                 child: Container(
                //                                     padding: EdgeInsets.all(8.0),
                //                                     child: Center(
                //                                       child: Checkbox(
                //                                         side: BorderSide(width: 1, color: c.grey_6),
                //                                         value: swmData[rowIndex][key_flag],
                //                                         onChanged: (v) {
                //                                           if (!getFlagStatus(mainList[mainIndex][key_assessment_id].toString())) {
                //                                             if (rowIndex == 0 || swmData[rowIndex - 1][key_flag] == true) {
                //                                               if (swmData[rowIndex][key_flag] == true) {
                //                                                 for (int i = 0; i < swmData.length; i++) {
                //                                                   if (i >= rowIndex) {
                //                                                     swmData[i][key_flag] = false;
                //                                                     mainList[mainIndex][key_swm_total] = mainList[mainIndex][key_swm_total] -
                //                                                         double.parse(Utils().getDemadAmount(swmData[i], mainList[mainIndex][key_taxtypeid].toString()));
                //                                                     mainList[mainIndex][key_swm_pay] = getTotal(mainList[mainIndex][key_swm_total], mainList[mainIndex][key_swm_available_advance]);
                //                                                   }
                //                                                 }
                //                                               } else {
                //                                                 swmData[rowIndex][key_flag] = true;
                //                                                 mainList[mainIndex][key_swm_total] = mainList[mainIndex][key_swm_total] +
                //                                                     double.parse(Utils().getDemadAmount(swmData[rowIndex], mainList[mainIndex][key_taxtypeid].toString()));
                //                                                 mainList[mainIndex][key_swm_pay] = getTotal(mainList[mainIndex][key_swm_total], mainList[mainIndex][key_swm_available_advance]);
                //                                               }
                //                                             } else {
                //                                               Utils().showAlert(context, ContentType.fail, 'pay_pending_year'.tr().toString());
                //                                             }
                //                                           } else {
                //                                             Utils().showAlert(context, ContentType.fail, 'pay_previous'.tr().toString());
                //                                           }

                //                                           setState(() {
                //                                             getCount();
                //                                             repeatOnce();
                //                                           });
                //                                         },
                //                                       ),
                //                                     )),
                //                               )
                //                             : Expanded(
                //                                 child: SizedBox(
                //                                 width: 5,
                //                               )),
                //                       ],
                //                     ));
                //               },
                //             )),
                //         UIHelper.verticalSpaceSmall,
                //       ],
                //     )),
              ],
            )),
      ],
    );
  }

  Widget selectAllWidget(String title, int mainIndex, List taxData) {
    return GestureDetector(
        onTap: () {
          for (int i = 0; i < mainList.length; i++) {
            if (mainList[i][key_DEMAND_DETAILS] != "Empty" && mainList[i][key_DEMAND_DETAILS] != "Pending") {
              if (i != mainIndex) {
                isSelectAll.remove(i);
                for (var item in mainList[i][key_DEMAND_DETAILS]) {
                  item[key_flag] = false;
                }
              }
            }
          }
          if (isSelectAll.contains(mainIndex)) {
            isSelectAll.remove(mainIndex);
            for (var item in taxData) {
              item[key_flag] = false;
            }
          } else {
            isSelectAll.add(mainIndex);
            for (var item in taxData) {
              item[key_flag] = true;
            }
          }
          // } else {
          //   Utils().showAlert(context, ContentType.fail, 'pay_previous'.tr().toString());
          // }
          repeatOnce();
          setState(() {});
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            UIHelper.titleTextStyle(title.toString().tr(), c.text_color, fs.h4, false, true),
            UIHelper.horizontalSpaceSmall,
            Image.asset(
              isSelectAll.contains(mainIndex) ? imagePath.tick : imagePath.unchecked,
              color: isSelectAll.contains(mainIndex) ? c.account_status_green_color : c.text_color,
              height: 20,
              width: 20,
            ),
            UIHelper.horizontalSpaceSmall,
          ],
        ));
  }

  Widget demandCalculationWidget(int mainIndex, dynamic payableData) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                children: [
                  UIHelper.titleTextStyle('selected'.tr(), c.black, fs.h5, false, false),
                  UIHelper.verticalSpaceTiny,
                  Transform.scale(
                    scale: _animation.value,
                    child: UIHelper.titleTextStyle("\u{20B9} ${payableData[key_tax_total].toStringAsFixed(2)}", c.grey_10, fs.h5, true, false),
                  )
                ],
              ),
            ),
            Visibility(
              visible: isShowFlag.contains(mainIndex),
              child: InkWell(
                onTap: () {
                  if (mainList[mainIndex][key_tax_total] > 0) {
                    Utils().settingModalBottomSheet(context, [payableData], "Favourite Pay");
                  } else {
                    Utils().showAlert(context, ContentType.warning, 'select_demand'.tr().toString());
                  }
                },
                child: Container(
                    margin: EdgeInsets.only(right: 5),
                    decoration: UIHelper.GradientContainer(5, 5, 5, 5, [c.account_status_green_color, c.account_status_green_color]),
                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                    child: UIHelper.titleTextStyle("pay".tr().toString(), c.white, fs.h5, true, true)),
              ),
            ),
          ],
        ),
        UIHelper.verticalSpaceSmall,
      ],
    );
  }

  Widget addInputDropdownField() {
    return custom.FormBuilderDropdown(
      itemHeight: 30,
      menuMaxHeight: Screen.height(context)/1.5,
      style: TextStyle(fontSize: fs.h4, fontWeight: FontWeight.w400, color: c.grey_8),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 0),
        constraints: BoxConstraints(maxHeight: 35),
        hintText: 'select_taxtype'.tr().toString(),
        hintStyle: TextStyle(
          fontSize: 11,
        ),
        filled: true,
        fillColor: c.full_transparent,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: c.full_transparent, width: 0.0),
          borderRadius: BorderRadius.circular(0),
        ),
        focusedBorder: UIHelper.getInputBorder(0, borderColor: c.full_transparent),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 0.0),
          borderRadius: BorderRadius.circular(0), // Increase the radius to adjust the height
        ),
      ),
      initialValue: selectedTaxTypeData,
      iconSize: 28,
      autovalidateMode: custom.AutovalidateMode.onUserInteraction,
      validator: custom.FormBuilderValidators.compose([custom.FormBuilderValidators.required(errorText: "")]),
      items: taxTypeList
          .map((item) => custom.DropdownMenuItem(
                value: item,
                child: Text(
                  preferencesService.selectedLanguage == "en" ? item[key_taxtypedesc_en].toString() : item[key_taxtypedesc_ta].toString(),
                  style: TextStyle(fontSize: fs.h4, fontWeight: FontWeight.w400, color: c.black),
                ),
              ))
          .toList(),
      onChanged: (value) async {
        isShowFlag = [];
        isSelectAll = [];
        selectedTaxTypeData = value;
        // if (selectedTaxTypeData['taxtypeid'].toString() == "0") {
        //   mainList = preferencesService.taxListStream!.value!;
        // } else {
        //   mainList = preferencesService.taxListStream!.value!.where((element) => element[key_taxtypeid].toString() == selectedTaxTypeData['taxtypeid'].toString()).toList();
        // }
        setState(() {});
      },
      name: 'TaxType',
    );
  }
}
