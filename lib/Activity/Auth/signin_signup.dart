// ignore_for_file: unused_local_variable, non_constant_identifier_names, file_names, camel_case_types, prefer_typing_uninitialized_variables, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, avoid_print, library_prefixes, prefer_const_constructors, prefer_interpolation_to_compose_strings, use_build_context_synchronously, avoid_unnecessary_containers, no_leading_underscores_for_local_identifiers, equal_elements_in_set, must_be_immutable

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:public_vptax/Activity/Auth/Splash.dart';
import 'package:public_vptax/Layout/customgradientbutton.dart';
import 'package:public_vptax/Layout/number_keyboard.dart';
import 'package:public_vptax/Layout/screen_size.dart';
import 'package:public_vptax/Layout/ui_helper.dart';
import 'package:public_vptax/Layout/verification.dart';
import 'package:public_vptax/Model/startup_model.dart';
import 'package:public_vptax/Resources/ColorsValue.dart' as c;
import 'package:public_vptax/Resources/ImagePath.dart' as imagepath;
import 'package:public_vptax/Resources/StringsKey.dart';
import 'package:public_vptax/Services/Apiservices.dart';
import 'package:public_vptax/Services/Preferenceservices.dart';
import 'package:public_vptax/Services/locator.dart';
import 'package:public_vptax/Utils/ContentInfo.dart';
import 'package:public_vptax/Utils/utils.dart';
import 'package:stacked/stacked.dart';

class SignUpView extends StatefulWidget {
  bool isSignup;
  SignUpView({Key? key, required this.isSignup});
  @override
  State<SignUpView> createState() => SignUpStateView();
}

class SignUpStateView extends State<SignUpView> with TickerProviderStateMixin {
  Utils utils = Utils();
  ApiServices apiServices = ApiServices();
  PreferenceService preferencesService = locator<PreferenceService>();
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> _SecretKey = GlobalKey<FormBuilderState>();
  late Animation<Offset> _rightToLeftAnimation;
  late AnimationController _rightToLeftAnimController;
  int registerStep = 1;
  String finalOTP = '';
  String titleText = '';
  bool isShowKeyboard = false;
  bool verifyOTPFlag = false;
  String gender = "";
  List secureFields = [];
  Map<String, dynamic> postParams = {};

  List<dynamic> genderList = [
    {"title": 'female'.tr().toString(), "value": "F"},
    {"title": 'male'.tr().toString(), "value": "M"},
    {"title": 'others'.tr().toString(), "value": "O"}
  ];

  @override
  void initState() {
    super.initState();
    _rightToLeftAnimController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1300));
    _rightToLeftAnimation =
        Tween<Offset>(begin: registerStep == 2 ? Offset.zero : Offset(1.0, 0.0), end: const Offset(0.0, 0.0)).animate(CurvedAnimation(parent: _rightToLeftAnimController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _rightToLeftAnimController.dispose();
    super.dispose();
  }

  void changeImageAndAnimate() async {
    if (registerStep == 2) {
      _rightToLeftAnimController.forward();
    } else {
      await _rightToLeftAnimController.reverse();
    }
    setState(() {});
  }

  String getErrorMessage(String errTxt) {
    String retStr = "";
    switch (errTxt) {
      case "Mobile Number Not Registered":
        retStr = 'dont_have_mobile_number'.tr().toString();
        break;
      default:
        retStr = errTxt;
    }
    return retStr;
  }

// ************* Main Widget from this Class ****************** \\
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // ****************************** Background Color alone Field ****************************** //

            CustomGradientButton(
              width: Screen.width(context),
              height: Screen.height(context),
              topleft: 0,
              topright: 0,
              btmleft: 0,
              btmright: 0,
              btnPadding: 0,
            ),

            // ****************************** Back Arrow ****************************** //

            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: Screen.width(context) * 0.15, left: Screen.width(context) * 0.07),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.arrow_circle_left_outlined,
                  size: 30,
                  color: c.white,
                ),
              ),
            ),

            // ****************************** Upper Card Image Design Field ****************************** //

            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Visibility(
                    visible: registerStep == 1,
                    child: Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      margin: EdgeInsets.only(top: Screen.height(context) * 0.12),
                      width: Screen.width(context) - 150,
                      height: Screen.width(context) - 150,
                      decoration: UIHelper.roundedBorderWithColorWithShadow(30.0, c.white, c.white),
                      child: ClipRect(
                        child: SizedBox(
                          height: Screen.width(context) - 50,
                          width: Screen.width(context) - 50,
                          child: Image.asset(
                            imagepath.loginEnc,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    )),
                Visibility(
                    visible: registerStep != 1 && !isShowKeyboard,
                    child: Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      margin: EdgeInsets.only(top: Screen.height(context) * 0.02),
                      width: Screen.width(context) - 150,
                      height: Screen.width(context) - 150,
                      decoration: UIHelper.roundedBorderWithColorWithShadow(30.0, c.white, c.white),
                      child: ClipRect(
                        child: SizedBox(
                          height: Screen.width(context) - 50,
                          width: Screen.width(context) - 50,
                          child: AnimatedBuilder(
                              animation: _rightToLeftAnimation,
                              builder: (context, child) {
                                return SlideTransition(
                                  position: _rightToLeftAnimation,
                                  child: Image.asset(
                                    imagepath.loginPass,
                                    fit: BoxFit.contain,
                                  ),
                                );
                              }),
                        ),
                      ),
                    )),
                UIHelper.verticalSpaceSmall,
                UIHelper.titleTextStyle(widget.isSignup ? 'signUP' : 'signIN', c.white, 25, true, true)
              ],
            ),

            // ****************************** Log in Field ****************************** //
            Positioned(
              bottom: 0,
              child: SizedBox(
                height: Screen.height(context),
                child: ViewModelBuilder<StartUpViewModel>.reactive(
                    builder: (context, model, child) {
                      return Column(
                        children: [
                          Expanded(child: SizedBox()),
                          Container(
                            width: Screen.width(context) - 50,
                            padding: EdgeInsets.all(15),
                            decoration: UIHelper.roundedBorderWithColorWithShadow(30.0, c.white, c.white),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (verifyOTPFlag) UIHelper.titleTextStyle(titleText, c.text_color, 15, true, false),
                                if (registerStep == 1) formControls(context),
                                if (registerStep == 2) otpControls(model),
                                if (registerStep == 3) appKeyControls(),
                                UIHelper.verticalSpaceMedium,

                                // ****************************** Submit Action Field ****************************** //
                                CustomGradientButton(
                                  onPressed: () async {
                                    finalValidation(model);
                                  },
                                  width: Screen.width(context) - 100,
                                  height: 50,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'submit'.tr().toString(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isShowKeyboard)
                            CustomNumberBoard(
                              initialValue: finalOTP,
                              length: 6,
                              onChanged: (value) {
                                finalOTP = value;
                                setState(() {});
                              },
                              onCompleted: () {
                                isShowKeyboard = false;
                                setState(() {});
                              },
                            ),
                          isShowKeyboard ? UIHelper.verticalSpaceSmall : UIHelper.verticalSpaceLarge
                        ],
                      );
                    },
                    viewModelBuilder: () => StartUpViewModel()),
              ),
            )
          ],
        ),
      ),
    );
  }

// ************* Register Form Widget ****************** \\
  Widget formControls(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: widget.isSignup,
          child: Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {
                widget.isSignup = false;
                setState(() {});
              },
              child: Text(
                'already_register'.tr().toString(),
                style: TextStyle(
                  color: c.sky_blue,
                  fontSize: 11,
                ),
              ),
            ),
          ),
        ),
        UIHelper.verticalSpaceSmall,
        FormBuilder(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              addInputFormControl(key_mobile_number, 'mobileNumber'.tr().toString(), key_mobile_number),
              if (widget.isSignup) ...{
                addInputFormControl(key_name, key_name.tr().toString(), "text"),
                addInputFormControl(key_email, 'emailAddress'.tr().toString(), key_email_id),
                UIHelper.verticalSpaceSmall,
                addInputDropdownField(),
              } else ...{
                UIHelper.verticalSpaceVeryLarge,
              }
            ],
          ),
        ),
      ],
    );
  }

// ************* Input Field Widget ********************* \\
  Widget addInputFormControl(String nameField, String hintText, String fieldType, {bool isShowSuffixIcon = false}) {
    return Column(
      children: [
        UIHelper.verticalSpaceSmall,
        FormBuilderTextField(
          style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, color: c.grey_9),
          obscureText: secureFields.contains(nameField) || !isShowSuffixIcon ? false : true,
          name: nameField,
          autocorrect: false,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: (value) {},
          decoration: InputDecoration(
            suffixIcon: isShowSuffixIcon
                ? GestureDetector(
                    onTap: () {
                      if (secureFields.contains(nameField)) {
                        secureFields.remove(nameField);
                      } else {
                        secureFields.add(nameField);
                      }
                      setState(() {});
                    },
                    child: secureFields.contains(nameField)
                        ? Icon(
                            Icons.visibility_off,
                            size: 25,
                            color: c.grey_6,
                          )
                        : Icon(
                            Icons.visibility,
                            size: 25,
                            color: c.grey_6,
                          ))
                : null,
            labelText: hintText,
            labelStyle: TextStyle(fontSize: 11.0, fontWeight: FontWeight.w600, color: c.grey_7),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: UIHelper.getInputBorder(1, borderColor: c.grey_7),
            focusedBorder: UIHelper.getInputBorder(1, borderColor: c.grey_7),
            focusedErrorBorder: UIHelper.getInputBorder(1, borderColor: Colors.red),
            errorBorder: UIHelper.getInputBorder(1, borderColor: Colors.red),
            errorStyle: TextStyle(fontSize: 10),
            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12), // Optional: Adjust padding
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
              : fieldType == key_email_id
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
          inputFormatters: fieldType == key_mobile_number || fieldType == key_number
              ? [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(fieldType == key_mobile_number ? 10 : 4),
                ]
              : [],
          keyboardType: fieldType == key_mobile_number || fieldType == key_number ? TextInputType.number : TextInputType.text,
        ),
      ],
    );
  }

// ************* Input DropDown Field Widget ********************* \\
  Widget addInputDropdownField() {
    return FormBuilderDropdown(
      name: key_gender,
      decoration: InputDecoration(
        labelText: key_gender.tr().toString(),
        labelStyle: TextStyle(fontSize: 11.0, fontWeight: FontWeight.w600, color: c.grey_7),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: UIHelper.getInputBorder(1, borderColor: c.grey_7),
        focusedBorder: UIHelper.getInputBorder(1, borderColor: c.grey_7),
        focusedErrorBorder: UIHelper.getInputBorder(1, borderColor: Colors.red),
        errorBorder: UIHelper.getInputBorder(1, borderColor: Colors.red),
        errorStyle: TextStyle(fontSize: 10),
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12), // Optional: Adjust padding
      ),
      initialValue: gender,
      autovalidateMode: gender.isNotEmpty ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
      validator: FormBuilderValidators.compose([FormBuilderValidators.required(errorText: key_gender.tr().toString() + " " + 'isEmpty'.tr())]),
      items: genderList
          .map((item) => DropdownMenuItem(
                value: item['value'],
                child: Text(
                  item['title'],
                  style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, color: c.grey_9),
                ),
              ))
          .toList(),
      onChanged: (value) async {
        gender = value.toString();
        setState(() {});
      },
    );
  }

// ************* OTP Form Control *********************** \\
  Widget otpControls(StartUpViewModel model) {
    return Column(
      children: [
        GestureDetector(
            onTap: () {
              isShowKeyboard = true;
              setState(() {});
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: VerificationView(fixedlength: 6, pinString: finalOTP, secureText: false),
            )),
        GestureDetector(
            onTap: () async {
              String serviceid = "";
              if (widget.isSignup) {
                serviceid = "ResendOtp";
              } else {
                serviceid = "ResendOTPforGeneratePIN";
              }

              var sendData = {key_service_id: serviceid, key_mobile_number: postParams[key_mobile_number].toString()};
              var response = await model.authendicationServicesAPIcall(context, sendData);
              if (response[key_status].toString() == key_success && response[key_response].toString() == key_success) {
                utils.showToast(context, 'otp_resent_success'.tr().toString(), "S");
              } else {
                utils.showAlert(context, ContentType.fail, getErrorMessage(response[key_message].toString()));
              }
            },
            child: Container(
              width: Screen.width(context) - 100,
              margin: EdgeInsets.only(right: 5),
              alignment: Alignment.centerRight,
              child: Text(
                "( ${'resendOTP'.tr().toString()} )",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: c.primary_text_color2,
                ),
              ),
            )),
        UIHelper.verticalSpaceMedium
      ],
    );
  }

// ************* finalValidation  *********************** \\

  Future<void> finalValidation(StartUpViewModel model) async {
    if (registerStep == 1) {
      if (_formKey.currentState!.saveAndValidate()) {
        postParams = Map.from(_formKey.currentState!.value);
        String serviceId = "";

        if (widget.isSignup) {
          serviceId = "register";
        } else {
          serviceId = verifyOTPFlag ? "ResendOtp" : "SendOTPforGeneratePIN";
        }
        postParams[key_service_id] = serviceId;
        var response = await model.authendicationServicesAPIcall(context, postParams);
        if (response[key_status].toString() == key_success && response[key_response].toString() == key_success) {
          utils.showToast(context, 'otp_resent_success'.tr().toString(), "S");
          registerStep++;
          setState(() {});
          changeImageAndAnimate();
        } else if (response[key_status].toString() == key_success && response[key_response].toString() == key_fail) {
          verifyOTPFlag = true;
          titleText = "verifyOTP".tr();
          utils.closeKeypad(context);
          setState(() {});
        } else {
          utils.showAlert(context, ContentType.fail, getErrorMessage(response[key_message].toString()));
        }
      }
    } else if (registerStep == 2) {
      if (finalOTP.length == 6) {
        String serviceId = "";
        if (widget.isSignup) {
          serviceId = "VerifyOtp";
        } else {
          serviceId = "VerifyOTPforGeneratePIN";
        }

        var sendData = {key_service_id: serviceId, key_mobile_number: postParams[key_mobile_number].toString(), "mobile_otp": finalOTP};
        var response = await model.authendicationServicesAPIcall(context, sendData);
        if (response[key_status].toString() == key_success && response[key_response].toString() == key_success) {
          dynamic resData = response['DATA'];
          await preferencesService.setUserInfo("userId", resData['id'].toString());
          await preferencesService.setUserInfo(key_name, resData[key_name].toString());
          await preferencesService.setUserInfo(key_mobile_number, resData[key_mobile_number].toString());
          await preferencesService.setUserInfo(key_email, resData[key_email].toString());
          await preferencesService.setUserInfo(key_gender, resData[key_gender].toString());
          registerStep++;
          setState(() {});
        } else {
          utils.showAlert(context, ContentType.fail, 'wrong_otp_msg'.tr().toString());
        }
      }
    } else if (registerStep == 3) {
      if (_SecretKey.currentState!.saveAndValidate()) {
        Map<String, dynamic> postkEYParams = Map.from(_SecretKey.currentState!.value);
        if (postkEYParams[key_secretKey].toString() == postkEYParams['confirm'].toString()) {
          await preferencesService.setUserInfo(key_secretKey, postkEYParams[key_secretKey].toString());
          if (widget.isSignup) {
            await utils.showAlert(context, ContentType.success, 'user_registered_successfull'.tr().toString());
          }
          Navigator.push(context, MaterialPageRoute(builder: (context) => Splash()));
        } else {
          utils.showAlert(context, ContentType.warning, 'wrong_confirm_pin'.tr().toString());
        }
      }
    } else {
      debugPrint("End of the Statement....");
    }
  }

// ************* SecretKey Form Control *********************** \\
  Widget appKeyControls() {
    return Column(
      children: [
        UIHelper.titleTextStyle('enter_your_SecretPin'.tr().toString(), c.text_color, 12, true, false),
        UIHelper.verticalSpaceSmall,
        FormBuilder(
            key: _SecretKey,
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                child: Column(
                  children: [
                    addInputFormControl(key_secretKey, 'enter_your_digitPin'.tr().toString(), key_number, isShowSuffixIcon: true),
                    UIHelper.verticalSpaceSmall,
                    addInputFormControl("confirm", 'confirm_pin'.tr().toString(), key_number, isShowSuffixIcon: true),
                  ],
                ))),
        UIHelper.verticalSpaceMedium
      ],
    );
  }
}
