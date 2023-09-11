// ignore_for_file: library_prefixes, prefer_const_constructors_in_immutables, library_private_types_in_public_api, prefer_typing_uninitialized_variables, prefer_const_constructors, avoid_print, deprecated_member_use, use_build_context_synchronously, file_names, non_constant_identifier_names, use_key_in_widget_constructors, prefer_adjacent_string_concatenation, avoid_function_literals_in_foreach_calls

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:public_vptax/Activity/Tax_Collection/added_tax_pay_details.dart';
import 'package:public_vptax/Activity/Tax_Collection/taxCollection_view_request_screen.dart';
import 'package:public_vptax/Layout/customclip.dart';
import 'package:public_vptax/Layout/screen_size.dart';
import 'package:public_vptax/Layout/ui_helper.dart';
import 'package:public_vptax/Model/startup_model.dart';
import 'package:public_vptax/Resources/ColorsValue.dart' as c;
import 'package:public_vptax/Utils/ContentInfo.dart';
import 'package:public_vptax/Utils/utils.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import '../../Layout/customgradientbutton.dart';
import '../../Resources/StringsKey.dart' as s;
import 'package:public_vptax/Services/Preferenceservices.dart';
import 'package:public_vptax/Services/locator.dart';
import 'package:stacked/stacked.dart';
import 'package:public_vptax/Resources/ImagePath.dart' as imagePath;

import '../../Resources/StringsKey.dart';
import '../Auth/Home.dart';

class TaxCollectionDetailsWithAdd extends StatefulWidget {
  final selectedTaxTypeData;
  TaxCollectionDetailsWithAdd({Key? key, this.selectedTaxTypeData});

  @override
  _TaxCollectionDetailsWithAddState createState() => _TaxCollectionDetailsWithAddState();
}

class _TaxCollectionDetailsWithAddState extends State<TaxCollectionDetailsWithAdd> with TickerProviderStateMixin {
  //Animation
  late AnimationController _controller;
  late Animation<double> _animation;

  PreferenceService preferencesService = locator<PreferenceService>();

  //Strings
  String selectedLang = "";

  //List
  List sampleDataList = [];
  List mainList = [];
  List isSelectAll = [];

  //int Double
  int main_count = 0;
  int totalAssessment = 0;
  int pendingAssessment = 0;

  ScrollController controller_scroll = ScrollController();

  var selectedTaxTypeData;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    selectedTaxTypeData = widget.selectedTaxTypeData;
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
    selectedLang = await preferencesService.getUserInfo("lang");
    await filterDataList();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: c.white,
        appBar: AppBar(
          backgroundColor: c.colorPrimary,
          centerTitle: true,
          elevation: 2,
          title: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: AlignmentDirectional.center,
                  child: Container(
                    transform: Matrix4.translationValues(-30.0, 0.0, 0.0),
                    alignment: Alignment.center,
                    child: Text(
                      selectedLang == "en" ? selectedTaxTypeData["taxtypedesc_en"] : selectedTaxTypeData["taxtypedesc_ta"],
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: ViewModelBuilder<StartUpViewModel>.reactive(
            builder: (context, model, child) {
              return Container(
                  color: c.need_improvement2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      UIHelper.verticalSpaceSmall,
                      assetCountWidget(),
                      Expanded(
                        child: SingleChildScrollView(
                            controller: controller_scroll,
                            scrollDirection: Axis.vertical,
                            child: Column(
                              children: [
                                Visibility(
                                  visible: mainList.isNotEmpty,
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: mainList.length,
                                      itemBuilder: (context, mainIndex) {
                                        return Column(
                                          children: [
                                            headerCardUIWidget(mainIndex),
                                            UIHelper.verticalSpaceMedium,
                                          ],
                                        );
                                      }),
                                ),
                                Visibility(
                                  visible: mainList.isEmpty,
                                  child: Center(child: Container(margin: EdgeInsets.only(top: 100), child: UIHelper.titleTextStyle("no_record".tr().toString(), c.grey_9, 12, true, true))),
                                )
                              ],
                            )),
                      ),
                      GestureDetector(
                          onTap: () {
                            List selectedDataList = [];
                            for (var item in isSelectAll) {
                              selectedDataList.add(mainList[item]);
                            }
                            print("Tamil----" + selectedDataList.length.toString());
                          },
                          child: Container(
                            height: 60,
                            width: Screen.width(context),
                            decoration: UIHelper.roundedBorderWithColor(60, 60, 0, 0, c.colorPrimary),
                            child: Center(child: UIHelper.titleTextStyle("Add to Pay List", c.white, 14, true, true)),
                          )),
                    ],
                  ));
            },
            viewModelBuilder: () => StartUpViewModel()));
  }

  Widget headerCardUIWidget(int mainIndex) {
    List demandList = mainList[mainIndex][s.key_DEMAND_DETAILS] ?? [];
    List taxData = [];
    List swmData = [];
    if (demandList.isNotEmpty) {
      for (int i = 0; i < demandList.length; i++) {
        if (mainList[mainIndex][key_taxtypeid].toString() == "1") {
          if (demandList[i][s.key_taxtypeid].toString() == mainList[mainIndex][key_taxtypeid].toString()) {
            taxData.add(demandList[i]);
          } else {
            swmData.add(demandList[i]);
          }
        } else {
          taxData.add(demandList[i]);
        }
      }
    }

    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          height: 80,
          width: 80,
          decoration: UIHelper.roundedBorderWithColorWithShadow(5, c.colorPrimary, c.colorPrimary, borderWidth: 0),
        ),
        Container(
            width: Screen.width(context),
            margin: EdgeInsets.only(left: 20, top: 5, right: 25),
            padding: EdgeInsets.fromLTRB(10, 10, 10, 15),
            decoration: UIHelper.roundedBorderWithColorWithShadow(5, c.white, c.white, borderWidth: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  width: Screen.width(context),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                          Expanded(
                            child: Flex(
                              direction: Axis.horizontal,
                              children: [Flexible(child: UIHelper.titleTextStyle(mainList[mainIndex][s.key_name] ?? '', c.grey_9, 12, true, false))],
                            ),
                          ),
                          UIHelper.horizontalSpaceSmall,
                          Container(
                            child: selectAllWidget('select_To_Pay', mainIndex),
                          )
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
                                UIHelper.titleTextStyle(getDoorAndStreetName(mainIndex, selectedTaxTypeData['taxtypeid'].toString()), c.grey_8, 11, false, false),
                                UIHelper.titleTextStyle(getvillageAndBlockName(mainIndex, selectedTaxTypeData['taxtypeid'].toString()), c.grey_8, 11, false, false),
                                UIHelper.titleTextStyle(mainList[mainIndex][s.key_district_name] ?? '', c.grey_8, 11, false, false)
                              ],
                            ),
                          ),
                          UIHelper.horizontalSpaceSmall,
                        ],
                      ),
                      UIHelper.verticalSpaceSmall,
                    ],
                  ),
                ),
                UIHelper.verticalSpaceTiny,
                Container(alignment: Alignment.centerLeft, child: taxWiseReturnDataWidget(mainIndex, c.grey_8)),
              ],
            ))
      ],
    );
  }

  Widget selectAllWidget(String title, int mainIndex) {
    return GestureDetector(
        onTap: () {
          if (isSelectAll.contains(mainIndex)) {
            isSelectAll.remove(mainIndex);
            addDataList(mainIndex);
          } else {
            isSelectAll.add(mainIndex);
          }
          setState(() {});
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            UIHelper.titleTextStyle(("+ " + 'add'.tr().toString()), c.text_color, 12, false, true),
            UIHelper.horizontalSpaceSmall,
            Image.asset(
              isSelectAll.contains(mainIndex) ? imagePath.tick : imagePath.unchecked,
              color: isSelectAll.contains(mainIndex) ? c.account_status_green_color : c.text_color,
              height: 20,
              width: 20,
            ),
          ],
        ));
  }

  Widget taxWiseReturnDataWidget(int mainIndex, Color clr) {
    return selectedTaxTypeData[s.key_taxtypeid] == 1
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UIHelper.titleTextStyle(("${'computerRegisterNumber'.tr()} : ${mainList[mainIndex][s.key_assessment_id].toString() ?? ""}"), clr, 12, false, true),
              UIHelper.verticalSpaceTiny,
              UIHelper.titleTextStyle(("${'building_licence_number'.tr()} : ${mainList[mainIndex][s.key_building_licence_no].toString() ?? ""}"), clr, 12, false, true),
              UIHelper.verticalSpaceTiny,
              UIHelper.titleTextStyle(("${'assesment_number'.tr()} : ${mainList[mainIndex][s.key_assessment_no].toString() ?? ""}"), clr, 12, false, true),
              UIHelper.verticalSpaceTiny,
              UIHelper.titleTextStyle(("${'pending_payment'.tr()} : \u{20B9} ${getTotalToPay(mainIndex)}"), c.grey_10, 12, true, true),
            ],
          )
        : selectedTaxTypeData[s.key_taxtypeid] == 2
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UIHelper.titleTextStyle(("${'computerRegisterNumber'.tr()} : ${mainList[mainIndex][s.key_assessment_id].toString() ?? ""}"), clr, 12, false, true),
                  UIHelper.verticalSpaceTiny,
                  UIHelper.titleTextStyle(("${'water_connection_number'.tr()} : ${mainList[mainIndex][s.key_assessment_no].toString() ?? ""}"), clr, 12, false, true),
                  UIHelper.verticalSpaceTiny,
                  UIHelper.titleTextStyle(("${'pending_payment'.tr()} : \u{20B9} ${getTotalToPay(mainIndex)}"), c.grey_10, 12, true, true),
                ],
              )
            : selectedTaxTypeData[s.key_taxtypeid] == 4
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UIHelper.titleTextStyle(("${'computerRegisterNumber'.tr()} : ${mainList[mainIndex][s.key_assessment_id].toString() ?? ""}"), clr, 12, false, true),
                      UIHelper.verticalSpaceTiny,
                      UIHelper.titleTextStyle(("${'financialYear'.tr()} : ${mainList[mainIndex]['financialyear'].toString() ?? ""}"), clr, 12, false, true),
                      UIHelper.verticalSpaceTiny,
                      UIHelper.titleTextStyle(("${'assesment_number'.tr()} : ${mainList[mainIndex][s.key_assessment_no].toString() ?? ""}"), clr, 12, false, true),
                      UIHelper.verticalSpaceTiny,
                      UIHelper.titleTextStyle(("${'pending_payment'.tr()} : \u{20B9} ${getTotalToPay(mainIndex)}"), c.grey_10, 12, true, true),
                    ],
                  )
                : selectedTaxTypeData[s.key_taxtypeid] == 5
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          UIHelper.titleTextStyle(("${'computerRegisterNumber'.tr()} : ${mainList[mainIndex][s.key_assessment_id].toString() ?? ""}"), clr, 12, false, true),
                          UIHelper.verticalSpaceTiny,
                          UIHelper.titleTextStyle(("${'lease_number'.tr()} : ${mainList[mainIndex][s.key_assessment_no].toString() ?? ""}"), clr, 12, false, true),
                          UIHelper.verticalSpaceTiny,
                          UIHelper.titleTextStyle(("${'lease_state'.tr()} : ${mainList[mainIndex]['lease_statename'].toString() ?? ""}"), clr, 12, false, true),
                          UIHelper.verticalSpaceTiny,
                          UIHelper.titleTextStyle(("${'lease_district'.tr()} : ${mainList[mainIndex]['lease_districtname'].toString() ?? ""}"), clr, 12, false, true),
                          UIHelper.verticalSpaceTiny,
                          UIHelper.titleTextStyle(
                              ("${'lease_duration'.tr()} : ${mainList[mainIndex]['from_date'].toString() ?? ""} - ${mainList[mainIndex]['to_date'].toString() ?? ""}"), clr, 12, false, true),
                          UIHelper.verticalSpaceTiny,
                          UIHelper.titleTextStyle(("${'pending_payment'.tr()} : \u{20B9} ${getTotalToPay(mainIndex)}"), c.grey_10, 12, true, true),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          UIHelper.titleTextStyle(("${'computerRegisterNumber'.tr()} : ${mainList[mainIndex][s.key_assessment_id].toString() ?? ""}"), clr, 12, false, true),
                          UIHelper.verticalSpaceTiny,
                          UIHelper.titleTextStyle(("${'traders_code'.tr()} : ${mainList[mainIndex][s.key_assessment_no].toString() ?? ""}"), clr, 12, false, true),
                          UIHelper.verticalSpaceTiny,
                          UIHelper.titleTextStyle(("${'pending_payment'.tr()} : \u{20B9} ${getTotalToPay(mainIndex)}"), c.grey_10, 12, true, true),
                        ],
                      );
  }

  Widget demandCalculationWidget(int mainIndex) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // UIHelper.titleTextStyle("${'total'.tr()} : \u{20B9} "+getTotalToPay(mainIndex), c.grey_10, 12, false, false),
            UIHelper.titleTextStyle("${'selected'.tr()} : \u{20B9} ${mainList[mainIndex][s.key_tax_total]}", c.grey_10, 12, false, false),
            UIHelper.horizontalSpaceSmall,
            /* UIHelper.titleTextStyle("${'demand'.tr()} : \u{20B9} ${mainList[mainIndex][s.key_tax_total]}", c.grey_10, 12, false, false),
            UIHelper.titleTextStyle("${'advance'.tr()} : \u{20B9} ${Utils().getTaxAdvance(mainList[mainIndex], selectedTaxTypeData['taxtypeid'].toString())}", c.grey_10, 12, false, false),
          */
          ],
        ),
        UIHelper.verticalSpaceSmall,
        /* UIHelper.titleTextStyle('payable'.tr().toString()+" : "+"\u{20B9} "+mainList[mainIndex][s.key_tax_pay].toString(), c.grey_8, 11, true, false),
      UIHelper.verticalSpaceTiny,*/
      ],
    );
  }

  Widget demandCalculationWidgetForSWM(int mainIndex) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            UIHelper.titleTextStyle("${'total'.tr()} : \u{20B9} " + getTotalToPaySWM(mainIndex), c.grey_10, 12, false, false),
            UIHelper.titleTextStyle("${'selected'.tr()} : \u{20B9} ${mainList[mainIndex][s.key_swm_total]}", c.grey_10, 12, false, false),
            /* UIHelper.titleTextStyle("${'demand'.tr()} : \u{20B9} ${mainList[mainIndex][s.key_swm_total]}", c.black, 11, false, false),
            UIHelper.titleTextStyle("${'advance'.tr()} : \u{20B9} ${mainList[mainIndex][s.key_swm_available_advance]}", c.black, 11, false, false),
          */
          ],
        ),
        UIHelper.verticalSpaceSmall,
        /*UIHelper.titleTextStyle('payable'.tr().toString()+" : "+"\u{20B9} "+mainList[mainIndex][s.key_swm_pay].toString(), c.grey_8, 11, true, false),
      UIHelper.verticalSpaceTiny,*/
      ],
    );
  }

  Widget assetCountWidget() {
    return Visibility(
        visible: totalAssessment > 0,
        child: Container(
          margin: EdgeInsets.only(top: 5, left: 20, right: 20, bottom: 15),
          decoration: UIHelper.GradientContainer(20, 20, 20, 20, [c.subscription_type_red_color, c.subscription_type_red_color], intwid: 0),
          child: Container(
            margin: EdgeInsets.only(left: 5, bottom: 3),
            decoration: UIHelper.roundedBorderWithColor(20, 20, 20, 20, c.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 5,
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      UIHelper.titleTextStyle("total_assessment".tr().toString(), c.grey_10, 11, true, true),
                      UIHelper.titleTextStyle(" $totalAssessment", c.grey_10, 14, true, true),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Visibility(
                  visible: pendingAssessment > 0,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.only(
                      top: 5,
                    ),
                    decoration: UIHelper.GradientContainer(0, 0, 18, 18, [c.red_new_light, c.red_new_light], intwid: 0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            UIHelper.titleTextStyle("pending_assessment_transaction".tr().toString(), c.grey_10, 11, true, true),
                            UIHelper.titleTextStyle(" $pendingAssessment", c.grey_10, 14, true, true),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        UIHelper.titleTextStyle(getWarningHint(), c.subscription_type_red_color, 11, true, true),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  String getWarningHint() {
    String hint = "";
    switch (selectedTaxTypeData[key_taxtypeid].toString()) {
      case '0':
        hint = "transaction_warning_hint".tr().toString();
        break;
      case '1':
        hint = "property_hint".tr().toString();
        break;
      case '2':
        hint = "water_hint".tr().toString();
        break;
      case '4':
        hint = "professional_hint".tr().toString();
        break;
      case '5':
        hint = "non_hint".tr().toString();
        break;
      case '6':
        hint = "trade_hint".tr().toString();
        break;
    }
    return hint;
  }

  double getTotal(double d1, double d2) {
    double s = 0.00;
    double ss = 0.00;
    ss = d1 - d2;
    ss > 0 ? s = ss : s = 0.00;
    return s;
  }

  Future<void> filterDataList() async {
    sampleDataList.clear();
    sampleDataList = preferencesService.taxCollectionDetailsList;
    totalAssessment = int.parse(await preferencesService.getUserInfo(key_total_assesment));
    pendingAssessment = int.parse(await preferencesService.getUserInfo(key_pending_assessment));
    mainList.clear();
    for (var sampletaxData in sampleDataList) {
      if (sampletaxData[s.key_taxtypeid].toString() == selectedTaxTypeData[s.key_taxtypeid].toString()) {
        if (preferencesService.addedTaxPayList.isNotEmpty) {
          for (var addtaxData in preferencesService.addedTaxPayList) {
            if (addtaxData[s.key_dcode] == sampletaxData[s.key_dcode] &&
                addtaxData[s.key_bcode] == sampletaxData[s.key_bcode] &&
                addtaxData[s.key_pvcode] == sampletaxData[s.key_pvcode] &&
                addtaxData[s.key_taxtypeid] == sampletaxData[s.key_taxtypeid] &&
                addtaxData[s.key_assessment_id] == sampletaxData[s.key_assessment_id] &&
                addtaxData[s.key_assessment_no] == sampletaxData[s.key_assessment_no] &&
                (addtaxData[key_no_of_demand_available] > 0) &&
                (sampletaxData[key_no_of_demand_available] > 0)) {
              for (var addtaxListData in addtaxData[s.key_DEMAND_DETAILS]) {
                for (var sampleSelectedList in sampletaxData[s.key_DEMAND_DETAILS]) {
                  if (Utils().getDemandId(addtaxListData, sampletaxData[s.key_taxtypeid].toString()) == Utils().getDemandId(sampleSelectedList, sampletaxData[s.key_taxtypeid].toString()) &&
                      (Utils().getDemadAmount(addtaxListData, sampletaxData[s.key_taxtypeid].toString()) == Utils().getDemadAmount(sampleSelectedList, sampletaxData[s.key_taxtypeid].toString()))) {
                    sampleSelectedList[s.key_flag] = addtaxListData[s.key_flag];
                    if (addtaxListData[s.key_flag] == true) {
                      if (sampletaxData[s.key_taxtypeid].toString() == "1") {
                        if (sampletaxData[s.key_taxtypeid].toString() == addtaxListData[s.key_taxtypeid].toString()) {
                          sampletaxData[s.key_tax_total] = sampletaxData[s.key_tax_total] + double.parse(Utils().getDemadAmount(addtaxListData, addtaxData[s.key_taxtypeid].toString()));
                        } else {
                          sampletaxData[s.key_swm_total] = sampletaxData[s.key_swm_total] + double.parse(Utils().getDemadAmount(addtaxListData, addtaxData[s.key_taxtypeid].toString()));
                        }
                      } else {
                        sampletaxData[s.key_tax_total] = sampletaxData[s.key_tax_total] + double.parse(Utils().getDemadAmount(addtaxListData, addtaxData[s.key_taxtypeid].toString()));
                      }
                    }
                  }
                }
              }
            }
          }
        }
        mainList.add(sampletaxData);
      }
    }
  }

  Future<void> addDataList(int mainIndex) async {
    List dataList = [];
    dataList.add(sampleDataList[mainIndex]);
    for (var sampletaxData in dataList) {
      if (sampletaxData[s.key_taxtypeid].toString() == selectedTaxTypeData[s.key_taxtypeid].toString()) {
        for (var addtaxData in preferencesService.addedTaxPayList) {
          if (addtaxData[s.key_taxtypeid] == sampletaxData[s.key_taxtypeid] &&
              addtaxData[s.key_assessment_id] == sampletaxData[s.key_assessment_id] &&
              addtaxData[s.key_assessment_no] == sampletaxData[s.key_assessment_no]) {
            addtaxData = sampletaxData;
          }
        }

        preferencesService.addedTaxPayList.add(sampletaxData);
      }
    }
    print("added" + preferencesService.addedTaxPayList.toString());
    print("added" + preferencesService.addedTaxPayList.length.toString());
  }

  Future<void> removeDataList(int mainIndex) async {
    List dataList = [];
    dataList.add(sampleDataList[mainIndex]);
    for (var sampletaxData in dataList) {
      if (preferencesService.addedTaxPayList.isNotEmpty) {
        for (var addtaxData in preferencesService.addedTaxPayList) {
          if (addtaxData[s.key_taxtypeid] == sampletaxData[s.key_taxtypeid] &&
              addtaxData[s.key_assessment_id] == sampletaxData[s.key_assessment_id] &&
              addtaxData[s.key_assessment_no] == sampletaxData[s.key_assessment_no]) {
            preferencesService.addedTaxPayList.remove(addtaxData);
          }
        }
      }
    }
    print("removed" + preferencesService.addedTaxPayList.toString());
    print("removed" + preferencesService.addedTaxPayList.length.toString());
  }

  String getvillageAndBlockName(int mainIndex, String taxTypeId) {
    String street = "";
    street = ((mainList[mainIndex][s.key_localbody_name] ?? '') + ", " + (mainList[mainIndex][s.key_bname] ?? ''));
    return street;
  }

  String getDoorAndStreetName(int mainIndex, String taxTypeId) {
    String street = "";
    switch (taxTypeId) {
      case '1':
        street = (mainList[mainIndex][s.key_door_no] ?? '') + ", " + (selectedLang == 'en' ? (mainList[mainIndex][s.key_street_name_en] ?? '') : (mainList[mainIndex][s.key_street_name_ta] ?? ''));
        break;
      case '2':
        street = selectedLang == 'en' ? (mainList[mainIndex]["street_name"] ?? '') : (mainList[mainIndex]["street_name"] ?? '');
        break;
      case '4':
        street = (mainList[mainIndex]['doorno'] ?? '') + ", " + (selectedLang == 'en' ? (mainList[mainIndex]["street_name_t"] ?? '') : (mainList[mainIndex]["street_name_t"] ?? ''));
        break;
      case '5':
        street = (mainList[mainIndex]['doorno'] ?? '') + ", " + (selectedLang == 'en' ? (mainList[mainIndex]["street_name"] ?? '') : (mainList[mainIndex]["street_name"] ?? ''));
        break;
      case '6':
        street = selectedLang == 'en' ? (mainList[mainIndex]["street_name_en"] ?? '') : (mainList[mainIndex]["street_name_ta"] ?? '');
        break;
    }
    return street;
  }

  bool getFlagStatus(String assId) {
    bool flag = false;
    if (mainList.isNotEmpty) {
      for (var data in mainList) {
        if (data[key_assessment_id].toString() != assId) {
          if (data[key_no_of_demand_available] > 0) {
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

  String getTotalToPay(int mainIndex) {
    double totAmt = 0.00;
    if (mainList.isNotEmpty) {
      if (mainList[mainIndex][key_no_of_demand_available] > 0) {
        for (var demanData in mainList[mainIndex][s.key_DEMAND_DETAILS]) {
          totAmt = totAmt + double.parse(Utils().getDemadAmount(demanData, mainList[mainIndex][key_taxtypeid].toString()));
        }
      }
    }
    return totAmt.toString();
  }

  String getTotalToPaySWM(int mainIndex) {
    double totAmt = 0.00;
    if (mainList.isNotEmpty) {
      for (var data in mainList) {
        if (data[key_no_of_demand_available] > 0) {
          for (var demanData in data[s.key_DEMAND_DETAILS]) {
            if (data[s.key_taxtypeid].toString() == "1") {
              if (data[s.key_taxtypeid].toString() != demanData[s.key_taxtypeid].toString()) {
                totAmt = totAmt + double.parse(Utils().getDemadAmount(demanData, data[key_taxtypeid].toString()));
              }
            }
          }
        }
      }
    }
    return totAmt.toString();
  }
}
