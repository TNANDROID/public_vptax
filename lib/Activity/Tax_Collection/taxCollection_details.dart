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
import '../Transaction/CheckTransaction.dart';

class TaxCollectionDetailsView extends StatefulWidget {
  final responseData;
  TaxCollectionDetailsView({Key? key, required this.responseData});

  @override
  _TaxCollectionDetailsViewState createState() => _TaxCollectionDetailsViewState();
}

class _TaxCollectionDetailsViewState extends State<TaxCollectionDetailsView> with TickerProviderStateMixin {
  //Animation
  late AnimationController _controller;
  late Animation<double> _animation;
  PreferenceService preferencesService = locator<PreferenceService>();
  List isSelectAll = [];
  List isShowFlag = [];
  List mainList = [];
  List taxTypeList = [];
  var selectedTaxTypeData;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    dynamic val = {key_taxtypeid: 0, key_taxtypedesc_en: "All Taxes", key_taxtypedesc_ta: "அனைத்து வரிகள்", key_img_path: imagePath.all};
    taxTypeList.add(val);
    taxTypeList.addAll(preferencesService.taxTypeList);
    selectedTaxTypeData = taxTypeList[0];
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
    mainList = widget.responseData;
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
            onModelReady: (model) async {
              await getDemandList(model);
            },
            builder: (context, model, child) {
              double marginSpace = Screen.width(context) / 4;
              return model.isBusy
                  ? Center(child: Container(margin: EdgeInsets.only(top: 30), child: UIHelper.titleTextStyle("no_record".tr().toString(), c.grey_9, 12, true, true)))
                  : Container(
                      color: c.need_improvement2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          UIHelper.verticalSpaceMedium,
                          Visibility(
                            visible: mainList.isNotEmpty,
                            child: Expanded(
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
                                                      padding: EdgeInsets.fromLTRB(15, 15, 5, 15),
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
                                                      child: headerCardUIWidget(mainIndex, mainList[mainIndex]))),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                              itemComparator: (item1, item2) => item1[key_assessment_no].compareTo(item2[key_assessment_no]), // optional
                            )),
                          ),
                          Visibility(
                              visible: mainList.isEmpty,
                              child: Expanded(
                                child: Center(child: Container(margin: EdgeInsets.only(top: 30), child: UIHelper.titleTextStyle("no_record".tr().toString(), c.grey_9, 12, true, true))),
                              )),
                        ],
                      ));
            },
            viewModelBuilder: () => StartUpViewModel()));
  }

// *************** Blue Color Main Card Widget ***********
  Widget headerCardUIWidget(int mainIndex, dynamic getData) {
    List taxData = [];
    if (getData[key_DEMAND_DETAILS] != "Empty" && getData[key_DEMAND_DETAILS] != "Pending" && getData[key_DEMAND_DETAILS] != null) {
      taxData = getData[key_DEMAND_DETAILS];
    }
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
                        children: [Flexible(child: UIHelper.titleTextStyle(getData[s.key_name] ?? '', c.grey_9, 12, true, false))],
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
                      size: 15,
                    ),
                    UIHelper.horizontalSpaceTiny,
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          UIHelper.titleTextStyle(Utils().getDoorAndStreetName(getData, preferencesService.selectedLanguage), c.grey_8, 11, false, false),
                          UIHelper.titleTextStyle(Utils().getvillageAndBlockName(getData), c.grey_8, 11, false, false),
                          UIHelper.titleTextStyle(getData[s.key_district_name] ?? '', c.grey_8, 11, false, false)
                        ],
                      ),
                    ),
                    UIHelper.horizontalSpaceSmall,
                  ],
                ),
                UIHelper.verticalSpaceTiny,
                Container(alignment: Alignment.centerLeft, child: taxWiseReturnDataWidget(getData, c.grey_8)),
                UIHelper.titleTextStyle(("${'pending_payment'.tr()} : \u{20B9} " + getData['totaldemand']), c.grey_10, 14, true, true),
              ],
            ),

            //************************** Down Arrow ***************************/

            Visibility(
                visible: getData[key_DEMAND_DETAILS] != "Empty" && getData[key_DEMAND_DETAILS] != "Pending",
                child: Positioned(
                  bottom: 0,
                  right: 0,
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

            //************************** Tax Image ***************************/

            Visibility(
              visible: isShowFlag.contains(mainIndex),
              child: Positioned(
                right: 0,
                child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: UIHelper.roundedBorderWithColorWithShadow(5, c.white, c.white),
                    child: Image.asset(
                      getTaxImage(mainIndex),
                      fit: BoxFit.contain,
                      height: 40,
                      width: 40,
                    )),
              ),
            ),

            //************************** Warning and Danger Logo ***************************/

            Visibility(
              visible: getData[key_DEMAND_DETAILS] == "Empty" || getData[key_DEMAND_DETAILS] == "Pending",
              child: Positioned(
                right: 10,
                child: Container(
                    decoration: UIHelper.roundedBorderWithColorWithShadow(50, c.white, c.white),
                    child: Image.asset(
                      getData[key_DEMAND_DETAILS] == "Empty" ? imagePath.warning_png : imagePath.delete_png,
                      fit: BoxFit.contain,
                      height: 40,
                      width: 40,
                    )),
              ),
            ),

            //************************** Proceed To Pay Button ***************************/

            Positioned(
              right: 0,
              child: Visibility(
                visible: !isShowFlag.contains(mainIndex) && getData[key_DEMAND_DETAILS] != "Empty" && getData[key_DEMAND_DETAILS] != "Pending",
                child: InkWell(
                  onTap: () {
                    for (var item in taxData) {
                      item[s.key_flag] = true;
                    }
                    Utils().settingModalBottomSheet(context, [getData], "Quick Pay");
                  },
                  child: Container(
                      margin: EdgeInsets.only(top: 0, right: 10, bottom: 10),
                      decoration: UIHelper.GradientContainer(5, 5, 5, 5, [c.account_status_green_color, c.account_status_green_color]),
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 7),
                      child: UIHelper.titleTextStyle("pay".tr().toString(), c.white, 11, true, true)),
                ),
              ),
            )
          ],
        ),
        UIHelper.verticalSpaceSmall,
        getData[key_DEMAND_DETAILS] == "Empty"
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: UIHelper.titleTextStyle('no_demand'.tr().toString(), c.warningYellow, 12, true, false),
              )
            : getData[key_DEMAND_DETAILS] == "Pending"
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CheckTransaction(),
                          ));
                        },
                        child: UIHelper.titleTextStyle('transaction_warning_hint'.tr().toString(), c.red, 12, true, true)),
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

// *************** Tax based  Data Get Widget***********
  Widget taxWiseReturnDataWidget(dynamic getData, Color clr) {
    return getData[key_taxtypeid].toString() == "1"
        ? Container(
            margin: EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UIHelper.titleTextStyle(("${'computerRegisterNumber'.tr()} : ${getData[s.key_assessment_id].toString() ?? ""}"), clr, 12, false, true),
                UIHelper.verticalSpaceTiny,
                UIHelper.titleTextStyle(("${'building_licence_number'.tr()} : ${getData[s.key_building_licence_no].toString() ?? ""}"), clr, 12, false, true),
                UIHelper.verticalSpaceTiny,
                UIHelper.titleTextStyle(("${'assesment_number'.tr()} : ${getData[s.key_assessment_no].toString() ?? ""}"), clr, 12, false, true),
                UIHelper.verticalSpaceTiny,
              ],
            ),
          )
        : getData[key_taxtypeid].toString() == "2"
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UIHelper.titleTextStyle(("${'computerRegisterNumber'.tr()} : ${getData[s.key_assessment_id].toString() ?? ""}"), clr, 12, false, true),
                  UIHelper.verticalSpaceTiny,
                  UIHelper.titleTextStyle(("${'water_connection_number'.tr()} : ${getData[s.key_assessment_no].toString() ?? ""}"), clr, 12, false, true),
                  UIHelper.verticalSpaceTiny,
                ],
              )
            : getData[key_taxtypeid].toString() == "4"
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UIHelper.titleTextStyle(("${'computerRegisterNumber'.tr()} : ${getData[s.key_assessment_id].toString() ?? ""}"), clr, 12, false, true),
                      UIHelper.verticalSpaceTiny,
                      UIHelper.titleTextStyle(("${'financialYear'.tr()} : ${getData['financialyear'].toString() ?? ""}"), clr, 12, false, true),
                      UIHelper.verticalSpaceTiny,
                      UIHelper.titleTextStyle(("${'assesment_number'.tr()} : ${getData[s.key_assessment_no].toString() ?? ""}"), clr, 12, false, true),
                      UIHelper.verticalSpaceTiny,
                    ],
                  )
                : getData[key_taxtypeid].toString() == "5"
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          UIHelper.titleTextStyle(("${'computerRegisterNumber'.tr()} : ${getData[s.key_assessment_id].toString() ?? ""}"), clr, 12, false, true),
                          UIHelper.verticalSpaceTiny,
                          UIHelper.titleTextStyle(("${'lease_number'.tr()} : ${getData[s.key_assessment_no].toString() ?? ""}"), clr, 12, false, true),
                          UIHelper.verticalSpaceTiny,
                          UIHelper.titleTextStyle(("${'lease_state'.tr()} : ${getData['lease_statename'].toString() ?? ""}"), clr, 12, false, true),
                          UIHelper.verticalSpaceTiny,
                          UIHelper.titleTextStyle(("${'lease_district'.tr()} : ${getData['lease_districtname'].toString() ?? ""}"), clr, 12, false, true),
                          UIHelper.verticalSpaceTiny,
                          UIHelper.titleTextStyle(("${'lease_duration'.tr()} : ${getData['from_date'].toString() ?? ""} - ${getData['to_date'].toString() ?? ""}"), clr, 12, false, true),
                          UIHelper.verticalSpaceTiny,
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          UIHelper.titleTextStyle(("${'computerRegisterNumber'.tr()} : ${getData[s.key_assessment_id].toString() ?? ""}"), clr, 12, false, true),
                          UIHelper.verticalSpaceTiny,
                          UIHelper.titleTextStyle(("${'traders_code'.tr()} : ${getData[s.key_assessment_no].toString() ?? ""}"), clr, 12, false, true),
                          UIHelper.verticalSpaceTiny,
                        ],
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
        margin: EdgeInsets.only(top: 10),
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
                    Utils().settingModalBottomSheet(context, [payableData], "Quick Pay");
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

  String getTaxImage(int typeId) {
    String taxTypeID = mainList[typeId][s.key_taxtypeid].toString();
    List selectedTaxitem = taxTypeList.where((element) => element[s.key_taxtypeid].toString() == taxTypeID).toList();
    return selectedTaxitem[0][s.key_img_path].toString();
  }

  Future getDemandList(StartUpViewModel model) async {
    for (var item in mainList) {
      dynamic getDemandRequest = {
        key_service_id: "getAssessmentDemandList",
        key_taxtypeid: item[key_taxtypeid],
        key_assessment_id: item[key_assessment_id],
        key_dcode: item[key_dcode],
        key_bcode: item[key_bcode],
        key_pvcode: item[key_lbcode],
        key_language_name: preferencesService.selectedLanguage,
      };
      if (item[key_taxtypeid] == 4) {
        getDemandRequest[key_fin_year] = item[key_financialyear];
      }
      var getDemandResponce = await model.overAllMainService(context, getDemandRequest);

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

    setState(() {});
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
