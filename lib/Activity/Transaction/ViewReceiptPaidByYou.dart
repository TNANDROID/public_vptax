import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:public_vptax/Layout/Read_more_or_less.dart';
import 'package:public_vptax/Layout/customCalender.dart';
import 'package:public_vptax/Layout/screen_size.dart';
import 'package:public_vptax/Layout/ui_helper.dart';
import 'package:public_vptax/Resources/ColorsValue.dart' as c;
import 'package:public_vptax/Resources/ImagePath.dart' as imagePath;
import 'package:public_vptax/Services/Preferenceservices.dart';
import 'package:public_vptax/Services/locator.dart';
import 'package:public_vptax/Utils/utils.dart';
import 'package:stacked/stacked.dart';

import '../../Model/startup_model.dart';
import '../../Resources/StringsKey.dart';
import '../../Services/Apiservices.dart';

class ViewReceiptPaidByYou extends StatefulWidget {
  @override
  State<ViewReceiptPaidByYou> createState() => _ViewReceiptPaidByYouState();
}

class _ViewReceiptPaidByYouState extends State<ViewReceiptPaidByYou> {
  @override
  Utils utils = Utils();
  ApiServices apiServices = ApiServices();
  PreferenceService preferencesService = locator<PreferenceService>();
  FS fs = locator<FS>();
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  String selectedTaxType = "";
  List<dynamic> receiptList = [];
  bool noDataFound = false;
  final scrollController = ScrollController();

  String dateText = "select_from_to_date".tr().toString();
  String from_Date = "";
  String to_Date = "";
  String mobile_number = "";

  @override
  void initState() {
    super.initState();
    initialize();
  }

  initialize() async {
    mobile_number = await preferencesService.getUserInfo(key_mobile_number);
  }

  //Dropdown Input Field Widget
  Widget addInputDropdownField(String inputHint, String fieldName, StartUpViewModel model) {
    String titleText = "";
    String titleTextTamil = "";
    String initValue = "";
    titleText = key_taxtypedesc_en;
    titleTextTamil = key_taxtypedesc_ta;
    initValue = selectedTaxType;

    return FormBuilderDropdown(
      decoration: InputDecoration(
        suffixIcon: Icon(
          Icons.arrow_drop_down,
          color: c.grey_8,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelText: inputHint.tr().toString(),
        labelStyle: TextStyle(fontSize: 10.0, fontWeight: FontWeight.w400, color: c.grey_7),
        filled: true,
        fillColor: c.need_improvement2,
        enabledBorder: UIHelper.getInputBorder(0, borderColor: c.full_transparent, radius: 40),
        focusedBorder: UIHelper.getInputBorder(0, borderColor: c.full_transparent, radius: 40),
        focusedErrorBorder: UIHelper.getInputBorder(0, borderColor: Colors.red, radius: 40),
        errorBorder: UIHelper.getInputBorder(0, borderColor: Colors.red, radius: 40),
        errorStyle: TextStyle(fontSize: 10),
        contentPadding: EdgeInsets.symmetric(vertical: 1, horizontal: 10), // Optional: Adjust padding
      ),
      icon: Container(width: 0, height: 0),
      name: fieldName,
      initialValue: initValue,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: FormBuilderValidators.compose([FormBuilderValidators.required(errorText: inputHint)]),
      items: preferencesService.taxTypeList
          .map((item) => DropdownMenuItem(
              value: item[key_taxtypeid],
              child: Padding(
                padding: EdgeInsets.only(left: 10, top: 5),
                child: Text(
                  preferencesService.selectedLanguage == "en" ? item[titleText].toString() : item[titleTextTamil].toString(),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: fs.h4, fontWeight: FontWeight.w400, color: c.grey_8),
                ),
              )))
          .toList(),
      onChanged: (value) async {
        receiptList.clear();
        selectedTaxType = "";
        selectedTaxType = value.toString();
        setState(() {});
      },
    );
  }

  ///This [widget] Used for Input field and Headings are same row Alignment.
  Widget headingWithDropdownWidget(String title, Widget dropdownWidget) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            title.tr().toString(),
            style: TextStyle(fontSize: fs.h4, color: c.grey_10),
          ),
        ),
        Expanded(flex: 0, child: Text(":  ", style: TextStyle(fontSize: fs.h4, color: c.grey_10))),
        Expanded(flex: 2, child: dropdownWidget),
      ],
    );
  }

  ///This [widget] Used for set of Input fields form.
  Widget formField(BuildContext context, StartUpViewModel model) {
    return Column(children: [
      Container(
        transform: Matrix4.translationValues(0.0, -50.0, 0.0),
        height: MediaQuery.of(context).size.height / 2,
        child: Image.asset(
          imagePath.house_tax,
          fit: BoxFit.fitWidth,
          width: MediaQuery.of(context).size.width,
        ),
      ),
      Container(
          transform: Matrix4.translationValues(-6.0, -120.0, 10.0),
          margin: EdgeInsets.only(left: 25, right: 15, top: 5),
          padding: EdgeInsets.only(top: 10, left: 5, right: 5, bottom: 50),
          decoration: UIHelper.roundedBorderWithColorWithShadow(15, c.white, c.white, borderColor: Colors.transparent, borderWidth: 5),
          child: FormBuilder(
              key: _formKey,
              child: Column(children: [
                headingWithDropdownWidget('taxType', addInputDropdownField('select_taxtype'.tr().toString(), "taxtypeid", model)),
                UIHelper.verticalSpaceSmall,
                if (selectedTaxType.isNotEmpty)
                  GestureDetector(
                      onTap: () {
                        ShowCalenderDialog(context);
                      },
                      child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                          decoration: UIHelper.roundedBorderWithColorWithShadow(15, c.need_improvement2, c.need_improvement2, borderColor: Colors.transparent, borderWidth: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child: UIHelper.titleTextStyle(dateText, c.grey_8, dateText == "select_from_to_date".tr().toString() ? fs.h4 : fs.h3, true, false)),
                              Image.asset(
                                imagePath.datepicker_icon,
                                height: 30,
                                width: 30,
                              ),
                            ],
                          ))),
              ]))),
      Container(
        transform: Matrix4.translationValues(5.0, -150.0, 10.0),
        child: TextButton(
          child: Padding(padding: EdgeInsets.only(left: 5, right: 5), child: Text("submit".tr().toString(), style: TextStyle(color: c.white, fontSize: fs.h3))),
          style: TextButton.styleFrom(fixedSize: const Size(130, 20), shape: StadiumBorder(), backgroundColor: c.colorPrimary),
          onPressed: () async {
            if (_formKey.currentState!.saveAndValidate() && from_Date.isNotEmpty && to_Date.isNotEmpty) {
              Map<String, dynamic> postParams = Map.from(_formKey.currentState!.value);
              postParams['service_id'] = "ReceiptBillDetails";
              postParams['language_name'] = preferencesService.selectedLanguage;
              postParams['from_date'] = from_Date;
              postParams['to_date'] = to_Date;
              postParams[key_mobile_number] = mobile_number;
              postParams.removeWhere((key, value) {
                return value == null || (value is String && value.isEmpty);
              });
              Utils().showProgress(context, 1);
              var response = await model.overAllMainService(context, postParams);
              if (response[key_response] == key_fail) {
                receiptList = [];
                noDataFound = true;
              } else {
                noDataFound = false;
                receiptList = response[key_data];
              }
              Utils().hideProgress(context);
            }
            setState(() {});
            scrollController.animateTo(
              400,
              duration: Duration(milliseconds: 500),
              curve: Curves.linearToEaseOut,
            );
            setState(() {});
          },
        ),
      ),
    ]);
  }

  ///This [widget] Used for Doownload Receipt container.
  Widget getReceiptDownloadWidget(BuildContext context, String title, dynamic sendData, String language, StartUpViewModel model) {
    sendData[key_receipt_id] = sendData['receiptid'];
    sendData[key_state_code] = sendData['statecode'];
    return InkWell(
      child: Stack(
        children: [
          Container(
              width: Screen.width(context) / 1.5,
              height: 60,
              padding: EdgeInsets.all(10),
              decoration: UIHelper.roundedBorderWithColorWithShadow(10, c.white, c.white, borderColor: c.full_transparent, borderWidth: 0),
              child: Center(child: UIHelper.titleTextStyle(title, c.text_color, 12, false, true))),
          Container(
            transform: Matrix4.translationValues(-12, 18, 0),
            decoration: UIHelper.circleWithColorWithShadow(300, c.white, c.white),
            child: Image.asset(
              imagePath.download_img,
              height: 24,
              width: 24,
            ),
          )
        ],
      ),
      onTap: () {
        model.getReceipt(context, sendData, 'paymentReceipt', language);
      },
    );
  }

  ///This [widget] Used for set of [getReceiptDownloadWidget] are used.
  Widget listview(BuildContext context, StartUpViewModel model) {
    return receiptList.length > 0
        ? Container(
            transform: Matrix4.translationValues(-5.0, -100.0, 10.0),
            padding: EdgeInsets.only(left: 22, right: 22),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'payed_by'.tr().toString(),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: fs.h4, color: c.grey_9),
                    ),
                    UIHelper.horizontalSpaceSmall,
                    Expanded(child: UIHelper.titleTextStyle((": ($mobile_number) "), c.primary_text_color2, fs.h3, false, false)),
                  ],
                ),
                UIHelper.verticalSpaceMedium,
                AnimationLimiter(
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: receiptList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(children: [
                        AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 800),
                          child: SlideAnimation(
                            horizontalOffset: 200.0,
                            child: FlipAnimation(child: customCardDesign(receiptList[index], model)),
                          ),
                        ),
                        UIHelper.verticalSpaceSmall
                      ]);
                    },
                  ),
                ),
              ],
            ),
          )
        : noDataFound
            ? Container(
                transform: Matrix4.translationValues(-5.0, -100.0, 10.0), padding: EdgeInsets.only(left: 22, right: 22), child: UIHelper.titleTextStyle('no_record', c.text_color, 12, true, true))
            : SizedBox();
  }

  Widget keyValueRowWidget(String key, String value) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 2, child: UIHelper.titleTextStyle(key, c.grey_8, fs.h4, false, false)),
            Expanded(flex: 0, child: UIHelper.titleTextStyle(":", c.grey_8, fs.h4, false, false)),
            UIHelper.horizontalSpaceSmall,
            Expanded(flex: 3, child: UIHelper.titleTextStyle(value, c.grey_8, fs.h3, false, false)),
          ],
        ),
        UIHelper.verticalSpaceSmall
      ],
    );
  }

  Widget customCardDesign(dynamic getData, StartUpViewModel model) {
    return Container(
        margin: EdgeInsets.only(top: 10),
        //  height: 210,
        decoration: UIHelper.roundedBorderWithColorWithShadow(15, c.white, c.white, borderWidth: 0, borderColor: c.colorAccent),
        width: Screen.width(context),
        child: Column(children: [
          Container(
            height: 15,
            decoration: UIHelper.roundedBorderWithColor(15, 15, 0, 0, c.colorPrimaryDark, borderWidth: 0),
          ),
          Container(
            height: 10,
            transform: Matrix4.translationValues(0.0, -1, 0),
            width: Screen.width(context) / 1.5,
            decoration: UIHelper.roundedBorderWithColor(0, 0, 10, 10, c.colorPrimaryDark, borderWidth: 0),
          ),
          Container(
              margin: EdgeInsets.only(right: 10, left: 20),
              child: Column(
                children: [
                  UIHelper.verticalSpaceSmall,
                  Align(alignment: Alignment.topRight, child: UIHelper.titleTextStyle(formatedDate(getData['collectiondate'].toString()), c.text_color, fs.h4, false, false)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        imagePath.user,
                        color: c.colorPrimaryDark,
                        height: 15,
                        width: 15,
                      ),
                      UIHelper.horizontalSpaceTiny,
                      Expanded(
                        child: Text(
                          getData['owner_name'].toString(),
                          style: TextStyle(fontSize: fs.h2, fontWeight: FontWeight.bold, color: c.text_color),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // UIHelper.titleTextStyle(/*getData['owner_name'].toString()*/"fd gd fg fd dfgrtrtertretret etretert ggggggg gggg", c.text_color, 15, true, false),
                    ],
                  ),
                  UIHelper.verticalSpaceMedium,
                  keyValueRowWidget('receiptno'.tr().toString(), getData['receipt_no'].toString()),
                  keyValueRowWidget('assesmentNumber'.tr().toString(), getData['assessment_no'].toString()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [getReceiptDownloadWidget1(context, "தமிழ்", getData, "ta", model), UIHelper.horizontalSpaceMedium, getReceiptDownloadWidget1(context, "English", getData, "en", model)],
                  ),
                  UIHelper.verticalSpaceSmall,
                ],
              )),
          Container(
            height: 25,
            width: Screen.width(context),
            decoration: UIHelper.roundedBorderWithColor(0, 0, 15, 15, c.colorPrimaryDark, borderWidth: 0),
            child: Column(
              children: [
                Container(
                  height: 15,
                  width: Screen.width(context) / 1.5,
                  transform: Matrix4.translationValues(0.0, -1, 0),
                  decoration: UIHelper.roundedBorderWithColor(0, 0, 10, 10, c.white, borderWidth: 0),
                ),
              ],
            ),
          ),
        ]));
  }

  Widget getReceiptDownloadWidget1(BuildContext context, String title, dynamic sendData, String language, StartUpViewModel model) {
    sendData[key_receipt_id] = sendData['receiptid'];
    sendData[key_state_code] = sendData['statecode'];
    return InkWell(
      child: Stack(
        children: [
          Container(
              width: Screen.width(context) / 4,
              height: 40,
              decoration: UIHelper.roundedBorderWithColorWithShadow(10, c.white, c.white, borderColor: c.grey_4, borderWidth: 0),
              child: Center(child: UIHelper.titleTextStyle(title, c.text_color, fs.h4, true, true))),
          Container(
            transform: Matrix4.translationValues(-12, 10, 0),
            decoration: UIHelper.circleWithColorWithShadow(300, c.white, c.white),
            child: Image.asset(
              imagePath.download_img,
              height: 20,
              width: 20,
            ),
          )
        ],
      ),
      onTap: () {
        model.getReceipt(context, sendData, 'paymentReceipt', language);
      },
    );
  }

  /// Main Build Widget of this class
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: UIHelper.getBar('view_receipt_details'),
        body: SafeArea(
          top: true,
          child: ViewModelBuilder<StartUpViewModel>.reactive(
              onModelReady: (model) async {},
              builder: (context, model, child) {
                return SingleChildScrollView(
                    controller: scrollController,
                    scrollDirection: Axis.vertical,
                    child: Container(
                        child: Column(
                      children: [formField(context, model), listview(context, model)],
                    )));
              },
              viewModelBuilder: () => StartUpViewModel()),
        ));
  }

  ShowCalenderDialog(BuildContext context) async {
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return CustomCalenderView(onCompleted: (value) {
            from_Date = DateFormat('dd-MM-yyyy').format(value['fromDate']!);
            to_Date = DateFormat('dd-MM-yyyy').format(value['toDate']!);
            dateText = "$from_Date  To  $to_Date";
            setState(() {});
          });
        });
  }

  String formatedDate(String string) {
    DateFormat dateFormat = DateFormat("dd-MM-yyyy hh:mm a");
    DateTime dateTime = dateFormat.parse(string);
    String formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);
    return formattedDate;
  }
}
