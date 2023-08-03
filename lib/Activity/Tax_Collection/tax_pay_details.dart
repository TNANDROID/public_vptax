import 'dart:ffi';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:public_vptax/Layout/screen_size.dart';

import 'package:public_vptax/Resources/ColorsValue.dart' as c;
import 'package:public_vptax/Services/Preferenceservices.dart';
import 'package:public_vptax/Services/locator.dart';
import 'package:stacked/stacked.dart';
import 'package:public_vptax/Resources/ImagePath.dart' as imagePath;

import '../../Layout/ui_helper.dart';
import '../../Model/startup_model.dart';

class TaxPayDetailsView extends StatefulWidget {
  final mainList;
  final selectedTaxTypeData;
  TaxPayDetailsView({Key? key, this.mainList, this.selectedTaxTypeData});

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

  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
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
    for (int i = 0; i < widget.mainList.length; i++) {
      if (widget.mainList[i]['total'] > 0 ||
          widget.mainList[i]['swm_total'] > 0) {
        mainDataList.add(widget.mainList[i]);
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget demandCalculationWidget(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        UIHelper.titleTextStyle(
            title.tr().toString() + " : ", c.grey_8, 10, true, false),
        UIHelper.titleTextStyle("\u{20B9} " + value, c.grey_9, 11, true, false),
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

                              return Container(
                                margin: EdgeInsets.all(10),
                                decoration:
                                    UIHelper.roundedBorderWithColorWithShadow(
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
                                              selectedLang == "en"
                                                  ? widget.selectedTaxTypeData[
                                                      "taxtypedesc_en"]
                                                  : widget.selectedTaxTypeData[
                                                      "taxtypedesc_ta"],
                                              c.white,
                                              14,
                                              true,
                                              true),
                                        )),
                                    Row(
                                      children: [
                                        taxWiseReturnDataWidget(index),
                                        Visibility(
                                            visible: mainDataList[index]
                                                    ['total'] >
                                                0,
                                            child: Container(
                                                padding: EdgeInsets.only(
                                                    top: 10,
                                                    bottom: 10,
                                                    left: 10,
                                                    right: 10),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                        width: Screen.width(
                                                                context) /
                                                            2,
                                                        height: selectedTaxonly
                                                                        .length *
                                                                    40 >=
                                                                200
                                                            ? 203
                                                            : selectedTaxonly
                                                                        .length *
                                                                    45 +
                                                                3,
                                                        child: ListView.builder(
                                                          // physics:
                                                          //     NeverScrollableScrollPhysics(),
                                                          itemCount:
                                                              selectedTaxonly
                                                                  .length,
                                                          itemBuilder: (context,
                                                              rowIndex) {
                                                            return Column(
                                                                children: [
                                                                  ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5.0),
                                                                      child: Container(
                                                                          decoration: UIHelper.leftBorderContainer(c.green_new, index % 2 == 0 ? c.grey_3 : c.grey_4),
                                                                          height: 40,
                                                                          child: Row(
                                                                            children: [
                                                                              Expanded(child: Container(child: Center(child: UIHelper.titleTextStyle(selectedTaxonly[rowIndex]['fin_year'] + "\n" + selectedTaxonly[rowIndex]['year'], c.grey_8, 10, false, true)))),
                                                                              Expanded(
                                                                                child: Container(padding: EdgeInsets.all(8.0), child: Center(child: UIHelper.titleTextStyle("\u{20B9} " + selectedTaxonly[rowIndex]['Amount'].toString(), c.black, 12, false, false))),
                                                                              ),
                                                                            ],
                                                                          ))),
                                                                  UIHelper
                                                                      .verticalSpaceTiny
                                                                ]);
                                                          },
                                                        )),
                                                  ],
                                                )))
                                      ],
                                    ),
                                    Visibility(
                                        visible:
                                            mainDataList[index]['total'] > 0,
                                        child: Container(
                                            padding: EdgeInsets.fromLTRB(
                                                20, 0, 20, 20),
                                            child: Column(
                                              children: [
                                                demandCalculationWidget(
                                                    'demand_selected',
                                                    mainDataList[index]['total']
                                                        .toString()),
                                                UIHelper.verticalSpaceSmall,
                                                demandCalculationWidget(
                                                    'advance_amount',
                                                    mainDataList[index]
                                                            ['tax_advance']
                                                        .toString()),
                                                UIHelper.verticalSpaceSmall,
                                                demandCalculationWidget(
                                                    'total_amount_to_pay',
                                                    mainDataList[index]
                                                            ['tax_pay']
                                                        .toString()),
                                              ],
                                            ))),
                                    Visibility(
                                        visible: mainDataList[index]
                                                ['swm_total'] >
                                            0,
                                        child: Container(
                                            padding: EdgeInsets.only(
                                                top: 15,
                                                bottom: 10,
                                                left: 10,
                                                right: 10),
                                            child: Column(
                                              children: [
                                                UIHelper.titleTextStyle(
                                                    'swm_charges'
                                                        .tr()
                                                        .toString(),
                                                    c.grey_8,
                                                    10,
                                                    true,
                                                    true),
                                                UIHelper.verticalSpaceSmall,
                                                Container(
                                                    margin:
                                                        EdgeInsets.only(top: 5),
                                                    height:
                                                        selectedSWMonly.length *
                                                                30 +
                                                            0.02,
                                                    child: ListView.builder(
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      itemCount: selectedSWMonly
                                                          .length,
                                                      itemBuilder:
                                                          (context, rowIndex) {
                                                        return Container(
                                                            height: 30,
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                    child: Container(
                                                                        padding:
                                                                            EdgeInsets.all(
                                                                                8.0),
                                                                        child: Center(
                                                                            child: UIHelper.titleTextStyle(
                                                                                selectedSWMonly[rowIndex]['fin_year'],
                                                                                c.grey_8,
                                                                                12,
                                                                                false,
                                                                                true)))),
                                                                Expanded(
                                                                  child: Container(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              8.0),
                                                                      child: Center(
                                                                          child: UIHelper.titleTextStyle(
                                                                              "\u{20B9} " + selectedSWMonly[rowIndex]['Amount'].toString(),
                                                                              c.black,
                                                                              13,
                                                                              false,
                                                                              false))),
                                                                ),
                                                              ],
                                                            ));
                                                      },
                                                    )),
                                                UIHelper.tinyLinewidget(),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 4,
                                                      child: Container(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: Text(
                                                            "demand_selected"
                                                                .tr()
                                                                .toString(),
                                                            style: TextStyle(
                                                                color:
                                                                    c.grey_10,
                                                                fontSize: 11,
                                                                decoration:
                                                                    TextDecoration
                                                                        .none,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                            textAlign:
                                                                TextAlign.right,
                                                          )),
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Container(
                                                          margin:
                                                              EdgeInsets.all(5),
                                                          child: UIHelper.titleTextStyle(
                                                              "\u{20B9} " +
                                                                  mainDataList[
                                                                              index]
                                                                          [
                                                                          'swm_total']
                                                                      .toString(),
                                                              c.grey_9,
                                                              12,
                                                              true,
                                                              false)),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 4,
                                                      child: Container(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: Text(
                                                            "advance_amount"
                                                                .tr()
                                                                .toString(),
                                                            style: TextStyle(
                                                                color:
                                                                    c.grey_10,
                                                                fontSize: 11,
                                                                decoration:
                                                                    TextDecoration
                                                                        .none,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                            textAlign:
                                                                TextAlign.right,
                                                          )),
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Container(
                                                          margin:
                                                              EdgeInsets.all(5),
                                                          child: UIHelper.titleTextStyle(
                                                              "\u{20B9} " +
                                                                  mainDataList[
                                                                              index]
                                                                          [
                                                                          'swm_advance']
                                                                      .toString(),
                                                              c.grey_9,
                                                              12,
                                                              true,
                                                              false)),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 4,
                                                      child: Container(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: Text(
                                                            "amount_to_pay"
                                                                .tr()
                                                                .toString(),
                                                            style: TextStyle(
                                                                color:
                                                                    c.grey_10,
                                                                fontSize: 11,
                                                                decoration:
                                                                    TextDecoration
                                                                        .none,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                            textAlign:
                                                                TextAlign.right,
                                                          )),
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Container(
                                                          margin:
                                                              EdgeInsets.all(5),
                                                          child: UIHelper.titleTextStyle(
                                                              "\u{20B9} " +
                                                                  getTotal(
                                                                          mainDataList[index]
                                                                              [
                                                                              'swm_total'],
                                                                          mainDataList[index]
                                                                              [
                                                                              'swm_advance'])
                                                                      .toString(),
                                                              c.grey_9,
                                                              12,
                                                              true,
                                                              false)),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ))),
                                  ],
                                ),
                              );
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
    return Expanded(
        child: Column(
      children: [
        Container(
            padding: EdgeInsets.all(5),
            decoration:
                UIHelper.roundedBorderWithColorWithShadow(5, c.white, c.white),
            child: Image.asset(
              widget.selectedTaxTypeData["img_path"].toString(),
              fit: BoxFit.contain,
              height: 50,
              width: 50,
            )),
        UIHelper.verticalSpaceSmall,
        widget.selectedTaxTypeData["taxtypeid"] == 1
            ? UIHelper.titleTextStyle(
                "Building Licence Number :\n" +
                    mainDataList[mainIndex]['building_licence_number'],
                c.grey_9,
                12,
                true,
                true)
            : widget.selectedTaxTypeData["taxtypeid"] == 2
                ? UIHelper.titleTextStyle(
                    "Water Connection Number :\n" +
                        mainDataList[mainIndex]['assesment_no'],
                    c.grey_9,
                    12,
                    true,
                    true)
                : widget.selectedTaxTypeData["taxtypeid"] == 3
                    ? UIHelper.titleTextStyle(
                        "Assesment Number :\n" +
                            mainDataList[mainIndex]['assesment_no'],
                        c.grey_9,
                        12,
                        true,
                        true)
                    : widget.selectedTaxTypeData["taxtypeid"] == 4
                        ? UIHelper.titleTextStyle(
                            "Lease Number :\n" +
                                mainDataList[mainIndex]['assesment_no'],
                            c.grey_9,
                            12,
                            true,
                            true)
                        : UIHelper.titleTextStyle(
                            "Traders Code :\n" +
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
}
