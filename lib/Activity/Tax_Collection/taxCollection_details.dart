import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:public_vptax/Layout/customclip.dart';
import 'package:public_vptax/Layout/screen_size.dart';
import 'package:public_vptax/Layout/ui_helper.dart';
import 'package:public_vptax/Model/startup_model.dart';
import 'package:public_vptax/Services/Preferenceservices.dart';
import 'package:public_vptax/Services/locator.dart';
import 'package:public_vptax/Resources/ColorsValue.dart' as c;
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

  List<dynamic> examplePropertyData = [
    {"fin_year": "2022-2023", "Amount": "480"},
    {"fin_year": "2023-2024", "Amount": "480"},
    {"fin_year": "2022-2023", "Amount": "480"},
    {"fin_year": "2023-2024", "Amount": "480"},
  ];

  Widget headerTextWidget() {
    return Container(
        width: Screen.width(context),
        padding: EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UIHelper.titleTextStyle("SaravanaKumar", c.white, 20, true, true),
            UIHelper.verticalSpaceMedium,
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.location_on,
                  color: c.white,
                  size: 40,
                ),
                UIHelper.horizontalSpaceSmall,
                UIHelper.titleTextStyle(
                    "54/A, Vadamalappur,\nVadamalappur,\n9a Nathampannai,\nPUDUKKOTTAI.",
                    c.white,
                    15,
                    true,
                    false),
              ],
            ),
            UIHelper.verticalSpaceSmall,
            SizedBox(
                width: Screen.width(context) / 2,
                child: UIHelper.tinyLinewidget(borderColor: c.white)),
            UIHelper.verticalSpaceSmall,
            UIHelper.titleTextStyle(
                "Building Licence Number: 123456", c.white, 14, true, true),
            UIHelper.titleTextStyle(
                "Ward Name : 27 ward", c.white, 14, true, true),
          ],
        ));
  }

  Widget headerCardUIWidget() {
    return Container(
        decoration:
            UIHelper.roundedBorderWithColorWithShadow(20, Colors.blueGrey),
        padding: EdgeInsets.all(12),
        child: Stack(
          children: [
            UIHelper.unEvenContainer(
              15,
              headerTextWidget(),
            ),
            Positioned(
                top:
                    25, // Adjust this value to control the distance from the bottom
                right: 1,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(50.0),
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: UIHelper.GradientContainer(
                          0, 0, 0, 0, [c.colorPrimary, c.colorPrimaryDark]),
                      //  color: c.white,
                      child: Center(
                        child: UIHelper.titleTextStyle(
                            "1457", c.black, 20, true, true),
                      ),
                    ))),
          ],
        ));
  }

  Widget propertyTaxRowWidget(
      String sino, String finyear, String amount, bool isHeading) {
    return Row(
      children: [
        Expanded(
          child: Container(
              height: isHeading ? 60 : null,
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: Center(
                  child: UIHelper.titleTextStyle(
                      sino,
                      isHeading ? c.colorPrimaryDark : c.grey_10,
                      16,
                      isHeading ? true : false,
                      true))),
        ),
        Expanded(
            flex: 3,
            child: Container(
                height: isHeading ? 60 : null,
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: Center(
                    child: UIHelper.titleTextStyle(
                        finyear,
                        isHeading ? c.colorPrimaryDark : c.grey_10,
                        16,
                        isHeading ? true : false,
                        true)))),
        Expanded(
          flex: 2,
          child: Container(
              height: isHeading ? 60 : null,
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: Center(
                  child: UIHelper.titleTextStyle(
                      amount,
                      isHeading ? c.colorPrimaryDark : c.grey_10,
                      16,
                      isHeading ? true : true,
                      true))),
        ),
        Expanded(
          flex: 3,
          child: Container(
              height: isHeading ? 60 : null,
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: Center(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      isHeading
                          ? UIHelper.titleTextStyle(
                              "Select All",
                              isHeading ? c.colorPrimaryDark : c.grey_10,
                              16,
                              isHeading ? true : true,
                              true)
                          : SizedBox(),
                      SizedBox(
                          width: 30,
                          height: 19,
                          child: Checkbox(
                            value: true,
                            onChanged: (v) {
                              // setState(() {
                              //   _onClickFunction(
                              //       index, "Single");
                              // });
                            },
                          ))
                    ]),
              )),
        ),
      ],
    );
  }

  Widget propertyTaxCollectionWidget() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          width: Screen.width(context),
          decoration:
              UIHelper.roundedBorderWithColor(15, 15, 0, 0, c.colorPrimaryDark),
          child: UIHelper.titleTextStyle(
              "Property Tax Collection", c.white, 18, true, true),
        ),
        propertyTaxRowWidget("Si.\nNo", "Financial Year", "Amount", true),
        Container(
            width: Screen.width(context),
            height: Screen.width(context) / 1.5,
            child: ListView.builder(
              itemCount: examplePropertyData.length,
              itemBuilder: (context, rowIndex) {
                int siNo = rowIndex + 1;
                return Container(
                    color:
                        rowIndex % 2 == 0 ? c.blueAccent : Colors.transparent,
                    child: propertyTaxRowWidget(
                        "$siNo",
                        examplePropertyData[rowIndex]['fin_year'],
                        examplePropertyData[rowIndex]['Amount'],
                        false));
              },
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      top: true,
      child: ViewModelBuilder<StartUpViewModel>.reactive(
          builder: (context, model, child) {
            return model.isBusy
                ? CircularProgressIndicator()
                : Container(
                    color: Colors.white,
                    width: Screen.width(context),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        UIHelper.verticalSpaceMedium,
                        Expanded(
                            child: SingleChildScrollView(
                          child: Column(
                            children: [
                              headerCardUIWidget(),
                              UIHelper.verticalSpaceMedium,
                              propertyTaxCollectionWidget(),
                              UIHelper.verticalSpaceMedium,
                            ],
                          ),
                        )),
                      ],
                    ));
          },
          viewModelBuilder: () => StartUpViewModel()),
    ));
  }
}
