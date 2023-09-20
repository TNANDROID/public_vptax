// ignore_for_file: library_prefixes, prefer_const_constructors_in_immutables, library_private_types_in_public_api, prefer_typing_uninitialized_variables, prefer_const_constructors, avoid_print, deprecated_member_use, use_build_context_synchronously, file_names, non_constant_identifier_names, use_key_in_widget_constructors, prefer_adjacent_string_concatenation, avoid_function_literals_in_foreach_calls

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:public_vptax/Activity/Tax_Collection/AllYourTaxDetails.dart';
import 'package:public_vptax/Activity/Tax_Collection/favourite_list.dart';
import 'package:public_vptax/Layout/screen_size.dart';
import 'package:public_vptax/Layout/ui_helper.dart';
import 'package:public_vptax/Model/startup_model.dart';
import 'package:public_vptax/Resources/ColorsValue.dart' as c;
import 'package:public_vptax/Resources/ImagePath.dart' as imagePath;
import 'package:public_vptax/Resources/StringsKey.dart';
import 'package:public_vptax/Services/Preferenceservices.dart';
import 'package:public_vptax/Services/locator.dart';

class TaxCollectionDetailsWithAdd extends StatefulWidget {
  final selectedTaxTypeData;
  List<dynamic> responseData;
  TaxCollectionDetailsWithAdd({Key? key, this.selectedTaxTypeData, required this.responseData});

  @override
  _TaxCollectionDetailsWithAddState createState() => _TaxCollectionDetailsWithAddState();
}

class _TaxCollectionDetailsWithAddState extends State<TaxCollectionDetailsWithAdd> with TickerProviderStateMixin {
  PreferenceService preferencesService = locator<PreferenceService>();
  ScrollController controller_scroll = ScrollController();
  String selectedLang = "";
  List mainList = [];
  List selectedList = [];

  var selectedTaxTypeData;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    selectedTaxTypeData = widget.selectedTaxTypeData;
    selectedLang = await preferencesService.getUserInfo("lang");
    mainList = widget.responseData;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: c.white,
      appBar: UIHelper.getBar(selectedLang == "en" ? selectedTaxTypeData["taxtypedesc_en"] : selectedTaxTypeData["taxtypedesc_ta"]),
      body: Container(
          color: c.need_improvement2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              UIHelper.verticalSpaceSmall,
              Expanded(
                child: SingleChildScrollView(
                    controller: controller_scroll,
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        Visibility(
                          visible: mainList.isNotEmpty,
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
                              }),
                        ),
                        Visibility(
                          visible: mainList.isEmpty,
                          child: Center(child: Container(margin: EdgeInsets.only(top: 100), child: UIHelper.titleTextStyle("no_record".tr().toString(), c.grey_9, 12, true, true))),
                        )
                      ],
                    )),
              ),
              selectedList.isNotEmpty
                  ? InkWell(
                      onTap: () async {
                        List selectedDataList = [];
                        for (var item in selectedList) {
                          var sendData = {};

                          sendData['user_id'] = await preferencesService.getUserInfo("userId");
                          sendData['mobile'] = await preferencesService.getUserInfo(key_mobile_number);
                          sendData[key_dcode] = mainList[item][key_dcode];
                          sendData[key_bcode] = mainList[item][key_bcode];
                          sendData[key_pvcode] = mainList[item][key_lbcode];
                          sendData[key_taxtypeid] = mainList[item][key_taxtypeid];
                          sendData[key_assessment_no] = mainList[item][key_assessment_no];
                          if (mainList[item][key_taxtypeid] == 4) {
                            sendData[key_fin_year] = item[key_financialyear];
                          }
                          selectedDataList.add(sendData);
                        }
                        var requestJson = {"service_id": "AddfavouriteList", "favourite_assessment_list": selectedDataList};
                        var response = await StartUpViewModel().authendicationServicesAPIcall(context, requestJson);

                        if (response[key_status].toString() == key_success && response[key_response].toString() == key_success) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: c.account_status_green_color,
                            content: Text(
                              response[key_message].toString(),
                              style: TextStyle(color: c.white),
                            ),
                          ));
                          Navigator.pop(context);
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => FavouriteTaxDetails()));
                        }
                        print("response----:)$response");
                      },
                      child: Container(
                          height: 50,
                          width: Screen.width(context),
                          decoration: UIHelper.roundedBorderWithColor(60, 60, 0, 0, c.white, borderColor: c.grey_7, borderWidth: 2),
                          child: Container(
                            margin: EdgeInsets.fromLTRB(3, 3, 3, 0),
                            decoration: UIHelper.roundedBorderWithColor(60, 60, 0, 0, c.colorPrimary),
                            child: Center(child: UIHelper.titleTextStyle("Add to Pay List", c.white, 14, true, true)),
                          )))
                  : SizedBox(),
            ],
          )),
      floatingActionButton: selectedList.isNotEmpty
          ? Container(
              width: 50,
              height: 50,
              decoration: UIHelper.circleWithColorWithShadow(30, c.white, c.white, borderColor: c.grey_7, borderWidth: 5),
              padding: EdgeInsets.all(3),
              child: Container(
                  decoration: UIHelper.circleWithColorWithShadow(30, c.yellow_new, c.colorPrimaryDark),
                  child: Center(child: UIHelper.titleTextStyle(selectedList.length.toString(), c.white, 18, true, true))),
            )
          : SizedBox(),
    );
  }

  Widget headerCardUIWidget(int mainIndex) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          height: 80,
          width: 80,
          decoration: UIHelper.roundedBorderWithColorWithShadow(5, c.colorPrimary, c.colorPrimary, borderWidth: 0),
        ),
        Container(
            width: Screen.width(context),
            margin: EdgeInsets.only(left: 20, top: 5, right: 25),
            padding: EdgeInsets.fromLTRB(10, 10, 10, 15),
            decoration: UIHelper.roundedBorderWithColorWithShadow(5, c.white, c.white, borderWidth: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
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
                          Expanded(
                            child: Flex(
                              direction: Axis.horizontal,
                              children: [Flexible(child: UIHelper.titleTextStyle(mainList[mainIndex][key_name] ?? '', c.grey_9, 12, true, false))],
                            ),
                          ),
                          UIHelper.horizontalSpaceSmall,
                          Container(
                            child: selectedDemandWidget('select_To_Pay', mainIndex),
                          )
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
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                UIHelper.titleTextStyle(getDoorAndStreetName(mainIndex, selectedTaxTypeData['taxtypeid'].toString()), c.grey_8, 11, false, false),
                                UIHelper.titleTextStyle(getvillageAndBlockName(mainIndex, selectedTaxTypeData['taxtypeid'].toString()), c.grey_8, 11, false, false),
                                UIHelper.titleTextStyle(mainList[mainIndex][key_district_name] ?? '', c.grey_8, 11, false, false)
                              ],
                            ),
                          ),
                          UIHelper.horizontalSpaceSmall,
                        ],
                      ),
                      UIHelper.verticalSpaceSmall,
                    ],
                  ),
                ),
                UIHelper.verticalSpaceTiny,
                Container(alignment: Alignment.centerLeft, child: taxWiseReturnDataWidget(mainIndex, c.grey_8)),
              ],
            ))
      ],
    );
  }

  Widget selectedDemandWidget(String title, int mainIndex) {
    return GestureDetector(
        onTap: () {
          if (selectedList.contains(mainIndex)) {
            selectedList.remove(mainIndex);
          } else {
            selectedList.add(mainIndex);
          }
          setState(() {});
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            UIHelper.titleTextStyle(selectedList.contains(mainIndex) ? ("- ${'remove'.tr()}") : ("+ ${'add'.tr()}"), c.text_color, 12, false, true),
            UIHelper.horizontalSpaceSmall,
            Image.asset(
              selectedList.contains(mainIndex) ? imagePath.tick : imagePath.unchecked,
              color: selectedList.contains(mainIndex) ? c.account_status_green_color : c.text_color,
              height: 20,
              width: 20,
            ),
          ],
        ));
  }

  Widget taxWiseReturnDataWidget(int mainIndex, Color clr) {
    return selectedTaxTypeData[key_taxtypeid] == 1
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UIHelper.titleTextStyle(("${'computerRegisterNumber'.tr()} : ${mainList[mainIndex][key_assessment_id].toString() ?? ""}"), clr, 12, false, true),
              UIHelper.verticalSpaceTiny,
              UIHelper.titleTextStyle(("${'building_licence_number'.tr()} : ${mainList[mainIndex][key_building_licence_no].toString() ?? ""}"), clr, 12, false, true),
              UIHelper.verticalSpaceTiny,
              UIHelper.titleTextStyle(("${'assesment_number'.tr()} : ${mainList[mainIndex][key_assessment_no].toString() ?? ""}"), clr, 12, false, true),
              UIHelper.verticalSpaceTiny,
            ],
          )
        : selectedTaxTypeData[key_taxtypeid] == 2
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UIHelper.titleTextStyle(("${'computerRegisterNumber'.tr()} : ${mainList[mainIndex][key_assessment_id].toString() ?? ""}"), clr, 12, false, true),
                  UIHelper.verticalSpaceTiny,
                  UIHelper.titleTextStyle(("${'water_connection_number'.tr()} : ${mainList[mainIndex][key_assessment_no].toString() ?? ""}"), clr, 12, false, true),
                  UIHelper.verticalSpaceTiny,
                ],
              )
            : selectedTaxTypeData[key_taxtypeid] == 4
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UIHelper.titleTextStyle(("${'computerRegisterNumber'.tr()} : ${mainList[mainIndex][key_assessment_id].toString() ?? ""}"), clr, 12, false, true),
                      UIHelper.verticalSpaceTiny,
                      UIHelper.titleTextStyle(("${'financialYear'.tr()} : ${mainList[mainIndex]['financialyear'].toString() ?? ""}"), clr, 12, false, true),
                      UIHelper.verticalSpaceTiny,
                      UIHelper.titleTextStyle(("${'assesment_number'.tr()} : ${mainList[mainIndex][key_assessment_no].toString() ?? ""}"), clr, 12, false, true),
                      UIHelper.verticalSpaceTiny,
                    ],
                  )
                : selectedTaxTypeData[key_taxtypeid] == 5
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          UIHelper.titleTextStyle(("${'computerRegisterNumber'.tr()} : ${mainList[mainIndex][key_assessment_id].toString() ?? ""}"), clr, 12, false, true),
                          UIHelper.verticalSpaceTiny,
                          UIHelper.titleTextStyle(("${'lease_number'.tr()} : ${mainList[mainIndex][key_assessment_no].toString() ?? ""}"), clr, 12, false, true),
                          UIHelper.verticalSpaceTiny,
                          UIHelper.titleTextStyle(("${'lease_state'.tr()} : ${mainList[mainIndex]['lease_statename'].toString() ?? ""}"), clr, 12, false, true),
                          UIHelper.verticalSpaceTiny,
                          UIHelper.titleTextStyle(("${'lease_district'.tr()} : ${mainList[mainIndex]['lease_districtname'].toString() ?? ""}"), clr, 12, false, true),
                          UIHelper.verticalSpaceTiny,
                          UIHelper.titleTextStyle(
                              ("${'lease_duration'.tr()} : ${mainList[mainIndex]['from_date'].toString() ?? ""} - ${mainList[mainIndex]['to_date'].toString() ?? ""}"), clr, 12, false, true),
                          UIHelper.verticalSpaceTiny,
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          UIHelper.titleTextStyle(("${'computerRegisterNumber'.tr()} : ${mainList[mainIndex][key_assessment_id].toString() ?? ""}"), clr, 12, false, true),
                          UIHelper.verticalSpaceTiny,
                          UIHelper.titleTextStyle(("${'traders_code'.tr()} : ${mainList[mainIndex][key_assessment_no].toString() ?? ""}"), clr, 12, false, true),
                          UIHelper.verticalSpaceTiny,
                        ],
                      );
  }

  String getvillageAndBlockName(int mainIndex, String taxTypeId) {
    String street = "";
    street = ((mainList[mainIndex][key_localbody_name] ?? '') + ", " + (mainList[mainIndex][key_bname] ?? ''));
    return street;
  }

  String getDoorAndStreetName(int mainIndex, String taxTypeId) {
    String street = "";
    switch (taxTypeId) {
      case '1':
        street = (mainList[mainIndex][key_door_no] ?? '') + ", " + (selectedLang == 'en' ? (mainList[mainIndex][key_street_name_en] ?? '') : (mainList[mainIndex][key_street_name_ta] ?? ''));
        break;
      case '2':
        street = selectedLang == 'en' ? (mainList[mainIndex]["street_name"] ?? '') : (mainList[mainIndex]["street_name"] ?? '');
        break;
      case '4':
        street = (mainList[mainIndex]['doorno'] ?? '') + ", " + (selectedLang == 'en' ? (mainList[mainIndex]["street_name_t"] ?? '') : (mainList[mainIndex]["street_name_t"] ?? ''));
        break;
      case '5':
        street = (mainList[mainIndex]['doorno'] ?? '') + ", " + (selectedLang == 'en' ? (mainList[mainIndex]["street_name"] ?? '') : (mainList[mainIndex]["street_name"] ?? ''));
        break;
      case '6':
        street = selectedLang == 'en' ? (mainList[mainIndex]["street_name_en"] ?? '') : (mainList[mainIndex]["street_name_ta"] ?? '');
        break;
    }
    return street;
  }
}
