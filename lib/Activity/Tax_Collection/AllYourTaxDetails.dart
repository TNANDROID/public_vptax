// ignore_for_file: library_prefixes, prefer_const_constructors_in_immutables, library_private_types_in_public_api, prefer_typing_uninitialized_variables, prefer_const_constructors, avoid_print, deprecated_member_use, use_build_context_synchronously, file_names, non_constant_identifier_names, use_key_in_widget_constructors, prefer_adjacent_string_concatenation, avoid_function_literals_in_foreach_calls

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:public_vptax/Activity/Tax_Collection/taxCollection_view_request_screen.dart';
import 'package:public_vptax/Layout/screen_size.dart';
import 'package:public_vptax/Layout/ui_helper.dart';
import 'package:public_vptax/Model/startup_model.dart';
import 'package:public_vptax/Resources/ColorsValue.dart' as c;
import 'package:public_vptax/Services/Apiservices.dart';
import 'package:public_vptax/Utils/ContentInfo.dart';
import 'package:public_vptax/Utils/utils.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import '../../Resources/StringsKey.dart' as s;
import 'package:public_vptax/Services/Preferenceservices.dart';
import 'package:public_vptax/Services/locator.dart';
import 'package:stacked/stacked.dart';
import 'package:public_vptax/Resources/ImagePath.dart' as imagePath;
import '../../Resources/StringsKey.dart';
import '../Transaction/CheckTransaction.dart';

class AllYourTaxDetails extends StatefulWidget {
  final isHome;
  final selectedTaxTypeData;
  AllYourTaxDetails({this.selectedTaxTypeData, this.isHome});

  @override
  _AllYourTaxDetailsState createState() => _AllYourTaxDetailsState();
}

class _AllYourTaxDetailsState extends State<AllYourTaxDetails> with TickerProviderStateMixin {
  //Animation
  late AnimationController _controller;
  late Animation<double> _animation;
  PreferenceService preferencesService = locator<PreferenceService>();
  dynamic requestJson = {key_service_id: service_key_getAllTaxAssessmentList};
  List isSelectAll = [];
  String selectedLang = "";
  List isShowFlag = [];
  List mainList = [];
  List sourceList = [];
  List taxTypeList = [];
  var selectedTaxTypeData;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    if (widget.isHome) {
      selectedTaxTypeData = widget.selectedTaxTypeData;
    } else {
      dynamic val = {key_taxtypeid: 0, key_taxtypedesc_en: "All Taxes", key_taxtypedesc_ta: "அனைத்து வரிகள்", key_img_path: imagePath.all};
      taxTypeList.add(val);
      taxTypeList.addAll(preferencesService.taxTypeList);
      selectedTaxTypeData = taxTypeList[0];
    }

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
    requestJson[key_mobile_number] = await preferencesService.getUserInfo(key_mobile_number);
    print(">>>" + requestJson[key_mobile_number].toString());
    requestJson[key_language_name] = selectedLang;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  // ********* Main Widget for this Class **********
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: c.white,
        appBar: UIHelper.getBar('tax_details_yours'),
        body: ViewModelBuilder<StartUpViewModel>.reactive(
            onModelReady: (model) async {
              await getAllDemandDetails(context, model);
              setState(() {});
            },
            builder: (context, model, child) {
              return model.isBusy
                  ? Center(child: Container(margin: EdgeInsets.only(top: 30), child: UIHelper.titleTextStyle("no_record".tr().toString(), c.grey_9, 12, true, true)))
                  : Container(
                      color: c.need_improvement2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Visibility(
                                    visible: false,
                                    child: Align(
                                        alignment: Alignment.centerRight,
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => TaxCollectionView(selectedTaxTypeData: selectedTaxTypeData, flag: "3")));
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context).size.width / 2.5,
                                            margin: EdgeInsets.only(top: 10, bottom: 15, left: 15),
                                            decoration: UIHelper.GradientContainer(5, 5, 5, 5, [c.grey_8, c.grey_8]),
                                            padding: EdgeInsets.fromLTRB(5, 8, 0, 8),
                                            child: Row(
                                              // Wrap with Row to add the plus icon
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.add, // Use the icon you prefer (e.g., Icons.add, Icons.add_circle, etc.)
                                                  color: c.white,
                                                  size: 15,
                                                ),
                                                SizedBox(width: 3),
                                                Flexible(
                                                    child: UIHelper.titleTextStyle(
                                                  "new".tr().toString() +
                                                      (selectedLang == "en" ? selectedTaxTypeData["taxtypedesc_en"] : selectedTaxTypeData["taxtypedesc_ta"]) +
                                                      "new2".tr().toString(),
                                                  c.white,
                                                  10,
                                                  true,
                                                  true,
                                                )) // Add a small space between the icon and the text
                                                ,
                                              ],
                                            ),
                                          ),
                                        )),
                                  ),
                                ),
                                Visibility(
                                  visible: !widget.isHome,
                                  child: Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(right: 15),
                                      decoration: UIHelper.roundedBorderWithColorWithShadow(5, c.white, c.white),
                                      child: Row(
                                        children: [
                                          Container(
                                              width: 30,
                                              height: 30,
                                              padding: EdgeInsets.all(5),
                                              decoration: UIHelper.roundedBorderWithColor(5, 5, 5, 5, c.colorPrimary),
                                              child: Image.asset(
                                                selectedTaxTypeData[key_img_path].toString(),
                                                fit: BoxFit.contain,
                                                height: 15,
                                                width: 15,
                                              )),
                                          UIHelper.horizontalSpaceSmall,
                                          Container(width: 100, margin: EdgeInsets.only(left: 5), child: addInputDropdownField()),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: mainList.isNotEmpty,
                            child: Expanded(
                                child: GroupedListView<dynamic, String>(
                              elements: mainList,
                              useStickyGroupSeparators: true,
                              floatingHeader: true,
                              shrinkWrap: true,
                              groupBy: (element) => element[key_taxtypeid].toString(),
                              groupSeparatorBuilder: (element) => stickyHeader(element),
                              indexedItemBuilder: (context, dynamic element, mainIndex) => Container(
                                  margin: EdgeInsets.only(top: 5),
                                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                  child: AnimatedContainer(
                                    padding: EdgeInsets.only(bottom: 5),
                                    duration: const Duration(milliseconds: 500),
                                    child: Container(
                                      padding: EdgeInsets.only(bottom: 5),
                                      width: Screen.width(context),
                                      decoration: BoxDecoration(
                                          color: mainList[mainIndex][key_DEMAND_DETAILS] == "Empty"
                                              ? c.yellow_new
                                              : mainList[mainIndex][key_DEMAND_DETAILS] == "Pending"
                                                  ? c.red_new
                                                  : c.green_new,
                                          borderRadius: BorderRadius.circular(20)),
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            top: 0,
                                            right: 0,
                                            child: Container(
                                              constraints: const BoxConstraints(maxWidth: 130, maxHeight: 80),
                                              decoration: BoxDecoration(
                                                  color: mainList[mainIndex][key_DEMAND_DETAILS] == "Empty"
                                                      ? c.yellow_new_light
                                                      : mainList[mainIndex][key_DEMAND_DETAILS] == "Pending"
                                                          ? c.red_new_light
                                                          : c.light_green_new,
                                                  borderRadius: BorderRadius.circular(20)),
                                            ),
                                          ),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                  margin: const EdgeInsets.all(0),
                                                  child: Container(
                                                      padding: EdgeInsets.fromLTRB(15, 15, 5, 0),
                                                      decoration: BoxDecoration(
                                                        color: c.white,
                                                        borderRadius: BorderRadius.circular(20),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey.withOpacity(0.5), // Shadow color
                                                            spreadRadius: 3, // Spread radius
                                                            blurRadius: 5, // Blur radius
                                                            offset: Offset(3, 3), // Offset from the top-left corner
                                                          ),
                                                        ],
                                                      ),
                                                      width: Screen.width(context) - 40,
                                                      child: headerCardUIWidget(mainIndex, mainList[mainIndex], model))),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                              itemComparator: (item1, item2) => item1[key_assessment_no].compareTo(item2[key_assessment_no]), // optional
                            )),
                          ),
                          Visibility(
                              visible: mainList.isEmpty,
                              child: Expanded(
                                child: Center(child: Container(margin: EdgeInsets.only(top: 30), child: UIHelper.titleTextStyle("no_record".tr().toString(), c.grey_9, 12, true, true))),
                              )),
                        ],
                      ));
            },
            viewModelBuilder: () => StartUpViewModel()));
  }

// *************** Sticky Header Widget ***********
  Widget stickyHeader(var taxTypeId) {
    var TaxList = preferencesService.taxTypeList;
    String TaxHeader = '';
    for (var list in TaxList) {
      if (list[key_taxtypeid].toString() == taxTypeId) {
        TaxHeader = selectedLang == 'en' ? list[key_taxtypedesc_en] : list[key_taxtypedesc_ta];
      }
    }
    int totalCount = mainList.where((item) => item[s.key_taxtypeid] == taxTypeId).length;

    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
      child: Container(
        margin: EdgeInsets.only(left: MediaQuery.of(context).size.width / 4, right: MediaQuery.of(context).size.width / 4),
        padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
        decoration: UIHelper.roundedBorderWithColor(20, 20, 20, 20, c.colorPrimary),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: UIHelper.titleTextStyle(TaxHeader, c.white, 12, true, true)),
            Container(
              width: 25,
              height: 25,
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(color: c.white, border: Border.all(width: 1, color: c.white), borderRadius: BorderRadius.circular(20)),
              child: Center(
                child: UIHelper.titleTextStyle("$totalCount", c.grey_10, 12, true, false),
              ),
            )
          ],
        ),
      ),
    );
  }

// *************** Blue Color Main Card Widget ***********
  Widget headerCardUIWidget(int mainIndex, dynamic getData, StartUpViewModel model) {
    List taxData = [];
    if (getData[key_DEMAND_DETAILS] != "Empty" && getData[key_DEMAND_DETAILS] != "Pending" && getData[key_DEMAND_DETAILS] != "Something Went Wrong" && getData[key_DEMAND_DETAILS] != null) {
      taxData = getData[key_DEMAND_DETAILS];
    }
    return Column(
      children: [
        Stack(
          children: [
            //************************** Basic Details ***************************/

            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UIHelper.verticalSpaceSmall,
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
                    SizedBox(
                      width: Screen.width(context) / 2,
                      child: Flex(
                        direction: Axis.horizontal,
                        children: [Flexible(child: UIHelper.titleTextStyle(getData[s.key_name] ?? '', c.grey_9, 12, true, false))],
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
                      size: 18,
                    ),
                    UIHelper.horizontalSpaceTiny,
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          UIHelper.titleTextStyle(getDoorAndStreetName(getData).trim(), c.grey_9, 12, false, false),
                          UIHelper.titleTextStyle(getvillageAndBlockName(getData).trim(), c.grey_9, 12, false, false),
                          UIHelper.titleTextStyle(getData[s.key_district_name].trim() ?? '', c.grey_9, 12, false, false)
                        ],
                      ),
                    ),
                  ],
                ),
                Container(alignment: Alignment.centerLeft, child: taxWiseReturnDataWidget(getData, c.grey_10)),
                Row(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width / 2,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 0, right: 10),
                        child: UIHelper.titleTextStyle(("${'pending_payment'.tr()} : "), c.grey_10, selectedLang == "ta" ? 13 : 15, true, false)),
                    Container(
                        decoration: UIHelper.GradientContainer(10, 10, 10, 10, [c.need_improvement2, c.need_improvement2]),
                        padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                        width: MediaQuery.of(context).size.width / 3,
                        child: UIHelper.titleTextStyle(("\u{20B9} " + getData['totaldemand']), c.text_color, 16, true, true)),
                  ],
                ),
                UIHelper.verticalSpaceSmall,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Visibility(
                          visible: getData[key_DEMAND_DETAILS] != "Empty" && getData[key_DEMAND_DETAILS] != "Pending",
                          child: Container(
                            alignment: Alignment.topLeft,
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
                              child: Icon(
                                isShowFlag.contains(mainIndex) ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                                size: 30,
                              ),
                            ),
                          )),
                    ),
                    Visibility(
                      visible: !isShowFlag.contains(mainIndex) && getData[key_DEMAND_DETAILS] != "Empty" && getData[key_DEMAND_DETAILS] != "Pending",
                      child: InkWell(
                        onTap: () {
                          isShowFlag.add(mainIndex);
                          for (int i = 0; i < mainList.length; i++) {
                            if (mainList[i][key_DEMAND_DETAILS] != "Empty" && mainList[i][key_DEMAND_DETAILS] != "Pending") {
                              if (i == mainIndex) {
                                for (var item in mainList[i][key_DEMAND_DETAILS]) {
                                  item[s.key_flag] = true;
                                  isSelectAll.add(i);
                                }
                              } else {
                                for (var item in mainList[i][key_DEMAND_DETAILS]) {
                                  item[s.key_flag] = false;
                                  isSelectAll.remove(i);
                                }
                              }
                            }
                          }
                          setState(() {});
                          Utils().settingModalBottomSheet(context, [getData]);
                        },
                        child: Container(
                            margin: EdgeInsets.only(top: 5, right: 0, bottom: 10),
                            decoration: UIHelper.GradientContainer(5, 5, 5, 5, [c.account_status_green_color, c.account_status_green_color]),
                            padding: EdgeInsets.fromLTRB(10, 5, 10, 7),
                            child: UIHelper.titleTextStyle("pay".tr().toString(), c.white, 12, true, true)),
                      ),
                    )
                  ],
                ),
              ],
            ),

            //************************** Down Arrow ***************************/

            //************************** Tax Image ***************************/

            // Visibility(
            //   visible: isShowFlag.contains(mainIndex),
            //   child: Positioned(
            //     right: 0,
            //     child: Container(
            //         padding: const EdgeInsets.all(5),
            //         decoration: UIHelper.roundedBorderWithColorWithShadow(5, c.white, c.white),
            //         child: Image.asset(
            //           getTaxImage(mainIndex),
            //           fit: BoxFit.contain,
            //           height: 40,
            //           width: 40,
            //         )),
            //   ),
            // ),

            //************************** Warning and Danger Logo ***************************/

            /*  Visibility(
              visible: getData[key_DEMAND_DETAILS] == "Empty" || getData[key_DEMAND_DETAILS] == "Pending",
              child: Positioned(
                right: 10,
                child: Container(
                    decoration: UIHelper.roundedBorderWithColorWithShadow(50, c.white, c.white),
                    child: Image.asset(
                      getData[key_DEMAND_DETAILS] == "Empty" ? imagePath.warning_png : imagePath.delete_png,
                      fit: BoxFit.contain,
                      height: 40,
                      width: 40,
                    )),
              ),
            ),*/
            /* Positioned(
              right: 0,
              child: InkWell(
                onTap: () async {
                  await showPopupLocation(getData, model,c.grey_9,context,ContentType.success,"");
                },
                child: Padding(padding: EdgeInsets.only(right: 5), child: Icon(Icons.location_on_sharp, color: c.grey_9, size: 25)),
              ),
            )
*/

            //************************** Proceed To Pay Button ***************************/
          ],
        ),
        UIHelper.verticalSpaceSmall,
        getData[key_DEMAND_DETAILS] == "Empty" || getData[key_DEMAND_DETAILS] == null
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                child: UIHelper.titleTextStyle('no_demand'.tr().toString(), c.warningYellow, 12, true, false),
              )
            : getData[key_DEMAND_DETAILS] == "Pending" || getData[key_DEMAND_DETAILS] == null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                    child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CheckTransaction(),
                          ));
                        },
                        child: UIHelper.titleTextStyle('transaction_warning_hint'.tr().toString(), c.red, 12, true, true)),
                  )
                : AnimatedSize(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.linear,
                    child: Visibility(
                      visible: isShowFlag.contains(mainIndex),
                      child: propertyTaxCollectionWidget(mainIndex, getData),
                    ),
                  ),
      ],
    );
  }

  Future<bool> showlocationPopup(dynamic getData, StartUpViewModel model, Color clr) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Container(
              height: MediaQuery.of(context).size.width / 2,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.location_on,
                        color: c.grey_8,
                        size: 20,
                      ),
                      UIHelper.horizontalSpaceTiny,
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            UIHelper.titleTextStyle(getDoorAndStreetName(getData), c.grey_8, 13, false, false),
                            UIHelper.titleTextStyle(getvillageAndBlockName(getData), c.grey_8, 13, false, false),
                            UIHelper.titleTextStyle(getData[s.key_district_name] ?? '', c.grey_8, 13, false, false)
                          ],
                        ),
                      ),
                      UIHelper.horizontalSpaceSmall,
                    ],
                  ),
                  getData[key_taxtypeid].toString() == "1"
                      ? Container(
                          // margin: EdgeInsets.only(left: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              UIHelper.titleTextStyle(("${'computerRegisterNumber'.tr()} : ${getData[s.key_assessment_id].toString() ?? ""}"), clr, 12, false, true),
                              UIHelper.verticalSpaceTiny,
                              UIHelper.titleTextStyle(("${'building_licence_number'.tr()} : ${getData[s.key_building_licence_no].toString() ?? ""}"), clr, 12, false, true),
                              UIHelper.verticalSpaceTiny,
                              UIHelper.titleTextStyle(("${'assesment_number'.tr()} : ${getData[s.key_assessment_no].toString() ?? ""}"), clr, 12, false, true),
                              UIHelper.verticalSpaceTiny,
                            ],
                          ),
                        )
                      : getData[key_taxtypeid].toString() == "2"
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                UIHelper.titleTextStyle(("${'computerRegisterNumber'.tr()} : ${getData[s.key_assessment_id].toString() ?? ""}"), clr, 12, false, true),
                                UIHelper.verticalSpaceTiny,
                                UIHelper.titleTextStyle(("${'water_connection_number'.tr()} : ${getData[s.key_assessment_no].toString() ?? ""}"), clr, 12, false, true),
                                UIHelper.verticalSpaceTiny,
                              ],
                            )
                          : getData[key_taxtypeid].toString() == "4"
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    UIHelper.titleTextStyle(("${'computerRegisterNumber'.tr()} : ${getData[s.key_assessment_id].toString() ?? ""}"), clr, 12, false, true),
                                    UIHelper.verticalSpaceTiny,
                                    UIHelper.titleTextStyle(("${'financialYear'.tr()} : ${getData['financialyear'].toString() ?? ""}"), clr, 12, false, true),
                                    UIHelper.verticalSpaceTiny,
                                    UIHelper.titleTextStyle(("${'assesment_number'.tr()} : ${getData[s.key_assessment_no].toString() ?? ""}"), clr, 12, false, true),
                                    UIHelper.verticalSpaceTiny,
                                  ],
                                )
                              : getData[key_taxtypeid].toString() == "5"
                                  ? Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        UIHelper.titleTextStyle(("${'computerRegisterNumber'.tr()} : ${getData[s.key_assessment_id].toString() ?? ""}"), clr, 12, false, true),
                                        UIHelper.verticalSpaceTiny,
                                        UIHelper.titleTextStyle(("${'lease_number'.tr()} : ${getData[s.key_assessment_no].toString() ?? ""}"), clr, 12, false, true),
                                        UIHelper.verticalSpaceTiny,
                                        UIHelper.titleTextStyle(("${'lease_state'.tr()} : ${getData['lease_statename'].toString() ?? ""}"), clr, 12, false, true),
                                        UIHelper.verticalSpaceTiny,
                                        UIHelper.titleTextStyle(("${'lease_district'.tr()} : ${getData['lease_districtname'].toString() ?? ""}"), clr, 12, false, true),
                                        UIHelper.verticalSpaceTiny,
                                        UIHelper.titleTextStyle(("${'lease_duration'.tr()} : ${getData['from_date'].toString() ?? ""} - ${getData['to_date'].toString() ?? ""}"), clr, 12, false, true),
                                        UIHelper.verticalSpaceTiny,
                                      ],
                                    )
                                  : Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        UIHelper.titleTextStyle(("${'computerRegisterNumber'.tr()} : ${getData[s.key_assessment_id].toString() ?? ""}"), clr, 12, false, true),
                                        UIHelper.verticalSpaceTiny,
                                        UIHelper.titleTextStyle(("${'traders_code'.tr()} : ${getData[s.key_assessment_no].toString() ?? ""}"), clr, 12, false, true),
                                        UIHelper.verticalSpaceTiny,
                                      ],
                                    )
                ],
              ),
            ),
          ),
        ) ??
        false; //if showDialouge had returned null, then return false
  }

// *************** Village Name Get Widget ***********
  String getvillageAndBlockName(dynamic getData) {
    String street = "";
    street = ((getData[s.key_localbody_name] ?? '') + ", " + (getData[s.key_bname] ?? ''));
    return street;
  }

// *************** Door Number and Street Get Widget ***********
  String getDoorAndStreetName(dynamic getData) {
    String street = "";
    switch (getData[key_taxtypeid].toString()) {
      case '1':
        street = (getData['doorno'] ?? '') + ", " + (selectedLang == 'en' ? (getData[s.key_street_name_en] ?? '') : (getData[s.key_street_name_ta] ?? ''));
        break;
      case '2':
        street = (getData["street_name"] ?? '');
        break;
      case '4':
        street = (getData['doorno'] ?? '') + ", " + (selectedLang == 'en' ? (getData["street_name_t"] ?? '') : (getData["street_name_t"] ?? ''));
        break;
      case '5':
        street = (getData['doorno'] ?? '') + ", " + (selectedLang == 'en' ? (getData["street_name"] ?? '') : (getData["street_name"] ?? ''));
        break;
      case '6':
        street = selectedLang == 'en' ? (getData["street_name_en"] ?? '') : (getData["street_name_ta"] ?? '');
        break;
    }
    return street;
  }

// *************** Tax based  Data Get Widget***********
  Widget taxWiseReturnDataWidget(dynamic getData, Color clr) {
    return getData[key_taxtypeid].toString() == "1"
        ? Container(
            // margin: EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UIHelper.titleTextStyle(("${'computerRegisterNumber'.tr()} : ${getData[s.key_assessment_id].toString() ?? ""}"), clr, 12, false, true),
                UIHelper.verticalSpaceTiny,
                UIHelper.titleTextStyle(("${'assesment_number'.tr()} : ${getData[s.key_assessment_no].toString() ?? ""}"), clr, 12, false, true),
                UIHelper.verticalSpaceTiny,
              ],
            ),
          )
        : getData[key_taxtypeid].toString() == "2"
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UIHelper.titleTextStyle(("${'computerRegisterNumber'.tr()} : ${getData[s.key_assessment_id].toString() ?? ""}"), clr, 12, false, true),
                  UIHelper.verticalSpaceTiny,
                  UIHelper.titleTextStyle(("${'water_connection_number'.tr()} : ${getData[s.key_assessment_no].toString() ?? ""}"), clr, 12, false, true),
                  UIHelper.verticalSpaceTiny,
                ],
              )
            : getData[key_taxtypeid].toString() == "4"
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UIHelper.titleTextStyle(("${'computerRegisterNumber'.tr()} : ${getData[s.key_assessment_id].toString() ?? ""}"), clr, 12, false, true),
                      UIHelper.verticalSpaceTiny,
                      UIHelper.titleTextStyle(("${'financialYear'.tr()} : ${getData['financialyear'].toString() ?? ""}"), clr, 12, false, true),
                      UIHelper.verticalSpaceTiny,
                      UIHelper.titleTextStyle(("${'assesment_number'.tr()} : ${getData[s.key_assessment_no].toString() ?? ""}"), clr, 12, false, true),
                      UIHelper.verticalSpaceTiny,
                    ],
                  )
                : getData[key_taxtypeid].toString() == "5"
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          UIHelper.titleTextStyle(("${'computerRegisterNumber'.tr()} : ${getData[s.key_assessment_id].toString() ?? ""}"), clr, 12, false, true),
                          UIHelper.verticalSpaceTiny,
                          UIHelper.titleTextStyle(("${'lease_number'.tr()} : ${getData[s.key_assessment_no].toString() ?? ""}"), clr, 12, false, true),
                          UIHelper.verticalSpaceTiny,
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          UIHelper.titleTextStyle(("${'computerRegisterNumber'.tr()} : ${getData[s.key_assessment_id].toString() ?? ""}"), clr, 12, false, true),
                          UIHelper.verticalSpaceTiny,
                          UIHelper.titleTextStyle(("${'traders_code'.tr()} : ${getData[s.key_assessment_no].toString() ?? ""}"), clr, 12, false, true),
                          UIHelper.verticalSpaceTiny,
                        ],
                      );
  }

  Widget propertyTaxCollectionWidget(int mainIndex, dynamic demandData) {
    List taxData = demandData[key_DEMAND_DETAILS];
    dynamic calcOfHeight = taxData.length / 2;
    int roundedValueOfHeight = calcOfHeight.ceil();
    double selectedAmount = 0;
    List selectedList = taxData.where((item) => item[s.key_flag] == true).toList();
    for (var taxItem in selectedList) {
      String getAmount = Utils().getDemadAmount(taxItem, demandData[key_taxtypeid]);
      selectedAmount = selectedAmount + double.parse(getAmount);
    }
    demandData[s.key_tax_total] = selectedAmount;

    return Column(
      children: [
        Container(
            margin: EdgeInsets.only(top: 0, bottom: 15, right: 5),
            padding: EdgeInsets.only(top: 5),
            decoration: UIHelper.GradientContainer(5, 5, 5, 5, [c.need_improvement2, c.need_improvement2]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Visibility(
                    visible: taxData.isNotEmpty,
                    child: Row(
                      children: [Expanded(child: selectAllWidget('select_All', mainIndex, taxData))],
                    )),
                UIHelper.verticalSpaceSmall,
                SizedBox(
                    height: roundedValueOfHeight * 72,
                    child: ResponsiveGridList(
                        listViewBuilderOptions: ListViewBuilderOptions(physics: NeverScrollableScrollPhysics()),
                        horizontalGridMargin: 15,
                        verticalGridMargin: 0,
                        minItemWidth: Screen.width(context) / 4,
                        children: List.generate(
                          taxData.length,
                          (index) {
                            String finYearStr = "";
                            if (demandData[key_taxtypeid].toString() == "4") {
                              finYearStr = taxData[index]['financialyear'];
                            } else {
                              finYearStr = taxData[index][key_fin_year];
                            }
                            String durationStr = taxData[index][key_installment_group_name].toString().trim();
                            bool isStatus = taxData[index][s.key_flag] ?? false;
                            return GestureDetector(
                                onTap: () {
                                  for (int i = 0; i < mainList.length; i++) {
                                    if (mainList[i][key_DEMAND_DETAILS] != "Empty" && mainList[i][key_DEMAND_DETAILS] != "Pending") {
                                      if (i != mainIndex) {
                                        isSelectAll.remove(i);
                                        for (var item in mainList[i][key_DEMAND_DETAILS]) {
                                          item[s.key_flag] = false;
                                        }
                                      }
                                    }
                                  }

                                  if (index == 0 || taxData[index - 1][s.key_flag] == true) {
                                    if (taxData[index][key_flag] == true) {
                                      for (int i = 0; i < taxData.length; i++) {
                                        if (i >= index) {
                                          taxData[i][key_flag] = false;
                                        }
                                      }
                                    } else {
                                      taxData[index][key_flag] = true;
                                    }
                                  } else {
                                    Utils().showAlert(context, ContentType.fail, 'pay_pending_year'.tr().toString());
                                  }

                                  int countActiveItems = taxData.where((item) => item[s.key_flag] == true).length;
                                  if (countActiveItems == taxData.length) {
                                    isSelectAll.add(mainIndex);
                                  } else {
                                    isSelectAll.remove(mainIndex);
                                  }
                                  repeatOnce();
                                  setState(() {});
                                },
                                child: Stack(
                                  children: [
                                    Column(
                                      children: [
                                        SizedBox(height: 5),
                                        Container(
                                            padding: EdgeInsets.all(5.0),
                                            decoration: isStatus
                                                ? UIHelper.roundedBorderWithColorWithShadow(5, c.need_improvement, c.need_improvement)
                                                : UIHelper.roundedBorderWithColorWithShadow(5, c.white, c.white),
                                            height: 50,
                                            child: Column(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "$finYearStr ( $durationStr )",
                                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.normal, color: isStatus ? c.white : c.grey_8),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                      padding: EdgeInsets.all(0),
                                                      child: Center(
                                                          child: UIHelper.titleTextStyle("\u{20B9} ${Utils().getDemadAmount(taxData[index], mainList[mainIndex][key_taxtypeid].toString())}",
                                                              isStatus ? c.white : c.grey_10, 12, false, false))),
                                                ),
                                              ],
                                            ))
                                      ],
                                    ),
                                    Positioned(
                                        right: 5,
                                        child: Container(
                                            decoration: isStatus
                                                ? UIHelper.circleWithColorWithShadow(0, c.green_new, c.satisfied, borderColor: c.white, borderWidth: 2)
                                                : UIHelper.circleWithColorWithShadow(0, c.yello, c.unsatisfied1, borderColor: c.white, borderWidth: 2),
                                            height: 14,
                                            width: 14))
                                  ],
                                ));
                          },
                        ))),

                demandCalculationWidget(mainIndex, demandData),
                // Visibility(
                //     visible: swmData.isNotEmpty && mainList[mainIndex][key_taxtypeid].toString() == "1",
                //     child: Column(
                //       children: [
                //         UIHelper.verticalSpaceSmall,
                //         UIHelper.titleTextStyle("swmUserCharges".tr().toString(), c.grey_9, 11, false, true),
                //         UIHelper.verticalSpaceSmall,
                //         Container(
                //             margin: EdgeInsets.only(top: 5),
                //             height: swmHeight + 0.02,
                //             child: ListView.builder(
                //               physics: NeverScrollableScrollPhysics(),
                //               itemCount: swmData.length,
                //               itemBuilder: (context, rowIndex) {
                //                 int siNo = rowIndex + 1;
                //                 return SizedBox(
                //                     height: 30,
                //                     child: Row(
                //                       children: [
                //                         Expanded(
                //                           flex: 1,
                //                           child: Container(padding: EdgeInsets.all(8.0), child: Center(child: UIHelper.titleTextStyle("$siNo", c.grey_8, 12, false, true))),
                //                         ),
                //                         Expanded(
                //                             flex: 3,
                //                             child: Container(padding: EdgeInsets.all(8.0), child: Center(child: UIHelper.titleTextStyle(swmData[rowIndex]['fin_year'], c.grey_8, 12, false, true)))),
                //                         Expanded(
                //                           flex: 2,
                //                           child: Container(
                //                               padding: EdgeInsets.all(8.0),
                //                               child: Center(
                //                                   child: UIHelper.titleTextStyle(Utils().getDemadAmount(swmData[rowIndex], mainList[mainIndex][key_taxtypeid].toString()), c.grey_8, 12, false, true))),
                //                         ),
                //                         rowIndex == 0 || taxData[rowIndex - 1][s.key_flag] == true
                //                             ? Expanded(
                //                                 flex: 1,
                //                                 child: Container(
                //                                     padding: EdgeInsets.all(8.0),
                //                                     child: Center(
                //                                       child: Checkbox(
                //                                         side: BorderSide(width: 1, color: c.grey_6),
                //                                         value: swmData[rowIndex][s.key_flag],
                //                                         onChanged: (v) {
                //                                           if (!getFlagStatus(mainList[mainIndex][key_assessment_id].toString())) {
                //                                             if (rowIndex == 0 || swmData[rowIndex - 1][s.key_flag] == true) {
                //                                               if (swmData[rowIndex][s.key_flag] == true) {
                //                                                 for (int i = 0; i < swmData.length; i++) {
                //                                                   if (i >= rowIndex) {
                //                                                     swmData[i][s.key_flag] = false;
                //                                                     mainList[mainIndex][s.key_swm_total] = mainList[mainIndex][s.key_swm_total] -
                //                                                         double.parse(Utils().getDemadAmount(swmData[i], mainList[mainIndex][key_taxtypeid].toString()));
                //                                                     mainList[mainIndex][s.key_swm_pay] = getTotal(mainList[mainIndex][s.key_swm_total], mainList[mainIndex][s.key_swm_available_advance]);
                //                                                   }
                //                                                 }
                //                                               } else {
                //                                                 swmData[rowIndex][s.key_flag] = true;
                //                                                 mainList[mainIndex][s.key_swm_total] = mainList[mainIndex][s.key_swm_total] +
                //                                                     double.parse(Utils().getDemadAmount(swmData[rowIndex], mainList[mainIndex][key_taxtypeid].toString()));
                //                                                 mainList[mainIndex][s.key_swm_pay] = getTotal(mainList[mainIndex][s.key_swm_total], mainList[mainIndex][s.key_swm_available_advance]);
                //                                               }
                //                                             } else {
                //                                               Utils().showAlert(context, ContentType.fail, 'pay_pending_year'.tr().toString());
                //                                             }
                //                                           } else {
                //                                             Utils().showAlert(context, ContentType.fail, 'pay_previous'.tr().toString());
                //                                           }

                //                                           setState(() {
                //                                             getCount();
                //                                             repeatOnce();
                //                                           });
                //                                         },
                //                                       ),
                //                                     )),
                //                               )
                //                             : Expanded(
                //                                 child: SizedBox(
                //                                 width: 5,
                //                               )),
                //                       ],
                //                     ));
                //               },
                //             )),
                //         UIHelper.verticalSpaceSmall,
                //       ],
                //     )),
              ],
            )),
      ],
    );
  }

  Widget selectAllWidget(String title, int mainIndex, List taxData) {
    return GestureDetector(
        onTap: () {
          //  if (!getFlagStatus(mainList[mainIndex][key_assessment_id].toString())) {
          for (int i = 0; i < mainList.length; i++) {
            if (mainList[i][key_DEMAND_DETAILS] != "Empty" && mainList[i][key_DEMAND_DETAILS] != "Pending") {
              if (i != mainIndex) {
                isSelectAll.remove(i);
                for (var item in mainList[i][key_DEMAND_DETAILS]) {
                  item[s.key_flag] = false;
                }
              }
            }
          }
          if (isSelectAll.contains(mainIndex)) {
            isSelectAll.remove(mainIndex);
            for (var item in taxData) {
              item[s.key_flag] = false;
            }
          } else {
            isSelectAll.add(mainIndex);
            for (var item in taxData) {
              item[s.key_flag] = true;
            }
          }
          // } else {
          //   Utils().showAlert(context, ContentType.fail, 'pay_previous'.tr().toString());
          // }
          repeatOnce();
          setState(() {});
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            UIHelper.titleTextStyle(title.toString().tr(), c.text_color, 12, false, true),
            UIHelper.horizontalSpaceSmall,
            Image.asset(
              isSelectAll.contains(mainIndex) ? imagePath.tick : imagePath.unchecked,
              color: isSelectAll.contains(mainIndex) ? c.account_status_green_color : c.text_color,
              height: 20,
              width: 20,
            ),
            UIHelper.horizontalSpaceSmall,
          ],
        ));
  }

  Widget demandCalculationWidget(int mainIndex, dynamic payableData) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                children: [
                  UIHelper.titleTextStyle('selected'.tr(), c.black, 12, false, false),
                  UIHelper.verticalSpaceTiny,
                  Transform.scale(
                    scale: _animation.value,
                    child: UIHelper.titleTextStyle("\u{20B9} ${payableData[s.key_tax_total].toStringAsFixed(2)}", c.grey_10, 13, true, false),
                  )
                ],
              ),
            ),
            Visibility(
              visible: isShowFlag.contains(mainIndex),
              child: InkWell(
                onTap: () {
                  if (mainList[mainIndex][key_tax_total] > 0) {
                    Utils().settingModalBottomSheet(context, [payableData]);
                  } else {
                    Utils().showAlert(context, ContentType.warning, 'select_demand'.tr().toString());
                  }
                },
                child: Container(
                    margin: EdgeInsets.only(top: 0, right: 10, bottom: 10),
                    decoration: UIHelper.GradientContainer(5, 5, 5, 5, [c.account_status_green_color, c.account_status_green_color]),
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 7),
                    child: UIHelper.titleTextStyle("pay".tr().toString(), c.white, 11, true, true)),
              ),
            ),
          ],
        ),
        UIHelper.verticalSpaceSmall,
      ],
    );
  }

  Widget addInputDropdownField() {
    return FormBuilderDropdown(
      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: c.grey_8),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 0),
        constraints: BoxConstraints(maxHeight: 35),
        hintText: 'select_taxtype'.tr().toString(),
        hintStyle: TextStyle(
          fontSize: 11,
        ),
        filled: true,
        fillColor: c.full_transparent,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: c.full_transparent, width: 0.0),
          borderRadius: BorderRadius.circular(0),
        ),
        focusedBorder: UIHelper.getInputBorder(0, borderColor: c.full_transparent),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 0.0),
          borderRadius: BorderRadius.circular(0), // Increase the radius to adjust the height
        ),
      ),
      initialValue: selectedTaxTypeData,
      iconSize: 28,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: FormBuilderValidators.compose([FormBuilderValidators.required(errorText: "")]),
      items: taxTypeList
          .map((item) => DropdownMenuItem(
                value: item,
                child: Text(
                  selectedLang == "en" ? item[s.key_taxtypedesc_en].toString() : item[s.key_taxtypedesc_ta].toString(),
                  style: TextStyle(fontSize: 11.0, fontWeight: FontWeight.w400, color: c.black),
                ),
              ))
          .toList(),
      onChanged: (value) async {
        isShowFlag = [];
        isSelectAll = [];
        selectedTaxTypeData = value;
        if (selectedTaxTypeData['taxtypeid'].toString() == "0") {
          mainList = sourceList;
        } else {
          mainList = sourceList.where((element) => element[s.key_taxtypeid].toString() == selectedTaxTypeData['taxtypeid'].toString()).toList();
        }
        setState(() {});
      },
      name: 'TaxType',
    );
  }

  String getTaxImage(int typeId) {
    String taxTypeID = mainList[typeId][s.key_taxtypeid].toString();
    List selectedTaxitem = taxTypeList.where((element) => element[s.key_taxtypeid].toString() == taxTypeID).toList();
    return selectedTaxitem[0][s.key_img_path].toString();
  }

  //Auth Service API Call
  Future getAllDemandDetails(BuildContext context, StartUpViewModel model) async {
    if (await Utils().isOnline()) {
      Utils().showProgress(context, 1);
      try {
        var response = await model.demandServicesAPIcall(context, requestJson);
        if (response[key_data] != null && response[key_data].length > 0) {
          List resList = response[key_data].toList();
          resList.sort((a, b) {
            return int.parse(a[key_assessment_no].toString()).compareTo(int.parse(b[key_assessment_no].toString()));
          });
          if (widget.isHome) {
            sourceList = resList.where((item) => item[key_taxtypeid].toString() == selectedTaxTypeData['taxtypeid'].toString() && double.parse(item['totaldemand']) != 0).toList();
          } else {
            sourceList = resList.where((item) => item["is_favourite"] != "Y").toList();
          }
          mainList = sourceList.toList();
          mainList.sort((a, b) {
            return a[key_taxtypeid].toString().compareTo(b[key_taxtypeid].toString());
          });
          for (var item in mainList) {
            dynamic getDemandRequest = {
              key_service_id: service_key_getAssessmentDemandList,
              key_taxtypeid: item[key_taxtypeid],
              key_assessment_id: item[key_assessment_id],
              key_dcode: item[key_dcode],
              key_bcode: item[key_bcode],
              key_pvcode: item[key_lbcode],
              key_language_name: await preferencesService.getUserInfo("lang"),
            };
            if (item[key_taxtypeid] == 4) {
              getDemandRequest[key_fin_year] = item[key_financialyear];
            }
            var getDemandResponce = await model.demandServicesAPIcall(context, getDemandRequest);
            if (getDemandResponce[key_response] == key_fail) {
              if (getDemandResponce[key_message] == "Demand Details Not Found") {
                item[key_DEMAND_DETAILS] = "Empty";
              } else if (getDemandResponce[key_message] == "Your previous transaction is pending. Please try after 60 minutes") {
                item[key_DEMAND_DETAILS] = "Pending";
              } else {
                item[key_DEMAND_DETAILS] = "Something Went Wrong";
              }
            } else {
              if (getDemandResponce[key_data] != null && getDemandResponce[key_data].length > 0) {
                item[key_DEMAND_DETAILS] = getDemandResponce[key_data];
              }
            }
          }
        } else {
          mainList = [];
        }

        Utils().hideProgress(context);
        return "true";
      } catch (error) {
        Utils().hideProgress(context);
        debugPrint('error : $error has been caught');
      }
    } else {
      Utils().showAlert(
        context,
        ContentType.fail,
        "noInternet".tr().toString(),
      );
    }
  }

  bool getFlagStatus(String assId) {
    bool flag = false;
    if (mainList.isNotEmpty) {
      for (var data in mainList) {
        if (data[key_assessment_id].toString() != assId) {
          if (data[s.key_DEMAND_DETAILS] != "Empty" && data[s.key_DEMAND_DETAILS] != "Pending") {
            for (var demanData in data[s.key_DEMAND_DETAILS]) {
              if (demanData[s.key_flag] == true) {
                flag = true;
              }
            }
          }
        }
      }
    }
    return flag;
  }

  Future<void> showPopupLocation(
    dynamic getData,
    StartUpViewModel model,
    Color clr,
    BuildContext mcontext,
    ContentType contentType,
    String message, {
    String? title,
    String? btnCount,
    String? btnText,
    String? btnmsg,
    double? titleFontSize,
    double? messageFontSize,
  }) async {
    await showDialog<void>(
      context: mcontext,
      barrierDismissible: btnCount != null ? false : true, // user must tap button!
      builder: (BuildContext context) {
        // Size
        final size = MediaQuery.of(context).size;

        ContentInfo contentInfo = ContentInfo(title: "Location", assetPath: imagePath.location, color: c.white);

        final hsl = HSLColor.fromColor(contentInfo.color);
        final hslDark = hsl.withLightness((hsl.lightness - 0.1).clamp(0.0, 1.0));

        return WillPopScope(
            onWillPop: () async {
              return btnCount != null ? false : true;
            },
            child: Center(
              child: Container(
                width: size.width,
                height: size.width / 1.3,
                margin: EdgeInsets.symmetric(horizontal: size.width * 0.045),
                decoration: UIHelper.roundedBorderWithColorWithShadow(20, c.white, c.white),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      bottom: 0,
                      left: size.width * 0.001,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                        ),
                        child: SvgPicture.asset(
                          imagePath.bubbles,
                          height: size.height * 0.06,
                          width: size.width * 0.05,
                          color: c.colorPrimary,
                          // colorFilter: getColorFilter(hslDark.toColor(), ui.BlendMode.srcIn),
                        ),
                      ),
                    ),

                    // ***********************  Bubble With Icon *********************** //
                    Positioned(
                      top: -size.height * 0.030,
                      left: size.width * 0.08,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            imagePath.location,
                            color: c.colorPrimary,
                            height: size.height * 0.08,
                            // colorFilter: getColorFilter(hslDark.toColor(), ui.BlendMode.srcIn),
                          ),
                          Positioned(
                            top: size.height * 0.025,
                            child: SvgPicture.asset(
                              contentInfo.assetPath,
                              height: size.height * 0.022,
                            ),
                          )
                        ],
                      ),
                    ),

                    // ***********************  Text Content *********************** //

                    Container(
                      margin: EdgeInsets.only(bottom: size.width * 0.05, left: size.width * 0.05, right: size.width * 0.05, top: size.width * 0.07),
                      child: Container(
                        child: Column(
                          children: [
                            Container(
                              child: Text(
                                "location".tr().toString(),
                                style: TextStyle(
                                  fontSize: 15,
                                  height: 1.5,
                                  color: c.colorPrimaryDark,
                                  decoration: TextDecoration.none,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            UIHelper.verticalSpaceMedium,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: c.grey_9,
                                  size: 20,
                                ),
                                UIHelper.horizontalSpaceTiny,
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      UIHelper.titleTextStyle(getDoorAndStreetName(getData).trim(), c.grey_9, 14, false, false),
                                      UIHelper.titleTextStyle(getvillageAndBlockName(getData).trim(), c.grey_9, 14, false, false),
                                      UIHelper.titleTextStyle(getData[s.key_district_name].trim() ?? '', c.grey_9, 14, false, false)
                                    ],
                                  ),
                                ),
                                UIHelper.horizontalSpaceSmall,
                              ],
                            ),
                            getData[key_taxtypeid].toString() == "1"
                                ? Container(
                                    // margin: EdgeInsets.only(left: 20),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        UIHelper.titleTextStyle(("${'computerRegisterNumber'.tr()} : ${getData[s.key_assessment_id].toString() ?? ""}"), clr, 13, false, true),
                                        UIHelper.verticalSpaceTiny,
                                        UIHelper.titleTextStyle(("${'building_licence_number'.tr()} : ${getData[s.key_building_licence_no].toString() ?? ""}"), clr, 13, false, true),
                                        UIHelper.verticalSpaceTiny,
                                        UIHelper.titleTextStyle(("${'assesment_number'.tr()} : ${getData[s.key_assessment_no].toString() ?? ""}"), clr, 13, false, true),
                                        UIHelper.verticalSpaceTiny,
                                      ],
                                    ),
                                  )
                                : getData[key_taxtypeid].toString() == "2"
                                    ? Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          UIHelper.titleTextStyle(("${'computerRegisterNumber'.tr()} : ${getData[s.key_assessment_id].toString() ?? ""}"), clr, 13, false, true),
                                          UIHelper.verticalSpaceTiny,
                                          UIHelper.titleTextStyle(("${'water_connection_number'.tr()} : ${getData[s.key_assessment_no].toString() ?? ""}"), clr, 13, false, true),
                                          UIHelper.verticalSpaceTiny,
                                        ],
                                      )
                                    : getData[key_taxtypeid].toString() == "4"
                                        ? Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              UIHelper.titleTextStyle(("${'computerRegisterNumber'.tr()} : ${getData[s.key_assessment_id].toString() ?? ""}"), clr, 13, false, true),
                                              UIHelper.verticalSpaceTiny,
                                              UIHelper.titleTextStyle(("${'financialYear'.tr()} : ${getData['financialyear'].toString() ?? ""}"), clr, 12, false, true),
                                              UIHelper.verticalSpaceTiny,
                                              UIHelper.titleTextStyle(("${'assesment_number'.tr()} : ${getData[s.key_assessment_no].toString() ?? ""}"), clr, 12, false, true),
                                              UIHelper.verticalSpaceTiny,
                                            ],
                                          )
                                        : getData[key_taxtypeid].toString() == "5"
                                            ? Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  UIHelper.titleTextStyle(("${'computerRegisterNumber'.tr()} : ${getData[s.key_assessment_id].toString() ?? ""}"), clr, 13, false, true),
                                                  UIHelper.verticalSpaceTiny,
                                                  UIHelper.titleTextStyle(("${'lease_number'.tr()} : ${getData[s.key_assessment_no].toString() ?? ""}"), clr, 13, false, true),
                                                  UIHelper.verticalSpaceTiny,
                                                  UIHelper.titleTextStyle(("${'lease_state'.tr()} : ${getData['lease_statename'].toString() ?? ""}"), clr, 13, false, true),
                                                  UIHelper.verticalSpaceTiny,
                                                  UIHelper.titleTextStyle(("${'lease_district'.tr()} : ${getData['lease_districtname'].toString() ?? ""}"), clr, 13, false, true),
                                                  UIHelper.verticalSpaceTiny,
                                                  UIHelper.titleTextStyle(
                                                      ("${'lease_duration'.tr()} : ${getData['from_date'].toString() ?? ""} - ${getData['to_date'].toString() ?? ""}"), clr, 13, false, true),
                                                  UIHelper.verticalSpaceTiny,
                                                ],
                                              )
                                            : Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  UIHelper.titleTextStyle(("${'computerRegisterNumber'.tr()} : ${getData[s.key_assessment_id].toString() ?? ""}"), clr, 13, false, true),
                                                  UIHelper.verticalSpaceTiny,
                                                  UIHelper.titleTextStyle(("${'traders_code'.tr()} : ${getData[s.key_assessment_no].toString() ?? ""}"), clr, 13, false, true),
                                                  UIHelper.verticalSpaceTiny,
                                                ],
                                              )
                          ],
                        ),
                      ),
                    ),

                    // ***********************  Close Icon button *********************** //

                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () async {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.close_rounded,
                            size: 20,
                            color: c.colorPrimary,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Row(children: [
                        Visibility(
                          visible: true,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            child: ElevatedButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                              },
                              style: ButtonStyle(
                                elevation: MaterialStateProperty.all(5.0),
                                backgroundColor: MaterialStateProperty.all(c.white),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0), // Set the desired border radius here
                                  ),
                                ),
                              ),
                              child: Text(
                                "OK",
                                style: TextStyle(color: c.colorPrimary, fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: btnCount == '2' ? true : false,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: ButtonStyle(
                                elevation: MaterialStateProperty.all(5.0),
                                backgroundColor: MaterialStateProperty.all(c.white),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0), // Set the desired border radius here
                                  ),
                                ),
                              ),
                              child: Text(
                                'Cancel',
                                style: TextStyle(color: contentInfo.color, fontSize: 11),
                              ),
                            ),
                          ),
                        ),
                      ]),
                    )
                  ],
                ),
              ),
            ));
      },
    );
  }
}
