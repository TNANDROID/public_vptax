// ignore_for_file: file_names

import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
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

class ViewReceipt extends StatefulWidget {
  @override
  State<ViewReceipt> createState() => _ViewReceiptState();
}

class _ViewReceiptState extends State<ViewReceipt> {
  @override
  Utils utils = Utils();
  ApiServices apiServices = ApiServices();
  PreferenceService preferencesService = locator<PreferenceService>();
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  String selectedDistrict = "";
  String selectedBlock = "";
  String selectedvillage = "";
  String selectedTaxType = "";
  bool invalidReceiptNumber = false;
  List<dynamic> receiptList = [];
  bool noDataFound = false;

  String finalOTP = '';
  String selectedLang = "";
  final scrollController = ScrollController();
//  OtpFieldController OTPcontroller = OtpFieldController();
  TextEditingController assessmentController = TextEditingController();
  TextEditingController receiptController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initialize();
  }

  initialize() async {
    selectedLang = await preferencesService.getUserInfo("lang");
  }

  //Dropdown Input Field Widget
  Widget addInputDropdownField(int index, String inputHint, String fieldName, StartUpViewModel model) {
    List dropList = [];
    String keyCode = "";
    String titleText = "";
    String titleTextTamil = "";
    String initValue = "";
    if (index == 0) {
      dropList = preferencesService.taxTypeList;
      keyCode = key_taxtypeid;
      titleText = key_taxtypedesc_en;
      titleTextTamil = key_taxtypedesc_ta;
      initValue = selectedTaxType;
    } else if (index == 1) {
      dropList = preferencesService.districtList;
      dropList.sort((a, b) {
        return a[selectedLang == 'en' ? key_dname : key_dname_ta].compareTo(b[selectedLang == 'en' ? key_dname : key_dname_ta]);
      });
      keyCode = key_dcode;
      titleText = key_dname;
      titleTextTamil = key_dname_ta;
      initValue = selectedDistrict;
    } else if (index == 2) {
      dropList = model.selectedBlockList;
      dropList.sort((a, b) {
        return a[selectedLang == 'en' ? key_bname : key_bname_ta].compareTo(b[selectedLang == 'en' ? key_bname : key_bname_ta]);
      });
      keyCode = key_bcode;
      titleText = key_bname;
      titleTextTamil = key_bname_ta;
      initValue = selectedBlock;
    } else if (index == 3) {
      dropList = model.selectedVillageList;
      dropList.sort((a, b) {
        return a[selectedLang == 'en' ? key_pvname : key_pvname_ta].compareTo(b[selectedLang == 'en' ? key_pvname : key_pvname_ta]);
      });
      keyCode = key_pvcode;
      titleText = key_pvname;
      titleTextTamil = key_pvname_ta;
      initValue = selectedvillage;
    }
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
      items: dropList
          .map((item) => DropdownMenuItem(
              value: item[keyCode],
              child: Padding(
                padding: EdgeInsets.only(left: 10, top: 5),
                child: Text(
                  selectedLang == "en" ? item[titleText].toString() : item[titleTextTamil].toString(),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, color: c.grey_8),
                ),
              )))
          .toList(),
      onChanged: (value) async {
        Utils().showProgress(context, 1);
        receiptController.text = "";
        assessmentController.text = "";
        _formKey.currentState!.patchValue({'assessment_no': "", 'receiptno': ""});
        if (index == 0) {
          selectedTaxType = value.toString();
          Utils().hideProgress(context);
        } else if (index == 1) {
          model.selectedBlockList.clear();
          model.selectedVillageList.clear();
          selectedDistrict = value.toString();
          selectedBlock = "";
          selectedvillage = "";
          _formKey.currentState!.patchValue({'block': "", 'village': ""});
          Future.delayed(Duration(milliseconds: 500), () {
            model.loadUIBlock(selectedDistrict);
            setState(() {});
            Utils().hideProgress(context);
          });
        } else if (index == 2) {
          selectedBlock = value.toString();
          selectedvillage = "";
          _formKey.currentState!.patchValue({'village': ""});
          model.selectedVillageList.clear();
          Future.delayed(Duration(milliseconds: 500), () {
            model.loadUIVillage(selectedDistrict, selectedBlock);

            setState(() {});
            Utils().hideProgress(context);
          });
        } else if (index == 3) {
          selectedvillage = value.toString();
          Future.delayed(Duration(milliseconds: 200), () {
            Utils().hideProgress(context);
          });
        } else {
          debugPrint("End of the Statement......");
        }

        setState(() {});
      },
    );
  }

//Text Input Field Widget
  Widget addInputFormControl(String nameField) {
    bool isEnabled = false;
    if (nameField == "assessment_no") {
      if (receiptController.text.isEmpty || receiptController.text == null) {
        isEnabled = true;
      }
    } else {
      if (assessmentController.text.isEmpty || assessmentController.text == null) {
        isEnabled = true;
      }
    }
    return FormBuilderTextField(
      style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, color: c.grey_9),
      name: nameField,
      autocorrect: false,
      enabled: isEnabled,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (value) {
        if (nameField == "assessment_no") {
          assessmentController.text = value.toString();
        } else {
          receiptController.text = value.toString();
        }
        setState(() {});
        Validate();
      },
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelStyle: TextStyle(fontSize: 10.0, fontWeight: FontWeight.w400, color: c.grey_7),
        filled: true,
        constraints: BoxConstraints(maxHeight: 35),
        fillColor: isEnabled ? c.white : c.grey_2,
        enabledBorder: UIHelper.getInputBorder(0, borderColor: c.white, radius: 20),
        disabledBorder: UIHelper.getInputBorder(0, borderColor: c.grey_5, radius: 20),
        focusedBorder: UIHelper.getInputBorder(0, borderColor: c.white, radius: 20),
        focusedErrorBorder: UIHelper.getInputBorder(0, borderColor: Colors.red, radius: 20),
        errorBorder: UIHelper.getInputBorder(0, borderColor: Colors.red, radius: 20),
        errorStyle: TextStyle(fontSize: 10),
        contentPadding: EdgeInsets.symmetric(vertical: 1, horizontal: 10), // Optional: Adjust padding
      ),
      inputFormatters: nameField == "assessment_no"
          ? [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ]
          : [CustomInputFormatter()],
      keyboardType: nameField == "assessment_no" ? TextInputType.number : TextInputType.text,
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
            style: TextStyle(fontSize: 12, color: c.grey_10),
          ),
        ),
        Expanded(flex: 0, child: Text(":  ", style: TextStyle(fontSize: 12, color: c.grey_10))),
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
                headingWithDropdownWidget('taxType', addInputDropdownField(0, 'select_taxtype'.tr().toString(), "taxtypeid", model)),
                UIHelper.verticalSpaceSmall,
                headingWithDropdownWidget('district', addInputDropdownField(1, 'select_District'.tr().toString(), "dcode", model)),
                UIHelper.verticalSpaceSmall,
                if (model.selectedBlockList.isNotEmpty) headingWithDropdownWidget('block', addInputDropdownField(2, 'select_Block'.tr().toString(), "bcode", model)),
                if (model.selectedBlockList.isNotEmpty) UIHelper.verticalSpaceSmall,
                if (model.selectedVillageList.isNotEmpty) headingWithDropdownWidget('villagePanchayat', addInputDropdownField(3, 'select_VillagePanchayat'.tr().toString(), "pvcode", model)),
                if (model.selectedVillageList.isNotEmpty) UIHelper.verticalSpaceSmall,
                if (selectedvillage.isNotEmpty)
                  Container(
                      decoration: UIHelper.roundedBorderWithColorWithShadow(15, c.need_improvement2, c.need_improvement2, borderColor: Colors.transparent, borderWidth: 5),
                      padding: EdgeInsets.only(top: 15, bottom: 10, left: 10, right: 10),
                      child: Column(children: [
                        headingWithDropdownWidget('assesmentNumber', addInputFormControl("assessment_no")),
                        UIHelper.verticalSpaceSmall,
                        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Text(
                            "(" + 'or'.tr().toString() + ")",
                            style: TextStyle(fontSize: 12),
                          )
                        ]),
                        UIHelper.verticalSpaceSmall,
                        headingWithDropdownWidget('receiptno', addInputFormControl("receiptno")),
                        UIHelper.verticalSpaceSmall,
                        invalidReceiptNumber
                            ? UIHelper.titleTextStyle('receiptno'.tr().toString() + "/" + 'assesmentNumber'.tr().toString() + " " + 'isEmpty'.tr().toString(), c.red, 10, false, false)
                            : SizedBox()
                      ])),
              ]))),
      Container(
        transform: Matrix4.translationValues(5.0, -150.0, 10.0),
        child: TextButton(
          child: Padding(padding: EdgeInsets.only(left: 5, right: 5), child: Text("submit".tr().toString(), style: TextStyle(color: c.white, fontSize: 13))),
          style: TextButton.styleFrom(fixedSize: const Size(130, 20), shape: StadiumBorder(), backgroundColor: c.colorPrimary),
          onPressed: () async {
            Validate();
            if (_formKey.currentState!.saveAndValidate() && !invalidReceiptNumber) {
              Map<String, dynamic> postParams = Map.from(_formKey.currentState!.value);
              postParams['service_id'] = "ReceiptBillDetails";
              postParams['language_name'] = selectedLang;
              postParams.removeWhere((key, value) {
                return value == null || (value is String && value.isEmpty);
              });
              Utils().showProgress(context, 1);
              var response = await model.receiptRelatedMainService(context, postParams);
              if (response == "FAIL") {
                receiptList = [];
                noDataFound = true;
              } else {
                noDataFound = false;
                receiptList = response;
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
  Widget getReceiptDownloadWidget(BuildContext context, String title, dynamic sendData, String language) {
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
        utils.getReceipt(context, sendData, 'paymentReceipt', language);
      },
    );
  }

  ///This [widget] Used for set of [getReceiptDownloadWidget] are used.
  Widget listview(BuildContext context) {
    return receiptList.length > 0
        ? Container(
            transform: Matrix4.translationValues(-5.0, -100.0, 10.0),
            padding: EdgeInsets.only(left: 22, right: 22),
            child: AnimationLimiter(
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
                        child: FlipAnimation(
                            child: Stack(children: [
                          Container(
                            height: 220,
                            decoration: UIHelper.roundedBorderWithColorWithShadow(10, c.colorAccentlight, c.white, stop1: 0.25, stop2: 0.1),
                            child: Center(
                                child: Container(
                                    margin: EdgeInsets.all(10.0),
                                    child: Column(
                                      children: [
                                        UIHelper.titleTextStyle('receiptno'.tr().toString(), c.primary_text_color, 12, false, true),
                                        UIHelper.titleTextStyle(receiptList[index]['receipt_no'].toString(), c.text_color, 12, true, true),
                                        UIHelper.verticalSpaceMedium,
                                        getReceiptDownloadWidget(context, 'download_tamil'.tr().toString() + "\n" + 'tamil_1'.tr().toString(), receiptList[index], "ta"),
                                        UIHelper.verticalSpaceMedium,
                                        getReceiptDownloadWidget(context, 'download_english'.tr().toString() + "\n" + 'english_1'.tr().toString(), receiptList[index], "en"),
                                      ],
                                    ))),
                          ),
                        ])),
                      ),
                    ),
                    UIHelper.verticalSpaceSmall
                  ]);
                },
              ),
            ),
          )
        : noDataFound
            ? Container(
                transform: Matrix4.translationValues(-5.0, -100.0, 10.0), padding: EdgeInsets.only(left: 22, right: 22), child: UIHelper.titleTextStyle('no_record', c.text_color, 12, true, true))
            : SizedBox();
  }

  /// Main Build Widget of this class
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: c.colorPrimary,
          centerTitle: true,
          elevation: 2,
          title: Container(
            child: Text(
              'view_receipt_details'.tr().toString(),
              style: TextStyle(fontSize: 14),
            ),
          ),
        ),
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
                      children: [formField(context, model), listview(context)],
                    )));
              },
              viewModelBuilder: () => StartUpViewModel()),
        ));
  }

  Validate() {
    _formKey.currentState!.saveAndValidate();
    Map<String, dynamic> postParams = Map.from(_formKey.currentState!.value);

    if ((postParams['assessment_no'] == null || postParams['assessment_no'] == "") && (postParams['receiptno'] == null || postParams['receiptno'] == "")) {
      invalidReceiptNumber = true;
    } else {
      invalidReceiptNumber = false;
    }
    setState(() {});
  }

  // void _settingModalBottomSheet(context) {
  //   showModalBottomSheet(
  //       context: context,
  //       backgroundColor: c.full_transparent,
  //       builder: (BuildContext bc) {
  //         return Wrap(
  //           children: <Widget>[
  //             Container(
  //                 alignment: Alignment.center,
  //                 height: MediaQuery.of(context).size.height * 3 / 4,
  //                 decoration: UIHelper.GradientContainer(30.0, 30, 0, 0, [c.white, c.white]),
  //                 child: Column(
  //                   children: [
  //                     Container(
  //                       padding: EdgeInsets.only(top: 15),
  //                       alignment: Alignment.center,
  //                       child: Text("Enter  OTP"),
  //                     ),
  //                     Visibility(
  //                       visible: true,
  //                       child: Column(
  //                         children: [
  //                           Padding(
  //                             // padding:EdgeInsets.all(25),
  //                             padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
  //                             child: OTPTextField(
  //                               onChanged: (pin) {
  //                                 print("Changed: " + pin);
  //                               },
  //                               onCompleted: (pin) {
  //                                 utils.closeKeypad(context);
  //                                 finalOTP = pin;
  //                               },
  //                               width: 250,
  //                               controller: OTPcontroller,
  //                               length: 6,
  //                               fieldStyle: FieldStyle.box,
  //                               fieldWidth: 35,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                     Container(
  //                         height: 40,
  //                         padding: EdgeInsets.all(5),
  //                         margin: EdgeInsets.only(left: 0, right: 10, bottom: 15, top: 5),
  //                         decoration: UIHelper.roundedBorderWithColorWithShadow(10, c.colorAccentlight, c.colorAccentlight, borderColor: Colors.transparent, borderWidth: 0),
  //                         child: InkWell(
  //                           child: Padding(
  //                             padding: EdgeInsets.only(left: 5, top: 5, bottom: 5, right: 5),
  //                             child: Text(
  //                               'verifyOTP'.tr().toString(),
  //                               textAlign: TextAlign.center,
  //                               overflow: TextOverflow.ellipsis,
  //                               style: TextStyle(
  //                                 color: c.white,
  //                                 fontWeight: FontWeight.w500,
  //                                 fontSize: 13,
  //                                 decorationStyle: TextDecorationStyle.wavy,
  //                               ),
  //                             ),
  //                           ),
  //                           onTap: () async {
  //                             if (await utils.isOnline()) {
  //                               if (finalOTP.isNotEmpty) {
  //                                 Navigator.pop(context);
  //                                 utils.showAlert(context, ContentType.success, "Receipt Downloaded Successfully");
  //                               } else {
  //                                 utils.showAlert(context, ContentType.warning, "Please Enter A Valid OTP");
  //                               }
  //                             } else {
  //                               utils.showAlert(
  //                                 context,
  //                                 ContentType.fail,
  //                                 "noInternet".tr().toString(),
  //                               );
  //                             }
  //                           },
  //                         )),
  //                   ],
  //                 )),
  //           ],
  //         );
  //       });
  // }
}

class CustomInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Create a pattern that matches digits, hyphens, and slashes
    final RegExp validCharacters = RegExp(r'[0-9\-/]+');

    // Use the pattern to filter the new input value
    final String filteredValue = validCharacters.allMatches(newValue.text).map((e) => e.group(0)).join();

    return TextEditingValue(
      text: filteredValue,
      selection: TextSelection.collapsed(offset: filteredValue.length),
    );
  }
}
