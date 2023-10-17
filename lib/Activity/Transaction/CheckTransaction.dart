// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, non_constant_identifier_names, unnecessary_brace_in_string_interps, use_build_context_synchronously

import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:public_vptax/Layout/screen_size.dart';
import 'package:public_vptax/Model/startup_model.dart';
import 'package:public_vptax/Resources/ColorsValue.dart' as c;
import 'package:public_vptax/Utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Layout/customclip.dart';
import '../../Layout/ui_helper.dart';
import '../../Resources/StringsKey.dart';
import '../../Services/Apiservices.dart';
import '../../Services/Preferenceservices.dart';
import '../../Services/locator.dart';
import '../../Utils/ContentInfo.dart';

class CheckTransaction extends StatefulWidget {
  const CheckTransaction({super.key});

  @override
  State<CheckTransaction> createState() => _CheckTransactionState();
}

class _CheckTransactionState extends State<CheckTransaction> {
  PreferenceService preferencesService = locator<PreferenceService>();
  FS fs = locator<FS>();
  ApiServices apiServices = locator<ApiServices>();
  StartUpViewModel model = StartUpViewModel();

  Utils utils = Utils();
  List defaultWorklist = [];
  List filterList = [];
  String selectedFilter = "All";
  List typeList = [
    {"key": 'All', "title": "all".tr().toString()},
    {"key": 'Success', "title": "success".tr().toString()},
    {"key": 'Pending', "title": "pending".tr().toString()},
    {"key": 'Failed', "title": "failed".tr().toString()}
  ];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    dynamic requestData = {key_service_id: service_key_TransactionHistory, key_mobile_no: await preferencesService.getUserInfo(key_mobile_number), key_email_id: ''};
    Utils().showProgress(context, 1);
    var response = await model.overAllMainService(context, requestData);
    Utils().hideProgress(context);

    if (response[key_status] == key_success && response[key_response] == key_success) {
      defaultWorklist = response[key_data];
      filterList = defaultWorklist.toList();
    } else {
      Utils().showAlert(context, ContentType.warning, response[key_response].toString());
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UIHelper.getBar('payment_transaction_history'.tr().toString()),
      body: SizedBox(
        height: Screen.height(context),
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
                child: Row(children: [
                  Expanded(
                      child: Card(
                          elevation: 5,
                          shadowColor: c.black,
                          color: c.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: FormBuilderTextField(
                            onChanged: (value) {
                              getSearchData(value.toString());
                            },
                            name: 'search',
                            controller: searchController,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.left,
                            decoration: InputDecoration(
                              hintText: 'transaction_id'.tr(),
                              hintStyle: TextStyle(fontSize: 12),
                              filled: true,
                              contentPadding: EdgeInsets.all(10),
                              focusedBorder: UIHelper.getInputBorder(0, borderColor: c.white, radius: 20),
                              enabledBorder: UIHelper.getInputBorder(0, borderColor: c.white, radius: 20),
                              suffixIcon: searchController.text.isNotEmpty
                                  ? GestureDetector(
                                      onTap: () {
                                        searchController.text = "";
                                        Utils().hideSoftKeyBoard(context);
                                        getSearchData("");
                                      },
                                      child: Icon(Icons.highlight_off, color: c.red))
                                  : GestureDetector(onTap: () {}, child: Icon(Icons.search, color: c.helpBlue)),
                              fillColor: c.white,
                            ),
                            style: TextStyle(fontSize: fs.h3),
                          ))),
                  // SizedBox(width: 20),
                  // PopupMenuButton<dynamic>(
                  //   color: c.white,
                  //   child: Container(margin: EdgeInsets.only(right: 10), child: Icon(Icons.menu_outlined, color: c.black)),
                  //   onSelected: (value) {
                  //     getFilterData(value.toString());
                  //   },
                  //   itemBuilder: (BuildContext context) {
                  //     return typeList
                  //         .map((item) => PopupMenuItem(
                  //               value: item["key"],
                  //               child: Text(
                  //                 item["title"],
                  //                 style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: c.text_color),
                  //                 overflow: TextOverflow.ellipsis,
                  //               ),
                  //             ))
                  //         .toList();
                  //   },
                  // ),
                ])),
            SizedBox(
              width: Screen.width(context) * 0.95,
              height: 75,
              child: Card(
                elevation: 5,
                shadowColor: c.black,
                color: c.white,
                margin: EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [TabBar('Success'), TabBar('Pending'), TabBar('Failed')],
                ),
              ),
            ),
            Expanded(
                child: SingleChildScrollView(
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: filterList.length,
                  itemBuilder: (context, mainIndex) {
                    var item = filterList[mainIndex];
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                      child: buildTransactionStatusCard(item),
                    );
                  }),
            )),
          ],
        ),
      ),
    );
  }

  Expanded TabBar(String type) {
    String headerText = '';
    Color bgColor;
    if (type == 'Success') {
      headerText = "success".tr();
      bgColor = c.light_green_new;
    } else if (type == 'Pending') {
      headerText = "pending".tr();
      bgColor = c.yellow_new_light;
    } else {
      headerText = "failed".tr();
      bgColor = c.red_new_light;
    }
    return Expanded(
      flex: 1,
      child: Container(
        decoration: BoxDecoration(
          color: selectedFilter == type ? bgColor : null,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: TextButton(
            onPressed: () {
              selectedFilter = type;
              getFilterData(type);
            },
            style: ButtonStyle(
              shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: type == 'Failed'
                      ? BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: c.red_new,
                            width: 1,
                          ),
                        )
                      : null,
                  child: Icon(
                    type == 'Success'
                        ? Icons.check_circle_outline_rounded
                        : type == 'Failed'
                            ? Icons.clear
                            : Icons.error_outline_rounded,
                    size: type == 'Failed' ? 10 : 15,
                    color: type == 'Success'
                        ? c.green_new
                        : type == 'Failed'
                            ? c.red_new
                            : c.warningYellow,
                  ),
                ),
                SizedBox(width: 3),
                Flexible(
                  child: Text(
                    headerText,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(color: c.text_color, fontSize: fs.h5),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Stack buildTransactionStatusCard(var item) {
    String headerText = '';

    String status = item[key_transaction_status] ?? '';
    String transID = item[key_transaction_id].toString();
    String transDate = item[key_transaction_date];
    String transAmount = item[key_res_paid_amount].toString();
    String taxTypeID = item[key_taxtypeid].toString();

    Color cardColorPrimary;
    Color cardColorPrimaryDark;
    Color cardColorSecondary;

    if (status == 'SUCCESS') {
      cardColorPrimary = c.green_new;
      cardColorSecondary = c.light_green;
      cardColorPrimaryDark = c.successGreen;
      headerText = "success".tr();
    } else if (status == 'PENDING' || status == '') {
      cardColorPrimary = c.warningYellow;
      cardColorSecondary = c.yellow_new_light;
      cardColorPrimaryDark = c.yellow_new;
      headerText = "pending".tr();
    } else {
      cardColorPrimary = c.red_new;
      cardColorSecondary = c.red_new_light;
      cardColorPrimaryDark = c.red_new_dark;
      headerText = "failed".tr();
    }

    return Stack(
      children: [
        Card(
          elevation: 5,
          shadowColor: cardColorPrimary,
          color: cardColorSecondary,
          margin: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: SizedBox(
            height: 150,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: Screen.width(context) * 0.15),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text("${"transaction_id".tr().toString()} :", style: TextStyle(fontSize: fs.h5, color: c.black)),
                            Text(transID, style: TextStyle(fontSize: fs.h4, color: c.text_color)),
                          ],
                        ),
                        Row(
                          children: [
                            Text("${"transaction_date".tr().toString()} :", style: TextStyle(fontSize: fs.h5, color: c.black)),
                            Text(transDate, style: TextStyle(fontSize: fs.h4, color: c.text_color)),
                          ],
                        ),
                        Row(
                          children: [
                            Text("${"transaction_amount".tr().toString()} :", style: TextStyle(fontSize: fs.h5, color: c.black)),
                            Text("\u{20B9} ${transAmount}", style: TextStyle(fontSize: fs.h4, color: c.text_color)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: status == 'FAILED' ? MainAxisAlignment.end : MainAxisAlignment.spaceBetween,
                        children: [
                          status == 'FAILED'
                              ? SizedBox(
                                  width: 150,
                                  height: 30,
                                )
                              : ElevatedButton(
                                  onPressed: () {
                                    checkReceiptStatus(status, transID, preferencesService.selectedLanguage, taxTypeID, context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: Size(160, 30),
                                    backgroundColor: cardColorPrimary,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      status == 'SUCCESS'
                                          ? Icon(
                                              Icons.download_rounded,
                                              color: c.white,
                                              size: preferencesService.selectedLanguage == 'ta' ? 16 : 18,
                                            )
                                          : SizedBox(),
                                      Text(
                                        status == 'SUCCESS' ? 'download_receipt'.tr() : 'check_status'.tr(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: fs.h5, color: c.white, fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            decoration: status == 'FAILED'
                                ? BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: cardColorPrimary,
                                      width: 1.5,
                                    ),
                                  )
                                : null,
                            child: Icon(
                              status == 'SUCCESS'
                                  ? Icons.check_circle_outline_rounded
                                  : status == 'FAILED'
                                      ? Icons.clear
                                      : Icons.error_outline_rounded,
                              color: cardColorPrimary,
                              size: status == 'FAILED' ? 11 : 15,
                            ),
                          ),
                          SizedBox(width: 5),
                          // Add some spacing between the icon and text
                          Text(
                            headerText,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(fontSize: fs.h5, color: c.text_color, fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Positioned(
          left: 30,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(children: [
                Container(
                  transform: Matrix4.translationValues(0.0, 1.0, 0.0),
                  width: 25,
                  height: 50,
                  decoration: UIHelper.GradientContainer(10, 0, 0, 0, [cardColorPrimary, cardColorPrimary]),
                  child: Center(child: UIHelper.titleTextStyle('', c.white, 18, true, true)),
                ),
                ClipPath(
                  clipper: BottomTriangleClipper(),
                  child: Container(
                    width: 40,
                    height: 20,
                    color: cardColorPrimary,
                    //   decoration: UIHelper.roundedBorderWithColorWithShadow(5, c.colorPrimary, c.colorPrimary, borderWidth: 0),
                  ),
                )
              ]),
              Container(
                  margin: EdgeInsets.only(left: 7.5, top: 1),
                  transform: Matrix4.translationValues(-15.0, 0.0, 0.0),
                  child: ClipPath(
                    clipper: RightTriangleClipper1(),
                    child: Container(
                      width: 10,
                      height: 8.5,
                      color: cardColorPrimaryDark,
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }

  getFilterData(String type) {
    print("$type");
    if (type == "Pending") {
      filterList = defaultWorklist.where((item) => item[key_transaction_status] != "SUCCESS" && item[key_transaction_status] != "FAILED").toList();
    } else if (type == "All") {
      filterList = defaultWorklist.toList();
    } else {
      filterList = defaultWorklist.where((item) => item[key_transaction_status].toString().toLowerCase() == type.toLowerCase()).toList();
    }
    setState(() {});
  }

  getSearchData(String value) {
    filterList = defaultWorklist.where((item) {
      return item[key_transaction_id].toString().startsWith(value);
    }).toList();
    setState(() {});
  }

  Future<void> checkReceiptStatus(String flag, String transID, String lang, String taxType, BuildContext context) async {
    if (flag == "SUCCESS") {
      String urlParams = "taxtypeid=${base64Encode(utf8.encode(taxType))}&transaction_id=${base64Encode(utf8.encode(transID))}&language_name=${base64Encode(utf8.encode(lang))}";

      String key = preferencesService.userPassKey;

      String Signature = utils.generateHmacSha256(urlParams, key, true);

      String encodedParams = "${ApiServices().pdfURL}?$urlParams&sign=$Signature";

      await launch(encodedParams.toString());
    } else {
      Utils().showProgress(context, 1);
      var requestData = {key_service_id: service_key_CheckTransaction, key_transaction_id: transID, key_language_name: lang};
      var response = await model.overAllMainService(context, requestData);
      await model.getDemandList(context);

      Utils().hideProgress(context);
      if (response[key_status] == key_success && response[key_response] == key_success) {
        Utils().showAlert(context, ContentType.help, '${response[key_message]}');

        initialize();
      }
    }
  }
}
