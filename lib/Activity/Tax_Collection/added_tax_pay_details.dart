// ignore_for_file: must_be_immutable, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_interpolation_to_compose_strings, prefer_const_constructors, sized_box_for_whitespace

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:public_vptax/Layout/screen_size.dart';
import 'package:public_vptax/Resources/ColorsValue.dart' as c;
import 'package:public_vptax/Resources/StringsKey.dart';
import 'package:public_vptax/Services/Preferenceservices.dart';
import 'package:public_vptax/Services/locator.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:stacked/stacked.dart';
import '../../Layout/ui_helper.dart';
import '../../Model/startup_model.dart';

class TaxPayDetailsView extends StatefulWidget {

  TaxPayDetailsView(
      {Key? key});

  @override
  _TaxPayDetailsViewState createState() => _TaxPayDetailsViewState();
}

class _TaxPayDetailsViewState extends State<TaxPayDetailsView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  PreferenceService preferencesService = locator<PreferenceService>();

  String selectedLang = "";
  List mainDataList = [];
  List taxTypeList = [];
  List isShowFlag = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

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
    taxTypeList=preferencesService.taxTypeList;
    mainDataList=preferencesService.addedTaxPayList;
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget demandCalculationWidget(String title, String value, bool isBoold) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            child: UIHelper.titleTextStyle(
                title.tr().toString() + " : ", c.grey_8, 10, isBoold, false)),
        UIHelper.titleTextStyle(
            "\u{20B9} " + value, c.grey_9, 11, isBoold, false),
      ],
    );
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
                      child: UIHelper.titleTextStyle(
                          'tax_details'.tr().toString(),
                          c.white,
                          15,
                          true,
                          false)),
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          top: true,
          child: ViewModelBuilder<StartUpViewModel>.reactive(
              builder: (context, model, child) {
                return Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.all(5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        UIHelper.verticalSpaceSmall,
                        Expanded(
                            child: Container(
                          alignment: Alignment.center,
                          child: ListView.builder(
                            itemCount: mainDataList.length,
                            itemBuilder: (context, index) {
                              List selectedTaxonly = [];
                              List selectedSWMonly = [];
                              for (var item in mainDataList[index]['taxData']) {
                                if (item['flag'] == true) {
                                  selectedTaxonly.add(item);
                                }
                              }

                              for (var item in mainDataList[index]['swmData']) {
                                if (item['flag'] == true) {
                                  selectedSWMonly.add(item);
                                }
                              }

                              return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (isShowFlag.contains(index)) {
                                        isShowFlag.remove(index);
                                      } else {
                                        isShowFlag.add(index);
                                      }
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    decoration: UIHelper
                                        .roundedBorderWithColorWithShadow(
                                            10,
                                            index % 2 == 0
                                                ? c.white
                                                : c.need_improvement2,
                                            index % 2 == 0
                                                ? c.white
                                                : c.need_improvement2,
                                            borderWidth: 1,
                                            borderColor: index % 2 == 0
                                                ? c.need_improvement2
                                                : c.grey_3),
                                    child: Column(
                                      children: [
                                        Container(
                                            width: Screen.width(context),
                                            height: 40,
                                            decoration:
                                                UIHelper.roundedBorderWithColor(
                                                    10, 10, 0, 0, Colors.blue),
                                            child: Center(
                                              child: UIHelper.titleTextStyle(
                                                getTaxName(index),
                                                  c.white,
                                                  14,
                                                  true,
                                                  true),
                                            )),
                                        taxWiseReturnDataWidget(index),
                                        Visibility(
                                            visible: mainDataList[index]
                                                    ['total'] >
                                                0,
                                            child: Column(children: [
                                              Container(
                                                  height: selectedTaxonly
                                                              .length <
                                                          3
                                                      ? 50
                                                      : selectedTaxonly.length >
                                                                  3 ||
                                                              selectedTaxonly
                                                                      .length <
                                                                  5
                                                          ? 100
                                                          : 150,
                                                  child: ResponsiveGridList(
                                                      listViewBuilderOptions:
                                                          ListViewBuilderOptions(
                                                              physics:
                                                                  NeverScrollableScrollPhysics()),
                                                      horizontalGridMargin: 20,
                                                      verticalGridMargin: 0,
                                                      minItemWidth:
                                                          Screen.width(
                                                                  context) /
                                                              3,
                                                      children: List.generate(
                                                        selectedTaxonly.length,
                                                        (index) => ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0),
                                                            child: Container(
                                                                decoration: UIHelper
                                                                    .leftBorderContainer(
                                                                        c.green_new,
                                                                        c.grey_4),
                                                                height: 40,
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                        child: Center(
                                                                            child: UIHelper.titleTextStyle(
                                                                                selectedTaxonly[index]['fin_year'] + "\n" + selectedTaxonly[index]['year'],
                                                                                c.grey_8,
                                                                                10,
                                                                                false,
                                                                                true))),
                                                                    Expanded(
                                                                      child: Container(
                                                                          padding: EdgeInsets.all(
                                                                              8.0),
                                                                          child:
                                                                              Center(child: UIHelper.titleTextStyle("\u{20B9} " + selectedTaxonly[index]['Amount'].toString(), c.black, 12, false, false))),
                                                                    ),
                                                                  ],
                                                                ))),
                                                      ))),
                                              UIHelper.verticalSpaceSmall,
                                              // isShowFlag.contains(index)
                                              //     ?
                                              Container(
                                                  padding: EdgeInsets.fromLTRB(
                                                      20, 0, 20, 20),
                                                  child: Column(
                                                    children: [
                                                      demandCalculationWidget(
                                                          'demand_selected',
                                                          mainDataList[index]
                                                                  ['total']
                                                              .toString(),
                                                          false),
                                                      UIHelper
                                                          .verticalSpaceSmall,
                                                      demandCalculationWidget(
                                                          'advance_amount',
                                                          mainDataList[index][
                                                                  'tax_advance']
                                                              .toString(),
                                                          false),
                                                      UIHelper
                                                          .verticalSpaceSmall,
                                                      mainDataList[index][
                                                                  'swm_total'] >
                                                              0
                                                          ? Column(
                                                              children: [
                                                                demandCalculationWidget(
                                                                    'swm_charges',
                                                                    mainDataList[index]
                                                                            [
                                                                            'swm_total']
                                                                        .toString(),
                                                                    false),
                                                                UIHelper
                                                                    .verticalSpaceSmall,
                                                                demandCalculationWidget(
                                                                    'swm_advance_charges',
                                                                    mainDataList[index]
                                                                            [
                                                                            'swm_advance']
                                                                        .toString(),
                                                                    false),
                                                                UIHelper
                                                                    .verticalSpaceSmall,
                                                              ],
                                                            )
                                                          : SizedBox(),
                                                      demandCalculationWidget(
                                                          'total_amount_to_pay',
                                                          mainDataList[index]
                                                                  ['tax_pay']
                                                              .toString(),
                                                          true),
                                                    ],
                                                  ))
                                              // : Container(
                                              //     alignment:
                                              //         Alignment.topRight,
                                              //     margin:
                                              //         EdgeInsets.fromLTRB(
                                              //             10, 0, 10, 0),
                                              //     child: Icon(
                                              //       Icons
                                              //           .expand_more_outlined,
                                              //       color: c.grey_7,
                                              //       size: 20,
                                              //     ),
                                              //   )
                                            ])),
                                      ],
                                    ),
                                  ));
                            },
                          ),
                        )),
                        payWidget()
                      ],
                    ));
              },
              viewModelBuilder: () => StartUpViewModel()),
        ));
  }

  Widget payWidget() {
    return Column(
      children: [
        Row(
          children: [
            UIHelper.horizontalSpaceTiny,
            Expanded(
              flex: 4,
              child: Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "total_amount_to_pay".tr().toString(),
                    style: TextStyle(
                        color: c.grey_9,
                        fontSize: 11,
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.right,
                  )),
            ),
            Expanded(
              flex: 2,
              child: Container(
                  decoration: BoxDecoration(
                    color: c.need_improvement2,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 8),
                  child: UIHelper.titleTextStyle(
                      "\u{20B9} " + getTotalAmoutToPay().toString(),
                      c.black,
                      13,
                      true,
                      true)),
            ),
          ],
        ),
        Align(
            alignment: Alignment.center,
            child: InkWell(
                onTap: () {},
                child: Container(
                    margin: EdgeInsets.only(top: 10, right: 30, bottom: 10),
                    decoration: UIHelper.GradientContainer(
                        5, 5, 5, 5, [c.grey_9, c.grey_9]),
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 8),
                    child: UIHelper.titleTextStyle(
                        "pay".tr().toString(), c.white, 12, true, true)))),
      ],
    );
  }

  Widget taxWiseReturnDataWidget(int mainIndex) {
    return Container(
        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
        transform: Matrix4.translationValues(0.0, -20.0, 0.0),
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
                padding: EdgeInsets.all(5),
                decoration: UIHelper.roundedBorderWithColorWithShadow(
                    5, c.white, c.white),
                child: Image.asset(
                  getTaxImage(mainIndex),
                  fit: BoxFit.contain,
                  height: 40,
                  width: 40,
                )),
            UIHelper.horizontalSpaceSmall,
            mainDataList[mainIndex][key_taxtypeid] == 1
                ? UIHelper.titleTextStyle(
                    "Building Licence Number : " +
                        mainDataList[mainIndex]['building_licence_number'],
                    c.grey_9,
                    12,
                    true,
                    true)
                : mainDataList[mainIndex][key_taxtypeid] == 2
                    ? UIHelper.titleTextStyle(
                        "Water Connection Number : " +
                            mainDataList[mainIndex]['assesment_no'],
                        c.grey_9,
                        12,
                        true,
                        true)
                    : mainDataList[mainIndex][key_taxtypeid] == 4
                        ? UIHelper.titleTextStyle(
                            "Assesment Number : " +
                                mainDataList[mainIndex]['assesment_no'],
                            c.grey_9,
                            12,
                            true,
                            true)
                        : mainDataList[mainIndex][key_taxtypeid] == 5
                            ? UIHelper.titleTextStyle(
                                "Lease Number : " +
                                    mainDataList[mainIndex]['assesment_no'],
                                c.grey_9,
                                12,
                                true,
                                true)
                            : UIHelper.titleTextStyle(
                                "Traders Code : " +
                                    mainDataList[mainIndex]['assesment_no'],
                                c.grey_9,
                                12,
                                true,
                                true)
          ],
        ));
  }

  double getTotal(double d1, double d2) {
    double s = 0.00;
    double ss = 0.00;
    ss = d1 - d2;
    ss > 0 ? s = ss : s = 0.00;
    return s;
  }

  double getTotalAmoutToPay() {
    double s = 0.00;
    for (int i = 0; i < mainDataList.length; i++) {
      s = s + mainDataList[i]['tax_pay'] + mainDataList[i]['swm_pay'];
    }
    return s;
  }

  String getTaxName(int index) {
    final item = taxTypeList.firstWhere((e) => e[key_taxtypeid] ==mainDataList[index][key_taxtypeid].toString());
    return selectedLang == "en"
        ? item[
    key_taxtypedesc_en]
        : item[
    key_taxtypedesc_ta];
  }
  String getTaxImage(int index) {
    final item = taxTypeList.firstWhere((e) => e[key_taxtypeid] ==mainDataList[index][key_taxtypeid].toString());
    return  item[key_img_path].toString();
  }
}
