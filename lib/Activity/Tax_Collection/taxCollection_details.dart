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
  dynamic selectedTaxTypeData;
  TaxCollectionDetailsView({Key? key, required this.selectedTaxTypeData})
      : super(key: key);

  @override
  _TaxCollectionDetailsViewState createState() =>
      _TaxCollectionDetailsViewState();
}

class _TaxCollectionDetailsViewState extends State<TaxCollectionDetailsView> {
  PreferenceService preferencesService = locator<PreferenceService>();
  String selectedLang = "";
  List isShowFlag = [];
  double main_totalAmount = 0.00;
  int main_count = 0;

  List mainList = [
    {
      "name": "SaravanaKumar",
      "door_no": "54/A",
      "street": "North street",
      "village": "Vadamalappur",
      "block": "Nathampannai",
      "district": "PUDUKKOTTAI",
      "building_licence_number": "1534",
      "assesment_no": "54",
      "rows": [],
      "swm": [],
      "total": 0.00,
      "taxData": [
        {"fin_year": "2022-2023", "Amount": 480, "flag": false},
        {"fin_year": "2023-2024", "Amount": 380, "flag": false},
        {"fin_year": "2022-2023", "Amount": 680, "flag": false},
        {"fin_year": "2023-2024", "Amount": 280, "flag": false},
      ],
      "swmData": [
        {"fin_year": "2022-2023", "Amount": 180, "flag": false},
        {"fin_year": "2023-2024", "Amount": 230, "flag": false},
      ]
    },
    {
      "name": "SaravanaKumar",
      "door_no": "54/B",
      "street": "North street",
      "village": "Vadamalappur",
      "block": "Nathampannai",
      "district": "PUDUKKOTTAI",
      "building_licence_number": "1534",
      "assesment_no": "54",
      "rows": [],
      "swm": [],
      "total": 0.00,
      "taxData": [
        {"fin_year": "2022-2023", "Amount": 480, "flag": false},
        {"fin_year": "2023-2024", "Amount": 380, "flag": false},
        {"fin_year": "2022-2023", "Amount": 680, "flag": false},
        {"fin_year": "2023-2024", "Amount": 280, "flag": false},
      ],
      "swmData": [
        {"fin_year": "2022-2023", "Amount": 180, "flag": false},
        {"fin_year": "2023-2024", "Amount": 230, "flag": false},
      ]
    },
    {
      "name": "SaravanaKumar",
      "door_no": "54/C",
      "street": "North street",
      "village": "Vadamalappur",
      "block": "Nathampannai",
      "district": "PUDUKKOTTAI",
      "building_licence_number": "1534",
      "assesment_no": "54",
      "rows": [],
      "swm": [],
      "total": 0.00,
      "taxData": [
        {"fin_year": "2022-2023", "Amount": 480, "flag": false},
        {"fin_year": "2023-2024", "Amount": 380, "flag": false},
        {"fin_year": "2022-2023", "Amount": 680, "flag": false},
        {"fin_year": "2023-2024", "Amount": 280, "flag": false},
      ],
      "swmData": [
        {"fin_year": "2022-2023", "Amount": 180, "flag": false},
        {"fin_year": "2023-2024", "Amount": 230, "flag": false},
      ]
    },
    {
      "name": "SaravanaKumar",
      "door_no": "54/D",
      "street": "North street",
      "village": "Vadamalappur",
      "block": "Nathampannai",
      "district": "PUDUKKOTTAI",
      "building_licence_number": "1534",
      "assesment_no": "54",
      "rows": [],
      "swm": [],
      "total": 0.00,
      "taxData": [
        {"fin_year": "2022-2023", "Amount": 480, "flag": false},
        {"fin_year": "2023-2024", "Amount": 380, "flag": false},
        {"fin_year": "2022-2023", "Amount": 680, "flag": false},
        {"fin_year": "2023-2024", "Amount": 280, "flag": false},
      ],
      "swmData": [
        {"fin_year": "2022-2023", "Amount": 180, "flag": false},
        {"fin_year": "2023-2024", "Amount": 230, "flag": false},
      ]
    },
    {
      "name": "SaravanaKumar",
      "door_no": "54/E",
      "street": "North street",
      "village": "Vadamalappur",
      "block": "Nathampannai",
      "district": "PUDUKKOTTAI",
      "building_licence_number": "1534",
      "assesment_no": "54",
      "rows": [],
      "swm": [],
      "total": 0.00,
      "taxData": [
        {"fin_year": "2022-2023", "Amount": 480, "flag": false},
        {"fin_year": "2023-2024", "Amount": 380, "flag": false},
        {"fin_year": "2022-2023", "Amount": 680, "flag": false},
        {"fin_year": "2023-2024", "Amount": 280, "flag": false},
      ],
      "swmData": [
        {"fin_year": "2022-2023", "Amount": 180, "flag": false},
        {"fin_year": "2023-2024", "Amount": 230, "flag": false},
      ]
    },
  ];

  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    selectedLang = await preferencesService.getUserInfo("lang");
    setState(() {});
  }

  Widget headerCardUIWidget(int mainIndex) {
    return Column(
      children: [
        Container(
            width: Screen.width(context),
            margin: EdgeInsets.only(left: 15, right: 15),
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
                                  mainList[mainIndex]['name'],
                                  c.white,
                                  14,
                                  true,
                                  false),
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
                                    mainList[mainIndex]['door_no'] +
                                        ", " +
                                        mainList[mainIndex]['street'] +
                                        ", " +
                                        mainList[mainIndex]['village'] +
                                        ",\n" +
                                        mainList[mainIndex]['block'] +
                                        ", " +
                                        mainList[mainIndex]['district'],
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
                        UIHelper.verticalSpaceMedium,
                        taxWiseReturnDataWidget(mainIndex),
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
                              widget.selectedTaxTypeData["img_path"],
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
                  visible: isShowFlag.contains(mainIndex),
                  child: propertyTaxCollectionWidget(mainIndex)),
            ])),
      ],
    );
  }

  Widget taxWiseReturnDataWidget(int mainIndex) {
    return widget.selectedTaxTypeData["taxtypeid"] == 1
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UIHelper.titleTextStyle(
                  "Building Licence Number : " +
                      mainList[mainIndex]['building_licence_number'],
                  c.white,
                  12,
                  true,
                  true),
              UIHelper.titleTextStyle(
                  "Assesment Number : " + mainList[mainIndex]['assesment_no'],
                  c.white,
                  12,
                  true,
                  true),
            ],
          )
        : widget.selectedTaxTypeData["taxtypeid"] == 2
            ? UIHelper.titleTextStyle(
                "Water Connection Number : " +
                    mainList[mainIndex]['assesment_no'],
                c.white,
                12,
                true,
                true)
            : widget.selectedTaxTypeData["taxtypeid"] == 3
                ? UIHelper.titleTextStyle(
                    "Assesment Number : " + mainList[mainIndex]['assesment_no'],
                    c.white,
                    12,
                    true,
                    true)
                : widget.selectedTaxTypeData["taxtypeid"] == 4
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          UIHelper.titleTextStyle(
                              "Lease From Date : " + "05-03-2015",
                              c.white,
                              12,
                              true,
                              true),
                          UIHelper.titleTextStyle(
                              "Lease To Date : " + "05-03-2018",
                              c.white,
                              12,
                              true,
                              true),
                        ],
                      )
                    : UIHelper.titleTextStyle(
                        "Traders Code : " + mainList[mainIndex]['assesment_no'],
                        c.white,
                        12,
                        true,
                        true);
  }

  Widget propertyTaxCollectionWidget(int mainIndex) {
    List taxData = mainList[mainIndex]['taxData'];
    List swmData = mainList[mainIndex]['swmData'];

    int dataWiseHeight = taxData.length * 30;
    int swmHeight = swmData.length * 30;
    return Container(
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
                height: dataWiseHeight + 0.02,
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: taxData.length,
                  itemBuilder: (context, rowIndex) {
                    int siNo = rowIndex + 1;
                    return Container(
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
                                            taxData[rowIndex]['fin_year'],
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
                                          taxData[rowIndex]['Amount']
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
                                      value: taxData[rowIndex]['flag'],
                                      onChanged: (v) {
                                        if (rowIndex == 0 ||
                                            taxData[rowIndex - 1]['flag'] ==
                                                true) {
                                          if (taxData[rowIndex]['flag'] ==
                                              true) {
                                            for (int i = 0;
                                                i < taxData.length;
                                                i++) {
                                              if (i >= rowIndex) {
                                                taxData[i]['flag'] = false;
                                                mainList[mainIndex]['total'] =
                                                    mainList[mainIndex]
                                                            ['total'] -
                                                        taxData[i]['Amount'];
                                              }
                                            }
                                          } else {
                                            taxData[rowIndex]['flag'] = true;
                                            mainList[mainIndex]['total'] =
                                                mainList[mainIndex]['total'] +
                                                    taxData[rowIndex]['Amount'];
                                          }
                                        }

                                        setState(() {
                                          main_count = 0;
                                          main_totalAmount = 0.00;

                                          for (int i = 0;
                                              i < mainList.length;
                                              i++) {
                                            List taxData =
                                                mainList[i]['taxData'];
                                            List swmData =
                                                mainList[i]['swmData'];
                                            for (int i = 0;
                                                i < taxData.length;
                                                i++) {
                                              if (taxData[i]['flag'] == true) {
                                                main_count = main_count + 1;
                                                main_totalAmount =
                                                    main_totalAmount +
                                                        taxData[i]['Amount'];
                                              }
                                            }
                                            for (int i = 0;
                                                i < swmData.length;
                                                i++) {
                                              if (swmData[i]['flag'] == true) {
                                                main_count = main_count + 1;
                                                main_totalAmount =
                                                    main_totalAmount +
                                                        swmData[i]['Amount'];
                                              }
                                            }
                                          }
                                        });
                                      },
                                    ),
                                  )),
                            ),
                          ],
                        ));
                  },
                )),
            UIHelper.verticalSpaceSmall,
            Visibility(
                visible: swmData.length > 0 &&
                    widget.selectedTaxTypeData["taxtypeid"] == 1,
                child: Column(
                  children: [
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
                            return Container(
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
                                                  swmData[rowIndex]['Amount']
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
                                              side: BorderSide(
                                                  width: 1, color: c.grey_6),
                                              value: swmData[rowIndex]['flag'],
                                              onChanged: (v) {
                                                if (rowIndex == 0 ||
                                                    swmData[rowIndex - 1]
                                                            ['flag'] ==
                                                        true) {
                                                  if (swmData[rowIndex]
                                                          ['flag'] ==
                                                      true) {
                                                    for (int i = 0;
                                                        i < swmData.length;
                                                        i++) {
                                                      if (i >= rowIndex) {
                                                        swmData[i]['flag'] =
                                                            false;
                                                        mainList[mainIndex]
                                                                ['total'] =
                                                            mainList[mainIndex]
                                                                    ['total'] -
                                                                swmData[i]
                                                                    ['Amount'];
                                                      }
                                                    }
                                                  } else {
                                                    swmData[rowIndex]['flag'] =
                                                        true;
                                                    mainList[mainIndex]
                                                            ['total'] =
                                                        mainList[mainIndex]
                                                                ['total'] +
                                                            swmData[rowIndex]
                                                                ['Amount'];
                                                  }
                                                }

                                                setState(() {
                                                  main_count = 0;
                                                  main_totalAmount = 0.00;

                                                  for (int i = 0;
                                                      i < mainList.length;
                                                      i++) {
                                                    List taxData =
                                                        mainList[i]['taxData'];
                                                    List swmData =
                                                        mainList[i]['swmData'];
                                                    for (int i = 0;
                                                        i < taxData.length;
                                                        i++) {
                                                      if (taxData[i]['flag'] ==
                                                          true) {
                                                        main_count =
                                                            main_count + 1;
                                                        main_totalAmount =
                                                            main_totalAmount +
                                                                taxData[i]
                                                                    ['Amount'];
                                                      }
                                                    }
                                                    for (int i = 0;
                                                        i < swmData.length;
                                                        i++) {
                                                      if (swmData[i]['flag'] ==
                                                          true) {
                                                        main_count =
                                                            main_count + 1;
                                                        main_totalAmount =
                                                            main_totalAmount +
                                                                swmData[i]
                                                                    ['Amount'];
                                                      }
                                                    }
                                                  }
                                                });
                                              },
                                            ),
                                          )),
                                    ),
                                  ],
                                ));
                          },
                        )),
                  ],
                )),

            // UIHelper.verticalSpaceSmall,
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "amount_to_pay".tr().toString(),
                        style: TextStyle(
                            color: c.grey_10,
                            fontSize: 10,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.right,
                      )),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                      decoration: UIHelper.GradientContainer(
                          5, 5, 5, 5, [c.grey, c.grey]),
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 8),
                      margin: EdgeInsets.all(10),
                      child: UIHelper.titleTextStyle(
                          "\u{20B9}" + mainList[mainIndex]['total'].toString(),
                          c.grey_9,
                          14,
                          true,
                          true)),
                ),
              ],
            ),

            UIHelper.verticalSpaceSmall,
          ],
        ));
  }

  Widget addToPayWidget() {
    return Stack(
      children: [
        Align(
            alignment: Alignment.centerLeft,
            child: Container(
                margin: EdgeInsets.only(top: 10, left: 10, bottom: 10),
                padding: EdgeInsets.fromLTRB(10, 5, 10, 8),
                child: UIHelper.titleTextStyle(
                    selectedLang == "en"
                        ? widget.selectedTaxTypeData["taxtypedesc_en"]
                        : widget.selectedTaxTypeData["taxtypedesc_ta"],
                    c.grey_8,
                    12,
                    true,
                    true))),
        Align(
            alignment: Alignment.centerRight,
            child: Container(
                margin: EdgeInsets.only(top: 10, right: 30, bottom: 10),
                decoration: UIHelper.GradientContainer(
                    5, 5, 5, 5, [c.grey_7, c.grey_7]),
                padding: EdgeInsets.fromLTRB(10, 5, 10, 8),
                child: UIHelper.titleTextStyle(
                    "added_to_pay".tr().toString(), c.white, 12, true, true))),
        Align(
            alignment: Alignment.topRight,
            child: Container(
              child: Container(
                  transform: Matrix4.translationValues(
                    0,
                    -5,
                    0,
                  ),
                  margin: EdgeInsets.only(top: 0, right: 10, bottom: 10),
                  decoration: UIHelper.circleWithColorWithShadow(
                      360,
                      c.account_status_green_color,
                      c.account_status_green_color),
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 8),
                  child: UIHelper.titleTextStyle(
                      (main_count).toString(), c.white, 12, true, true)),
            ))
      ],
    );
  }

  Widget payWidget() {
    return Stack(
      children: [
        Align(
            alignment: Alignment.centerLeft,
            child: Container(
                margin: EdgeInsets.only(top: 10, left: 30, bottom: 10),
                decoration: UIHelper.GradientContainer(
                    5, 5, 5, 5, [c.grey_7, c.grey_7]),
                padding: EdgeInsets.fromLTRB(10, 5, 10, 8),
                child: UIHelper.titleTextStyle(
                    "\u{20B9}" + main_totalAmount.toString(),
                    c.white,
                    12,
                    true,
                    true))),
        Align(
            alignment: Alignment.centerRight,
            child: Container(
                margin: EdgeInsets.only(top: 10, right: 30, bottom: 10),
                decoration: UIHelper.GradientContainer(5, 5, 5, 5, [
                  c.account_status_green_color,
                  c.account_status_green_color
                ]),
                padding: EdgeInsets.fromLTRB(10, 5, 10, 8),
                child: UIHelper.titleTextStyle(
                    "pay".tr().toString(), c.white, 12, true, true))),
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
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    UIHelper.verticalSpaceSmall,
                    addToPayWidget(),
                    UIHelper.verticalSpaceSmall,
                    Expanded(
                        child: Container(
                            height: MediaQuery.of(context).size.height,
                            child: ListView.builder(
                                shrinkWrap: true,
                                // physics: NeverScrollableScrollPhysics(),
                                itemCount: mainList.length,
                                itemBuilder: (context, mainIndex) {
                                  return Column(
                                    children: [
                                      headerCardUIWidget(mainIndex),
                                      UIHelper.verticalSpaceMedium,
                                    ],
                                  );
                                }))),
                    payWidget()
                  ],
                ));
              },
              viewModelBuilder: () => StartUpViewModel()),
        ));
  }
}
