import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:public_vptax/Layout/screen_size.dart';
import 'package:public_vptax/Layout/ui_helper.dart';
import 'package:public_vptax/Model/startup_model.dart';
import 'package:public_vptax/Resources/ColorsValue.dart' as c;
import 'package:public_vptax/Services/Preferenceservices.dart';
import 'package:public_vptax/Services/locator.dart';
import 'package:stacked/stacked.dart';
import 'package:public_vptax/Resources/ImagePath.dart' as imagePath;

class TaxCollectionDetailsView extends StatefulWidget {
  final flag;
  TaxCollectionDetailsView({this.flag});

  @override
  _TaxCollectionDetailsViewState createState() =>
      _TaxCollectionDetailsViewState();
}

class _TaxCollectionDetailsViewState extends State<TaxCollectionDetailsView> {
  PreferenceService preferencesService = locator<PreferenceService>();
  List isShowFlag = [];
  double main_totalAmount = 0.00;
  int main_count = 0;
  List<dynamic> examplePropertyData = [
    {"fin_year": "2022-2023", "Amount": 480},
    {"fin_year": "2023-2024", "Amount": 380},
    {"fin_year": "2022-2023", "Amount": 680},
    {"fin_year": "2023-2024", "Amount": 280},
  ];

  Map<String, List> checkedListData = {};

  Widget headerCardUIWidget(int mainIndex) {
    return Column(
      children: [
        Container(
            width: Screen.width(context),
            margin: EdgeInsets.only(left: 15,right: 15),
            padding: EdgeInsets.all(15),
            decoration: UIHelper.roundedBorderWithColorWithShadow(
                5, c.need_improvement1, c.need_improvement1,
                borderWidth: 0),
            child: Column(children: [
              Stack(
                children: [
                  UIHelper.unEvenContainer(
                    15,
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: UIHelper.titleTextStyle(
                                  "SaravanaKumar", c.white, 18, true, false),
                            ),
                          ],
                        ),
                        UIHelper.verticalSpaceSmall,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.location_on,
                              color: c.white,
                              size: 20,
                            ),
                            UIHelper.horizontalSpaceSmall,
                            Expanded(
                                child: UIHelper.titleTextStyle(
                                    "54/A, Vadamalappur,Vadamalappur,\n9a Nathampannai, PUDUKKOTTAI.",
                                    c.white,
                                    12,
                                    true,
                                    false)),
                          ],
                        ),
                        UIHelper.verticalSpaceSmall,
                        SizedBox(
                          width: Screen.width(context) / 2,
                          child: UIHelper.tinyLinewidget(borderColor: c.white),
                        ),
                        UIHelper.verticalSpaceSmall,
                        UIHelper.titleTextStyle(
                            "Building Licence Number : 123456",
                            c.white,
                            14,
                            true,
                            true),
                        UIHelper.titleTextStyle(
                            "Assesment Number: 27", c.white, 14, true, true),
                      ],
                    ),
                  ),
                  Positioned(
                    top:
                        5, // Adjust this value to control the distance from the bottom
                    right: 1,
                    child:
                        // ClipRRect(
                        //   borderRadius: BorderRadius.circular(50.0),
                        //   child:
                        Container(
                            padding: EdgeInsets.all(5),
                            decoration:
                                UIHelper.roundedBorderWithColorWithShadow(
                                    5, c.white, c.grey_2),
                            child: Image.asset(
                              imagePath.house,
                              fit: BoxFit.contain,
                              height: 35,
                              width: 35,
                            )),
                    //),
                  ),
                  Positioned(
                      bottom:
                          5, // Adjust this value to control the distance from the bottom
                      right: 1,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            if (isShowFlag.contains(mainIndex)) {
                              isShowFlag.remove(mainIndex);
                            } else {
                              isShowFlag.add(mainIndex);
                            }
                            setState(() {});
                          });
                        },
                        child: Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Icon(
                            isShowFlag.contains(mainIndex)
                                ? Icons.arrow_circle_up_rounded
                                : Icons.arrow_circle_down_rounded,
                            color: Colors.blue,
                            size: 30,
                          ),
                        ),
                      )),
                ],
              ),
              Visibility(
                  visible:isShowFlag.contains(mainIndex),
               child:
              propertyTaxCollectionWidget(mainIndex)),
            ])),
/*        if (isShowFlag.contains(mainIndex))
          Container(
              margin: EdgeInsets.only(left: 15,right: 15),
            transform: Matrix4.translationValues(0, -5, 0),
              width: Screen.width(context),
              decoration: UIHelper.roundedBorderWithColorWithShadow(
                  2, c.need_improvement1, c.need_improvement1,
                  borderWidth: 0),
              child: Column(children: [
                Container(
                    margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
                    decoration: UIHelper.roundedBorderWithColorWithShadow(
                        3, c.white, c.white,
                        borderWidth: 0),
                    child: propertyTaxCollectionWidget(mainIndex))
              ])),*/
      ],
    );
  }

  Widget propertyTaxCollectionWidget(int mainIndex) {
    if (checkedListData["$mainIndex"] == null) {
      checkedListData["$mainIndex"] = [];
    }
    int dataWiseHeight = examplePropertyData.length * 40;
    double totalAmount = 0.00;
    int count = 0;
    for (var item in checkedListData["$mainIndex"]!) {
      totalAmount = totalAmount + examplePropertyData[item]['Amount'];
      main_totalAmount=main_totalAmount+totalAmount;
      main_count=main_count+1;
    }
    return  Container(
      margin: EdgeInsets.only(top: 10),
        decoration: UIHelper.roundedBorderWithColorWithShadow(
            3, c.white, c.white,
            borderWidth: 0),
        padding: EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 5),
                height: dataWiseHeight +0.02,
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: examplePropertyData.length,
                  itemBuilder: (context, rowIndex) {
                    int siNo = rowIndex + 1;
                    return Container(
                        height: 35,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: Center(
                                      child: UIHelper.titleTextStyle("$siNo",
                                          c.grey_8, 12, false, true))),
                            ),
                            Expanded(
                                flex: 3,
                                child: Container(
                                    padding: EdgeInsets.all(8.0),
                                    child: Center(
                                        child: UIHelper.titleTextStyle(
                                            examplePropertyData[rowIndex]
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
                                          examplePropertyData[rowIndex]
                                                  ['Amount']
                                              .toString(),
                                          c.black,
                                          13,
                                          false,
                                          true))),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Checkbox(
                                      side:
                                      BorderSide(width: 1, color: c.grey_6),
                                      value: checkedListData[
                                      "$mainIndex"]
                                          ?.contains(rowIndex),
                                      onChanged: (v) {
                                        if (rowIndex == 0 ||
                                            checkedListData[
                                            "$mainIndex"]!
                                                .contains(
                                                rowIndex - 1)) {
                                          if (checkedListData[
                                          "$mainIndex"]!
                                              .contains(rowIndex)) {
                                            int endIndex =
                                                checkedListData[
                                                "$mainIndex"]!
                                                    .length -
                                                    1;
                                            checkedListData[
                                            "$mainIndex"]
                                                ?.removeRange(
                                                rowIndex,
                                                endIndex + 1);
                                          } else {
                                            checkedListData[
                                            "$mainIndex"]
                                                ?.add(rowIndex);
                                          }
                                        }

                                        setState(() {});
                                      },
                                    ),
                                  )),
                            ),
                          ],
                        ));
                  },
                )),
            UIHelper.titleTextStyle("swmUserCharges".tr().toString(),
                c.grey_9, 11, false, true),
            UIHelper.verticalSpaceSmall,
/*            SizedBox(
                width: Screen.width(context) / 1.2,
                child: UIHelper.tinyLinewidget(borderColor: c.grey_6)),*/
            // UIHelper.verticalSpaceSmall,
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child:Container(
                    alignment: Alignment.centerRight,
                      child: Text(
                          "amount_to_pay".tr().toString(),
                        style: TextStyle(
                            color: c.grey_10,
                            fontSize: 10,
                            decoration:TextDecoration.none,
                            fontWeight:  FontWeight.bold),
                        textAlign: TextAlign.right,
                      )),
                ),
                Expanded(
                  flex: 2,
                  child:Container(
                      decoration: UIHelper.GradientContainer(
                          5, 5, 5, 5, [c.grey, c.grey]),
                      padding: EdgeInsets.fromLTRB(10,5,10,8),
                      margin: EdgeInsets.all(10),
                      child: UIHelper.titleTextStyle(
                          "  $totalAmount", c.grey_9, 14, true, true)),
                ),
              ],),
/*
            Align(
              alignment: Alignment.centerRight,
              child:Visibility(
                visible: true,
                child: Container(
                    margin: EdgeInsets.only(top: 5,right: 10),
                  decoration: UIHelper.GradientContainer(
                      5, 5, 5, 5, [c.account_status_green_color, c.account_status_green_color]),
                  padding: EdgeInsets.fromLTRB(10,5,10,8),
                  child: UIHelper.titleTextStyle(
                      "pay".tr().toString(), c.white, 14, true, true)),)
            )
      ,
*/
            UIHelper.verticalSpaceSmall,
          ],
        ));
  }

  Widget taxInvoiceWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UIHelper.titleTextStyle("Property Tax", c.black, 16, true, false),
        UIHelper.verticalSpaceSmall,
        taxInvoiceRowWidget("Demand Selected (₹).", "480.00"),
        UIHelper.verticalSpaceTiny,
        taxInvoiceRowWidget("Advance Available (₹).", "0.00"),
        UIHelper.verticalSpaceTiny,
        taxInvoiceRowWidget("Amount payable (₹).", "480.00"),
        Align(
            alignment: Alignment.centerRight,
            child:Visibility(
              visible: true,
              child: Container(
                  margin: EdgeInsets.only(top: 5,right: 10),
                  decoration: UIHelper.GradientContainer(
                      5, 5, 5, 5, [c.account_status_green_color, c.account_status_green_color]),
                  padding: EdgeInsets.fromLTRB(10,5,10,8),
                  child: UIHelper.titleTextStyle(
                      "pay".tr().toString(), c.white, 14, true, true)),)
        )

      ],
    );
  }
  Widget addToPayWidget() {
    return Stack(
      children: [
        Align(
            alignment: Alignment.centerRight,
            child:Container(
                margin: EdgeInsets.only(top: 20,right: 30,bottom: 10),
                decoration: UIHelper.GradientContainer(
                    5, 5, 5, 5, [c.grey_7, c.grey_7]),
                padding: EdgeInsets.fromLTRB(10,5,10,8),
                child: UIHelper.titleTextStyle(
                    "added_to_pay".tr().toString(), c.white, 14, true, true))
        ),
        Align(
            alignment: Alignment.topRight,
            child:Container(
              child: Container(
                // transform: Matrix4.translationValues(0,-5,0,),
                  margin: EdgeInsets.only(top: 10,right: 10,bottom: 10),
                  decoration: UIHelper.circleWithColorWithShadow(360,
                     c.account_status_green_color, c.account_status_green_color),
                  padding: EdgeInsets.fromLTRB(10,5,10,8),
                  child: UIHelper.titleTextStyle(
                      (main_count).toString(), c.white, 14, true, true)),)
        )

      ],
    );
  }

  Widget taxInvoiceRowWidget(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        UIHelper.titleTextStyle(title, c.grey_10, 14, false, false),
        UIHelper.titleTextStyle(value, c.grey_10, 16, true, false),
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
                return  Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                         children: [
                           UIHelper.verticalSpaceSmall,
                           Align(
                             alignment:Alignment.centerLeft,
                             child: Container(
                               margin: EdgeInsets.all(10),
                               child: UIHelper.titleTextStyle(
                                 "propertyTax".tr().toString(),
                                 c.grey_8,
                                 14,
                                 true,
                                 false),),),
                           UIHelper.verticalSpaceSmall,
                           Expanded(child: Container(
                             height: MediaQuery.of(context).size.height,
                               child: ListView.builder(
                                  shrinkWrap: true,
                                 // physics: NeverScrollableScrollPhysics(),
                                   itemCount: 3,
                                   itemBuilder: (context, mainIndex) {
                                     return Column(
                                       children: [
                                         headerCardUIWidget(mainIndex),
                                         UIHelper.verticalSpaceMedium,
                                       ],
                                     );
                                   }))),
                           addToPayWidget()
                         ],
                            ));
              },
              viewModelBuilder: () => StartUpViewModel()),
        ));
  }
}
