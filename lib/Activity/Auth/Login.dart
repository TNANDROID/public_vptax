// ignore_for_file: unused_local_variable, non_constant_identifier_names, file_names, camel_case_types, prefer_typing_uninitialized_variables, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, avoid_print, library_prefixes, prefer_const_constructors, prefer_interpolation_to_compose_strings, use_build_context_synchronously, avoid_unnecessary_containers, no_leading_underscores_for_local_identifiers

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:public_vptax/Layout/customgradientbutton.dart';
import 'package:public_vptax/Layout/screen_size.dart';
import 'package:public_vptax/Layout/ui_helper.dart';
import 'package:public_vptax/Resources/ColorsValue.dart' as c;
import 'package:public_vptax/Resources/ImagePath.dart' as imagepath;
// import 'package:public_vptax/Resources/StringsKey.dart' as s;
import 'package:public_vptax/Services/Apiservices.dart';
import 'package:public_vptax/Services/Preferenceservices.dart';
import 'package:public_vptax/Services/locator.dart';
import 'package:public_vptax/Utils/utils.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => LoginState();
}

class LoginState extends State<Login> with TickerProviderStateMixin {
  Utils utils = Utils();
  ApiServices apiServices = ApiServices();
  PreferenceService preferencesService = locator<PreferenceService>();
  TextEditingController mobileController = TextEditingController();
  OtpFieldController OTPcontroller = OtpFieldController();

  //String values
  String finalOTP = '';

  //Bool Variables
  bool otpFlag = false;

  late AnimationController _rightToLeftAnimController;
  late Animation<Offset> _rightToLeftAnimation;

  @override
  void initState() {
    super.initState();

    _rightToLeftAnimController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));

    _rightToLeftAnimation = Tween<Offset>(
            begin: otpFlag ? Offset.zero : Offset(1.0, 0.0),
            end: const Offset(0.0, 0.0))
        .animate(CurvedAnimation(
            parent: _rightToLeftAnimController, curve: Curves.easeInOut));

    initialize();
  }

  @override
  void dispose() {
    _rightToLeftAnimController.dispose();
    super.dispose();
  }

  Future<void> initialize() async {}

  Future<void> onBackpress() async {
    if (otpFlag) {
      otpFlag = !otpFlag;
      changeImageAndAnimate();
    } else {
      Navigator.of(context).pop();
    }
  }

  void changeImageAndAnimate() {
    setState(() {
      if (otpFlag) {
        _rightToLeftAnimController.forward();
      } else {
        _rightToLeftAnimController.reverse();
      }
    });
  }

  Future<void> validate() async {
    // Get OTP
    if (!otpFlag) {
      print('mobileController.text: ${mobileController.text}');
      if (utils.isNumberValid(mobileController.text)) {
        otpFlag = !otpFlag;
        changeImageAndAnimate();
      }
    } else {
      print('finalOTP: $finalOTP');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // ****************************** Background Color alone Field ****************************** //

              Container(
                  width: Screen.width(context),
                  height: Screen.height(context),
                  color: c.white),

              // ****************************** Upper Card Image Design Field ****************************** //

              Visibility(
                visible: !otpFlag,
                child: Positioned(
                  top: 0,
                  child: SizedBox(
                    width: Screen.width(context),
                    height: Screen.height(context) / 2,
                    child: Image.asset(
                      imagepath.loginEnc,
                      fit: BoxFit.cover,
                      height: 100,
                      width: 100,
                    ),
                  ),
                ),
              ),

              Visibility(
                visible: otpFlag,
                child: Positioned(
                  top: 0,
                  child: AnimatedBuilder(
                    animation: _rightToLeftAnimation,
                    builder: (context, child) {
                      return SlideTransition(
                        position: _rightToLeftAnimation,
                        child: SizedBox(
                          width: Screen.width(context),
                          height: Screen.height(context) / 2,
                          child: Image.asset(
                            imagepath.loginPass,
                            fit: BoxFit.cover,
                            height: 100,
                            width: 100,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // ****************************** Log in Field ****************************** //

              Positioned(
                bottom: 0,
                child: CustomGradientButton(
                  width: Screen.width(context),
                  height: (Screen.height(context) / 2) + 16,
                  btnPadding: 0,
                  topleft: 50,
                  topright: 50,
                  gradientColors: [c.colorPrimary, c.colorAccentveryverylight2],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin:
                            EdgeInsets.only(top: Screen.width(context) * 0.07),
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
                      Container(
                        margin: EdgeInsets.only(
                            top: Screen.width(context) * 0.08,
                            right: Screen.width(context) * 0.08),
                        child: Text(
                          'signIN'.tr().toString(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox()
                    ],
                  ),
                ),
              ),

              // ****************************** Log in Field ****************************** //

              Positioned(
                bottom: 0,
                child: Container(
                    margin:
                        EdgeInsets.only(bottom: Screen.height(context) * 0.02),
                    width: Screen.width(context) - 50,
                    height: Screen.width(context) - 50,
                    decoration: UIHelper.roundedBorderWithColorWithShadow(
                        30.0, c.white, c.white),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(),

                        // ****************************** Mobile Number Field ****************************** //
                        Container(
                          margin: EdgeInsets.all(15),
                          width: Screen.width(context) - 100,
                          height: 50,
                          child: IgnorePointer(
                            ignoring: otpFlag,
                            child: FormBuilderTextField(
                              name: 'mobile',
                              textAlign: TextAlign.center,
                              controller: mobileController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                              ],
                              decoration: InputDecoration(
                                labelText: 'Mobile Number',
                                labelStyle: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                                hintText: 'Mobile Number',
                                hintStyle: TextStyle(fontSize: 16),
                                enabledBorder: UIHelper.getInputBorder(1,
                                    borderColor: c.grey_7),
                                focusedBorder: UIHelper.getInputBorder(1,
                                    borderColor: c.grey_7),
                                filled: true,
                                contentPadding: EdgeInsets.all(16),
                                fillColor: c.inputGrey,
                              ),
                            ),
                          ),
                        ),

                        // ****************************** OTP verification Field ****************************** //

                        Visibility(
                          visible: otpFlag,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 10),
                                child: OTPTextField(
                                  onChanged: (pin) {
                                    print("Changed: " + pin);
                                  },
                                  onCompleted: (pin) {
                                    utils.closeKeypad(context);
                                    finalOTP = pin;
                                  },
                                  width: Screen.width(context) - 100,
                                  controller: OTPcontroller,
                                  length: 6,
                                  fieldStyle: FieldStyle.box,
                                  fieldWidth: 40,
                                ),
                              ),
                              Container(
                                width: Screen.width(context) - 100,
                                margin: EdgeInsets.only(right: 5),
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "{ ${'resendOTP'.tr().toString()} }",
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: c.primary_text_color2,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),

                        // ****************************** Submit Action Field ****************************** //

                        CustomGradientButton(
                          onPressed: () async {
                            await validate();
                          },
                          width: Screen.width(context) - 100,
                          height: 50,
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              otpFlag
                                  ? 'verifyOTP'.tr().toString()
                                  : 'getOTP'.tr().toString(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        // Visibility(
                        //   visible: false,
                        //   child: Column(children: [
                        //     Text(
                        //       'signupText'.tr().toString(),
                        //       style: TextStyle(
                        //         color: c.text_color,
                        //         fontSize: 16,
                        //       ),
                        //     ),
                        //     UIHelper.verticalSpaceSmall,
                        //     InkWell(
                        //       onTap: () => {print("Sign in Tapped ")},
                        //       child: Text(
                        //         'signUP'.tr().toString(),
                        //         style: TextStyle(
                        //           color: c.sky_blue,
                        //           fontSize: 16,
                        //         ),
                        //       ),
                        //     ),
                        //   ]),
                        // ),
                        SizedBox()
                      ],
                    )),
              ),

              // ****************************** Center Logo Card Design Field ****************************** //

              // Positioned(
              //   child: Text(
              //     'signIN'.tr().toString(),
              //     style: TextStyle(
              //       fontSize: 32.0,
              //       fontWeight: FontWeight.bold,
              //       color: c.white,
              //       fontStyle: FontStyle.normal,
              //       decorationStyle: TextDecorationStyle.wavy,
              //     ),
              //   ),
              // )
            ],
          ),
        ));
  }
}
