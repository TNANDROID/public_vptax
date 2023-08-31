// ignore_for_file: library_prefixes, prefer_const_constructors_in_immutables, library_private_types_in_public_api, prefer_typing_uninitialized_variables, prefer_const_constructors, avoid_print, deprecated_member_use, use_build_context_synchronously, file_names, non_constant_identifier_names, use_key_in_widget_constructors, prefer_adjacent_string_concatenation, avoid_function_literals_in_foreach_calls

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:public_vptax/Activity/Tax_Collection/added_tax_pay_details.dart';
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

class TaxCollectionDetailsView extends StatefulWidget {
  final selectedTaxTypeData;
  final isHome;
  final dcode;
  final bcode;
  final pvcode;
  final mobile;
  final isTaxDropDown;
  final selectedEntryType;
  TaxCollectionDetailsView({Key? key, this.selectedTaxTypeData, this.isHome, this.dcode, this.bcode, this.pvcode, this.mobile, this.isTaxDropDown, this.selectedEntryType});

  @override
  _TaxCollectionDetailsViewState createState() => _TaxCollectionDetailsViewState();
}

class _TaxCollectionDetailsViewState extends State<TaxCollectionDetailsView> with TickerProviderStateMixin {
  //Animation
  late AnimationController _controller;
  late Animation<double> _animation;

  PreferenceService preferencesService = locator<PreferenceService>();

  //Strings
  String selectedLang = "";
  String selectTaxtype = "";
  String mobile_widget = "";
  String islogin = "";

  //List
  List isShowFlag = [];
  List mainList = [];
  List sampleDataList = [];
  List taxTypeList = [];

  //int Double
  double main_totalAmount = 0.00;
  int main_count = 0;
  int totalAssessment = 0;
  int pendingAssessment = 0;

  ScrollController controller_scroll = ScrollController();

  var selectedTaxTypeData;
  TextEditingController nameTextController = TextEditingController();
  TextEditingController mobileTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  bool _isKeyboardFocused = false;

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

  void getCount() {
    main_count = 0;
    if (preferencesService.addedTaxPayList.isNotEmpty) {
      for (var prefSelectData in preferencesService.addedTaxPayList) {
        for (var prefSelectedTaxData in prefSelectData[s.key_DEMAND_DETAILS]) {
          if (prefSelectedTaxData[s.key_flag] == true) {
            main_count++;
          }
        }
        // for (var prefSelectedTaxData in prefSelectData['swmData']) {
        //   if (prefSelectedTaxData[s.key_flag] == true) {
        //     main_count++;
        //   }
        // }
      }
    }
  }

  Future<void> initialize() async {
    selectedLang = await preferencesService.getUserInfo("lang");
    islogin = await preferencesService.getUserInfo(s.key_isLogin);
    mobile_widget = islogin == "yes" ? await preferencesService.getUserInfo("mobile_number") : widget.mobile;
    taxTypeList = preferencesService.taxTypeList;
    selectTaxtype = selectedTaxTypeData['taxtypeid'].toString();
    if (widget.isHome) {
      await getTaxDetails();
    }
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
                      'tax_details'.tr().toString(),
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
                      addToPayWidget(),
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
                      Visibility(visible: islogin != "yes" || !widget.isHome, child: payWidget())
                    ],
                  ));
            },
            viewModelBuilder: () => StartUpViewModel()));
  }

  Widget headerCardUIWidget(int mainIndex) {
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
            padding: EdgeInsets.fromLTRB(15, 15, 10, 15),
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
                          SizedBox(
                            width: Screen.width(context) / 2,
                            child: Flex(
                              direction: Axis.horizontal,
                              children: [Flexible(child: UIHelper.titleTextStyle(mainList[mainIndex][s.key_name] ?? '', c.grey_9, 12, true, false))],
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
                // UIHelper.verticalSpaceTiny,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Positioned(
                            bottom: 0,
                            child: Container(
                              transform: Matrix4.translationValues(22.0, 0.0, 0.0),
                              width: 12,
                              height: 10,
                              color: c.orangeClr,
                            )),
                        Container(
                          transform: Matrix4.translationValues(22.0, 0.0, 0.0),
                          width: 12,
                          height: 20,
                          decoration: BoxDecoration(
                            color: c.red,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(100), // Adjust this value for a smaller/bigger circle
                              bottomRight: Radius.circular(100),
                            ),
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                        onTap: () {
                          setState(() {
                            if (isShowFlag.contains(mainIndex)) {
                              isShowFlag.remove(mainIndex);
                            } else {
                              isShowFlag.add(mainIndex);
                            }
                          });
                          double scrollOffset = mainIndex * 500; // Replace ITEM_HEIGHT with the height of each item

                          // Scroll to the top of the current item
                          controller_scroll.animateTo(scrollOffset, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                        },
                        child: Container(
                          height: 30,
                          width: MediaQuery.of(context).size.width / 2,
                          transform: Matrix4.translationValues(22.0, 0.0, 0.0),
                          padding: EdgeInsets.all(5),
                          decoration: UIHelper.GradientContainer(5, 0, 5, 14, [c.colorPrimary, c.orangeClr]),
                          //decoration: UIHelper.GradientContainer(5, 0, 5, 10, [Color(0xFFFFF59D), Color(0xFFFFE082)]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: UIHelper.titleTextStyle('demand_details', c.white, 10, true, true),
                              ),
                              Icon(
                                isShowFlag.contains(mainIndex) ? Icons.arrow_circle_up_rounded : Icons.arrow_circle_down_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          ),
                        ))
                  ],
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.linear,
                  child: Visibility(
                    visible: isShowFlag.contains(mainIndex),
                    child: propertyTaxCollectionWidget(mainIndex),
                  ),
                ),
              ],
            ))
      ],
    );
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
            ],
          )
        : selectedTaxTypeData[s.key_taxtypeid] == 2
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UIHelper.titleTextStyle(("${'computerRegisterNumber'.tr()} : ${mainList[mainIndex][s.key_assessment_id].toString() ?? ""}"), clr, 12, false, true),
                  UIHelper.verticalSpaceTiny,
                  UIHelper.titleTextStyle(("${'water_connection_number'.tr()} : ${mainList[mainIndex][s.key_assessment_no].toString() ?? ""}"), clr, 12, false, true)
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
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          UIHelper.titleTextStyle(("${'computerRegisterNumber'.tr()} : ${mainList[mainIndex][s.key_assessment_id].toString() ?? ""}"), clr, 12, false, true),
                          UIHelper.verticalSpaceTiny,
                          UIHelper.titleTextStyle(("${'traders_code'.tr()} : ${mainList[mainIndex][s.key_assessment_no].toString() ?? ""}"), clr, 12, false, true)
                        ],
                      );
  }

  Widget propertyTaxCollectionWidget(int mainIndex) {
    List demandList = mainList[mainIndex][s.key_DEMAND_DETAILS] ?? [];
    List taxData = [];
    List swmData = [];
    if (demandList.isNotEmpty) {
      for (int i = 0; i < demandList.length; i++) {
        if (selectedTaxTypeData[s.key_taxtypeid].toString() == "1") {
          if (demandList[i][s.key_taxtypeid].toString() == selectedTaxTypeData[s.key_taxtypeid].toString()) {
            taxData.add(demandList[i]);
          } else {
            swmData.add(demandList[i]);
          }
        } else {
          taxData.add(demandList[i]);
        }
      }
    }
    dynamic calcOfHeight = taxData.length / 2;
    int roundedValueOfHeight = calcOfHeight.ceil();
    int swmHeight = swmData.length * 30;
    return Container(
        margin: EdgeInsets.only(top: 15),
        decoration: UIHelper.GradientContainer(5, 5, 5, 5, [Color(0xFFFFF3E0), Color(0xFFFFF3E0)]),
        padding: EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Visibility(
                visible: taxData.isNotEmpty,
                child: Container(
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
                            if (selectedTaxTypeData[key_taxtypeid].toString() == "4") {
                              finYearStr = taxData[index]['financialyear'];
                            } else {
                              finYearStr = taxData[index][key_fin_year];
                            }
                            String durationStr = taxData[index][key_installment_group_name];
                            bool isStatus = false;
                            if (taxData[index][s.key_flag] == true) {
                              isStatus = true;
                            } else {
                              isStatus = false;
                            }

                            return GestureDetector(
                                onTap: () {
                                  if (!getFlagStatus(mainList[mainIndex][key_assessment_id].toString()) || islogin == "yes") {
                                    if (index == 0 || taxData[index - 1][s.key_flag] == true) {
                                      if (taxData[index][s.key_flag] == true) {
                                        for (int i = 0; i < taxData.length; i++) {
                                          if (i >= index) {
                                            if (taxData[i][s.key_flag] == true) {
                                              taxData[i][s.key_flag] = false;
                                              mainList[mainIndex][s.key_tax_total] =
                                                  mainList[mainIndex][s.key_tax_total] - double.parse(Utils().getDemadAmount(taxData[i], selectedTaxTypeData['taxtypeid'].toString()));

                                              mainList[mainIndex][s.key_tax_pay] =
                                                  getTotal(mainList[mainIndex][s.key_tax_total], double.parse(Utils().getTaxAdvance(mainList[mainIndex], selectedTaxTypeData['taxtypeid'].toString())));
                                            }
                                            if (taxData[0][s.key_flag] == false) {
                                              preferencesService.setUserInfo(key_isChecked, "");
                                            }
                                          }
                                        }
                                      } else {
                                        taxData[index][s.key_flag] = true;
                                        mainList[mainIndex][s.key_tax_total] =
                                            mainList[mainIndex][s.key_tax_total] + double.parse(Utils().getDemadAmount(taxData[index], selectedTaxTypeData['taxtypeid'].toString()));
                                        mainList[mainIndex][s.key_tax_pay] =
                                            getTotal(mainList[mainIndex][s.key_tax_total], double.parse(Utils().getTaxAdvance(mainList[mainIndex], selectedTaxTypeData['taxtypeid'].toString())));
                                      }
                                    } else {
                                      Utils().showAlert(context, ContentType.fail, 'pay_pending_year'.tr().toString());
                                    }
                                  } else {
                                    Utils().showAlert(context, ContentType.fail, 'pay_previous'.tr().toString());
                                  }

                                  setState(() {
                                    main_totalAmount = 0.00;
                                    for (int i = 0; i < mainList.length; i++) {
                                      main_totalAmount = main_totalAmount + mainList[i][s.key_tax_pay] + mainList[i][s.key_swm_pay];
                                    }
                                    if (islogin == "yes") {
                                      preferencesService.addedTaxPayList.removeWhere((element) => element[key_assessment_id].toString() == mainList[mainIndex][key_assessment_id].toString());
                                      dynamic selectedDemandDetails = mainList[mainIndex];
                                      List selectedDemandDetailsList = selectedDemandDetails[key_DEMAND_DETAILS];
                                      bool hasActiveFlag = selectedDemandDetailsList.any((json) => json[key_flag] == true);

                                      if (hasActiveFlag) {
                                        preferencesService.addedTaxPayList.add(selectedDemandDetails);
                                      }

                                      // element[key_DEMAND_DETAILS].forEach((e) {
                                      //   if (e[key_flag] == true) {
                                      //     preferencesService.addedTaxPayList.add(element);
                                      //   }
                                      // });
                                    }

                                    getCount();
                                    repeatOnce();
                                  });
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
                                                // UIHelper.titleTextStyle(finYearStr + " ( $durationStr )", isStatus ? c.white : c.grey_8, 10, false, true),
                                                Expanded(
                                                  child: Container(
                                                      padding: EdgeInsets.all(0),
                                                      child: Center(
                                                          child: UIHelper.titleTextStyle("\u{20B9} ${Utils().getDemadAmount(taxData[index], selectedTaxTypeData[key_taxtypeid].toString())}",
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
                        )))),
            Visibility(
              visible: taxData.isEmpty,
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                child: UIHelper.titleTextStyle('no_demand'.tr().toString(), c.black, 11, false, false),
              ),
            ),
            UIHelper.verticalSpaceSmall,
            demandCalculationWidget(mainIndex),
            Visibility(
                visible: swmData.isNotEmpty && selectedTaxTypeData[s.key_taxtypeid] == 1,
                child: Column(
                  children: [
                    UIHelper.verticalSpaceSmall,
                    UIHelper.titleTextStyle("swmUserCharges".tr().toString(), c.grey_9, 11, false, true),
                    UIHelper.verticalSpaceSmall,
                    Container(
                        margin: EdgeInsets.only(top: 5),
                        height: swmHeight + 0.02,
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: swmData.length,
                          itemBuilder: (context, rowIndex) {
                            int siNo = rowIndex + 1;
                            return SizedBox(
                                height: 30,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(padding: EdgeInsets.all(8.0), child: Center(child: UIHelper.titleTextStyle("$siNo", c.grey_8, 12, false, true))),
                                    ),
                                    Expanded(
                                        flex: 3,
                                        child: Container(padding: EdgeInsets.all(8.0), child: Center(child: UIHelper.titleTextStyle(swmData[rowIndex]['fin_year'], c.grey_8, 12, false, true)))),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                          padding: EdgeInsets.all(8.0),
                                          child: Center(
                                              child: UIHelper.titleTextStyle(Utils().getDemadAmount(swmData[rowIndex], selectedTaxTypeData['taxtypeid'].toString()), c.grey_8, 12, false, true))),
                                    ),
                                    rowIndex == 0 || taxData[rowIndex - 1][s.key_flag] == true
                                        ? Expanded(
                                            flex: 1,
                                            child: Container(
                                                padding: EdgeInsets.all(8.0),
                                                child: Center(
                                                  child: Checkbox(
                                                    side: BorderSide(width: 1, color: c.grey_6),
                                                    value: swmData[rowIndex][s.key_flag],
                                                    onChanged: (v) {
                                                      if (!getFlagStatus(mainList[mainIndex][key_assessment_id].toString())) {
                                                        if (rowIndex == 0 || swmData[rowIndex - 1][s.key_flag] == true) {
                                                          if (swmData[rowIndex][s.key_flag] == true) {
                                                            for (int i = 0; i < swmData.length; i++) {
                                                              if (i >= rowIndex) {
                                                                swmData[i][s.key_flag] = false;
                                                                mainList[mainIndex][s.key_swm_total] = mainList[mainIndex][s.key_swm_total] -
                                                                    double.parse(Utils().getDemadAmount(swmData[i], selectedTaxTypeData['taxtypeid'].toString()));
                                                                mainList[mainIndex][s.key_swm_pay] = getTotal(mainList[mainIndex][s.key_swm_total], mainList[mainIndex][s.key_swm_available_advance]);
                                                              }
                                                            }
                                                          } else {
                                                            swmData[rowIndex][s.key_flag] = true;
                                                            mainList[mainIndex][s.key_swm_total] = mainList[mainIndex][s.key_swm_total] +
                                                                double.parse(Utils().getDemadAmount(swmData[rowIndex], selectedTaxTypeData['taxtypeid'].toString()));
                                                            mainList[mainIndex][s.key_swm_pay] = getTotal(mainList[mainIndex][s.key_swm_total], mainList[mainIndex][s.key_swm_available_advance]);
                                                          }
                                                        } else {
                                                          Utils().showAlert(context, ContentType.fail, 'pay_pending_year'.tr().toString());
                                                        }
                                                      } else {
                                                        Utils().showAlert(context, ContentType.fail, 'pay_previous'.tr().toString());
                                                      }

                                                      setState(() {
                                                        main_totalAmount = 0.00;
                                                        if (islogin == "yes") {
                                                          preferencesService.addedTaxPayList.removeWhere((element) => element['taxtypeid'].toString() == selectedTaxTypeData['taxtypeid'].toString());
                                                        }
                                                        for (int i = 0; i < mainList.length; i++) {
                                                          main_totalAmount = main_totalAmount + mainList[i][s.key_tax_pay] + mainList[i][s.key_swm_pay];
                                                        }
                                                        if (islogin == "yes") {
                                                          mainList.forEach((element) {
                                                            element[key_DEMAND_DETAILS].forEach((e) {
                                                              if (e[key_flag] == true) {
                                                                preferencesService.addedTaxPayList.add(element);
                                                              }
                                                            });
                                                          });
                                                        }

                                                        getCount();
                                                        repeatOnce();
                                                      });
                                                    },
                                                  ),
                                                )),
                                          )
                                        : Expanded(
                                            child: SizedBox(
                                            width: 5,
                                          )),
                                  ],
                                ));
                          },
                        )),
                    UIHelper.verticalSpaceSmall,
                    demandCalculationWidgetForSWM(mainIndex),
                  ],
                )),
            UIHelper.verticalSpaceSmall,
          ],
        ));
  }

  Widget demandCalculationWidget(int mainIndex) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            UIHelper.titleTextStyle("${'demand'.tr()} : \u{20B9} ${mainList[mainIndex][s.key_tax_total]}", c.grey_10, 12, false, false),
            UIHelper.titleTextStyle("${'advance'.tr()} : \u{20B9} ${Utils().getTaxAdvance(mainList[mainIndex], selectedTaxTypeData['taxtypeid'].toString())}", c.grey_10, 12, false, false),
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
            UIHelper.titleTextStyle("${'demand'.tr()} : \u{20B9} ${mainList[mainIndex][s.key_swm_total]}", c.black, 11, false, false),
            UIHelper.titleTextStyle("${'advance'.tr()} : \u{20B9} ${mainList[mainIndex][s.key_swm_available_advance]}", c.black, 11, false, false),
          ],
        ),
        UIHelper.verticalSpaceSmall,
        /*UIHelper.titleTextStyle('payable'.tr().toString()+" : "+"\u{20B9} "+mainList[mainIndex][s.key_swm_pay].toString(), c.grey_8, 11, true, false),
      UIHelper.verticalSpaceTiny,*/
      ],
    );
  }

  Widget addToPayWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: Container(
            margin: EdgeInsets.only(top: 10, bottom: 15, left: 15),
            decoration: UIHelper.roundedBorderWithColorWithShadow(5, c.white, c.white),
            child: Row(
              children: [
                Container(
                    width: 35,
                    height: 35,
                    padding: EdgeInsets.all(5),
                    decoration: UIHelper.roundedBorderWithColor(5, 5, 5, 5, c.colorPrimary),
                    child: Image.asset(
                      selectedTaxTypeData["img_path"].toString(),
                      fit: BoxFit.contain,
                      height: 15,
                      width: 15,
                    )),
                UIHelper.horizontalSpaceSmall,
                Container(width: 110, margin: EdgeInsets.only(left: 5), child: addInputDropdownField()),
              ],
            ),
          ),
        ),
        Visibility(
          visible: !widget.isHome,
          child: Expanded(
            flex: 1,
            child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: MediaQuery.of(context).size.width / 2.5,
                  margin: EdgeInsets.only(top: 10, bottom: 15, right: 15),
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
                        "new".tr().toString() + (selectedLang == "en" ? selectedTaxTypeData["taxtypedesc_en"] : selectedTaxTypeData["taxtypedesc_ta"]) + "new2".tr().toString(),
                        c.white,
                        10,
                        true,
                        true,
                      )) // Add a small space between the icon and the text
                      ,
                    ],
                  ),
                )),
          ),
        ),
        Visibility(
          visible: widget.isHome,
          child: Expanded(
              flex: 1,
              child: Stack(
                children: [
                  Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          preferencesService.addedTaxPayList.isNotEmpty
                              ? Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => TaxPayDetailsView(),
                                ))
                              : Utils().showAlert(context, ContentType.warning, 'no_record'.tr().toString());
                        },
                        child: Container(
                            margin: EdgeInsets.only(top: 15, right: 30, bottom: 15),
                            decoration: UIHelper.GradientContainer(5, 5, 5, 5, [c.grey_7, c.grey_7]),
                            padding: EdgeInsets.fromLTRB(10, 5, 10, 8),
                            child: UIHelper.titleTextStyle("added_to_pay".tr().toString(), c.white, 12, true, true)),
                      )),
                  Positioned(
                      top: 1,
                      right: 1,
                      child: Transform.scale(
                          scale: _animation.value,
                          child: Container(
                            margin: EdgeInsets.only(right: 15),
                            child: Container(
                                decoration: UIHelper.circleWithColorWithShadow(360, c.account_status_green_color, c.account_status_green_color),
                                padding: EdgeInsets.fromLTRB(10, 5, 10, 8),
                                child: UIHelper.titleTextStyle((main_count).toString(), c.white, 12, true, true)),
                          )))
                ],
              )),
        ),
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
                        UIHelper.titleTextStyle("transaction_warning_hint".tr().toString(), c.subscription_type_red_color, 11, true, true),
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

  Widget addInputDropdownField() {
    return FormBuilderDropdown(
      enabled: widget.isTaxDropDown ? true : false,
      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: c.grey_8),
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
      iconSize: widget.isTaxDropDown ? 28 : 0,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: FormBuilderValidators.compose([FormBuilderValidators.required(errorText: "")]),
      items: taxTypeList
          .map((item) => DropdownMenuItem(
                value: item,
                child: Text(
                  selectedLang == "en" ? item[s.key_taxtypedesc_en].toString() : item[s.key_taxtypedesc_ta].toString(),
                  style: TextStyle(fontSize: 11.0, fontWeight: FontWeight.w400, color: c.black),
                ),
              ))
          .toList(),
      onChanged: (value) async {
        isShowFlag = [];
        selectTaxtype = value.toString();
        selectedTaxTypeData = value;
        await getTaxDetails();
        filterDataList();
        setState(() {});
      },
      name: 'TaxType',
    );
  }

  Widget payWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: UIHelper.GradientContainer(15, 15, 0, 0, [c.colorPrimary, c.colorAccentlight]),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 10, left: 20, right: 20),
              padding: EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  UIHelper.titleTextStyle("${'total_amount_to_pay'.tr()} : ", c.white, 11, true, true),
                  UIHelper.titleTextStyle("\u{20B9} $main_totalAmount", c.white, 14, true, true),
                ],
              ),
            ),
          ),
          // child: UIHelper.titleTextStyle("${'total_amount_to_pay'.tr()} : \u{20B9} $main_totalAmount", c.white, 12, true, true))),
          Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                  onTap: () {
                    List finalList = [];
                    for (int i = 0; i < mainList.length; i++) {
                      mainList[i][key_tax_total] > 0 ? finalList.add(mainList[i]) : null;
                    }
                    finalList.isNotEmpty ? _settingModalBottomSheet(context, finalList) : Utils().showAlert(context, ContentType.warning, 'select_demand'.tr().toString());
                  },
                  child: Container(
                      margin: EdgeInsets.only(top: 5, right: 30, bottom: 10),
                      decoration: UIHelper.GradientContainer(5, 5, 5, 5, [c.account_status_green_color, c.account_status_green_color]),
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 8),
                      child: UIHelper.titleTextStyle("pay".tr().toString(), c.white, 12, true, true)))),
        ],
      ),
    );
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
    main_count = 0;

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
                addtaxData[s.key_assessment_no] == sampletaxData[s.key_assessment_no]) {
              for (var addtaxListData in addtaxData[s.key_DEMAND_DETAILS]) {
                for (var sampleSelectedList in sampletaxData[s.key_DEMAND_DETAILS]) {
                  if (addtaxListData[s.key_fin_year] == sampleSelectedList[s.key_fin_year] &&
                      (Utils().getDemadAmount(addtaxListData, addtaxData[s.key_taxtypeid].toString()) == Utils().getDemadAmount(sampleSelectedList, sampletaxData[s.key_taxtypeid].toString()))) {
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

              /*for (var addtaxListData in addtaxData['swmData']) {
                for (var sampleSelectedList in sampletaxData['swmData']) {
                  if (addtaxListData[s.key_fin_year] == sampleSelectedList[s.key_fin_year] && addtaxListData[s.key_amount] == sampleSelectedList[s.key_amount]) {
                    sampleSelectedList[s.key_flag] = addtaxListData[s.key_flag];
                  }
                }
              } */
            }
          }
        }
        mainList.add(sampletaxData);
      }
    }
    getCount();

/*
    for (int m = 0; m < preferencesService.addedTaxPayList.length; m++) {
      for (int j = 0;
          j <
              preferencesService
                  .addedTaxPayList[m][s.key_DEMAND_DETAILS].length;
          j++) {
        if (preferencesService.addedTaxPayList[m][s.key_DEMAND_DETAILS][j]
                [s.key_flag] ==
            true) {
          main_count = main_count + 1;
        }
      }
      // for (int j = 0; j < preferencesService.addedTaxPayList[m]['swmData'].length; j++) {
      //   if (preferencesService.addedTaxPayList[m]['swmData'][j][s.key_flag] == true) {
      //     main_count = main_count + 1;
      //   }
      // }
    }
*/
  }

  Future<void> getTaxDetails() async {
    try {
      dynamic request = {};
      if (widget.selectedEntryType == 1) {
        request = {
          s.key_service_id: s.service_key_DemandSelectionList,
          s.key_mode_type: 1,
          s.key_taxtypeid: selectedTaxTypeData[s.key_taxtypeid].toString(),
          s.key_mobile_number: mobile_widget,
          s.key_language_name: selectedLang
        };
      }

      await StartUpViewModel().getMainServiceList("TaxCollectionDetails", requestDataValue: request, context: context, taxType: selectedTaxTypeData[s.key_taxtypeid].toString(), lang: selectedLang);

      // throw ('000');
    } catch (error) {
      debugPrint('error (${error.toString()}) has been caught');
    }
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

  Future<void> _settingModalBottomSheet(BuildContext context, List finalList) {
    int selected_id = -1;
    nameTextController.text = '';
    mobileTextController.text = '';
    emailTextController.text = '';

    List list = preferencesService.GatewayList;
    List paymentType = preferencesService.PaymentTypeList;
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: c.full_transparent,
        builder: (BuildContext bc) {
          return StatefulBuilder(builder: (BuildContext context, StateSetter mystate) {
            _isKeyboardFocused = MediaQuery.of(context).viewInsets.bottom > 0;
            return Wrap(
              children: <Widget>[
                Container(
                    decoration: UIHelper.GradientContainer(50.0, 50, 0, 0, [c.white, c.white]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            margin: EdgeInsets.only(top: 20, bottom: 10),
                            child: Text(('payment_mode'.tr().toString() + (selectedLang == 'en' ? paymentType[0][key_paymenttype_en] : paymentType[0][key_paymenttype_ta])),
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                              margin: EdgeInsets.only(top: 5, left: 20, bottom: 5),
                              child: Text('select_payment_gateway'.tr().toString(), style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal, color: c.black))),
                        ),
                        Container(
                            child: AnimationLimiter(
                                child: ListView.builder(
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: list.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return AnimationConfiguration.staggeredList(
                                          position: index,
                                          duration: const Duration(milliseconds: 800),
                                          child: SlideAnimation(
                                            horizontalOffset: 200.0,
                                            child: FlipAnimation(
                                              child: Padding(
                                                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                                  child: InkWell(
                                                    onTap: () {
                                                      mystate(() {
                                                        selected_id = list[index][key_gateway_id];
                                                      });
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Align(
                                                          alignment: Alignment.centerLeft,
                                                          child: selected_id == list[index][key_gateway_id]
                                                              ? Image.asset(
                                                                  imagePath.tick,
                                                                  color: c.account_status_green_color,
                                                                  height: 25,
                                                                  width: 25,
                                                                )
                                                              : Image.asset(
                                                                  imagePath.unchecked,
                                                                  color: c.grey_9,
                                                                  height: 25,
                                                                  width: 25,
                                                                ),
                                                        ),
                                                        IconButton(
                                                            onPressed: () {},
                                                            icon: Image.asset(
                                                              imagePath.payment_gateway,
                                                              height: 25,
                                                              width: 25,
                                                            )),
                                                        Text(
                                                          list[index][key_gateway_name],
                                                          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12, color: c.grey_9),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                            ),
                                          ));
                                    }))),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                              margin: EdgeInsets.only(top: 10, left: 20, bottom: 5),
                              child: Text('enter_the_details'.tr().toString(), style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal, color: c.black))),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
                          child: FormBuilder(
                              key: _formKey,
                              child: Column(
                                children: [
                                  addInputFormControl('name', 'name'.tr().toString(), key_name),
                                  UIHelper.verticalSpaceSmall,
                                  addInputFormControl('mobile', 'mobileNumber'.tr().toString(), key_mobile_number),
                                  UIHelper.verticalSpaceSmall,
                                  addInputFormControl('email', 'emailAddress'.tr().toString(), key_email),
                                  UIHelper.verticalSpaceSmall,
                                ],
                              )),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            margin: EdgeInsets.only(left: 5, right: 20, bottom: 20),
                            /*margin: EdgeInsets.only(left: 5, right: 20),
                      padding: EdgeInsets.only(bottom: 30, right: 10),*/
                            child: CustomGradientButton(
                              onPressed: () async {
                                if (selected_id > 0) {
                                  nameTextController.text = 'Test';
                                  mobileTextController.text = '9875235654';
                                  emailTextController.text = 'test@gmail.com';
                                  if (_formKey.currentState!.saveAndValidate()) {
                                    Map<String, dynamic> postParams = Map.from(_formKey.currentState!.value);
                                    postParams.removeWhere((key, value) => value == null);
                                    Navigator.of(context).pop();
                                    getPaymentToken(finalList, selected_id);
                                  }
                                } else {
                                  Utils().showAlert(context, ContentType.fail, 'select_anyOne_gateway'.tr().toString());
                                  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('select_anyOne_gateway'.tr().toString())));
                                }
                              },
                              width: 120,
                              height: 40,
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  "CONTINUE",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: _isKeyboardFocused ? Screen.height(context) * 0.36 : 0,
                        )
                      ],
                    )),
              ],
            );
          });
        });
  }

  Widget addInputFormControl(String nameField, String hintText, String fieldType) {
    return FormBuilderTextField(
      style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w400, color: c.grey_9),
      name: nameField,
      controller: fieldType == key_mobile_number
          ? mobileTextController
          : fieldType == key_name
              ? nameTextController
              : emailTextController,
      autocorrect: false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (value) {},
      decoration: InputDecoration(
        labelText: hintText,
        labelStyle: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600, color: c.grey_7),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: UIHelper.getInputBorder(1, borderColor: c.grey_7),
        focusedBorder: UIHelper.getInputBorder(1, borderColor: c.grey_7),
        focusedErrorBorder: UIHelper.getInputBorder(1, borderColor: Colors.red),
        errorBorder: UIHelper.getInputBorder(1, borderColor: Colors.red),
        errorStyle: TextStyle(fontSize: 10),
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12), // Optional: Adjust padding
      ),
      validator: fieldType == key_mobile_number
          ? ((value) {
              if (value == "" || value == null) {
                return "$hintText ${'isEmpty'.tr()}";
              }
              if (!Utils().isNumberValid(value)) {
                return "$hintText ${'isInvalid'.tr()}";
              }
              return null;
            })
          : fieldType == key_email
              ? ((value) {
                  if (value == "" || value == null) {
                    return "$hintText ${'isEmpty'.tr()}";
                  }
                  if (!Utils().isEmailValid(value)) {
                    return "$hintText ${'isInvalid'.tr()}";
                  }
                  return null;
                })
              : FormBuilderValidators.compose([
                  FormBuilderValidators.required(errorText: "$hintText ${'isEmpty'.tr()}"),
                ]),
      inputFormatters: fieldType == key_mobile_number
          ? [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ]
          : [],
      keyboardType: fieldType == key_mobile_number || fieldType == key_number ? TextInputType.number : TextInputType.text,
    );
  }

  /*{
  "data_content": {
  "service_id": "CollectionPaymentTokenList",
  "language_name": "en",
  "taxtypeid": "1",
  "dcode": "1",
  "bcode": "1",
  "pvcode": "1",
  "paymenttypeid": "5",
  "assessment_no": "22",
  "name": "Muthu",
  "mobile_no": "9698547875",
  "email_id": "sd@gmail.com",
  "payment_gateway": 1,
  "assessment_demand_list": {
  "Assessment_Details": [
  {
  "assessment_no": "22",
  "property_demand_id": [
  "36209149"
  ]
  }
  ]
  }
  }
  }*/
  Future<void> getPaymentToken(List selList, int selected_id) async {
    List finalList = selList;
    Utils().showProgress(context, 1);

    try {
      dynamic request = {};

      String taxType = finalList[0][s.key_taxtypeid].toString();
      var property_demand_id = [];

      for (var data in finalList[0][s.key_DEMAND_DETAILS]) {
        if (data[s.key_flag] == true) {
          if (taxType == "2") {
            String demandId = Utils().getDemandId(data, taxType);
            String amountToPay = data[key_watercharges];

            Map<String, String> details = {
              key_demand_id: demandId,
              key_amount_to_pay: amountToPay,
            };

            property_demand_id.add(details);
          } else {
            property_demand_id.add(Utils().getDemandId(data, taxType));
          }
        }
      }

      String demand_id = Utils().getPaymentTokenDemandId(taxType);

      List Assessment_Details = [
        {
          s.key_assessment_no: finalList[0][s.key_assessment_no].toString(),
          demand_id: property_demand_id,
        }
      ];
      dynamic assessment_demand_list = {
        'Assessment_Details': Assessment_Details,
      };
      request = {
        s.key_service_id: s.service_key_CollectionPaymentTokenList,
        s.key_language_name: selectedLang,
        s.key_taxtypeid: finalList[0][s.key_taxtypeid].toString(),
        s.key_dcode: finalList[0][s.key_dcode].toString(),
        s.key_bcode: finalList[0][s.key_bcode].toString(),
        s.key_pvcode: finalList[0][s.key_lbcode].toString(),
        if (finalList[0][s.key_taxtypeid].toString() == "4") s.key_fin_year: finalList[0][s.key_financialyear].toString(),
        s.key_assessment_no: finalList[0][s.key_assessment_no].toString(),
        s.key_paymenttypeid: 5,
        s.key_name: nameTextController.text,
        s.key_mobile_no: mobileTextController.text,
        s.key_email_id: emailTextController.text,
        s.key_payment_gateway: selected_id,
        'assessment_demand_list': assessment_demand_list,
      };
      dynamic pay_params =
          await StartUpViewModel().getMainServiceList("CollectionPaymentTokenList", requestDataValue: request, context: context, taxType: finalList[0][s.key_taxtypeid].toString(), lang: selectedLang);
     Utils().hideProgress(context);
      String transaction_unique_id = Utils().decodeBase64(pay_params['a'].toString());
      String atomTokenId = Utils().decodeBase64(pay_params['b'].toString());
      String req_payment_amount = Utils().decodeBase64(pay_params['c'].toString());
      String public_transaction_email_id = Utils().decodeBase64(pay_params['d'].toString());
      String public_transaction_mobile_no = Utils().decodeBase64(pay_params['e'].toString());
      String txmStartTime = Utils().decodeBase64(pay_params['f'].toString());
      String merchId = Utils().decodeBase64(pay_params['g'].toString());

      await Utils().openNdpsPG(context, atomTokenId, merchId, public_transaction_email_id, public_transaction_mobile_no);

      // throw ('000');
    } catch (error) {
      Utils().hideProgress(context);
      debugPrint('error (${error.toString()}) has been caught');
    }
  }
}
