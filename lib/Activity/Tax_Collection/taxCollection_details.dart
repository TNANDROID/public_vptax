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
  TaxCollectionDetailsView({Key? key,  this.selectedTaxTypeData,  this.isHome});

  @override
  _TaxCollectionDetailsViewState createState() =>
      _TaxCollectionDetailsViewState();
}

class _TaxCollectionDetailsViewState extends State<TaxCollectionDetailsView>
    with TickerProviderStateMixin  {
  late AnimationController _controller;
  late AnimationController _controller2;
  late Animation<double> _animation;
  late Animation<Offset> _offsetFloat;

  PreferenceService preferencesService = locator<PreferenceService>();
  String selectedLang = "";
  String selectTaxtype = "";
  List isShowFlag = [];
  double main_totalAmount = 0.00;
  int main_count = 0;
  ScrollController controller_scroll = ScrollController();
  List mainList = [
    {
      "name": "SaravanaKumar",
      "door_no": "54/A",
      "street": "North streetstreet street",
      "village": "Vadamalappur Vadamalappur",
      "block": "Nathampannai Nathampannai",
      "district": "PUDUKKOTTAI PUDUKKOTTAI",
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

  List taxTypeList = [];

  var selectedTaxTypeData;

  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );

    // Create a curved animation with Curves.bounceOut
    _animation = CurvedAnimation(parent: _controller, curve: Curves.bounceOut);

    taxTypeList= preferencesService.taxTypeList;
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
                  color: c.need_improvement2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                            controller: controller_scroll,
                            scrollDirection: Axis.vertical,
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
            margin: EdgeInsets.only(left: 20,top: 5, right: 15),
            padding: EdgeInsets.fromLTRB(15,15,10,15),
            decoration: UIHelper.roundedBorderWithColorWithShadow(
                5, c.white, c.white,
                borderWidth: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
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
                          Container(
                            width: Screen.width(context)/2,
                            child: Flex(
                              direction: Axis.horizontal,
                              children: [
                                Flexible(
                                    child:                         UIHelper.titleTextStyle(
                                        mainList[mainIndex]['name'],
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
                          Container(
                            width: MediaQuery.of(context).size.width*0.75,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                UIHelper.titleTextStyle(
                                    mainList[mainIndex]['door_no'] +
                                        ", " +
                                        mainList[mainIndex]['street'],
                                    c.grey_8,
                                    11,
                                    false,
                                    false),
                                UIHelper.titleTextStyle(
                                    mainList[mainIndex]['village'] +
                                        ", " +
                                        mainList[mainIndex]['block'] ,
                                    c.grey_8,
                                    11,
                                    false,
                                    false),
                                UIHelper.titleTextStyle(
                                    mainList[mainIndex]['district'],
                                    c.grey_8,
                                    11,
                                    false,
                                    false)

                              ],),
                          ),
                          UIHelper.horizontalSpaceSmall,
                        ],
                      ),
                      UIHelper.verticalSpaceSmall,
                    ],),),
                UIHelper.verticalSpaceTiny,
                Container(
                    alignment: Alignment.centerLeft,
                    child: taxWiseReturnDataWidget(mainIndex,c.grey_8)),
                UIHelper.verticalSpaceTiny,
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width /2,
                  padding: EdgeInsets.all(5),
                  decoration:
                  UIHelper.roundedBorderWithColorWithShadow(
                      5, c.colorPrimary, c.colorAccentlight),
                  child: InkWell(
                    onTap: (){
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: UIHelper.titleTextStyle(
                              'demand_details',
                              c.white,
                              10,
                              true,
                              true),
                        )
                        ,
                        Icon(
                          isShowFlag.contains(mainIndex)
                              ? Icons.arrow_circle_up_rounded
                              : Icons.arrow_circle_down_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],),
                  ),
                ),
                Visibility(
                    visible: isShowFlag.contains(mainIndex),
                    child: propertyTaxCollectionWidget(mainIndex))
              ],
            ))
      ],);
  }
  Widget taxWiseReturnDataWidget(int mainIndex, Color clr) {
    return selectedTaxTypeData["taxtypeid"] == 1
        ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UIHelper.titleTextStyle(
            "Building Licence Number : " +
                mainList[mainIndex]['building_licence_number'],
            clr,
            12,
            false,
            true),
        UIHelper.titleTextStyle(
            "Assesment Number : " + mainList[mainIndex]['assesment_no'],
            clr,
            12,
            false,
            true),
      ],
    )
        : selectedTaxTypeData["taxtypeid"] == 2
        ? UIHelper.titleTextStyle(
        "Water Connection Number : " +
            mainList[mainIndex]['assesment_no'],
        clr,
        12,
        false,
        true)
        : selectedTaxTypeData["taxtypeid"] == 3
        ? UIHelper.titleTextStyle(
        "Assesment Number : " + mainList[mainIndex]['assesment_no'],
        clr,
        12,
        false,
        true)
        : selectedTaxTypeData["taxtypeid"] == 4
        ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UIHelper.titleTextStyle(
            "Lease From Date : " + "05-03-2015",
            clr,
            12,
            false,
            true),
        UIHelper.titleTextStyle(
            "Lease To Date : " + "05-03-2018",
            clr,
            12,
            false,
            true),
      ],
    )
        : UIHelper.titleTextStyle(
        "Traders Code : " + mainList[mainIndex]['assesment_no'],
        clr,
        12,
        false,
        true);
  }

  Widget propertyTaxCollectionWidget(int mainIndex) {
    List taxData = mainList[mainIndex]['taxData'];
    List swmData = mainList[mainIndex]['swmData'];

    int dataWiseHeight = taxData.length * 30;
    int swmHeight = swmData.length * 30;
    return Container(
        margin: EdgeInsets.only(top: 15),
        decoration: UIHelper.roundedBorderWithColor(
            3,3,3,3, c.need_improvement2,
            borderWidth: 1,borderColor: c.grey_6),
        padding: EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                padding: EdgeInsets.only(top: 0),
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
                                          c.grey_8,
                                          12,
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
                                                if(taxData[i]['flag'] == true){
                                                  taxData[i]['flag'] = false;
                                                  print("Tot>>"+mainList[mainIndex]['total'].toString());
                                                  mainList[mainIndex]['total'] = mainList[mainIndex]['total'] - taxData[i]['Amount'];

                                                  print("Tot>>"+taxData[i]['Amount'].toString());
                                                  print("Tot"+mainList[mainIndex]['total'].toString());
                                                  mainList[mainIndex]['tax_pay'] =getTotal(mainList[mainIndex]['total'], mainList[mainIndex]['tax_advance']);

                                                }
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
            UIHelper.titleTextStyle('demand'.tr().toString()+" : "+"\u{20B9} "+mainList[mainIndex]['total'].toString(), c.black, 11, false, false),
            UIHelper.titleTextStyle('advance'.tr().toString()+" : "+"\u{20B9} "+mainList[mainIndex]['tax_advance'].toString(), c.black, 11, false, false),
          ],),
        UIHelper.verticalSpaceSmall,
        /* UIHelper.titleTextStyle('payable'.tr().toString()+" : "+"\u{20B9} "+mainList[mainIndex]['tax_pay'].toString(), c.grey_8, 11, true, false),
        UIHelper.verticalSpaceTiny,*/
      ],),
    );
  }
  Widget demandCalculationWidgetForSWM(int mainIndex){
    return Container(
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            UIHelper.titleTextStyle('demand'.tr().toString()+" : "+"\u{20B9} "+mainList[mainIndex]['swm_total'].toString(), c.black, 11, false, false),
            UIHelper.titleTextStyle('advance'.tr().toString()+" : "+"\u{20B9} "+mainList[mainIndex]['swm_advance'].toString(), c.black, 11, false, false),
          ],),
        UIHelper.verticalSpaceSmall,
        /*UIHelper.titleTextStyle('payable'.tr().toString()+" : "+"\u{20B9} "+mainList[mainIndex]['swm_pay'].toString(), c.grey_8, 11, true, false),
        UIHelper.verticalSpaceTiny,*/
      ],),
    );
  }
  Widget addToPayWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: Container(
            margin: EdgeInsets.only(top: 10, bottom: 15,left: 15),
            decoration:
            UIHelper.roundedBorderWithColorWithShadow(
                5, c.white, c.white),
            child: Row(children: [
              Container(
                  width: 35,
                  height: 35,
                  padding: EdgeInsets.all(5),
                  decoration:
                  UIHelper.roundedBorderWithColor(
                      5,5,5,5, c.colorPrimary),
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
            ],),
          ),
        ),
        Visibility(
          visible: !widget.isHome,
          child:Expanded(
            flex: 1,
            child:
            Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: MediaQuery.of(context).size.width/2.5,
                  margin: EdgeInsets.only(top: 10, bottom: 15,right: 15),
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
                      SizedBox(width: 3),
                      Flexible(
                          child:UIHelper.titleTextStyle(
                            "new".tr().toString() + (selectedLang == "en"
                                ? selectedTaxTypeData["taxtypedesc_en"]
                                : selectedTaxTypeData["taxtypedesc_ta"] )+"new2".tr().toString(),
                            c.white,
                            10,
                            true,
                            true,
                          ))// Add a small space between the icon and the text
                      ,
                    ],
                  ),
                )
            ),
          ),
        ),
        Visibility(
          visible: widget.isHome,
          child:Expanded(
              flex: 1,
              child:  Stack(
                children: [
                  Align(
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
                            margin: EdgeInsets.only(top: 15, right: 30, bottom: 15),
                            decoration: UIHelper.GradientContainer(
                                5, 5, 5, 5, [c.grey_7, c.grey_7]),
                            padding: EdgeInsets.fromLTRB(10, 5, 10, 8),
                            child: UIHelper.titleTextStyle(
                                "added_to_pay".tr().toString(), c.white, 12, true, true)),
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
                                    (main_count).toString(), c.white, 12, true, true)),
                          )))
                ],
              )),
        ),

      ],
    );
  }
  Widget addInputDropdownField() {

    return FormBuilderDropdown(
      style: TextStyle(
          fontSize: 12, fontWeight: FontWeight.w400, color: c.grey_8),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 0),
        constraints: BoxConstraints(
            maxHeight: 35
        ),
        hintText:'select_taxtype'.tr().toString(),
        hintStyle: TextStyle(fontSize: 11,),
        filled: true,
        fillColor: c.full_transparent,
        enabledBorder: OutlineInputBorder(
          borderSide:BorderSide(color: c.full_transparent, width: 0.0),
          borderRadius:BorderRadius.circular(0),
        ),
        focusedBorder: UIHelper.getInputBorder(0, borderColor: c.full_transparent),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 0.0),
          borderRadius: BorderRadius.circular(0), // Increase the radius to adjust the height
        ),
      ),
      initialValue: selectTaxtype,
      iconSize: 28,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(
            errorText: "")
      ]),
      items: taxTypeList.map((item) => DropdownMenuItem(
        value: item[key_taxtypeid].toString(),
        child: Text(
          selectedLang == "en"
              ? item[key_taxtypedesc_en].toString()
              : item[key_taxtypedesc_ta].toString(),
          style: TextStyle(
              fontSize: 11.0,
              fontWeight: FontWeight.w400,
              color: c.black),
        ),
      ))
          .toList(),
      onChanged: (value) async {
        setState(() {
          selectTaxtype = value.toString();
          handleClick(selectTaxtype);
        });

      }, name: 'TaxType',
    );
  }

  Widget payWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: UIHelper.GradientContainer(
          15, 15, 0, 0, [c.colorPrimary, c.colorAccentlight]),
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
