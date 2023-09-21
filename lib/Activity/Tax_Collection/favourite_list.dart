// ignore_for_file: library_prefixes, prefer_const_constructors_in_immutables, library_private_types_in_public_api, prefer_typing_uninitialized_variables, prefer_const_constructors, avoid_print, deprecated_member_use, use_build_context_synchronously, file_names, non_constant_identifier_names, use_key_in_widget_constructors, prefer_adjacent_string_concatenation, avoid_function_literals_in_foreach_calls

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:public_vptax/Activity/Tax_Collection/taxCollection_view_request_screen.dart';
import 'package:public_vptax/Layout/screen_size.dart';
import 'package:public_vptax/Layout/ui_helper.dart';
import 'package:public_vptax/Model/startup_model.dart';
import 'package:public_vptax/Resources/ColorsValue.dart' as c;
import 'package:public_vptax/Utils/ContentInfo.dart';
import 'package:public_vptax/Utils/utils.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import '../../Resources/StringsKey.dart' as s;
import 'package:public_vptax/Services/Preferenceservices.dart';
import 'package:public_vptax/Services/locator.dart';
import 'package:stacked/stacked.dart';
import 'package:public_vptax/Resources/ImagePath.dart' as imagePath;
import '../../Resources/StringsKey.dart';

class FavouriteTaxDetails extends StatefulWidget {
  FavouriteTaxDetails({Key? key});

  @override
  _FavouriteTaxDetailsState createState() => _FavouriteTaxDetailsState();
}

class _FavouriteTaxDetailsState extends State<FavouriteTaxDetails> with TickerProviderStateMixin {
  //Animation
  late AnimationController _controller;
  late Animation<double> _animation;
  PreferenceService preferencesService = locator<PreferenceService>();
  dynamic requestJson = {"service_id": "getAllTaxAssessmentList"};
  List isSelectAll = [];
  String selectedLang = "";
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
    _animation = CurvedAnimation(parent: _controller, curve: Curves.bounceOut);

    dynamic val = {key_taxtypeid: 0, key_taxtypedesc_en: "All Taxes", key_taxtypedesc_ta: "அனைத்து வரிகள்", key_img_path: imagePath.all};
    taxTypeList.add(val);
    taxTypeList.addAll(preferencesService.taxTypeList);
    selectedTaxTypeData = taxTypeList[0];

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
    selectedLang = await preferencesService.getUserInfo("lang");
    requestJson[key_mobile_number] = await preferencesService.getUserInfo(key_mobile_number);
    requestJson[key_language_name] = selectedLang;
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
      appBar: UIHelper.getBar('addedList'),
      body: ViewModelBuilder<StartUpViewModel>.reactive(
          onModelReady: (model) async {
            await getDemandList(model);
          },
          builder: (context, model, child) {
            return model.isBusy
                ? Center(child: Container(margin: EdgeInsets.only(top: 30), child: UIHelper.titleTextStyle("no_record".tr().toString(), c.grey_9, 12, true, true)))
                : Container(
                    color: c.need_improvement2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        UIHelper.verticalSpaceSmall,
                        Visibility(
                            visible: mainList.isNotEmpty,
                            child: Expanded(
                              child: ListView.builder(
                                itemCount: mainList.length,
                                itemBuilder: (context, mainIndex) {
                                  return Container(
                                      margin: EdgeInsets.only(top: 5),
                                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                      child: AnimatedContainer(
                                        padding: EdgeInsets.only(bottom: 5),
                                        duration: const Duration(milliseconds: 500),
                                        child: Container(
                                            margin: const EdgeInsets.all(0),
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  color: c.white,
                                                  borderRadius: BorderRadius.circular(5),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey.withOpacity(0.5), // Shadow color
                                                      spreadRadius: 3, // Spread radius
                                                      blurRadius: 5, // Blur radius
                                                      offset: Offset(3, 3), // Offset from the top-left corner
                                                    ),
                                                  ],
                                                ),
                                                width: Screen.width(context),
                                                child: headerCardUIWidget(mainIndex, mainList[mainIndex], model))),
                                      ));
                                },
                              ),
                            )),
                        Visibility(
                            visible: mainList.isEmpty,
                            child: Expanded(
                              child: Center(child: Container(margin: EdgeInsets.only(top: 30), child: UIHelper.titleTextStyle("no_record".tr().toString(), c.grey_9, 12, true, true))),
                            )),
                      ],
                    ));
          },
          viewModelBuilder: () => StartUpViewModel()),
      floatingActionButton: GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => TaxCollectionView(selectedTaxTypeData: selectedTaxTypeData, flag: "3")));
          },
          child: Container(
            width: 50,
            height: 50,
            decoration: UIHelper.circleWithColorWithShadow(30, c.white, c.white, borderColor: c.grey_7, borderWidth: 5),
            padding: EdgeInsets.all(3),
            child: Container(decoration: UIHelper.circleWithColorWithShadow(30, c.yellow_new, c.colorPrimaryDark), child: Center(child: UIHelper.titleTextStyle("+", c.white, 28, true, true))),
          )),
    );
  }

// *************** Blue Color Main Card Widget ***********
  Widget headerCardUIWidget(int mainIndex, dynamic getData, StartUpViewModel model) {
    List taxData = [];
    if (getData[key_DEMAND_DETAILS] != "Empty" && getData[key_DEMAND_DETAILS] != "Pending" && getData[key_DEMAND_DETAILS] != null) {
      taxData = getData[key_DEMAND_DETAILS];
    }
    return Container(
        decoration: BoxDecoration(
          color: c.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(width: 2, color: c.grey_5),
          boxShadow: [
            BoxShadow(
              color: c.grey_4,
              spreadRadius: 3, // Spread radius
              blurRadius: 5, // Blur radius
              offset: Offset(3, 3), // Offset from the top-left corner
            ),
          ],
        ),
        child: Column(
          children: [
            Stack(
              children: [
                //************************** Basic Details ***************************/

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                            transform: Matrix4.translationValues(0.0, -2, 0.0),
                            padding: const EdgeInsets.all(5),
                            margin: EdgeInsets.only(left: 15),
                            decoration: UIHelper.roundedBorderWithColor(5, 5, 100, 100, c.grey_3, borderColor: c.grey_5, borderWidth: 2),
                            child: Image.asset(
                              getTaxImage(mainIndex),
                              fit: BoxFit.contain,
                              height: 35,
                              width: 35,
                            )),
                        UIHelper.horizontalSpaceSmall,
                        Flexible(child: UIHelper.titleTextStyle(getData[s.key_name] ?? '', c.grey_9, 12, true, false))
                      ],
                    ),
                    UIHelper.verticalSpaceTiny,
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          taxWiseReturnDataWidget(getData, c.grey_8),
                          //   UIHelper.titleTextStyle(("${'pending_payment'.tr()} : \u{20B9} " + getData['totaldemand']), c.grey_10, 14, true, true),
                        ],
                      ),
                    )
                  ],
                ),

                //************************** Down Arrow ***************************/

                // Visibility(
                //     visible: getData[key_DEMAND_DETAILS] != "Empty" && getData[key_DEMAND_DETAILS] != "Pending",
                //     child: Positioned(
                //       bottom: 0,
                //       right: 0,
                //       child: InkWell(
                //         onTap: () {
                //           setState(() {
                //             if (isShowFlag.contains(mainIndex)) {
                //               isShowFlag.remove(mainIndex);
                //             } else {
                //               isShowFlag.add(mainIndex);
                //             }
                //           });
                //         },
                //         child: Icon(
                //           isShowFlag.contains(mainIndex) ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                //           size: 30,
                //         ),
                //       ),
                //     )),

                //************************** Proceed To Pay Button ***************************/

                Positioned(
                  right: 0,
                  child: InkWell(
                    onTap: () async {
                      await showRemovePopup(getData, model);
                    },
                    child: Padding(padding: EdgeInsets.only(right: 5, top: 10), child: Icon(Icons.delete, color: c.red, size: 25)),
                  ),
                )
              ],
            ),
            UIHelper.verticalSpaceSmall,
            // getData[key_DEMAND_DETAILS] == "Empty" || getData[key_DEMAND_DETAILS] == null
            //     ? Padding(
            //         padding: const EdgeInsets.symmetric(horizontal: 10.0),
            //         child: UIHelper.titleTextStyle('no_demand'.tr().toString(), c.warningYellow, 12, true, false),
            //       )
            //     : getData[key_DEMAND_DETAILS] == "Pending" || getData[key_DEMAND_DETAILS] == null
            //         ? Padding(
            //             padding: const EdgeInsets.symmetric(horizontal: 10.0),
            //             child: UIHelper.titleTextStyle('transaction_warning_hint'.tr().toString(), c.red, 12, true, true),
            //           )
            //         : AnimatedSize(
            //             duration: const Duration(milliseconds: 200),
            //             curve: Curves.linear,
            //             child: Visibility(
            //               visible: isShowFlag.contains(mainIndex),
            //               child: propertyTaxCollectionWidget(mainIndex, getData),
            //             ),
            //           ),
            // UIHelper.verticalSpaceSmall,
          ],
        ));
  }

// ********** App Exit and Logout Widget ***********\\
  Future<bool> showRemovePopup(dynamic getData, StartUpViewModel model) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: UIHelper.titleTextStyle('assessment_remove'.tr().toString(), c.black, 13, false, false),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  'no'.tr().toString(),
                  style: TextStyle(fontSize: 12),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  var requestJson = {"service_id": "RemovefavouriteList", "user_id": getData['user_id'], "favourite_assessment_id": getData['favourite_assessment_id']};
                  var responce = await model.authendicationServicesAPIcall(context, requestJson);
                  await getDemandList(model);
                  Navigator.of(context).pop(false);
                },
                child: Text(
                  'yes'.tr().toString(),
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ) ??
        false; //if showDialouge had returned null, then return false
  }

// *************** Village Name Get Widget ***********
  String getvillageAndBlockName(dynamic getData) {
    String street = "";
    street = ((getData[s.key_localbody_name] ?? '') + ", " + (getData[s.key_bname] ?? ''));
    return street;
  }

// *************** Door Number and Street Get Widget ***********
  String getDoorAndStreetName(dynamic getData) {
    String street = "";
    switch (getData[key_taxtypeid].toString()) {
      case '1':
        street = selectedLang == 'en' ? (getData[s.key_street_name_en] ?? '') : (getData[s.key_street_name_ta] ?? '');
        break;
      case '2':
        street = (getData["street_name"] ?? '');
        break;
      case '4':
        street = (getData['doorno'] ?? '') + ", " + (selectedLang == 'en' ? (getData["street_name_t"] ?? '') : (getData["street_name_t"] ?? ''));
        break;
      case '5':
        street = (getData['doorno'] ?? '') + ", " + (selectedLang == 'en' ? (getData["street_name"] ?? '') : (getData["street_name"] ?? ''));
        break;
      case '6':
        street = selectedLang == 'en' ? (getData["street_name_en"] ?? '') : (getData["street_name_ta"] ?? '');
        break;
    }
    return street;
  }

// *************** Tax based  Data Get Widget***********
  Widget taxWiseReturnDataWidget(dynamic getData, Color clr) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UIHelper.titleTextStyle(("${'computerRegisterNumber'.tr()} : ${getData[s.key_assessment_id].toString() ?? ""}"), clr, 12, false, true),
          UIHelper.verticalSpaceTiny,
          UIHelper.titleTextStyle(("${'assesment_number'.tr()} : ${getData[s.key_assessment_no].toString() ?? ""}"), clr, 12, false, true),
          UIHelper.verticalSpaceTiny,
        ],
      ),
    );
  }

  Widget propertyTaxCollectionWidget(int mainIndex, dynamic demandData) {
    List taxData = demandData[key_DEMAND_DETAILS];
    dynamic calcOfHeight = taxData.length / 2;
    int roundedValueOfHeight = calcOfHeight.ceil();
    double selectedAmount = 0;
    List selectedList = taxData.where((item) => item[s.key_flag] == true).toList();
    for (var taxItem in selectedList) {
      String getAmount = Utils().getDemadAmount(taxItem, demandData[key_taxtypeid]);
      selectedAmount = selectedAmount + double.parse(getAmount);
    }
    demandData[s.key_tax_total] = selectedAmount;

    return Container(
        margin: EdgeInsets.all(10),
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
                        bool isStatus = taxData[index][s.key_flag] ?? false;
                        return GestureDetector(
                            onTap: () {
                              if (!getFlagStatus(demandData[key_assessment_id].toString())) {
                                if (index == 0 || taxData[index - 1][s.key_flag] == true) {
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
                              } else {
                                Utils().showAlert(context, ContentType.fail, 'pay_previous'.tr().toString());
                              }

                              int countActiveItems = taxData.where((item) => item[s.key_flag] == true).length;
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
                                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.normal, color: isStatus ? c.white : c.grey_8),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                  padding: EdgeInsets.all(0),
                                                  child: Center(
                                                      child: UIHelper.titleTextStyle("\u{20B9} ${Utils().getDemadAmount(taxData[index], mainList[mainIndex][key_taxtypeid].toString())}",
                                                          isStatus ? c.white : c.grey_10, 12, false, false))),
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
            //                         rowIndex == 0 || taxData[rowIndex - 1][s.key_flag] == true
            //                             ? Expanded(
            //                                 flex: 1,
            //                                 child: Container(
            //                                     padding: EdgeInsets.all(8.0),
            //                                     child: Center(
            //                                       child: Checkbox(
            //                                         side: BorderSide(width: 1, color: c.grey_6),
            //                                         value: swmData[rowIndex][s.key_flag],
            //                                         onChanged: (v) {
            //                                           if (!getFlagStatus(mainList[mainIndex][key_assessment_id].toString())) {
            //                                             if (rowIndex == 0 || swmData[rowIndex - 1][s.key_flag] == true) {
            //                                               if (swmData[rowIndex][s.key_flag] == true) {
            //                                                 for (int i = 0; i < swmData.length; i++) {
            //                                                   if (i >= rowIndex) {
            //                                                     swmData[i][s.key_flag] = false;
            //                                                     mainList[mainIndex][s.key_swm_total] = mainList[mainIndex][s.key_swm_total] -
            //                                                         double.parse(Utils().getDemadAmount(swmData[i], mainList[mainIndex][key_taxtypeid].toString()));
            //                                                     mainList[mainIndex][s.key_swm_pay] = getTotal(mainList[mainIndex][s.key_swm_total], mainList[mainIndex][s.key_swm_available_advance]);
            //                                                   }
            //                                                 }
            //                                               } else {
            //                                                 swmData[rowIndex][s.key_flag] = true;
            //                                                 mainList[mainIndex][s.key_swm_total] = mainList[mainIndex][s.key_swm_total] +
            //                                                     double.parse(Utils().getDemadAmount(swmData[rowIndex], mainList[mainIndex][key_taxtypeid].toString()));
            //                                                 mainList[mainIndex][s.key_swm_pay] = getTotal(mainList[mainIndex][s.key_swm_total], mainList[mainIndex][s.key_swm_available_advance]);
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
        ));
  }

  Widget selectAllWidget(String title, int mainIndex, List taxData) {
    return GestureDetector(
        onTap: () {
          if (!getFlagStatus(mainList[mainIndex][key_assessment_id].toString())) {
            if (isSelectAll.contains(mainIndex)) {
              isSelectAll.remove(mainIndex);
              for (var item in taxData) {
                item[s.key_flag] = false;
              }
            } else {
              isSelectAll.add(mainIndex);
              for (var item in taxData) {
                item[s.key_flag] = true;
              }
            }
          } else {
            Utils().showAlert(context, ContentType.fail, 'pay_previous'.tr().toString());
          }
          repeatOnce();
          setState(() {});
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            UIHelper.titleTextStyle(title.toString().tr(), c.text_color, 12, false, true),
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
                  UIHelper.titleTextStyle('selected'.tr(), c.black, 12, false, false),
                  UIHelper.verticalSpaceTiny,
                  Transform.scale(
                    scale: _animation.value,
                    child: UIHelper.titleTextStyle("\u{20B9} ${payableData[s.key_tax_total]}", c.grey_10, 13, true, false),
                  )
                ],
              ),
            ),
            Visibility(
              visible: isShowFlag.contains(mainIndex),
              child: InkWell(
                onTap: () {
                  if (mainList[mainIndex][key_tax_total] > 0) {
                    Utils().settingModalBottomSheet(context, [payableData]);
                  } else {
                    Utils().showAlert(context, ContentType.warning, 'select_demand'.tr().toString());
                  }
                },
                child: Container(
                    margin: EdgeInsets.only(top: 0, right: 10, bottom: 10),
                    decoration: UIHelper.GradientContainer(5, 5, 5, 5, [c.account_status_green_color, c.account_status_green_color]),
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 7),
                    child: UIHelper.titleTextStyle("pay".tr().toString(), c.white, 11, true, true)),
              ),
            ),
          ],
        ),
        UIHelper.verticalSpaceSmall,
      ],
    );
  }

  Future getDemandList(StartUpViewModel model) async {
    var responce = await model.authendicationServicesAPIcall(context, requestJson);
    if (responce[key_data] != null && responce[key_data].length > 0) {
      List resList = responce[key_data].toList();
      sourceList = resList.where((item) => item["is_favourite"] == "Y").toList();
      mainList = sourceList.toList();

      for (var item in mainList) {
        dynamic getDemandRequest = {
          key_service_id: "getAssessmentDemandList",
          key_taxtypeid: item[key_taxtypeid],
          key_assessment_id: item[key_assessment_id],
          key_dcode: item[key_dcode],
          key_bcode: item[key_bcode],
          key_pvcode: item[key_lbcode],
          key_language_name: selectedLang,
        };
        if (item[key_taxtypeid] == 4) {
          getDemandRequest[key_fin_year] = item[key_financialyear];
        }
        var getDemandResponce = await model.authendicationServicesAPIcall(context, getDemandRequest);

        if (getDemandResponce[key_response] == key_fail) {
          if (getDemandResponce[key_message] == "Demand Details Not Found") {
            item[key_DEMAND_DETAILS] = "Empty";
          } else if (getDemandResponce[key_message] == "Your previous transaction is pending. Please try after 60 minutes") {
            item[key_DEMAND_DETAILS] = "Pending";
          } else {
            item[key_DEMAND_DETAILS] = "Something Went Wrong...";
          }
        } else {
          if (getDemandResponce[key_data] != null && getDemandResponce[key_data].length > 0) {
            item[key_DEMAND_DETAILS] = getDemandResponce[key_data];
          }
        }
      }
    } else {
      mainList = [];
    }
    setState(() {});
  }

  String getTaxImage(int typeId) {
    String taxTypeID = mainList[typeId][s.key_taxtypeid].toString();
    List selectedTaxitem = taxTypeList.where((element) => element[s.key_taxtypeid].toString() == taxTypeID).toList();
    return selectedTaxitem[0][s.key_img_path].toString();
  }

  bool getFlagStatus(String assId) {
    bool flag = false;
    if (mainList.isNotEmpty) {
      for (var data in mainList) {
        if (data[key_assessment_id].toString() != assId) {
          if (data[s.key_DEMAND_DETAILS] != "Empty" && data[s.key_DEMAND_DETAILS] != "Pending") {
            for (var demanData in data[s.key_DEMAND_DETAILS]) {
              if (demanData[s.key_flag] == true) {
                flag = true;
              }
            }
          }
        }
      }
    }
    return flag;
  }
}