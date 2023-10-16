// ignore_for_file: library_prefixes, prefer_const_constructors_in_immutables, library_private_types_in_public_api, prefer_typing_uninitialized_variables, prefer_const_constructors, avoid_print, deprecated_member_use, use_build_context_synchronously, file_names, non_constant_identifier_names, use_key_in_widget_constructors, prefer_adjacent_string_concatenation, avoid_function_literals_in_foreach_calls

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:public_vptax/Activity/Tax_Collection/taxCollection_view_request_screen.dart';
import 'package:public_vptax/Layout/screen_size.dart';
import 'package:public_vptax/Layout/ui_helper.dart';
import 'package:public_vptax/Model/startup_model.dart';
import 'package:public_vptax/Resources/ColorsValue.dart' as c;
import 'package:public_vptax/Resources/ImagePath.dart' as imagePath;
import 'package:public_vptax/Resources/StringsKey.dart';
import 'package:public_vptax/Services/Preferenceservices.dart';
import 'package:public_vptax/Services/locator.dart';
import 'package:public_vptax/Utils/ContentInfo.dart';
import 'package:public_vptax/Utils/utils.dart';
import 'package:public_vptax/stream/extended_asyncwidgets.dart';
import 'package:stacked/stacked.dart';

class FavouriteTaxDetails extends StatefulWidget {
  FavouriteTaxDetails({Key? key});

  @override
  _FavouriteTaxDetailsState createState() => _FavouriteTaxDetailsState();
}

class _FavouriteTaxDetailsState extends State<FavouriteTaxDetails> with TickerProviderStateMixin {
  PreferenceService preferencesService = locator<PreferenceService>();
  FS fs = locator<FS>();
  List mainList = [];
  List taxTypeList = [];
  var selectedTaxTypeData;
  Utils utils = Utils();

  @override
  void initState() {
    super.initState();

    dynamic val = {key_taxtypeid: 0, key_taxtypedesc_en: "All Taxes", key_taxtypedesc_ta: "அனைத்து வரிகள்", key_img_path: imagePath.all};
    taxTypeList.add(val);
    taxTypeList.addAll(preferencesService.taxTypeList);
    selectedTaxTypeData = taxTypeList[0];
  }

  // ********* Main Widget for this Class **********
  @override
  Widget build(BuildContext mcontext) {
    return Scaffold(
      backgroundColor: c.white,
      appBar: UIHelper.getBar('addedList'),
      body: ViewModelBuilder<StartUpViewModel>.reactive(
          onModelReady: (model) async {},
          builder: (context, model, child) {
            return Container(
                color: c.need_improvement2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    UIHelper.verticalSpaceSmall,
                    StreamedWidget<List<dynamic>?>(
                        stream: preferencesService.taxListStream!.outStream!,
                        builder: (context, snapshot) {
                          mainList = preferencesService.taxListStream!.value!.where((item) => item["is_favourite"] == "Y").toList();
                          double marginSpace = Screen.width(context) / 4;
                          return mainList.isNotEmpty
                              ? Expanded(
                                  child: GroupedListView<dynamic, String>(
                                  elements: mainList,
                                  useStickyGroupSeparators: true,
                                  floatingHeader: true,
                                  shrinkWrap: true,
                                  groupBy: (element) => element[key_taxtypeid].toString(),
                                  groupSeparatorBuilder: (element) => UIHelper.stickyHeader(element, preferencesService.selectedLanguage, mainList, marginSpace),
                                  indexedItemBuilder: (context, dynamic element, mainIndex) =>
                                      Container(margin: EdgeInsets.fromLTRB(15, 5, 15, 5), child: headerCardUIWidget(mcontext, mainIndex, mainList[mainIndex], model)),
                                  itemComparator: (item1, item2) => item1[key_assessment_no].compareTo(item2[key_assessment_no]), // optional
                                ))
                              : Expanded(
                                  child: Center(child: Container(margin: EdgeInsets.only(top: 30), child: UIHelper.titleTextStyle("no_record".tr().toString(), c.grey_9, fs.h4, true, true))),
                                );
                        }),
                  ],
                ));
          },
          viewModelBuilder: () => StartUpViewModel()),
      floatingActionButton: GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => TaxCollectionView(selectedTaxTypeData: selectedTaxTypeData, flag: "3")));
          },
          child: Container(
            width: 50,
            height: 50,
            decoration: UIHelper.circleWithColorWithShadow(30, c.white, c.white, borderColor: c.grey_7, borderWidth: 5),
            padding: EdgeInsets.all(3),
            child: Container(decoration: UIHelper.circleWithColorWithShadow(30, c.colorPrimary, c.colorPrimaryDark), child: Center(child: UIHelper.titleTextStyle("+", c.white, fs.h1, true, true))),
          )),
    );
  }

// *************** Blue Color Main Card Widget ***********
  Widget headerCardUIWidget(BuildContext mcontext, int mainIndex, dynamic getData, StartUpViewModel model) {
    return Container(
        decoration: BoxDecoration(
          color: c.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(width: 2, color: c.grey_5),
          boxShadow: [
            BoxShadow(
              color: c.grey_4,
              spreadRadius: 3, // Spread radius
              blurRadius: 5, // Blur radius
              offset: Offset(3, 3), // Offset from the top-left corner
            ),
          ],
        ),
        child: Column(
          children: [
            Stack(
              children: [
                //************************** Basic Details ***************************/

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                            transform: Matrix4.translationValues(0.0, -2, 0.0),
                            padding: const EdgeInsets.all(5),
                            margin: EdgeInsets.only(left: 15),
                            decoration: UIHelper.roundedBorderWithColor(5, 5, 100, 100, c.grey_3, borderColor: c.grey_5, borderWidth: 2),
                            child: Image.asset(
                              getTaxImage(mainIndex),
                              fit: BoxFit.contain,
                              height: 35,
                              width: 35,
                            )),
                        UIHelper.horizontalSpaceSmall,
                        Flexible(child: UIHelper.titleTextStyle(getData[key_name] ?? '', c.grey_9, fs.h4, true, false))
                      ],
                    ),
                    UIHelper.verticalSpaceTiny,
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      child: Utils().taxWiseReturnDataWidget(getData, c.grey_8),
                    )
                  ],
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: InkWell(
                    onTap: () async {
                      await showPopupLocation(getData, model, c.grey_9, context, ContentType.success, "");
                    },
                    child: Padding(padding: EdgeInsets.only(right: 5), child: Icon(Icons.location_on_sharp, color: c.grey_8, size: 25)),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: InkWell(
                    onTap: () async {
                      await showRemovePopup(mcontext, getData, model);
                    },
                    child: Padding(padding: EdgeInsets.only(right: 5, top: 10), child: Icon(Icons.delete, color: c.red, size: 25)),
                  ),
                )
              ],
            ),
            UIHelper.verticalSpaceSmall,
          ],
        ));
  }

// ********** App Exit and Logout Widget ***********\\
  Future<bool> showRemovePopup(BuildContext mccontext, dynamic getData, StartUpViewModel model) async {
    return await showDialog(
          context: mccontext,
          builder: (context) => AlertDialog(
            content: UIHelper.titleTextStyle('assessment_remove'.tr().toString(), c.black, fs.h4, false, false),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  'no'.tr().toString(),
                  style: TextStyle(fontSize: fs.h4),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop(false);
                  Utils().showProgress(mccontext, 1);
                  var requestJson = {key_service_id: service_key_RemovefavouriteList, key_user_id: getData['user_id'], key_favourite_assessment_id: getData['favourite_assessment_id']};
                  await model.overAllMainService(context, requestJson);
                  await model.getDemandList(mccontext);
                  Utils().hideProgress(mccontext);
                },
                child: Text(
                  'yes'.tr().toString(),
                  style: TextStyle(fontSize: fs.h4),
                ),
              ),
            ],
          ),
        ) ??
        false; //if showDialouge had returned null, then return false
  }

// *************** Tax based Image Render Widget***********
  String getTaxImage(int typeId) {
    String taxTypeID = mainList[typeId][key_taxtypeid].toString();
    List selectedTaxitem = taxTypeList.where((element) => element[key_taxtypeid].toString() == taxTypeID).toList();
    return selectedTaxitem[0][key_img_path].toString();
  }

// *************** Location Popup***********
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
                      left: 0,
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
                      child: Image.asset(
                        imagePath.location,
                        color: c.colorPrimary,
                        height: size.height * 0.08,
                      ),
                    ),

                    // ***********************  Text Content *********************** //

                    Container(
                      margin: EdgeInsets.only(bottom: size.width * 0.05, left: size.width * 0.05, right: size.width * 0.05, top: size.width * 0.07),
                      child: Column(
                        children: [
                          Text(
                            "location".tr().toString(),
                            style: TextStyle(
                              fontSize: fs.h3,
                              height: 1.5,
                              color: c.colorPrimaryDark,
                              decoration: TextDecoration.none,
                            ),
                            textAlign: TextAlign.center,
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
                                    UIHelper.titleTextStyle(Utils().getDoorAndStreetName(getData, preferencesService.selectedLanguage).trim(), c.grey_9, fs.h4, false, false),
                                    UIHelper.titleTextStyle(Utils().getvillageAndBlockName(getData).trim(), c.grey_9, fs.h4, false, false),
                                    UIHelper.titleTextStyle(getData[key_district_name].trim() ?? '', c.grey_9, fs.h4, false, false)
                                  ],
                                ),
                              ),
                              UIHelper.horizontalSpaceSmall,
                            ],
                          ),
                          UIHelper.verticalSpaceMedium,
                          getData[key_taxtypeid].toString() == "1"
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    UIHelper.titleTextStyle(("${'computerRegisterNumber'.tr()} : ${getData[key_assessment_id].toString()}"), clr, fs.h4, false, true),
                                    UIHelper.verticalSpaceTiny,
                                    UIHelper.titleTextStyle(("${'building_licence_number'.tr()} : ${getData[key_building_licence_no].toString()}"), clr, fs.h4, false, true),
                                    UIHelper.verticalSpaceTiny,
                                    UIHelper.titleTextStyle(("${'assesment_number'.tr()} : ${getData[key_assessment_no].toString()}"), clr, fs.h4, false, true),
                                    UIHelper.verticalSpaceTiny,
                                  ],
                                )
                              : getData[key_taxtypeid].toString() == "2"
                                  ? Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        UIHelper.titleTextStyle(("${'computerRegisterNumber'.tr()} : ${getData[key_assessment_id].toString()}"), clr, fs.h4, false, true),
                                        UIHelper.verticalSpaceTiny,
                                        UIHelper.titleTextStyle(("${'water_connection_number'.tr()} : ${getData[key_assessment_no].toString()}"), clr, fs.h4, false, true),
                                        UIHelper.verticalSpaceTiny,
                                      ],
                                    )
                                  : getData[key_taxtypeid].toString() == "4"
                                      ? Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            UIHelper.titleTextStyle(("${'computerRegisterNumber'.tr()} : ${getData[key_assessment_id].toString()}"), clr, fs.h4, false, true),
                                            UIHelper.verticalSpaceTiny,
                                            UIHelper.titleTextStyle(("${'financialYear'.tr()} : ${getData['financialyear'].toString()}"), clr, fs.h4, false, true),
                                            UIHelper.verticalSpaceTiny,
                                            UIHelper.titleTextStyle(("${'assesment_number'.tr()} : ${getData[key_assessment_no].toString()}"), clr, fs.h4, false, true),
                                            UIHelper.verticalSpaceTiny,
                                          ],
                                        )
                                      : getData[key_taxtypeid].toString() == "5"
                                          ? Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                UIHelper.titleTextStyle(("${'computerRegisterNumber'.tr()} : ${getData[key_assessment_id].toString()}"), clr, fs.h4, false, true),
                                                UIHelper.verticalSpaceTiny,
                                                UIHelper.titleTextStyle(("${'lease_number'.tr()} : ${getData[key_assessment_no].toString()}"), clr, fs.h4, false, true),
                                                UIHelper.verticalSpaceTiny,
                                                UIHelper.titleTextStyle(("${'lease_state'.tr()} : ${getData['lease_statename'].toString()}"), clr, fs.h4, false, true),
                                                UIHelper.verticalSpaceTiny,
                                                UIHelper.titleTextStyle(("${'lease_district'.tr()} : ${getData['lease_districtname'].toString()}"), clr, fs.h4, false, true),
                                                UIHelper.verticalSpaceTiny,
                                                UIHelper.titleTextStyle(("${'lease_duration'.tr()} : ${getData['from_date'].toString()} - ${getData['to_date'].toString()}"), clr, fs.h4, false, true),
                                                UIHelper.verticalSpaceTiny,
                                              ],
                                            )
                                          : Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                UIHelper.titleTextStyle(("${'computerRegisterNumber'.tr()} : ${getData[key_assessment_id].toString()}"), clr, fs.h4, false, true),
                                                UIHelper.verticalSpaceTiny,
                                                UIHelper.titleTextStyle(("${'traders_code'.tr()} : ${getData[key_assessment_no].toString()}"), clr, fs.h4, false, true),
                                                UIHelper.verticalSpaceTiny,
                                              ],
                                            )
                        ],
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
                                style: TextStyle(color: c.colorPrimary, fontSize: fs.h4, fontWeight: FontWeight.w500),
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
