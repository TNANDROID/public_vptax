// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, non_constant_identifier_names

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:public_vptax/Layout/screen_size.dart';
import 'package:public_vptax/Resources/ColorsValue.dart' as c;
import 'package:public_vptax/Resources/ImagePath.dart';

import '../../Layout/customclip.dart';
import '../../Layout/ui_helper.dart';
import '../../Model/transaction_model.dart';
import '../../Resources/StringsKey.dart';
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

  List mainList = [];
  List successList = [];
  List failureList = [];
  List pendingList = [];

  int statusFlag = 0;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    mainList = preferencesService.TransactionList;
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
              width: Screen.width(context) * 0.8,
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
                    }),
                    TabBar('Pending', () {
                      statusFlag = 2;
                      setState(() {});
                    }),
                    TabBar('Failed', () {
                      statusFlag = 3;
                      setState(() {});
                    })
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Expanded TabBar(String type, Function onPressed) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
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
                SizedBox(width: 4),
                Text(
                  type,
                  style: TextStyle(color: c.text_color, fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Stack buildTransactionStatusCard(var item) {
    String status = item[key_transaction_status];
    String transID = item[key_transaction_id].toString();
    String transDate = item[key_transaction_date];
    String transAmount = item[key_res_paid_amount].toString();

    return Stack(
      children: [
        Card(
          elevation: 5,
          shadowColor: status == 'SUCCESS'
              ? c.green_new
              : status == 'PENDING'
                  ? c.warningYellow
                  : c.red_new,
          color: status == 'SUCCESS'
              ? c.light_green
              : status == 'PENDING'
                  ? c.green_combo
                  : c.red_new_light,
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
                        'Transaction ID : ',
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
                        'Transaction Date : ',
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
                        'Transaction Amount : ',
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
                            // Add your onPressed logic here
                          },
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(125, 30),
                            backgroundColor: status == 'SUCCESS' ? c.green_new : c.warningYellow, // Set the button color
                          ),
                          child: Text(
                            status == 'SUCCESS' ? 'Download Reciept' : 'Check Status',
                            style: TextStyle(fontSize: 11, color: c.white),
                          ),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            status == 'SUCCESS'
                                ? Icons.check_circle_outline_rounded
                                : status == 'PENDING'
                                    ? Icons.error_outline_rounded
                                    : Icons.clear,
                            color: c.green_new,
                          ),
                          SizedBox(width: 5), // Add some spacing between the icon and text
                          Text(
                            status,
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
                  decoration: UIHelper.GradientContainer(10, 0, 0, 0, [c.green_new, c.green_new]),
                  child: Center(child: UIHelper.titleTextStyle('', c.white, 18, true, true)),
                ),
                ClipPath(
                  clipper: BottomTriangleClipper(),
                  child: Container(
                    width: 40,
                    height: 20,
                    color: c.green_new,
                    //   decoration: UIHelper.roundedBorderWithColorWithShadow(5, c.colorPrimary, c.colorPrimary, borderWidth: 0),
                  ),
                )
              ]),
              Container(
                  margin: EdgeInsets.only(left: 7.5, top: 1),
                  transform: Matrix4.translationValues(-15.0, 0.0, 0.0),
                  child: ClipPath(
                    clipper: RightTriangleClipper(),
                    child: Container(
                      width: 10,
                      height: 8.5,
                      color: c.successGreen,
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
      var transactionStatus = item[key_transaction_status];

      if (transactionStatus == "SUCCESS") {
        successList.add(item);
      } else if (transactionStatus == "PENDING") {
        pendingList.add(item);
      } else if (transactionStatus == "FAILED") {
        failureList.add(item);
      }
    }
    setState(() {});
  }
}
