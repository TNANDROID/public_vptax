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
  TaxCollectionDetailsView({Key? key}) : super(key: key);

  @override
  _TaxCollectionDetailsViewState createState() =>
      _TaxCollectionDetailsViewState();
}

class _TaxCollectionDetailsViewState extends State<TaxCollectionDetailsView> {
  PreferenceService preferencesService = locator<PreferenceService>();
  List isShowFlag = [];

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
            padding: EdgeInsets.all(15),
            decoration: isShowFlag.contains(mainIndex)
                ? UIHelper.GradientContainer(
                    30, 30, 0, 0, [c.colorAccentlight, c.colorPrimaryDark])
                : UIHelper.roundedBorderWithColorWithShadow(
                    5, c.need_improvement2, c.need_improvement2,
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
                            Icons.arrow_circle_down_rounded,
                            color: Colors.blue,
                            size: 30,
                          ),
                        ),
                      )),
                ],
              ),
            ])),
        if (isShowFlag.contains(mainIndex))
          Container(
              width: Screen.width(context),
              decoration: UIHelper.roundedBorderWithColor(
                  0, 0, 15, 15, c.colorPrimaryDark),
              child: Column(children: [
                Container(
                    margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
                    decoration: UIHelper.roundedBorderWithColorWithShadow(
                        5, c.need_improvement2, c.need_improvement2,
                        borderWidth: 0),
                    child: propertyTaxCollectionWidget(mainIndex))
              ])),
      ],
    );
  }

  Widget propertyTaxCollectionWidget(int mainIndex) {
    if (checkedListData["$mainIndex"] == null) {
      checkedListData["$mainIndex"] = [];
    }
    int dataWiseHeight = examplePropertyData.length * 40;
    double totalAmount = 0.00;
    for (var item in checkedListData["$mainIndex"]!) {
      totalAmount = totalAmount + examplePropertyData[item]['Amount'];
    }
    return Column(
      children: [
        Container(
            height: dataWiseHeight + 5,
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: examplePropertyData.length,
              itemBuilder: (context, rowIndex) {
                int siNo = rowIndex + 1;
                return Container(
                    height: 40,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                  child: UIHelper.titleTextStyle(
                                      "$siNo", c.grey_10, 14, false, true))),
                        ),
                        Expanded(
                            flex: 3,
                            child: Container(
                                padding: EdgeInsets.all(8.0),
                                child: Center(
                                    child: UIHelper.titleTextStyle(
                                        examplePropertyData[rowIndex]
                                            ['fin_year'],
                                        c.grey_10,
                                        14,
                                        false,
                                        true)))),
                        Expanded(
                          flex: 2,
                          child: Container(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                  child: UIHelper.titleTextStyle(
                                      examplePropertyData[rowIndex]['Amount']
                                          .toString(),
                                      c.grey_10,
                                      14,
                                      true,
                                      true))),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: Checkbox(
                                            value: checkedListData["$mainIndex"]
                                                ?.contains(rowIndex),
                                            onChanged: (v) {
                                              if (rowIndex == 0 ||
                                                  checkedListData["$mainIndex"]!
                                                      .contains(rowIndex - 1)) {
                                                if (checkedListData[
                                                        "$mainIndex"]!
                                                    .contains(rowIndex)) {
                                                  int endIndex =
                                                      checkedListData[
                                                                  "$mainIndex"]!
                                                              .length -
                                                          1;
                                                  checkedListData["$mainIndex"]
                                                      ?.removeRange(rowIndex,
                                                          endIndex + 1);
                                                } else {
                                                  checkedListData["$mainIndex"]
                                                      ?.add(rowIndex);
                                                }
                                              }

                                              setState(() {});
                                            },
                                          ))
                                    ]),
                              )),
                        ),
                      ],
                    ));
              },
            )),
        UIHelper.titleTextStyle(
            "swmUserCharges".tr().toString(), c.grey_9, 14, true, true),
        SizedBox(
            width: Screen.width(context) / 1.2,
            child: UIHelper.tinyLinewidget(borderColor: c.grey_8)),
        // UIHelper.verticalSpaceSmall,
        UIHelper.titleTextStyle(
            "Total : $totalAmount", c.grey_9, 14, true, true),
        UIHelper.verticalSpaceSmall,
      ],
    );
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
        appBar: PreferredSize(
          preferredSize: AppBar().preferredSize,
          child: Container(
              padding: EdgeInsets.only(top: 30, bottom: 10, right: 20),
              decoration: UIHelper.GradientContainer(
                  0, 0, 30, 30, [c.colorAccentlight, c.colorPrimaryDark]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: PopupMenuButton<String>(
                      color: c.white,
                      // onSelected: handleClick,
                      itemBuilder: (BuildContext context) {
                        return {'தமிழ்', 'English'}.map((String choice) {
                          return PopupMenuItem<String>(
                            value: choice,
                            child: Text(choice),
                          );
                        }).toList();
                      },
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        'quickPay'.tr().toString(),
                        style: TextStyle(
                          fontSize: 15,
                          color: c.white,
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ),
        body: SafeArea(
          top: true,
          child: ViewModelBuilder<StartUpViewModel>.reactive(
              builder: (context, model, child) {
                return model.isBusy
                    ? CircularProgressIndicator()
                    : Container(
                        padding: EdgeInsets.all(10),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              UIHelper.verticalSpaceSmall,
                              UIHelper.titleTextStyle(
                                  "propertyTax".tr().toString(),
                                  c.grey_8,
                                  14,
                                  true,
                                  false),
                              UIHelper.verticalSpaceSmall,
                              Container(
                                  height: Screen.height(context) / 1.3,
                                  child: ListView.builder(
                                      //physics: NeverScrollableScrollPhysics(),
                                      itemCount: 3,
                                      itemBuilder: (context, mainIndex) {
                                        return Column(
                                          children: [
                                            headerCardUIWidget(mainIndex),
                                            UIHelper.verticalSpaceMedium,
                                          ],
                                        );
                                      })),
                              UIHelper.verticalSpaceSmall,
                              Center(
                                  child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: UIHelper.GradientContainer(
                                    10,
                                    10,
                                    10,
                                    10,
                                    [c.colorAccentlight, c.colorPrimaryDark]),
                                child: UIHelper.titleTextStyle(
                                    "Pay Now", c.white, 12, true, true),
                              ))
                            ],
                          ),
                        ));
              },
              viewModelBuilder: () => StartUpViewModel()),
        ));
  }
}
