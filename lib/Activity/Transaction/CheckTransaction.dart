// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, non_constant_identifier_names, unnecessary_brace_in_string_interps

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:public_vptax/Layout/screen_size.dart';
import 'package:public_vptax/Resources/ColorsValue.dart' as c;
import '../../Layout/customclip.dart';
import '../../Layout/ui_helper.dart';
import '../../Model/transaction_model.dart';
import '../../Resources/StringsKey.dart';
import '../../Services/Apiservices.dart';
import '../../Services/Preferenceservices.dart';
import '../../Services/locator.dart';

class CheckTransaction extends StatefulWidget {
  const CheckTransaction({super.key});

  @override
  State<CheckTransaction> createState() => _CheckTransactionState();
}

class _CheckTransactionState extends State<CheckTransaction> {
  final TransactionModel transactionModel = TransactionModel();
  PreferenceService preferencesService = locator<PreferenceService>();
  ApiServices apiServices = locator<ApiServices>();
  String selectedLang = "";

  List mainList = [];
  List successList = [];
  List failureList = [];
  List pendingList = [];

  int statusFlag = 0;

  String selectLang = '';

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    mainList = preferencesService.TransactionList;
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
                    'transaction_history'.tr().toString(),
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
              margin: EdgeInsets.only(top: Screen.width(context) * 0.2),
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: statusFlag == 0
                      ? mainList.length
                      : statusFlag == 1
                          ? successList.length
                          : statusFlag == 2
                              ? pendingList.length
                              : failureList.length,
                  itemBuilder: (context, mainIndex) {
                    var item = statusFlag == 0
                        ? mainList[mainIndex]
                        : statusFlag == 1
                            ? successList[mainIndex]
                            : statusFlag == 2
                                ? pendingList[mainIndex]
                                : failureList[mainIndex];
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                      child: buildTransactionStatusCard(item),
                    );
                  }),
            )),
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
                  children: [
                    TabBar('Success', () {
                      statusFlag = 1;
                      setState(() {});
                    }, statusFlag == 1 ? true : false),
                    TabBar('Pending', () {
                      statusFlag = 2;
                      setState(() {});
                    }, statusFlag == 2 ? true : false),
                    TabBar('Failed', () {
                      statusFlag = 3;
                      setState(() {});
                    }, statusFlag == 3 ? true : false)
                  ],
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
                Text(
                  headerText,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(color: c.text_color, fontSize: selectLang == 'ta' ? 11 : 13),
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
      cardColorPrimaryDark = c.failureRed;
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
            child: Container(
              margin: EdgeInsets.only(left: Screen.width(context) * 0.15),
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Visibility(
                        visible: status == 'FAILED' ? false : true,
                        child: ElevatedButton(
                          onPressed: () {
                            checkReceiptStatus(status, transID, selectLang, context);
                          },
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(selectLang == 'ta' ? 150 : 130, 30),
                            backgroundColor: cardColorPrimary,
                          ),
                          child: Text(
                            status == 'SUCCESS' ? 'download_receipt'.tr() : 'check_status'.tr(),
                            style: TextStyle(fontSize: selectLang == 'ta' ? 10 : 12, color: c.text_color, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                            style: TextStyle(fontSize: 11, color: c.text_color, fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
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

    for (var item in mainList) {
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

  Future<void> checkReceiptStatus(String flag, String transID, String lang, BuildContext context) async {
    var requestData = {if (flag == "SUCCESS") key_service_id: service_key_TransactionidWiseGetReceipt, key_transaction_id: transID, key_language_name: lang};

    var GetRequestDataList = {key_data_content: requestData};

    var response = await apiServices.mainServiceFunction(GetRequestDataList);
    print('response>>: ${response}');
    if (response[key_status] == key_success && response[key_response] == key_success) {
      var receiptResponce = response[key_main_data];
      print('receiptResponce: ${receiptResponce}');
    }
  }
}
