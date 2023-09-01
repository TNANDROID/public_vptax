// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, non_constant_identifier_names, unnecessary_brace_in_string_interps, use_build_context_synchronously

import 'dart:convert';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:public_vptax/Layout/screen_size.dart';
import 'package:public_vptax/Model/startup_model.dart';
import 'package:public_vptax/Model/startup_model.dart';
import 'package:public_vptax/Resources/ColorsValue.dart' as c;
import 'package:public_vptax/Resources/ImagePath.dart';
import 'package:public_vptax/Utils/ContentInfo.dart';
import 'package:public_vptax/Utils/utils.dart';
import '../../Layout/customclip.dart';
import '../../Layout/ui_helper.dart';
import '../../Resources/StringsKey.dart';
import '../../Services/Apiservices.dart';
import '../../Services/Preferenceservices.dart';
import '../../Services/locator.dart';
import '../../Layout/Pdf_Viewer.dart';

class CheckTransaction extends StatefulWidget {
  final mobileNumber;
  final emailID;
  const CheckTransaction({super.key, this.mobileNumber, this.emailID});

  @override
  State<CheckTransaction> createState() => _CheckTransactionState();
}

class _CheckTransactionState extends State<CheckTransaction> {
  PreferenceService preferencesService = locator<PreferenceService>();
  ApiServices apiServices = locator<ApiServices>();
  StartUpViewModel model = StartUpViewModel();

  List successList = [];
  List failureList = [];
  List pendingList = [];
  List defaultWorklist = [];

  Iterable filteredWorklist = [];

  int statusFlag = 0;

  String _searchQuery = '';
  String selectLang = '';

  bool searchEnable = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initialize();
  }

  onSearchQueryChanged() {
    _searchQuery = searchController.text.toLowerCase();

    filteredWorklist = defaultWorklist.where((item) {
      final trans_id = item[key_transaction_id].toString();
      return trans_id.contains(_searchQuery);
    });
    setState(() {});
  }

  Future<void> initialize() async {
    defaultWorklist = preferencesService.TransactionList;
    selectLang = await preferencesService.getUserInfo('lang');
    FilterList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    'payment_transaction_history'.tr().toString(),
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SizedBox(
        height: Screen.height(context),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            SingleChildScrollView(
                child: Container(
              margin: EdgeInsets.only(top: Screen.width(context) * 0.35),
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: searchEnable ? filteredWorklist.length : defaultWorklist.length,
                  itemBuilder: (context, mainIndex) {
                    var item = searchEnable ? filteredWorklist.elementAt(mainIndex) : defaultWorklist[mainIndex];
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                      child: buildTransactionStatusCard(item),
                    );
                  }),
            )),
            Positioned(
              top: Screen.width(context) * 0.15,
              child: SizedBox(
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
                    children: [
                      Expanded(
                          child: FormBuilderTextField(
                        onChanged: (value) {
                          if (value == '') {
                            searchEnable = false;
                          }
                          setState(() {});
                        },
                        name: 'search',
                        controller: searchController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          hintText: 'transaction_id'.tr(),
                          hintStyle: TextStyle(fontSize: 11),
                          filled: true,
                          contentPadding: EdgeInsets.all(10),
                          focusedBorder: UIHelper.getInputBorder(0, borderColor: c.white, radius: 20),
                          enabledBorder: UIHelper.getInputBorder(0, borderColor: c.white, radius: 20),
                          fillColor: c.white,
                        ),
                        style: TextStyle(fontSize: 13),
                      )),
                      IconButton(
                        icon: Icon(
                          Icons.search,
                          color: c.helpBlue,
                        ),
                        onPressed: () {
                          Utils().hideSoftKeyBoard(context);
                          if (searchController.text.isNotEmpty) {
                            searchEnable = true;
                            onSearchQueryChanged();
                          } else {
                            searchEnable = false;
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              child: SizedBox(
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
                    children: [
                      TabBar('Success', () {
                        statusFlag = 1;
                        defaultWorklist = successList;
                        setState(() {});
                      }, statusFlag == 1 ? true : false),
                      TabBar('Pending', () {
                        defaultWorklist = pendingList;
                        statusFlag = 2;
                        setState(() {});
                      }, statusFlag == 2 ? true : false),
                      TabBar('Failed', () {
                        defaultWorklist = failureList;
                        statusFlag = 3;
                        setState(() {});
                      }, statusFlag == 3 ? true : false)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Expanded TabBar(String type, Function onPressed, bool isActive) {
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
          color: isActive ? bgColor : null,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: TextButton(
            onPressed: () {
              onPressed();
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
                    style: TextStyle(color: c.text_color, fontSize: selectLang == 'ta' ? 10 : 13),
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
                            Text(
                              "${"transaction_id".tr().toString()} :",
                              style: TextStyle(fontSize: 12, color: c.black),
                            ),
                            Text(
                              transID,
                              style: TextStyle(fontSize: 12, color: c.text_color),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "${"transaction_date".tr().toString()} :",
                              style: TextStyle(fontSize: 12, color: c.black),
                            ),
                            Text(
                              transDate,
                              style: TextStyle(fontSize: 12, color: c.text_color),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "${"transaction_amount".tr().toString()} :",
                              style: TextStyle(fontSize: 12, color: c.black),
                            ),
                            Text(
                              transAmount,
                              style: TextStyle(fontSize: 12, color: c.text_color),
                            ),
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
                                    checkReceiptStatus(status, transID, selectLang, taxTypeID, context);
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
                                              size: selectLang == 'ta' ? 16 : 18,
                                            )
                                          : SizedBox(),
                                      Text(
                                        status == 'SUCCESS' ? 'download_receipt'.tr() : 'check_status'.tr(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: selectLang == 'ta' ? 10 : 12, color: c.white, fontWeight: FontWeight.w600),
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
                          SizedBox(width: 5), // Add some spacing between the icon and text
                          Text(
                            headerText,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(fontSize: 10, color: c.text_color, fontWeight: FontWeight.bold),
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

  FilterList() {
    successList = [];
    failureList = [];
    pendingList = [];

    for (var item in defaultWorklist) {
      var transactionStatus = item[key_transaction_status] ?? '';

      if (transactionStatus == "SUCCESS") {
        successList.add(item);
      } else if (transactionStatus == "PENDING" || transactionStatus == "") {
        pendingList.add(item);
      } else if (transactionStatus == "FAILED") {
        failureList.add(item);
      }
    }
    setState(() {});
  }

  Future<void> checkReceiptStatus(String flag, String transID, String lang, String taxType, BuildContext context) async {
    Utils().showProgress(context, 1);
    var requestData = {
      if (flag == "SUCCESS") key_service_id: service_key_TransactionidWiseGetReceipt else key_service_id: service_key_CheckTransaction,
      if (flag == "SUCCESS") key_taxtypeid: taxType,
      key_transaction_id: transID,
      key_language_name: lang
    };
    var response = await model.mainServicesAPIcall(context, requestData);

    Utils().hideProgress(context);
    if (response[key_status] == key_success && response[key_response] == key_success) {
      if (flag == "SUCCESS") {
        var receiptResponce = response[key_data];
        var pdftoString = receiptResponce[key_receipt_content];
        Uint8List? pdf = const Base64Codec().decode(pdftoString);
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => PDF_Viewer(
                    pdfBytes: pdf,
                  )),
        );
      } else {
        Utils().showAlert(context, ContentType.help, '${response[key_message]}');
        await model.getTransactionStatus(context, widget.mobileNumber, widget.emailID);
        initialize();
      }
    }
  }
}
