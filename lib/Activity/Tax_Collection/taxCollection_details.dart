import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:public_vptax/Activity/Tax_Collection/tax_pay_details.dart';
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

class TaxCollectionDetailsView extends StatefulWidget {
  final selectedTaxTypeData;
  final isHome;
  TaxCollectionDetailsView({Key? key,  this.selectedTaxTypeData,  this.isHome});

  @override
  _TaxCollectionDetailsViewState createState() =>
      _TaxCollectionDetailsViewState();
}

class _TaxCollectionDetailsViewState extends State<TaxCollectionDetailsView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  PreferenceService preferencesService = locator<PreferenceService>();
  String selectedLang = "";
  String selectTaxtype = "";
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
      "tax_advance": 550.00,
      "swm_advance": 250.00,
      "assesment_no": "54",
      "total": 0.00,
      "tax_pay": 0.00,
      "swm_pay": 0.00,
      "swm_total": 0.00,
      "taxData": [
        {
          "fin_year": "2022-2023",
          "year": "April-March",
          "month": "Jan",
          "Amount": 480.00,
          "flag": false
        },
        {
          "fin_year": "2023-2024",
          "year": "April-March",
          "month": "Feb",
          "Amount": 380.00,
          "flag": false
        },
        {
          "fin_year": "2022-2023",
          "year": "April-March",
          "month": "Mar",
          "Amount": 680.00,
          "flag": false
        },
        {
          "fin_year": "2023-2024",
          "year": "April-March",
          "month": "Apr",
          "Amount": 280.00,
          "flag": false
        },
      ],
      "swmData": [
        {"fin_year": "2022-2023", "Amount": 180.00, "flag": false},
        {"fin_year": "2023-2024", "Amount": 230.00, "flag": false},
      ]
    },
    {
      "name": "SaravanaKumar",
      "door_no": "54/A",
      "street": "North street",
      "village": "Vadamalappur",
      "block": "Nathampannai",
      "district": "PUDUKKOTTAI",
      "building_licence_number": "1534",
      "assesment_no": "54",
      "tax_advance": 550.00,
      "swm_advance": 250.00,
      "tax_pay": 0.00,
      "swm_pay": 0.00,
      "total": 0.00,
      "swm_total": 0.00,
      "taxData": [
        {
          "fin_year": "2022-2023",
          "year": "April-March",
          "month": "Jan",
          "Amount": 480.00,
          "flag": false
        },
        {
          "fin_year": "2023-2024",
          "year": "April-March",
          "month": "Feb",
          "Amount": 380.00,
          "flag": false
        },
        {
          "fin_year": "2022-2023",
          "year": "April-March",
          "month": "Mar",
          "Amount": 680.00,
          "flag": false
        },
        {
          "fin_year": "2023-2024",
          "year": "April-March",
          "month": "Apr",
          "Amount": 280.00,
          "flag": false
        },
      ],
      "swmData": [
        {"fin_year": "2022-2023", "Amount": 180.00, "flag": false},
        {"fin_year": "2023-2024", "Amount": 230.00, "flag": false},
      ]
    },
    {
      "name": "SaravanaKumar",
      "door_no": "54/A",
      "street": "North street",
      "village": "Vadamalappur",
      "block": "Nathampannai",
      "district": "PUDUKKOTTAI",
      "building_licence_number": "1534",
      "assesment_no": "54",
      "tax_advance": 550.00,
      "swm_advance": 250.00,
      "total": 0.00,
      "swm_total": 0.00,
      "tax_pay": 0.00,
      "swm_pay": 0.00,
      "taxData": [
        {
          "fin_year": "2022-2023",
          "year": "April-March",
          "month": "Jan",
          "Amount": 480.00,
          "flag": false
        },
        {
          "fin_year": "2023-2024",
          "year": "April-March",
          "month": "Feb",
          "Amount": 380.00,
          "flag": false
        },
        {
          "fin_year": "2022-2023",
          "year": "April-March",
          "month": "Mar",
          "Amount": 680.00,
          "flag": false
        },
        {
          "fin_year": "2023-2024",
          "year": "April-March",
          "month": "Apr",
          "Amount": 280.00,
          "flag": false
        },
      ],
      "swmData": [
        {"fin_year": "2022-2023", "Amount": 180.00, "flag": false},
        {"fin_year": "2023-2024", "Amount": 230.00, "flag": false},
      ]
    },
  ];

  final List<Map<String, dynamic>> taxTypeList = [
    {
      'taxtypeid': 1,
      'taxtypedesc_en': 'House Tax',
      'taxtypedesc_ta': 'வீட்டு வரி',
      'img_path': imagePath.house
    },
    {
      'taxtypeid': 2,
      'taxtypedesc_en': 'Water Tax',
      'taxtypedesc_ta': 'குடிநீர் கட்டணங்கள்',
      'img_path': imagePath.water
    },
    {
      'taxtypeid': 3,
      'taxtypedesc_en': 'Professional Tax',
      'taxtypedesc_ta': 'தொழில் வரி',
      'img_path': imagePath.professional1
    },
    {
      'taxtypeid': 4,
      'taxtypedesc_en': 'Non Tax',
      'taxtypedesc_ta': 'இதர வரவினங்கள்',
      'img_path': imagePath.nontax1
    },
    {
      'taxtypeid': 5,
      'taxtypedesc_en': 'Trade Licence',
      'taxtypedesc_ta': 'வர்த்தக உரிமம்',
      'img_path': imagePath.property
    },
  ];

  var selectedTaxTypeData;

  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );

    // Create a curved animation with Curves.bounceOut
    _animation = CurvedAnimation(parent: _controller, curve: Curves.bounceOut);

    if(widget.isHome){
      selectedTaxTypeData = taxTypeList[0];
    }else{
      selectedTaxTypeData = widget.selectedTaxTypeData;
    }
    selectTaxtype = selectedTaxTypeData['taxtypeid'].toString();
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
                color: c.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                          child: SingleChildScrollView(
                              child: Column(children: [
                    UIHelper.verticalSpaceSmall,
                    addToPayWidget(),
                    Container(
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
                            }))
                    ],)),),
                      payWidget()


                    ],
                  ));
            },
            viewModelBuilder: () => StartUpViewModel()));
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
              InkWell(
                onTap: (){
                  setState(() {
                                            if (isShowFlag.contains(mainIndex)) {
                                              isShowFlag.remove(mainIndex);
                                            } else {
                                              isShowFlag.add(mainIndex);
                                            }
                                          });

                },
                child: Stack(
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
                        UIHelper.verticalSpaceSmall,
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
                          selectedTaxTypeData["img_path"].toString(),
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
              ),),
              Visibility(
                  visible: isShowFlag.contains(mainIndex),
                  child: propertyTaxCollectionWidget(mainIndex)),
            ])),
      ],
    );
  }

  Widget taxWiseReturnDataWidget(int mainIndex) {
    return selectedTaxTypeData["taxtypeid"] == 1
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
        : selectedTaxTypeData["taxtypeid"] == 2
            ? UIHelper.titleTextStyle(
                "Water Connection Number : " +
                    mainList[mainIndex]['assesment_no'],
                c.white,
                12,
                true,
                true)
            : selectedTaxTypeData["taxtypeid"] == 3
                ? UIHelper.titleTextStyle(
                    "Assesment Number : " + mainList[mainIndex]['assesment_no'],
                    c.white,
                    12,
                    true,
                    true)
                : selectedTaxTypeData["taxtypeid"] == 4
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
                                flex: 3,
                                child: Container(
                                    padding: EdgeInsets.all(8.0),
                                    child: Center(
                                        child: UIHelper.titleTextStyle(
                                            selectedTaxTypeData["taxtypeid"] ==
                                                    2
                                                ? taxData[rowIndex]['month']
                                                : taxData[rowIndex]['year'],
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
                                                print("Tot>>"+mainList[mainIndex]['total'].toString());
                                                mainList[mainIndex]['total'] = mainList[mainIndex]['total'] - taxData[i]['Amount'];

                                                print("Tot>>"+taxData[i]['Amount'].toString());
                                                print("Tot"+mainList[mainIndex]['total'].toString());
                                                mainList[mainIndex]['tax_pay'] =getTotal(mainList[mainIndex]['total'], mainList[mainIndex]['tax_advance']);
                                              }
                                            }
                                          } else {
                                            taxData[rowIndex]['flag'] = true;
                                            mainList[mainIndex]['total'] =
                                                mainList[mainIndex]['total'] +
                                                    taxData[rowIndex]['Amount'];
                                            mainList[mainIndex]['tax_pay'] =getTotal(mainList[mainIndex]['total'], mainList[mainIndex]['tax_advance']);

                                          }
                                        }

                                        setState(() {
                                          main_count = 0;
                                          main_totalAmount = 0.00;

                                          for (int i = 0;
                                              i < mainList.length;
                                              i++) {
                                            main_totalAmount =
                                                main_totalAmount +
                                                    mainList[i]['tax_pay']+mainList[i]['swm_pay'];
                                            List taxData =
                                                mainList[i]['taxData'];
                                            List swmData =
                                                mainList[i]['swmData'];
                                            for (int i = 0;
                                                i < taxData.length;
                                                i++) {
                                              if (taxData[i]['flag'] == true) {
                                                main_count = main_count + 1;
                                              }
                                            }
                                            for (int i = 0;
                                                i < swmData.length;
                                                i++) {
                                              if (swmData[i]['flag'] == true) {
                                                main_count = main_count + 1;
                                              }
                                            }
                                          }
                                          repeatOnce();
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
            demandCalculationWidget(mainIndex),
            Visibility(
                visible:
                    swmData.length > 0 && selectedTaxTypeData["taxtypeid"] == 1,
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
                                                  c.grey_8,
                                                  12,
                                                  true,
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
                                                                ['swm_total'] =
                                                            mainList[mainIndex][
                                                                    'swm_total'] -
                                                                swmData[i]
                                                                    ['Amount'];
                                                        mainList[mainIndex]['swm_pay'] =getTotal(mainList[mainIndex]['swm_total'], mainList[mainIndex]['swm_advance']);

                                                      }
                                                    }
                                                  } else {
                                                    swmData[rowIndex]['flag'] =
                                                        true;
                                                    mainList[mainIndex]
                                                            ['swm_total'] =
                                                        mainList[mainIndex]
                                                                ['swm_total'] +
                                                            swmData[rowIndex]
                                                                ['Amount'];
                                                    mainList[mainIndex]['swm_pay'] =getTotal(mainList[mainIndex]['swm_total'], mainList[mainIndex]['swm_advance']);

                                                  }
                                                }

                                                setState(() {
                                                  main_count = 0;
                                                  main_totalAmount = 0.00;

                                                  for (int i = 0;
                                                      i < mainList.length;
                                                      i++) {
                                                    main_totalAmount =
                                                        main_totalAmount +
                                                            mainList[i]['tax_pay']+mainList[i]['swm_pay'];
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
                                                      }
                                                    }
                                                    for (int i = 0;
                                                        i < swmData.length;
                                                        i++) {
                                                      if (swmData[i]['flag'] ==
                                                          true) {
                                                        main_count =
                                                            main_count + 1;
                                                      }
                                                    }
                                                  }
                                                  repeatOnce();
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
                    demandCalculationWidgetForSWM(mainIndex),
                  ],
                )),

            // UIHelper.verticalSpaceSmall,
/*            Row(
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
                          "\u{20B9}" + (mainList[mainIndex]['total']+mainList[mainIndex]['swm_total']).toString(),
                          c.grey_9,
                          14,
                          true,
                          true)),
                ),
              ],
            ),*/

            UIHelper.verticalSpaceSmall,
          ],
        ));
  }
  Widget demandCalculationWidget(int mainIndex){
    return Container(
      child: Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
      UIHelper.titleTextStyle('demand'.tr().toString()+" : "+mainList[mainIndex]['total'].toString(), c.grey_8, 10, true, false),
    UIHelper.titleTextStyle('advance'.tr().toString()+" : "+mainList[mainIndex]['tax_advance'].toString(), c.grey_8, 10, true, false),
    ],),
        UIHelper.verticalSpaceSmall,
        UIHelper.titleTextStyle('payable'.tr().toString()+" : "+mainList[mainIndex]['tax_pay'].toString(), c.grey_9, 11, true, false),
        UIHelper.verticalSpaceTiny,
      ],),
    );
  }
  Widget demandCalculationWidgetForSWM(int mainIndex){
    return Container(
      child: Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
      UIHelper.titleTextStyle('demand'.tr().toString()+" : "+mainList[mainIndex]['swm_total'].toString(), c.grey_8, 10, true, false),
    UIHelper.titleTextStyle('advance'.tr().toString()+" : "+mainList[mainIndex]['swm_advance'].toString(), c.grey_8, 10, true, false),
    ],),
        UIHelper.verticalSpaceSmall,
        UIHelper.titleTextStyle('payable'.tr().toString()+" : "+mainList[mainIndex]['swm_pay'].toString(), c.grey_9, 11, true, false),
        UIHelper.verticalSpaceTiny,
      ],),
    );
  }
  Widget addToPayWidget() {
    return Stack(
      children: [
      Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin:
        EdgeInsets.only(left: Screen.width(context) * 0.08, bottom: 10),
        child: DropdownButtonHideUnderline(child:IgnorePointer(
          ignoring: widget.isHome?false:true,
          child:  DropdownButton(
          elevation: 0,
          isExpanded: false,
          value: selectTaxtype,
          iconSize:0.0 ,
          icon: widget.isHome?Padding(
              padding: EdgeInsets.all(10),
              child: Icon(
                Icons.arrow_drop_down_circle,
                size: 15,
                color: c.grey_9,
              )):null,
          style: TextStyle(
            color: c.black,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
          items: taxTypeList
              .map((item) => DropdownMenuItem<String>(
            value: item['taxtypeid'].toString(),
            child: Text(
                preferencesService.getUserInfo('lang') == 'en'
                    ? item["taxtypedesc_en"]
                    : item["taxtypedesc_ta"]),
          ))
              .toList(),
          onChanged: (newValue) {
            setState(() {
              selectTaxtype = newValue.toString();
              handleClick(selectTaxtype);
            });
          },
        ),),),
      ),
    ),
        Visibility(
          visible: !widget.isHome,
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: MediaQuery.of(context).size.width/2,
              margin: EdgeInsets.only(top: 10, right: 15, bottom: 15),
              decoration: UIHelper.GradientContainer(5, 5, 5, 5, [
                c.grey_8,
                c.grey_8
              ]),
              padding: EdgeInsets.fromLTRB(5, 8, 0, 8),
              child: Row( // Wrap with Row to add the plus icon
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add, // Use the icon you prefer (e.g., Icons.add, Icons.add_circle, etc.)
                    color: c.white,
                    size: 15,
                  ),
                  SizedBox(width: 3), // Add a small space between the icon and the text
              Flexible(
                child:UIHelper.titleTextStyle(
                    "new".tr().toString() + (selectedLang == "en"
                        ? selectedTaxTypeData["taxtypedesc_en"]
                        : selectedTaxTypeData["taxtypedesc_ta"] )+"new2".tr().toString(),
                    c.white,
                    10,
                    true,
                    true,
                  )),
                ],
              ),
            )
        ),
        ),
        Visibility(
            visible: widget.isHome,
            child:Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: (){bool flag=false;
              for (int i = 0; i < mainList.length; i++) {
                if(mainList[i]['total'] > 0 || mainList[i]['swm_total'] > 0){
                  flag=true;
                }
              }
              flag?
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => TaxPayDetailsView(
                  mainList: mainList,
                  selectedTaxTypeData: selectedTaxTypeData,
                ),
              )):Utils().showAlert(context, ContentType.warning, 'message');
              },
              child: Container(
                  margin: EdgeInsets.only(top: 10, right: 30, bottom: 10),
                  decoration: UIHelper.GradientContainer(
                      5, 5, 5, 5, [c.grey_7, c.grey_7]),
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 8),
                  child: UIHelper.titleTextStyle(
                      "added_to_pay".tr().toString(), c.white, 12, true, true)),
            ))),
        Visibility(
            visible: widget.isHome,
            child:Align(
            alignment: Alignment.topRight,
            child: Transform.scale(
                scale: _animation.value,
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
                ))))
      ],
    );
  }

  Widget payWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: UIHelper.GradientContainer(
          15, 15, 0, 0, [c.colorPrimaryDark, c.colorAccentlight]),
      child:  Column(
      children: [
        Align(
            alignment: Alignment.centerLeft,
            child: Container(
                margin: EdgeInsets.only(top: 10, left: 20,right: 20),
                padding: EdgeInsets.all(5),
                child: UIHelper.titleTextStyle(
                    'total_amount_to_pay'.tr().toString()+" : ""\u{20B9}" + main_totalAmount.toString(),
                    c.white,
                    12,
                    true,
                    true))),
        Align(
            alignment: Alignment.centerRight,
            child:InkWell(
                onTap: (){bool flag=false;
                for (int i = 0; i < mainList.length; i++) {
                  if(mainList[i]['total'] > 0 || mainList[i]['swm_total'] > 0){
                    flag=true;
                  }
                }
                flag?
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => TaxPayDetailsView(
                    mainList: mainList,
                    selectedTaxTypeData: selectedTaxTypeData,
                  ),
                )):Utils().showAlert(context, ContentType.warning, 'message');
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
    ),);
  }
/*
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
            child:InkWell(
              onTap: (){bool flag=false;
              for (int i = 0; i < mainList.length; i++) {
                if(mainList[i]['total'] > 0 || mainList[i]['swm_total'] > 0){
                  flag=true;
                }
              }
              flag?
                Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => TaxPayDetailsView(
                  mainList: mainList,
                  selectedTaxTypeData: selectedTaxTypeData,
                ),
              )):Utils().showAlert(context, ContentType.warning, 'message');
              },
                child: Container(
                margin: EdgeInsets.only(top: 10, right: 30, bottom: 10),
                decoration: UIHelper.GradientContainer(5, 5, 5, 5, [
                  c.account_status_green_color,
                  c.account_status_green_color
                ]),
                padding: EdgeInsets.fromLTRB(10, 5, 10, 8),
                child: UIHelper.titleTextStyle(
                    "pay".tr().toString(), c.white, 12, true, true)))),
      ],
    );
  }
*/


  void handleClick(String value) async {
    switch (value) {
      case '1':
        setState(() {
          selectedTaxTypeData = taxTypeList[0];
        });
        break;
      case '2':
        setState(() {
          selectedTaxTypeData = taxTypeList[1];
        });
        break;
      case '3':
        setState(() {
          selectedTaxTypeData = taxTypeList[2];
        });
        break;
      case '4':
        setState(() {
          selectedTaxTypeData = taxTypeList[3];
        });
        break;
      case '5':
        setState(() {
          selectedTaxTypeData = taxTypeList[4];
        });
        break;
    }
  }
  double getTotal(double d1,double d2) {
    double s=0.00;
    double ss=0.00;
    ss=d1-d2;
    ss > 0 ? s=ss:s=0.00;
    return s;
  }
}
