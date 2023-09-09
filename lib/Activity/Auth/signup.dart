// ignore_for_file: unused_local_variable, non_constant_identifier_names, file_names, camel_case_types, prefer_typing_uninitialized_variables, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, avoid_print, library_prefixes, prefer_const_constructors, prefer_interpolation_to_compose_strings, use_build_context_synchronously, avoid_unnecessary_containers, no_leading_underscores_for_local_identifiers

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:public_vptax/Layout/custom_otp_field.dart';
import 'package:public_vptax/Layout/customgradientbutton.dart';
import 'package:public_vptax/Layout/screen_size.dart';
import 'package:public_vptax/Layout/ui_helper.dart';
import 'package:public_vptax/Resources/ColorsValue.dart' as c;
import 'package:public_vptax/Resources/ImagePath.dart' as imagepath;
import 'package:public_vptax/Resources/StringsKey.dart';
import 'package:public_vptax/Services/Apiservices.dart';
import 'package:public_vptax/Services/Preferenceservices.dart';
import 'package:public_vptax/Services/locator.dart';
import 'package:public_vptax/Utils/ContentInfo.dart';
import 'package:public_vptax/Utils/utils.dart';

class SignUpView extends StatefulWidget {
  @override
  State<SignUpView> createState() => SignUpStateView();
}

class SignUpStateView extends State<SignUpView> with TickerProviderStateMixin {
  Utils utils = Utils();
  ApiServices apiServices = ApiServices();
  PreferenceService preferencesService = locator<PreferenceService>();
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> _SecretKey = GlobalKey<FormBuilderState>();
  OtpFieldController OTPcontroller = OtpFieldController();
  late Animation<Offset> _rightToLeftAnimation;
  late AnimationController _rightToLeftAnimController;

  int registerStep = 1;
  String finalOTP = '';
  bool isValidOtp = true;
  String secretKey = '';
  bool secretKeyIsValid = true;
  List secureFields = [];

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

  onBackpress() async {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              // ****************************** Background Color alone Field ****************************** //

              CustomGradientButton(
                width: Screen.width(context),
                height: Screen.height(context) - 40,
                topleft: 0,
                topright: 0,
                btmleft: 0,
                btmright: 0,
                btnPadding: 0,
              ),

              // ****************************** Upper Card Image Design Field ****************************** //

              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(top: Screen.width(context) * 0.07, left: Screen.width(context) * 0.07),
                    child: InkWell(
                      onTap: () {
                        onBackpress();
                      },
                      child: Icon(
                        Icons.arrow_circle_left_outlined,
                        size: 30,
                        color: c.white,
                      ),
                    ),
                  ),
                  Visibility(
                      visible: registerStep == 1,
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
                  UIHelper.titleTextStyle('signUP', c.white, 25, true, true)
                ],
              ),

              // ****************************** Log in Field ****************************** //

              Positioned(
                bottom: 0,
                child: Container(
                    margin: EdgeInsets.only(bottom: Screen.height(context) * 0.02),
                    width: Screen.width(context) - 50,
                    // height: Screen.width(context),
                    padding: EdgeInsets.all(15),
                    decoration: UIHelper.roundedBorderWithColorWithShadow(30.0, c.white, c.white),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (registerStep == 1) formControls(context),
                        if (registerStep == 2) otpControls(),
                        if (registerStep == 3) appKeyControls(),
                        // ****************************** Submit Action Field ****************************** //
                        CustomGradientButton(
                          onPressed: () async {
                            if (registerStep == 1) {
                              if (_formKey.currentState!.saveAndValidate()) {
                                Map<String, dynamic> postParams = Map.from(_formKey.currentState!.value);
                                preferencesService.setUserInfo(key_mobile_number, postParams['mobile']);
                                print("postParams----" + postParams.toString());
                                registerStep++;
                                changeImageAndAnimate();
                              }
                            } else if (registerStep == 2) {
                              if (finalOTP.length == 6) {
                                print("finalOTP----" + finalOTP.toString());
                                registerStep++;
                                setState(() {});
                              }
                            } else if (registerStep == 3) {
                              if (_SecretKey.currentState!.saveAndValidate()) {
                                Map<String, dynamic> postParams = Map.from(_SecretKey.currentState!.value);
                                if (postParams['secretKey'].toString() == postParams['confirm'].toString()) {
                                  print("postParams----" + postParams.toString());
                                } else {
                                  utils.showAlert(context, ContentType.warning, "Your Secret PIN does not match");
                                }
                              }
                            } else {
                              debugPrint("End of the Statement....");
                            }
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
                    )),
              ),
            ],
          ),
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
        UIHelper.verticalSpaceMedium,
        FormBuilder(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              addInputFormControl('name', 'name'.tr().toString(), "text"),
              UIHelper.verticalSpaceSmall,
              addInputFormControl('mobile', 'mobileNumber'.tr().toString(), key_mobile_number),
              UIHelper.verticalSpaceSmall,
              addInputFormControl('emailAddress', 'emailAddress'.tr().toString(), key_email_id),
              UIHelper.verticalSpaceMedium,
            ],
          ),
        ),
      ],
    );
  }

// ************* Input Field Widget ********************* \\
  Widget addInputFormControl(String nameField, String hintText, String fieldType, {bool isShowSuffixIcon = false}) {
    return FormBuilderTextField(
      style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, color: c.grey_9),
      obscureText: secureFields.contains(nameField) ? true : false,
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
                        Icons.visibility,
                        size: 25,
                        color: c.grey_6,
                      )
                    : Icon(
                        Icons.visibility_off,
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
    );
  }

// ************* OTP Form Control *********************** \\
  Widget otpControls() {
    return Column(
      children: [
        UIHelper.titleTextStyle("Your Mobile Number has been Received the OTP", c.text_color, 12, true, false),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: CustomOTP(
                length: 6,
                onChanged: (pin) {
                  if (pin.length == 6) {
                    finalOTP = pin;
                    isValidOtp = true;
                  } else {
                    isValidOtp = false;
                    finalOTP = "";
                  }

                  setState(() {});
                })),
        if (!isValidOtp) UIHelper.titleTextStyle("InValid OTP", c.red_new, 10, true, false),
        Container(
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
        ),
        UIHelper.verticalSpaceMedium
      ],
    );
  }

// ************* OTP Form Control *********************** \\
  Widget appKeyControls() {
    return Column(
      children: [
        UIHelper.titleTextStyle("Enter Your Secrect PIN", c.text_color, 14, true, false),
        UIHelper.verticalSpaceSmall,
        FormBuilder(
            key: _SecretKey,
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                child: Column(
                  children: [
                    addInputFormControl("secretKey", "Enter Your 4 digit PIN", key_number, isShowSuffixIcon: true),
                    UIHelper.verticalSpaceSmall,
                    addInputFormControl("confirm", "Confirm Your PIN", key_number, isShowSuffixIcon: true),
                  ],
                ))),
        if (!secretKeyIsValid) UIHelper.titleTextStyle("InValid PIN", c.red_new, 10, true, false),
        UIHelper.verticalSpaceMedium
      ],
    );
  }
}
