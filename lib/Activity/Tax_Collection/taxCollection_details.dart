import 'package:flutter/material.dart';
import 'package:public_vptax/Layout/screen_size.dart';
import 'package:public_vptax/Layout/ui_helper.dart';
import 'package:public_vptax/Model/startup_model.dart';
import 'package:public_vptax/Resources/ColorsValue.dart' as c;
import 'package:public_vptax/Services/Preferenceservices.dart';
import 'package:public_vptax/Services/locator.dart';
import 'package:stacked/stacked.dart';

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
        decoration: UIHelper.GradientContainer(
            20, 20, 20, 20, [c.colorPrimaryDark, c.colorPrimary]),
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
                          0, 0, 0, 0, [c.colorAccent4, c.followers]),
                      // color: c.white,
                      child: Center(
                        child: UIHelper.titleTextStyle(
                            "1457", c.white, 20, true, true),
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
    int dataWiseHeight = examplePropertyData.length * 40;
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          width: Screen.width(context),
          decoration: UIHelper.GradientContainer(
              15, 15, 0, 0, [c.colorPrimary, c.colorPrimaryDark]),
          child: UIHelper.titleTextStyle(
              "Property Tax Collection", c.grey_8, 18, true, true),
        ),
        propertyTaxRowWidget("Si.\nNo", "Financial Year", "Amount", true),
        Container(
            width: Screen.width(context),
            height: dataWiseHeight + 5,
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: examplePropertyData.length,
              itemBuilder: (context, rowIndex) {
                int siNo = rowIndex + 1;
                return Container(
                    height: 40,
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
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              headerCardUIWidget(),
                              UIHelper.verticalSpaceMedium,
                              propertyTaxCollectionWidget(),
                              UIHelper.verticalSpaceMedium,
                              Container(
                                  decoration:
                                      UIHelper.roundedBorderWithColorWithShadow(
                                          10, c.grey_3, c.grey_3),
                                  padding: EdgeInsets.all(10),
                                  width: Screen.width(context),
                                  child: taxInvoiceWidget()),
                              UIHelper.verticalSpaceMedium,
                              ElevatedButton(
                                  onPressed: () {},
                                  child: UIHelper.titleTextStyle(
                                      "Pay Now", c.white, 16, true, true))
                            ],
                          ),
                        ),
                      ],
                    ));
          },
          viewModelBuilder: () => StartUpViewModel()),
    ));
  }
}
