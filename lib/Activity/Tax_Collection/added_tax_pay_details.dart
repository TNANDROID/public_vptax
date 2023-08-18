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
import '../../Utils/utils.dart';

class TaxPayDetailsView extends StatefulWidget {
  TaxPayDetailsView({Key? key});

  @override
  _TaxPayDetailsViewState createState() => _TaxPayDetailsViewState();
}

class _TaxPayDetailsViewState extends State<TaxPayDetailsView> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  PreferenceService preferencesService = locator<PreferenceService>();

  String selectedLang = "";
  List mainDataList = [];
  List taxTypeList = [];

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
    taxTypeList = preferencesService.taxTypeList;
    mainDataList = preferencesService.addedTaxPayList;
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
        Expanded(child: UIHelper.titleTextStyle(title.tr().toString() + " : ", c.grey_8, 10, isBoold, false)),
        UIHelper.titleTextStyle("\u{20B9} " + value, c.grey_9, 11, isBoold, false),
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
                      transform: Matrix4.translationValues(-30.0, 0.0, 0.0), alignment: Alignment.center, child: UIHelper.titleTextStyle('tax_details'.tr().toString(), c.white, 15, true, false)),
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
                              //  List selectedSWMonly = [];
                              dynamic mainselecteddynamicData = mainDataList[index];
                              for (var item in mainselecteddynamicData[key_DEMAND_DETAILS]) {
                                if (mainselecteddynamicData[key_taxtypeid] == "1") {
                                  if (item[key_flag] == true && item[key_taxtypeid].toString() == "1") {
                                    selectedTaxonly.add(item);
                                  }
                                } else {
                                  if (item[key_flag] == true) {
                                    selectedTaxonly.add(item);
                                  }
                                }
                              }

                              dynamic calcOfHeight = selectedTaxonly.length / 2;
                              int roundedValueOfHeight = calcOfHeight.ceil();

                              return Container(
                                margin: EdgeInsets.all(10),
                                decoration: UIHelper.roundedBorderWithColorWithShadow(10, index % 2 == 0 ? c.white : c.need_improvement2, index % 2 == 0 ? c.white : c.need_improvement2,
                                    borderWidth: 1, borderColor: index % 2 == 0 ? c.need_improvement2 : c.grey_3),
                                child: Column(
                                  children: [
                                    Container(
                                        width: Screen.width(context),
                                        height: 40,
                                        decoration: UIHelper.roundedBorderWithColor(10, 10, 0, 0, Colors.blue),
                                        child: Center(
                                          child: UIHelper.titleTextStyle(getTaxName(index), c.white, 14, true, true),
                                        )),
                                    taxWiseReturnDataWidget(mainDataList[index]),
                                    Visibility(
                                        visible: mainselecteddynamicData[key_tax_total] > 0,
                                        child: Column(children: [
                                          Container(
                                              height: roundedValueOfHeight * 55,
                                              child: ResponsiveGridList(
                                                  listViewBuilderOptions: ListViewBuilderOptions(physics: NeverScrollableScrollPhysics()),
                                                  horizontalGridMargin: 20,
                                                  verticalGridMargin: 0,
                                                  minItemWidth: Screen.width(context) / 3,
                                                  children: List.generate(
                                                    selectedTaxonly.length,
                                                    (index) {
                                                      String finYearStr = "";
                                                      if (mainselecteddynamicData[key_taxtypeid] == "4") {
                                                        finYearStr = selectedTaxonly[index]['financialyear'];
                                                      } else {
                                                        finYearStr = selectedTaxonly[index][key_fin_year];
                                                      }
                                                      String durationStr = selectedTaxonly[index][key_installment_group_name];

                                                      return ClipRRect(
                                                          borderRadius: BorderRadius.circular(5.0),
                                                          child: Container(
                                                              decoration: UIHelper.leftBorderContainer(c.green_new, c.grey_4),
                                                              height: 40,
                                                              child: Row(
                                                                children: [
                                                                  Expanded(child: Center(child: UIHelper.titleTextStyle(finYearStr + "\n" + durationStr, c.grey_8, 10, false, true))),
                                                                  Expanded(
                                                                    child: Container(
                                                                        padding: EdgeInsets.all(8.0),
                                                                        child: Center(
                                                                            child: UIHelper.titleTextStyle(
                                                                                "\u{20B9} " + Utils().getDemadAmount(selectedTaxonly[index], mainselecteddynamicData[key_taxtypeid].toString()),
                                                                                c.black,
                                                                                12,
                                                                                false,
                                                                                false))),
                                                                  ),
                                                                ],
                                                              )));
                                                    },
                                                  ))),
                                          UIHelper.verticalSpaceMedium,
                                          Container(
                                              padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                                              child: Column(
                                                children: [
                                                  demandCalculationWidget('demand_selected', mainDataList[index][key_tax_total].toString(), false),
                                                  UIHelper.verticalSpaceSmall,
                                                  demandCalculationWidget('advance_amount', Utils().getTaxAdvance(mainDataList[index], mainDataList[index][key_taxtypeid].toString()), false),
                                                  UIHelper.verticalSpaceSmall,
                                                  mainDataList[index]['swm_total'] > 0
                                                      ? Column(
                                                          children: [
                                                            demandCalculationWidget('swm_charges', mainDataList[index][key_swm_total].toString(), false),
                                                            UIHelper.verticalSpaceSmall,
                                                            demandCalculationWidget('swm_advance_charges', mainDataList[index][key_swm_available_advance].toString(), false),
                                                            UIHelper.verticalSpaceSmall,
                                                          ],
                                                        )
                                                      : SizedBox(),
                                                  demandCalculationWidget('total_amount_to_pay', (mainDataList[index][key_tax_pay]+mainDataList[index][key_swm_pay]).toString(), true),
                                                ],
                                              ))
                                        ])),
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
                    style: TextStyle(color: c.grey_9, fontSize: 11, decoration: TextDecoration.none, fontWeight: FontWeight.bold),
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
                  child: UIHelper.titleTextStyle("\u{20B9} " + getTotalAmoutToPay().toString(), c.black, 13, true, true)),
            ),
          ],
        ),
        Align(
            alignment: Alignment.center,
            child: InkWell(
                onTap: () {},
                child: Container(
                    margin: EdgeInsets.only(top: 10, right: 30, bottom: 10),
                    decoration: UIHelper.GradientContainer(5, 5, 5, 5, [c.grey_9, c.grey_9]),
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 8),
                    child: UIHelper.titleTextStyle("pay".tr().toString(), c.white, 12, true, true)))),
      ],
    );
  }

  Widget taxWiseReturnDataWidget(dynamic taxData) {
    return Container(
        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
        transform: Matrix4.translationValues(0.0, -20.0, 0.0),
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
                padding: EdgeInsets.all(5),
                decoration: UIHelper.roundedBorderWithColorWithShadow(5, c.white, c.white),
                child: Image.asset(
                  getTaxImage(taxData[key_taxtypeid].toString()),
                  fit: BoxFit.contain,
                  height: 40,
                  width: 40,
                )),
            UIHelper.horizontalSpaceSmall,
            UIHelper.titleTextStyle('assesmentNumber'.tr().toString() + " : " + taxData[key_assessment_no].toString(), c.grey_9, 12, true, true)

            // taxData[key_taxtypeid] == 1
            //     ? UIHelper.titleTextStyle('assesmentNumber'.tr().toString() + taxData['building_licence_number'], c.grey_9, 12, true, true)
            //     : taxData[key_taxtypeid] == 2
            //         ? UIHelper.titleTextStyle("Water Connection Number : " + taxData[key_assessment_no], c.grey_9, 12, true, true)
            //         : taxData[key_taxtypeid] == 4
            //             ? UIHelper.titleTextStyle("Assesment Number : " + taxData[key_assessment_no], c.grey_9, 12, true, true)
            //             : taxData[key_taxtypeid] == 5
            //                 ? UIHelper.titleTextStyle("Lease Number : " + taxData[key_assessment_no], c.grey_9, 12, true, true)
            //                 : UIHelper.titleTextStyle("Traders Code : " + taxData[key_assessment_no].toString(), c.grey_9, 12, true, true)
          ],
        ));
  }

  double getTotalAmoutToPay() {
    double s = 0.00;
    for (int i = 0; i < mainDataList.length; i++) {
      s = s + mainDataList[i][key_tax_pay] + mainDataList[i][key_swm_pay];
    }
    return s;
  }

  String getTaxName(int index) {
    List selectedTaxitem = taxTypeList.where((element) => element[key_taxtypeid].toString() == mainDataList[index][key_taxtypeid].toString()).toList();
    return selectedLang == "en" ? selectedTaxitem[0][key_taxtypedesc_en] : selectedTaxitem[0][key_taxtypedesc_ta];
  }

  String getTaxImage(String typeId) {
    List selectedTaxitem = taxTypeList.where((element) => element[key_taxtypeid].toString() == typeId.toString()).toList();
    return selectedTaxitem[0][key_img_path].toString();
  }

}
