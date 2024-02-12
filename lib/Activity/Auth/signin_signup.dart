// ignore_for_file: unused_local_variable, non_constant_identifier_names, file_names, camel_case_types, prefer_typing_uninitialized_variables, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, avoid_print, library_prefixes, prefer_const_constructors, prefer_interpolation_to_compose_strings, use_build_context_synchronously, avoid_unnecessary_containers, no_leading_underscores_for_local_identifiers, equal_elements_in_set, must_be_immutable

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:public_vptax/Activity/Auth/Splash.dart';
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
import '../../Layout/number_keyboard.dart';
import 'package:sms_otp_auto_verify/sms_otp_auto_verify.dart';

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
  FS fs = locator<FS>();
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> _SecretKey = GlobalKey<FormBuilderState>();
  StartUpViewModel model = StartUpViewModel();
  late Animation<Offset> _rightToLeftAnimation;
  late AnimationController _rightToLeftAnimController;
  int registerStep = 1;
  String finalOTP = '';
  String titleText = '';
  bool isShowKeyboard = false;
  bool verifyOTPFlag = false;
  bool signUpFlag = false;
  String gender = "";
  List secureFields = [];
  Map<String, dynamic> postParams = {};
  final intRegex = RegExp(r'\d+', multiLine: true);

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
    signUpFlag = widget.isSignup;
    _getSignatureCode();
  }

  /// get signature code
  _getSignatureCode() async {
    String? signature = await SmsVerification.getAppSignature();
    print("signature $signature");
  }

  @override
  void dispose() {
    _rightToLeftAnimController.dispose();
    SmsVerification.stopListening();
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
          alignment: Alignment.bottomCenter,
          children: [
            // ****************************** Background Color alone Field ****************************** //

            Container(
              decoration: UIHelper.roundedBorderWithColorWithoutShadow(0, c.colorPrimary, c.colorPrimaryDark),
              width: Screen.width(context),
              height: Screen.height(context),
            ),

            Positioned(
              top: 0,
              left: 0,
              child: Container(
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
            ),

            // ****************************** Upper Card Image Design Field ****************************** //

            Positioned(
              top: Screen.height(context) * 0.10,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Visibility(
                      visible: registerStep == 1,
                      child: Container(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
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
                      visible: registerStep != 1,
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
                  UIHelper.titleTextStyle(signUpFlag ? 'signUP' : 'signIN', c.white, fs.h1, true, true)
                ],
              ),
            ),

            // ****************************** Log in Field ****************************** //
            Positioned(
              bottom: isShowKeyboard ? 330 : Screen.width(context) * 0.10,
              child: Container(
                // margin: EdgeInsets.only(top: signUpFlag ? Screen.width(context) * 0.10 : Screen.width(context) * 0.20),
                width: Screen.width(context) - 50,
                padding: EdgeInsets.all(15),
                decoration: UIHelper.roundedBorderWithColorWithShadow(30.0, c.white, c.white),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (verifyOTPFlag && registerStep == 1) UIHelper.titleTextStyle(titleText, c.text_color, fs.h3, true, false),
                    if (registerStep == 1) formControls(context),
                    if (registerStep == 2) otpControls(model),
                    if (registerStep == 3) appKeyControls(),
                    UIHelper.verticalSpaceMedium,

                    // ****************************** Submit Action Field ****************************** //
                    GestureDetector(
                        onTap: () async {
                          finalValidation(model);
                        },
                        child: Container(
                            width: Screen.width(context) / 2,
                            height: 50,
                            decoration: UIHelper.roundedBorderWithColorWithoutShadow(20, c.colorPrimary, c.colorPrimaryDark),
                            alignment: Alignment.center,
                            child: UIHelper.titleTextStyle('submit'.tr().toString(), c.white, fs.h2, true, true))),
                  ],
                ),
              ),
            ),

            Visibility(
              visible: isShowKeyboard,
              child: SizedBox(
                height: 330,
                width: Screen.width(context),
                child: CustomNumberBoard(
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
              ),
            ),
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
        FormBuilder(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              addInputFormControl(key_mobile_number, 'mobileNumber'.tr().toString(), key_mobile_number),
              if (signUpFlag) ...{
                addInputFormControl(key_name, key_name.tr().toString(), "text"),
                addInputFormControl(key_email, 'emailAddress'.tr().toString(), key_email_id),
                UIHelper.verticalSpaceSmall,
                // addInputDropdownField(),
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
          style: TextStyle(fontSize: fs.h4, fontWeight: FontWeight.w400, color: c.grey_9),
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
                child: UIHelper.titleTextStyle(item['title'], c.grey_9, fs.h4, true, true),
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
              if (signUpFlag || verifyOTPFlag) {
                serviceid = "ResendOtp";
              } else {
                serviceid = "ResendOTPforGeneratePIN";
              }

              var sendData = {key_service_id: serviceid, key_mobile_number: postParams[key_mobile_number].toString()};
              var response;
              try {
                Utils().showProgress(context, 1);
                response = await model.overAllMainService(context, sendData);
                _startListeningSms();
              } catch (e) {
                Utils().showToast(context, "Fail", "W");
              } finally {
                Utils().hideProgress(context);
              }
              if (response != null && response.isNotEmpty) {
                if (response[key_status].toString() == key_success && response[key_response].toString() == key_success) {
                  utils.showToast(context, 'otp_resent_success'.tr().toString(), "S");
                } else {
                  utils.showAlert(context, ContentType.fail, getErrorMessage(response[key_message].toString()));
                }
              } else {
                utils.showAlert(context, ContentType.fail, getErrorMessage("failed".tr().toString()));
              }
            },
            child: Container(
                width: Screen.width(context) - 100,
                margin: EdgeInsets.only(right: 5),
                alignment: Alignment.centerRight,
                child: UIHelper.titleTextStyle('resendOTP'.tr().toString(), c.primary_text_color2, fs.h5, true, true))),
        UIHelper.verticalSpaceMedium
      ],
    );
  }

  /// listen sms
  _startListeningSms() {
    SmsVerification.startListeningSms().then((message) {
      setState(() {
        finalOTP = SmsVerification.getCode(message, intRegex);
      });
    });
  }

// ************* finalValidation  *********************** \\

  Future<void> finalValidation(StartUpViewModel model) async {
    utils.closeKeypad(context);

    if (registerStep == 1) {
      if (_formKey.currentState!.saveAndValidate()) {
        postParams = Map.from(_formKey.currentState!.value);
        String serviceId = "";

        if (signUpFlag) {
          serviceId = "register";
        } else {
          serviceId = verifyOTPFlag ? "ResendOtp" : "SendOTPforGeneratePIN";
        }
        postParams[key_service_id] = serviceId;
        var response;
        try {
          Utils().showProgress(context, 1);
          response = await model.overAllMainService(context, postParams);
          _startListeningSms();
        } catch (e) {
          Utils().showToast(context, "Fail", "W");
        } finally {
          Utils().hideProgress(context);
        }

        if (response != null && response.isNotEmpty) {
          if (response[key_status].toString() == key_success && response[key_response].toString() == key_success) {
            utils.showToast(context, 'otp_resent_success'.tr().toString(), "S");
            registerStep++;
            setState(() {});
            changeImageAndAnimate();
          } else if (response[key_status].toString() == key_success && response[key_response].toString() == key_fail) {
            await utils.showAlert(context, ContentType.fail, getErrorMessage(response[key_message].toString()));
            String flag = response['flag'] ?? '';
            if (flag == 'N') {
              verifyOTPFlag = true;
              titleText = "verifyOTP".tr();
            } else if (flag == 'Y') {
              verifyOTPFlag = false;
              signUpFlag = false;
            }

            setState(() {});
          } else {
            utils.showAlert(context, ContentType.fail, getErrorMessage(response[key_message].toString()));
          }
        } else {
          utils.showAlert(context, ContentType.fail, getErrorMessage("failed".tr().toString()));
        }
      }
    } else if (registerStep == 2) {
      if (finalOTP.length == 6) {
        String serviceId = "";
        if (signUpFlag || verifyOTPFlag) {
          serviceId = "VerifyOtp";
        } else {
          serviceId = "VerifyOTPforGeneratePIN";
        }

        var sendData = {key_service_id: serviceId, key_mobile_number: postParams[key_mobile_number].toString(), "mobile_otp": finalOTP};
        var response;
        try {
          Utils().showProgress(context, 1);
          response = await model.overAllMainService(context, sendData);
        } catch (e) {
          Utils().showToast(context, "Fail", "W");
        } finally {
          Utils().hideProgress(context);
        }
        if (response != null && response.isNotEmpty) {
          if (response[key_status].toString() == key_success && response[key_response].toString() == key_success) {
            dynamic resData = response['DATA'];
            await preferencesService.setString("userId", resData['id'].toString());
            await preferencesService.setString(key_name, resData[key_name].toString());
            await preferencesService.setString(key_mobile_number, resData[key_mobile].toString());
            await preferencesService.setString(key_email, resData[key_email].toString());
            // await preferencesService.setString(key_gender, resData[key_gender].toString());
            registerStep++;
            setState(() {});
          } else {
            utils.showAlert(context, ContentType.fail, 'wrong_otp_msg'.tr().toString());
          }
        } else {
          utils.showAlert(context, ContentType.fail, getErrorMessage("failed".tr().toString()));
        }
      }
    } else if (registerStep == 3) {
      if (_SecretKey.currentState!.saveAndValidate()) {
        Map<String, dynamic> postkEYParams = Map.from(_SecretKey.currentState!.value);
        if (postkEYParams[key_secretKey].toString() == postkEYParams['confirm'].toString()) {
          await preferencesService.setString(key_secretKey, postkEYParams[key_secretKey].toString());
          if (signUpFlag) {
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
        UIHelper.titleTextStyle('set_your_SecretPin'.tr().toString(), c.text_color, fs.h4, true, false),
        UIHelper.verticalSpaceSmall,
        FormBuilder(
            key: _SecretKey,
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                child: Column(
                  children: [
                    addInputFormControl(key_secretKey, 'enter_your_SecretPin'.tr().toString(), key_number, isShowSuffixIcon: true),
                    UIHelper.verticalSpaceSmall,
                    addInputFormControl("confirm", 'confirm_pin'.tr().toString(), key_number, isShowSuffixIcon: true),
                  ],
                ))),
        UIHelper.verticalSpaceMedium
      ],
    );
  }
}
