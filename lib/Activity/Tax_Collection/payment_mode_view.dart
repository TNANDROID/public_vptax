// ignore_for_file: use_build_context_synchronously, file_names, unused_field, must_be_immutable, non_constant_identifier_names

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:public_vptax/Layout/screen_size.dart';
import 'package:public_vptax/Layout/ui_helper.dart';
import 'package:public_vptax/Model/startup_model.dart';
import 'package:public_vptax/Resources/ColorsValue.dart' as c;
import 'package:public_vptax/Resources/imagepath.dart' as imagepath;
import 'package:public_vptax/Resources/StringsKey.dart';
import 'package:public_vptax/Services/Preferenceservices.dart';
import 'package:public_vptax/Services/locator.dart';
import 'package:public_vptax/Utils/ContentInfo.dart';
import 'package:public_vptax/Utils/utils.dart';

class PaymentGateWayView extends StatefulWidget {
  List<dynamic> dataList;
  BuildContext mcContext;
  PaymentGateWayView({super.key, required this.dataList, required this.mcContext});

  @override
  State<PaymentGateWayView> createState() => _PaymentGateWayViewState();
}

class _PaymentGateWayViewState extends State<PaymentGateWayView> {
  PreferenceService preferencesService = locator<PreferenceService>();
  FS fs = locator<FS>();
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  TextEditingController nameTextController = TextEditingController();
  TextEditingController mobileTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();

  int selectedid = -1;
  String isLogin = "";
  List list = [];
  List paymentType = [];
  bool _isKeyboardFocused = false;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    list = preferencesService.gatewayList;
    paymentType = preferencesService.paymentTypeList;
    isLogin = await preferencesService.getString(key_isLogin);
    if (isLogin == "yes") {
      nameTextController.text = await preferencesService.getString(key_name);
      mobileTextController.text = await preferencesService.getString(key_mobile_number);
      emailTextController.text = await preferencesService.getString(key_email);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _isKeyboardFocused = MediaQuery.of(context).viewInsets.bottom > 0;
    return Wrap(children: <Widget>[
      Container(
          decoration: UIHelper.GradientContainer(50.0, 50, 0, 0, [c.white, c.white]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 10),
                  child: Text(('payment_mode'.tr().toString() + (preferencesService.selectedLanguage == 'en' ? paymentType[0][key_paymenttype_en] : paymentType[0][key_paymenttype_ta])),
                      style: TextStyle(fontSize: fs.h3, fontWeight: FontWeight.bold))),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                    margin: const EdgeInsets.only(top: 5, left: 20, bottom: 5),
                    child: Text('select_payment_gateway'.tr().toString(), style: TextStyle(fontSize: fs.h3, fontWeight: FontWeight.normal, color: c.black))),
              ),
              AnimationLimiter(
                  child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: list.length,
                      itemBuilder: (BuildContext context, int index) {
                        return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 800),
                            child: SlideAnimation(
                              horizontalOffset: 200.0,
                              child: FlipAnimation(
                                child: Padding(
                                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                    child: InkWell(
                                      onTap: () {
                                        selectedid = list[index][key_gateway_id];
                                        setState(() {});
                                      },
                                      child: Row(
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: selectedid == list[index][key_gateway_id]
                                                ? Image.asset(
                                                    imagepath.tick,
                                                    color: c.account_status_green_color,
                                                    height: 25,
                                                    width: 25,
                                                  )
                                                : Image.asset(
                                                    imagepath.unchecked,
                                                    color: c.grey_9,
                                                    height: 25,
                                                    width: 25,
                                                  ),
                                          ),
                                          IconButton(
                                              onPressed: () {},
                                              icon: Image.asset(
                                                imagepath.payment_gateway,
                                                height: 25,
                                                width: 25,
                                              )),
                                          Text(
                                            list[index][key_gateway_name],
                                            style: TextStyle(fontWeight: FontWeight.normal, fontSize: fs.h3, color: c.grey_9),
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                            ));
                      })),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                    margin: const EdgeInsets.only(top: 10, left: 20, bottom: 5),
                    child: Text(isLogin == "yes" ? "Payment Details" : 'enter_the_details'.tr().toString(), style: TextStyle(fontSize: fs.h2, fontWeight: FontWeight.normal, color: c.black))),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: FormBuilder(
                    key: _formKey,
                    child: Column(
                      children: [
                        addInputFormControl('name', 'name'.tr().toString(), key_name, isLogin),
                        UIHelper.verticalSpaceSmall,
                        addInputFormControl('mobile', 'mobileNumber'.tr().toString(), key_mobile_number, isLogin),
                        UIHelper.verticalSpaceSmall,
                        addInputFormControl('email', 'emailAddress'.tr().toString(), key_email, isLogin),
                        UIHelper.verticalSpaceSmall,
                      ],
                    )),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: const EdgeInsets.only(left: 5, right: 20, bottom: 20),
                  child: GestureDetector(
                    onTap: () async {
                      if (selectedid > 0) {
                        if (_formKey.currentState!.saveAndValidate()) {
                          Map<String, dynamic> postParams = Map.from(_formKey.currentState!.value);
                          postParams.removeWhere((key, value) => value == null);
                          Navigator.of(context).pop();
                          getPaymentToken(context, widget.dataList);
                        }
                      } else {
                        Utils().showAlert(context, ContentType.fail, 'select_anyOne_gateway'.tr().toString());
                      }
                    },
                    child: Container(
                      width: 120,
                      height: 40,
                      decoration: UIHelper.roundedBorderWithColorWithShadow(15, c.colorPrimary, c.colorPrimaryDark),
                      alignment: Alignment.center,
                      child: Text(
                        "continue".tr().toString(),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: fs.h2,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: _isKeyboardFocused ? Screen.height(context) * 0.36 : 0,
              )
            ],
          ))
    ]);
  }

  Widget addInputFormControl(String nameField, String hintText, String fieldType, String isLogin) {
    return FormBuilderTextField(
      enabled: isLogin == "yes" ? false : true,
      style: TextStyle(fontSize: fs.h3, fontWeight: FontWeight.w400, color: c.grey_9),
      name: nameField,
      controller: fieldType == key_mobile_number
          ? mobileTextController
          : fieldType == key_name
              ? nameTextController
              : emailTextController,
      autocorrect: false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (value) {},
      decoration: InputDecoration(
        labelText: hintText,
        labelStyle: TextStyle(fontSize: fs.h3, fontWeight: FontWeight.w600, color: c.grey_7),
        filled: true,
        fillColor: Colors.white,
        // disabledBorder: UIHelper.getInputBorder(1, borderColor: c.grey_7),
        enabledBorder: UIHelper.getInputBorder(1, borderColor: c.grey_7),
        focusedBorder: UIHelper.getInputBorder(1, borderColor: c.grey_7),
        focusedErrorBorder: UIHelper.getInputBorder(1, borderColor: Colors.red),
        errorBorder: UIHelper.getInputBorder(1, borderColor: Colors.red),
        errorStyle: const TextStyle(fontSize: 10),
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12), // Optional: Adjust padding
      ),
      validator: fieldType == key_mobile_number
          ? ((value) {
              if (value == "" || value == null) {
                return "$hintText ${'isEmpty'.tr()}";
              }
              if (!Utils().isNumberValid(value)) {
                return "$hintText ${'isInvalid'.tr()}";
              }
              return null;
            })
          : fieldType == key_email
              ? ((value) {
                  if (value == "" || value == null) {
                    return "$hintText ${'isEmpty'.tr()}";
                  }
                  if (!Utils().isEmailValid(value)) {
                    return "$hintText ${'isInvalid'.tr()}";
                  }
                  return null;
                })
              : FormBuilderValidators.compose([
                  FormBuilderValidators.required(errorText: "$hintText ${'isEmpty'.tr()}"),
                ]),
      inputFormatters: fieldType == key_mobile_number
          ? [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ]
          : [],
      keyboardType: fieldType == key_mobile_number || fieldType == key_number ? TextInputType.number : TextInputType.text,
    );
  }

  Future<void> getPaymentToken(BuildContext context, List finalList) async {
    try {
      String taxType = finalList[0][key_taxtypeid].toString();
      List property_demand_id = [];

      for (var data in finalList[0][key_DEMAND_DETAILS]) {
        if (data[key_flag] == true) {
          if (taxType == "2") {
            String demandId = Utils().getDemandId(data, taxType);
            String amountToPay = data[key_watercharges];
            Map<String, String> details = {
              key_demand_id: demandId,
              key_amount_to_pay: amountToPay,
            };
            property_demand_id.add(details);
          } else {
            property_demand_id.add(Utils().getDemandId(data, taxType));
          }
        }
      }
      String demand_id = Utils().getPaymentTokenDemandId(taxType);
      List Assessment_Details = [
        {key_assessment_no: finalList[0][key_assessment_no].toString(), demand_id: property_demand_id}
      ];
      dynamic assessment_demand_list = {'Assessment_Details': Assessment_Details};
      dynamic request = {
        key_service_id: service_key_CollectionPaymentTokenList,
        key_language_name: preferencesService.selectedLanguage,
        key_taxtypeid: finalList[0][key_taxtypeid].toString(),
        key_dcode: finalList[0][key_dcode].toString(),
        key_bcode: finalList[0][key_bcode].toString(),
        key_pvcode: finalList[0][key_lbcode].toString(),
        if (finalList[0][key_taxtypeid].toString() == "4") key_fin_year: finalList[0][key_financialyear].toString(),
        key_assessment_no: finalList[0][key_assessment_no].toString(),
        key_paymenttypeid: 5,
        key_name: nameTextController.text,
        key_mobile_no: mobileTextController.text,
        key_email_id: emailTextController.text,
        key_payment_gateway: selectedid,
        'assessment_demand_list': assessment_demand_list,
      };
      Utils().showProgress(widget.mcContext, 1);
      var response = await StartUpViewModel().overAllMainService(widget.mcContext, request);
      Utils().hideProgress(widget.mcContext);

      var status = response[key_status];
      String response_value = response[key_response];
      if (status == key_success && response_value == key_success) {
        dynamic pay_params = response['pay_params'];
        // String transaction_unique_id = Utils().decodeBase64(pay_params['a'].toString());
        //  String req_payment_amount = Utils().decodeBase64(pay_params['c'].toString());
        // String txmStartTime = Utils().decodeBase64(pay_params['f'].toString());
        String atomTokenId = Utils().decodeBase64(pay_params['b'].toString());
        String public_transaction_email_id = Utils().decodeBase64(pay_params['d'].toString());
        String public_transaction_mobile_no = Utils().decodeBase64(pay_params['e'].toString());
        String merchId = Utils().decodeBase64(pay_params['g'].toString());

        await Utils().openNdpsPG(widget.mcContext, atomTokenId, merchId, public_transaction_email_id, public_transaction_mobile_no);
      } else if (response_value == key_fail) {
        Utils().showAlert(widget.mcContext, ContentType.warning, response[key_message].toString());
      } else {
        Utils().showAlert(widget.mcContext, ContentType.warning, response_value.toString());
      }
    } catch (error) {
      Utils().hideProgress(widget.mcContext);
      debugPrint('error (${error.toString()}) has been caught');
    }
  }
}
