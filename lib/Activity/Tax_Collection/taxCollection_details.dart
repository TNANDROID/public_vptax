// ignore_for_file: library_prefixes, prefer_const_constructors_in_immutables, library_private_types_in_public_api, prefer_typing_uninitialized_variables, prefer_const_constructors, avoid_print, deprecated_member_use, use_build_context_synchronously, file_names, non_constant_identifier_names, use_key_in_widget_constructors, prefer_adjacent_string_concatenation

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:public_vptax/Activity/Tax_Collection/added_tax_pay_details.dart';
import 'package:public_vptax/Layout/screen_size.dart';
import 'package:public_vptax/Layout/ui_helper.dart';
import 'package:public_vptax/Model/startup_model.dart';
import 'package:public_vptax/Resources/ColorsValue.dart' as c;
import 'package:public_vptax/Utils/ContentInfo.dart';
import 'package:public_vptax/Utils/utils.dart';
import '../../Resources/StringsKey.dart' as s;
import 'package:public_vptax/Services/Preferenceservices.dart';
import 'package:public_vptax/Services/locator.dart';
import 'package:stacked/stacked.dart';
import 'package:public_vptax/Resources/ImagePath.dart' as imagePath;

import '../../Resources/StringsKey.dart';

class TaxCollectionDetailsView extends StatefulWidget {
  final selectedTaxTypeData;
  final isHome;
  final dcode;
  final bcode;
  final pvcode;
  final mobile;
  final isTaxDropDown;
  final selectedEntryType;
  TaxCollectionDetailsView(
      {Key? key,
      this.selectedTaxTypeData,
      this.isHome,
      this.dcode,
      this.bcode,
      this.pvcode,
      this.mobile,
      this.isTaxDropDown,
      this.selectedEntryType});

  @override
  _TaxCollectionDetailsViewState createState() =>
      _TaxCollectionDetailsViewState();
}

class _TaxCollectionDetailsViewState extends State<TaxCollectionDetailsView>
    with TickerProviderStateMixin {
  //Animation
  late AnimationController _controller;
  late Animation<double> _animation;

  PreferenceService preferencesService = locator<PreferenceService>();

  //Strings
  String selectedLang = "";
  String selectTaxtype = "";
  String mobile_widget = "";

  //List
  List isShowFlag = [];
  List mainList = [];
  List sampleDataList = [];
  List taxTypeList = [];

  //int Double
  double main_totalAmount = 0.00;
  int main_count = 0;

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
    print("asdasd $selectedLang");
    mobile_widget = await preferencesService.getUserInfo(s.key_isLogin) == "yes"
        ? await preferencesService.getUserInfo("mobile_number")
        : widget.mobile;
    taxTypeList = preferencesService.taxTypeList;
    selectTaxtype = selectedTaxTypeData['taxtypeid'].toString();
    if (widget.isHome) {
      await getTaxDetails();
    }
    filterDataList();
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
                      Expanded(
                        child: SingleChildScrollView(
                            controller: controller_scroll,
                            scrollDirection: Axis.vertical,
                            child: Column(
                              children: [
                                UIHelper.verticalSpaceSmall,
                                addToPayWidget(),
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
                                  child: Container(
                                      margin:
                                          EdgeInsets.only(top: 100, right: 30),
                                      child: UIHelper.titleTextStyle(
                                          "no_record".tr().toString(),
                                          c.grey_9,
                                          12,
                                          true,
                                          true)),
                                )
                              ],
                            )),
                      ),
                      payWidget()
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
          decoration: UIHelper.roundedBorderWithColorWithShadow(
              5, c.colorPrimary, c.colorPrimary,
              borderWidth: 0),
        ),
        Container(
            width: Screen.width(context),
            margin: EdgeInsets.only(left: 20, top: 5, right: 15),
            padding: EdgeInsets.fromLTRB(15, 15, 10, 15),
            decoration: UIHelper.roundedBorderWithColorWithShadow(
                5, c.white, c.white,
                borderWidth: 0),
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
                              children: [
                                Flexible(
                                    child: UIHelper.titleTextStyle(
                                        mainList[mainIndex][s.key_name] ?? '',
                                        c.grey_9,
                                        12,
                                        true,
                                        false))
                              ],
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
                                UIHelper.titleTextStyle(
                                    getDoorAndStreetName(
                                        mainIndex,
                                        selectedTaxTypeData['taxtypeid']
                                            .toString()),
                                    c.grey_8,
                                    11,
                                    false,
                                    false),
                                UIHelper.titleTextStyle(
                                    getvillageAndBlockName(
                                        mainIndex,
                                        selectedTaxTypeData['taxtypeid']
                                            .toString()),
                                    c.grey_8,
                                    11,
                                    false,
                                    false),
                                UIHelper.titleTextStyle(
                                    mainList[mainIndex][s.key_district_name] ??
                                        '',
                                    c.grey_8,
                                    11,
                                    false,
                                    false)
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
                Container(
                    alignment: Alignment.centerLeft,
                    child: taxWiseReturnDataWidget(mainIndex, c.grey_8)),
                UIHelper.verticalSpaceTiny,
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width / 2,
                  padding: EdgeInsets.all(5),
                  decoration: UIHelper.roundedBorderWithColorWithShadow(
                      5, c.colorPrimary, c.colorAccentlight),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        if (isShowFlag.contains(mainIndex)) {
                          isShowFlag.remove(mainIndex);
                        } else {
                          isShowFlag.add(mainIndex);
                        }
                      });
                      double scrollOffset = mainIndex *
                          500; // Replace ITEM_HEIGHT with the height of each item

                      // Scroll to the top of the current item
                      controller_scroll.animateTo(scrollOffset,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: UIHelper.titleTextStyle(
                              'demand_details', c.white, 10, true, true),
                        ),
                        Icon(
                          isShowFlag.contains(mainIndex)
                              ? Icons.arrow_circle_up_rounded
                              : Icons.arrow_circle_down_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
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
              UIHelper.titleTextStyle(
                  ('building_licence_number'.tr().toString() +
                      " : " +
                      (mainList[mainIndex][s.key_building_licence_no]
                              .toString() ??
                          "")),
                  clr,
                  12,
                  false,
                  true),
              UIHelper.titleTextStyle(
                  ('assesment_number'.tr().toString() +
                      " : " +
                      (mainList[mainIndex][s.key_assessment_no].toString() ??
                          "")),
                  clr,
                  12,
                  false,
                  true),
            ],
          )
        : selectedTaxTypeData[s.key_taxtypeid] == 2
            ? UIHelper.titleTextStyle(
                ('water_connection_number'.tr().toString() +
                    " : " +
                    (mainList[mainIndex][s.key_assessment_no].toString() ??
                        "")),
                clr,
                12,
                false,
                true)
            : selectedTaxTypeData[s.key_taxtypeid] == 4
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UIHelper.titleTextStyle(
                          ('fin_year'.tr().toString() +
                              " : " +
                              (mainList[mainIndex]['financialyear']
                                      .toString() ??
                                  "")),
                          clr,
                          12,
                          false,
                          true),
                      UIHelper.titleTextStyle(
                          ('assesment_number'.tr().toString() +
                              " : " +
                              (mainList[mainIndex][s.key_assessment_no]
                                      .toString() ??
                                  "")),
                          clr,
                          12,
                          false,
                          true),
                    ],
                  )
                : selectedTaxTypeData[s.key_taxtypeid] == 5
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          UIHelper.titleTextStyle(
                              ('lease_number'.tr().toString() +
                                  " : " +
                                  (mainList[mainIndex][s.key_assessment_no]
                                          .toString() ??
                                      "")),
                              clr,
                              12,
                              false,
                              true),
                          UIHelper.verticalSpaceTiny,
                          UIHelper.titleTextStyle(
                              ('lease_state'.tr().toString() +
                                  " : " +
                                  (mainList[mainIndex]['lease_statename']
                                          .toString() ??
                                      "")),
                              clr,
                              12,
                              false,
                              true),
                          UIHelper.verticalSpaceTiny,
                          UIHelper.titleTextStyle(
                              ('lease_district'.tr().toString() +
                                  " : " +
                                  (mainList[mainIndex]['lease_districtname']
                                          .toString() ??
                                      "")),
                              clr,
                              12,
                              false,
                              true),
                          UIHelper.verticalSpaceTiny,
                          UIHelper.titleTextStyle(
                              ('lease_duration'.tr().toString() +
                                  " : " +
                                  (mainList[mainIndex]['from_date']
                                          .toString() ??
                                      "") +
                                  " - " +
                                  (mainList[mainIndex]['to_date'].toString() ??
                                      "")),
                              clr,
                              12,
                              false,
                              true),
                        ],
                      )
                    : UIHelper.titleTextStyle(
                        ('traders_code'.tr().toString() +
                            " : " +
                            (mainList[mainIndex][s.key_assessment_no]
                                    .toString() ??
                                "")),
                        clr,
                        12,
                        false,
                        true);
  }

  Widget propertyTaxCollectionWidget(int mainIndex) {
    List demandList = mainList[mainIndex][s.key_DEMAND_DETAILS];
    List taxData = [];
    List swmData = [];
    for (int i = 0; i < demandList.length; i++) {
      if (selectedTaxTypeData[s.key_taxtypeid].toString() == "1") {
        if (demandList[i][s.key_taxtypeid].toString() ==
            selectedTaxTypeData[s.key_taxtypeid].toString()) {
          taxData.add(demandList[i]);
        } else {
          swmData.add(demandList[i]);
        }
      } else {
        taxData.add(demandList[i]);
      }
    }

    int dataWiseHeight = taxData.length * 30;
    int swmHeight = swmData.length * 30;
    return Container(
        margin: EdgeInsets.only(top: 15),
        decoration: UIHelper.roundedBorderWithColor(
            3, 3, 3, 3, c.need_improvement2,
            borderWidth: 1, borderColor: c.grey_6),
        padding: EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Visibility(
              visible: taxData.isNotEmpty,
                child: Container(
                padding: EdgeInsets.only(top: 0),
                height: dataWiseHeight + 0.02,
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: taxData.length,
                  itemBuilder: (context, rowIndex) {
                    int siNo = rowIndex + 1;
                    return SizedBox(
                        height: 30,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: Center(
                                      child: UIHelper.titleTextStyle(
                                          "$siNo", c.grey_8, 12, false, true))),
                            ),
                            Expanded(
                                flex: 3,
                                child: Container(
                                    padding: EdgeInsets.all(8.0),
                                    child: Center(
                                        child: UIHelper.titleTextStyle(
                                            selectedTaxTypeData[
                                            s.key_taxtypeid] ==
                                                4
                                                ? taxData[rowIndex]
                                            ['financialyear']
                                                : taxData[rowIndex]
                                            [s.key_fin_year],
                                            c.grey_8,
                                            12,
                                            false,
                                            true)))),
                            Expanded(
                                flex: 3,
                                child: Container(
                                    padding: EdgeInsets.all(8.0),
                                    child: Center(
                                        child: UIHelper.titleTextStyle(
                                            taxData[rowIndex]
                                            [s.key_installment_group_name],
                                            c.grey_8,
                                            12,
                                            false,
                                            true)))),
                            Expanded(
                              flex: 2,
                              child: Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: Center(
                                      child: UIHelper.titleTextStyle(
                                          getDemad(
                                              taxData[rowIndex],
                                              selectedTaxTypeData['taxtypeid']
                                                  .toString()),
                                          c.grey_8,
                                          12,
                                          false,
                                          true))),
                            ),
                            rowIndex ==0 || taxData[rowIndex-1][s.key_flag]==true?
                            Expanded(
                              flex: 1,
                              child: Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Checkbox(
                                      side:
                                      BorderSide(width: 1, color: c.grey_6),
                                      value: taxData[rowIndex][s.key_flag],
                                      onChanged: (v) async {
                                        if (!getFlagStatus(mainList[mainIndex][key_assessment_id].toString())) {
                                          if (rowIndex == 0 ||
                                              taxData[rowIndex - 1]
                                              [s.key_flag] ==
                                                  true) {
                                            if (taxData[rowIndex][s.key_flag] ==
                                                true) {
                                              for (int i = 0;
                                              i < taxData.length;
                                              i++) {
                                                if (i >= rowIndex) {
                                                  if (taxData[i][s.key_flag] ==
                                                      true) {
                                                    taxData[i][s.key_flag] =
                                                    false;
                                                    print(
                                                        "Tot>>${mainList[mainIndex][s.key_tax_total]}");
                                                    mainList[mainIndex][s
                                                        .key_tax_total] = mainList[
                                                    mainIndex]
                                                    [s.key_tax_total] -
                                                        double.parse(getDemad(
                                                            taxData[i],
                                                            selectedTaxTypeData[
                                                            'taxtypeid']
                                                                .toString()));

                                                    print(
                                                        "Tot>>${getDemad(taxData[i], selectedTaxTypeData['taxtypeid'].toString())}");
                                                    print(
                                                        "Tot${mainList[mainIndex][s.key_tax_total]}");
                                                    mainList[mainIndex][
                                                    s
                                                        .key_tax_pay] = getTotal(
                                                        mainList[mainIndex]
                                                        [s.key_tax_total],
                                                        double.parse(getTaxAdvance(
                                                            mainList[mainIndex],
                                                            selectedTaxTypeData[
                                                            'taxtypeid']
                                                                .toString())));
                                                  }
                                                  if (taxData[0][s.key_flag] ==
                                                      false) {
                                                    preferencesService.setUserInfo(key_isChecked, "");

                                                  }
                                                }
                                              }
                                            } else {
                                              taxData[rowIndex][s.key_flag] =
                                              true;
                                              print(
                                                  'key_tax_total: ${mainList[mainIndex][s.key_tax_total].runtimeType}');
                                              print(
                                                  'key_demand: ${getTaxAdvance(mainList[mainIndex], selectedTaxTypeData['taxtypeid'].toString()).runtimeType}');
                                              mainList[mainIndex]
                                              [s.key_tax_total] =
                                                  mainList[mainIndex]
                                                  [s.key_tax_total] +
                                                      double.parse(getDemad(
                                                          taxData[rowIndex],
                                                          selectedTaxTypeData[
                                                          'taxtypeid']
                                                              .toString()));
                                              mainList[mainIndex][
                                              s
                                                  .key_tax_pay] = getTotal(
                                                  mainList[mainIndex]
                                                  [s.key_tax_total],
                                                  double.parse(getTaxAdvance(
                                                      mainList[mainIndex],
                                                      selectedTaxTypeData[
                                                      'taxtypeid']
                                                          .toString())));
                                            }
                                          } else {
                                            Utils().showAlert(
                                                context,
                                                ContentType.fail,
                                                'pay_pending_year'
                                                    .tr()
                                                    .toString());
                                          }
                                        } else {
                                          Utils().showAlert(
                                              context,
                                              ContentType.fail,
                                              'pay_previous'.tr().toString());
                                        }

                                        setState(() {
                                          main_count = 0;
                                          main_totalAmount = 0.00;
                                          preferencesService.addedTaxPayList
                                              .removeWhere((element) =>
                                          element['taxtypeid']
                                              .toString() ==
                                              selectedTaxTypeData
                                              ['taxtypeid']
                                                  .toString());
                                          for (int i = 0;
                                          i < mainList.length;
                                          i++) {
                                            main_totalAmount =
                                                main_totalAmount +
                                                    mainList[i][s.key_tax_pay] +
                                                    mainList[i][s.key_swm_pay];
                                            if (mainList[mainIndex]
                                            [s.key_tax_total] >
                                                0 ||
                                                mainList[mainIndex]
                                                [s.key_swm_total] >
                                                    0) {
                                              preferencesService.addedTaxPayList
                                                  .add(mainList[mainIndex]);
                                            }

                                          }

                                          getCount();
                                          repeatOnce();
                                        });
                                      },
                                    ),
                                  )),
                            ):
                            Expanded(child: SizedBox(width: 5,)),
                          ],
                        ));
                  },
                ))),
            Visibility(
              visible: taxData.isEmpty,
              child: Container(
                alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              child: UIHelper.titleTextStyle(
                  'no_demand'.tr().toString(),
                  c.black,
                  11,
                  false,
                  false),
            ),
            ),
            UIHelper.verticalSpaceSmall,
            demandCalculationWidget(mainIndex),
            Visibility(
                visible: swmData.isNotEmpty &&
                    selectedTaxTypeData[s.key_taxtypeid] == 1,
                child: Column(
                  children: [
                    UIHelper.verticalSpaceSmall,
                    UIHelper.titleTextStyle("swmUserCharges".tr().toString(),
                        c.grey_9, 11, false, true),
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
                                      child: Container(
                                          padding: EdgeInsets.all(8.0),
                                          child: Center(
                                              child: UIHelper.titleTextStyle(
                                                  "$siNo",
                                                  c.grey_8,
                                                  12,
                                                  false,
                                                  true))),
                                    ),
                                    Expanded(
                                        flex: 3,
                                        child: Container(
                                            padding: EdgeInsets.all(8.0),
                                            child: Center(
                                                child: UIHelper.titleTextStyle(
                                                    swmData[rowIndex]
                                                        ['fin_year'],
                                                    c.grey_8,
                                                    12,
                                                    false,
                                                    true)))),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                          padding: EdgeInsets.all(8.0),
                                          child: Center(
                                              child: UIHelper.titleTextStyle(
                                                  getDemad(
                                                      swmData[rowIndex],
                                                      selectedTaxTypeData[
                                                              'taxtypeid']
                                                          .toString()),
                                                  c.grey_8,
                                                  12,
                                                  false,
                                                  true))),
                                    ),
                                    rowIndex ==0 || taxData[rowIndex-1][s.key_flag]==true?
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                          padding: EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Checkbox(
                                              side: BorderSide(
                                                  width: 1, color: c.grey_6),
                                              value: swmData[rowIndex]
                                                  [s.key_flag],
                                              onChanged: (v) {
                                                if (!getFlagStatus(mainList[mainIndex][key_assessment_id].toString())) {
                                                  if (rowIndex == 0 ||
                                                      swmData[rowIndex - 1]
                                                              [s.key_flag] ==
                                                          true) {
                                                    if (swmData[rowIndex]
                                                            [s.key_flag] ==
                                                        true) {
                                                      for (int i = 0;
                                                          i < swmData.length;
                                                          i++) {
                                                        if (i >= rowIndex) {
                                                          swmData[i]
                                                                  [s.key_flag] =
                                                              false;
                                                          mainList[mainIndex][s
                                                              .key_swm_total] = mainList[
                                                                      mainIndex]
                                                                  [s
                                                                      .key_swm_total] -
                                                              double.parse(getDemad(
                                                                  swmData[i],
                                                                  selectedTaxTypeData[
                                                                          'taxtypeid']
                                                                      .toString()));
                                                          mainList[mainIndex][
                                                              s
                                                                  .key_swm_pay] = getTotal(
                                                              mainList[mainIndex][s
                                                                  .key_swm_total],
                                                              mainList[
                                                                      mainIndex]
                                                                  [
                                                                  s.key_swm_available_advance]);
                                                        }
                                                      }
                                                    } else {
                                                      swmData[rowIndex]
                                                          [s.key_flag] = true;
                                                      mainList[mainIndex][s
                                                          .key_swm_total] = mainList[
                                                                  mainIndex][
                                                              s.key_swm_total] +
                                                          double.parse(getDemad(
                                                              swmData[rowIndex],
                                                              selectedTaxTypeData[
                                                                      'taxtypeid']
                                                                  .toString()));
                                                      mainList[mainIndex][
                                                          s
                                                              .key_swm_pay] = getTotal(
                                                          mainList[mainIndex]
                                                              [s.key_swm_total],
                                                          mainList[mainIndex][s
                                                              .key_swm_available_advance]);
                                                    }
                                                  } else {
                                                    Utils().showAlert(
                                                        context,
                                                        ContentType.fail,
                                                        'pay_pending_year'
                                                            .tr()
                                                            .toString());
                                                  }
                                                } else {
                                                  Utils().showAlert(
                                                      context,
                                                      ContentType.fail,
                                                      'pay_previous'
                                                          .tr()
                                                          .toString());
                                                }

                                                setState(() {
                                                  main_count = 0;
                                                  main_totalAmount = 0.00;
                                                  preferencesService
                                                      .addedTaxPayList
                                                      .removeWhere((element) =>
                                                  element['taxtypeid']
                                                      .toString() ==
                                                      selectedTaxTypeData
                                                      [
                                                      'taxtypeid']
                                                          .toString() );
                                                  for (int i = 0;
                                                      i < mainList.length;
                                                      i++) {
                                                    main_totalAmount =
                                                        main_totalAmount +
                                                            mainList[i][
                                                                s.key_tax_pay] +
                                                            mainList[i]
                                                                [s.key_swm_pay];
                                                    if (mainList[mainIndex][
                                                    s.key_tax_total] >
                                                        0 ||
                                                        mainList[mainIndex][
                                                        s.key_swm_total] >
                                                            0) {
                                                      preferencesService
                                                          .addedTaxPayList
                                                          .add(mainList[
                                                      mainIndex]);
                                                    }

                                                  }

                                                  getCount();
                                                  repeatOnce();
                                                });
                                              },
                                            ),
                                          )),
                                    ):
                                    Expanded(child: SizedBox(width: 5,)),
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
            UIHelper.titleTextStyle(
                "${'demand'.tr()} : \u{20B9} ${mainList[mainIndex][s.key_tax_total]}",
                c.black,
                11,
                false,
                false),
            UIHelper.titleTextStyle(
                "${'advance'.tr()} : \u{20B9} ${getTaxAdvance(mainList[mainIndex], selectedTaxTypeData['taxtypeid'].toString())}",
                c.black,
                11,
                false,
                false),
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
            UIHelper.titleTextStyle(
                "${'demand'.tr()} : \u{20B9} ${mainList[mainIndex][s.key_swm_total]}",
                c.black,
                11,
                false,
                false),
            UIHelper.titleTextStyle(
                "${'advance'.tr()} : \u{20B9} ${mainList[mainIndex][s.key_swm_available_advance]}",
                c.black,
                11,
                false,
                false),
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
            decoration:
                UIHelper.roundedBorderWithColorWithShadow(5, c.white, c.white),
            child: Row(
              children: [
                Container(
                    width: 35,
                    height: 35,
                    padding: EdgeInsets.all(5),
                    decoration: UIHelper.roundedBorderWithColor(
                        5, 5, 5, 5, c.colorPrimary),
                    child: Image.asset(
                      selectedTaxTypeData["img_path"].toString(),
                      fit: BoxFit.contain,
                      height: 15,
                      width: 15,
                    )),
                UIHelper.horizontalSpaceSmall,
                Container(
                    width: 110,
                    margin: EdgeInsets.only(left: 5),
                    child: addInputDropdownField()),
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
                  decoration: UIHelper.GradientContainer(
                      5, 5, 5, 5, [c.grey_8, c.grey_8]),
                  padding: EdgeInsets.fromLTRB(5, 8, 0, 8),
                  child: Row(
                    // Wrap with Row to add the plus icon
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons
                            .add, // Use the icon you prefer (e.g., Icons.add, Icons.add_circle, etc.)
                        color: c.white,
                        size: 15,
                      ),
                      SizedBox(width: 3),
                      Flexible(
                          child: UIHelper.titleTextStyle(
                        "new".tr().toString() +
                            (selectedLang == "en"
                                ? selectedTaxTypeData["taxtypedesc_en"]
                                : selectedTaxTypeData["taxtypedesc_ta"]) +
                            "new2".tr().toString(),
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
                              : Utils().showAlert(context, ContentType.warning,
                                  'no_record'.tr().toString());
                        },
                        child: Container(
                            margin:
                                EdgeInsets.only(top: 15, right: 30, bottom: 15),
                            decoration: UIHelper.GradientContainer(
                                5, 5, 5, 5, [c.grey_7, c.grey_7]),
                            padding: EdgeInsets.fromLTRB(10, 5, 10, 8),
                            child: UIHelper.titleTextStyle(
                                "added_to_pay".tr().toString(),
                                c.white,
                                12,
                                true,
                                true)),
                      )),
                  Positioned(
                      top: 1,
                      right: 1,
                      child: Transform.scale(
                          scale: _animation.value,
                          child: Container(
                            margin: EdgeInsets.only(right: 15),
                            child: Container(
                                decoration: UIHelper.circleWithColorWithShadow(
                                    360,
                                    c.account_status_green_color,
                                    c.account_status_green_color),
                                padding: EdgeInsets.fromLTRB(10, 5, 10, 8),
                                child: UIHelper.titleTextStyle(
                                    (main_count).toString(),
                                    c.white,
                                    12,
                                    true,
                                    true)),
                          )))
                ],
              )),
        ),
      ],
    );
  }

  Widget addInputDropdownField() {
    return FormBuilderDropdown(
      enabled: widget.isTaxDropDown ? true : false,
      style:
          TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: c.grey_8),
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
        focusedBorder:
            UIHelper.getInputBorder(0, borderColor: c.full_transparent),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 0.0),
          borderRadius: BorderRadius.circular(
              0), // Increase the radius to adjust the height
        ),
      ),
      initialValue: selectedTaxTypeData,
      iconSize: widget.isTaxDropDown ? 28 : 0,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: FormBuilderValidators.compose(
          [FormBuilderValidators.required(errorText: "")]),
      items: taxTypeList
          .map((item) => DropdownMenuItem(
                value: item,
                child: Text(
                  selectedLang == "en"
                      ? item[s.key_taxtypedesc_en].toString()
                      : item[s.key_taxtypedesc_ta].toString(),
                  style: TextStyle(
                      fontSize: 11.0,
                      fontWeight: FontWeight.w400,
                      color: c.black),
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
      decoration: UIHelper.GradientContainer(
          15, 15, 0, 0, [c.colorPrimary, c.colorAccentlight]),
      child: Column(
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: Container(
                  margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                  padding: EdgeInsets.all(5),
                  child: UIHelper.titleTextStyle(
                      "${'total_amount_to_pay'.tr()} : \u{20B9}$main_totalAmount",
                      c.white,
                      12,
                      true,
                      true))),
          Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                  onTap: () {
                    preferencesService.addedTaxPayList.isNotEmpty
                        ? Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => TaxPayDetailsView(),
                          ))
                        : Utils().showAlert(context, ContentType.warning,
                            'no_record'.tr().toString());
                  },
                  child: Container(
                      margin: EdgeInsets.only(top: 5, right: 30, bottom: 10),
                      decoration: UIHelper.GradientContainer(5, 5, 5, 5, [
                        c.account_status_green_color,
                        c.account_status_green_color
                      ]),
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 8),
                      child: UIHelper.titleTextStyle(
                          "pay".tr().toString(), c.white, 12, true, true)))),
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

  void filterDataList() {
    sampleDataList.clear();
    sampleDataList = preferencesService.taxCollectionDetailsList;
    main_count = 0;

    mainList.clear();
    for (var sampletaxData in sampleDataList) {
      if (sampletaxData[s.key_taxtypeid].toString() ==
          selectedTaxTypeData[s.key_taxtypeid].toString()) {
        if (preferencesService.addedTaxPayList.isNotEmpty) {
          for (var addtaxData in preferencesService.addedTaxPayList) {
            if (addtaxData[s.key_dcode] == sampletaxData[s.key_dcode] &&
                addtaxData[s.key_bcode] == sampletaxData[s.key_bcode] &&
                addtaxData[s.key_pvcode] == sampletaxData[s.key_pvcode] &&
                addtaxData[s.key_taxtypeid] == sampletaxData[s.key_taxtypeid] &&
                addtaxData[s.key_assessment_id] == sampletaxData[s.key_assessment_id] &&
                addtaxData[s.key_assessment_no] ==
                    sampletaxData[s.key_assessment_no]) {
              for (var addtaxListData in addtaxData[s.key_DEMAND_DETAILS]) {
                for (var sampleSelectedList
                    in sampletaxData[s.key_DEMAND_DETAILS]) {
                  if (addtaxListData[s.key_fin_year] ==
                          sampleSelectedList[s.key_fin_year] &&
                      addtaxListData[s.key_amount] ==
                          sampleSelectedList[s.key_amount]) {
                    sampleSelectedList[s.key_flag] = addtaxListData[s.key_flag];
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
        print("mainList>>>>>>>"+mainList.toString());
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

      await StartUpViewModel().getMainServiceList("TaxCollectionDetails",
          requestDataValue: request,
          context: context,
          taxType: selectedTaxTypeData[s.key_taxtypeid].toString(),
          lang: selectedLang);

      // throw ('000');
    } catch (error) {
      print('error (${error.toString()}) has been caught');
    }
  }

  String getvillageAndBlockName(int mainIndex, String taxTypeId) {
    String street = "";
    street = ((mainList[mainIndex][s.key_localbody_name] ?? '') +
        ", " +
        (mainList[mainIndex][s.key_bname] ?? ''));
    print(mainList[mainIndex][s.key_localbody_name]);
    print(mainList[mainIndex][s.key_bname]);
    print(street);
    return street;
  }

  String getDoorAndStreetName(int mainIndex, String taxTypeId) {
    String street = "";
    switch (taxTypeId) {
      case '1':
        street =
            (mainList[mainIndex][s.key_door_no] ?? '') + ", " + selectedLang ==
                    'en'
                ? (mainList[mainIndex][s.key_street_name_en] ?? '')
                : (mainList[mainIndex][s.key_street_name_ta] ?? '');
        break;
      case '2':
        street = selectedLang == 'en'
            ? (mainList[mainIndex]["street_name"] ?? '')
            : (mainList[mainIndex]["street_name"] ?? '');
        break;
      case '4':
        street =
            (mainList[mainIndex]['doorno'] ?? '') + ", " + selectedLang == 'en'
                ? (mainList[mainIndex]["street_name_t"] ?? '')
                : (mainList[mainIndex]["street_name_t"] ?? '');
        break;
      case '5':
        street =
            (mainList[mainIndex]['doorno'] ?? '') + ", " + selectedLang == 'en'
                ? (mainList[mainIndex]["street_name"] ?? '')
                : (mainList[mainIndex]["street_name"] ?? '');
        break;
      case '6':
        street = (mainList[mainIndex][s.key_localbody_name] ?? '') +
            ", " +
            (mainList[mainIndex][s.key_bname] ?? '');
        break;
    }
    print(street);
    return street;
  }

  String getDemad(taxData, String taxTypeId) {
    String amount = "";
    switch (taxTypeId) {
      case '1':
        amount = taxData['demand'].toString();
        break;
      case '2':
        amount = taxData['watercharges'].toString();
        break;
      case '4':
        amount = taxData['profession_tax'].toString();
        break;
      case '5':
        amount = taxData['nontax_amount'].toString();
        break;
      case '6':
        amount = taxData['traders_rate'].toString();
        break;
    }

    // taxData[rowIndex][s.key_demand].toString();
    return amount;
  }

  String getTaxAdvance(taxData, String taxTypeId) {
    String amount = "";
    switch (taxTypeId) {
      case '1':
        amount = taxData['property_available_advance'].toString();
        break;
      case '2':
        amount = taxData['water_available_advance'].toString();
        break;
      case '4':
        amount = taxData['professional_available_advance'].toString();
        break;
      case '5':
        amount = taxData['non_available_advance'].toString();
        break;
      case '6':
        amount = taxData['trade_available_advance'].toString();
        break;
    }

    // taxData[rowIndex][s.key_demand].toString();
    return amount;
  }

  bool getFlagStatus(String assId) {
    bool flag=false;
    if (mainList.isNotEmpty) {
      for (var data in mainList) {
        if(data[key_assessment_id].toString()!=assId){
          print("fa1>>>"+flag.toString());
          for (var demanData in data[s.key_DEMAND_DETAILS]) {
            if (demanData[s.key_flag] == true) {
              flag=true;
            }
          }

        }
      }
    }

    print("fa>>>"+flag.toString());
    return flag;
  }
}
