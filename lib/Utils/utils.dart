// ignore_for_file: unused_local_variable, non_constant_identifier_names, file_names, camel_case_types, prefer_typing_uninitialized_variables, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, avoid_print, library_prefixes, use_build_context_synchronously, nullable_type_in_catch_clause

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:crypto/crypto.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:datetime_setting/datetime_setting.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:public_vptax/Activity/Auth/Splash.dart';
import 'package:public_vptax/Activity/Tax_Collection/payment_mode_view.dart';
import 'package:public_vptax/Layout/circle_loader.dart';
import 'package:public_vptax/Layout/screen_size.dart';
import 'package:public_vptax/Layout/ui_helper.dart';
import 'package:public_vptax/Resources/ColorsValue.dart' as c;
import 'package:public_vptax/Resources/StringsKey.dart' as s;
import 'package:public_vptax/Resources/ImagePath.dart' as imagePath;
import 'package:public_vptax/Services/Apiservices.dart';
import 'package:public_vptax/Services/Preferenceservices.dart';
import 'package:public_vptax/Services/atom_paynets_service.dart';
import 'package:public_vptax/Services/env.dart';
import 'package:public_vptax/Services/locator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Activity/Auth/Home.dart';
import '../Model/startup_model.dart';
import '../Resources/StringsKey.dart';
import '../Services/env.dart';
import '../Services/env.dart';
import '../Services/env.dart';
import 'ContentInfo.dart';

class Utils {
  PreferenceService preferencesService = locator<PreferenceService>();
  FS fs = locator<FS>();

  Future<bool> isOnline() async {
    bool online = false;
    try {
      final result = await InternetAddress.lookup('example.com');
      online = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      online = false;
    }
    return online;
  }

  Future<bool> isAutoDatetimeisEnable() async {
    bool isAutoDatetimeisEnable = false;

    if (Platform.isAndroid) {
      bool timeAuto = await DatetimeSetting.timeIsAuto();
      bool timezoneAuto = await DatetimeSetting.timeZoneIsAuto();
      timezoneAuto && timeAuto ? isAutoDatetimeisEnable = true : isAutoDatetimeisEnable = false;
    } else if (Platform.isIOS) {
      isAutoDatetimeisEnable = true;
    }
    return isAutoDatetimeisEnable;
  }

  launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<SecurityContext> get globalContext async {
    final sslCert1 = await rootBundle.load(imagePath.certificate);
    SecurityContext sc = SecurityContext(withTrustedRoots: false);
    sc.setTrustedCertificatesBytes(sslCert1.buffer.asInt8List());
    return sc;
  }

  Future<String> getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = "";
    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    return packageInfo.version;
  }

  Future<void> hideSoftKeyBoard(BuildContext context) async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  void showToast(BuildContext context, String msg, String type) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: type == "S" ? c.account_status_green_color : c.grey_10,
      content: UIHelper.titleTextStyle(msg, type == "S" ? c.white : c.white, fs.h3, true, false),
      duration: const Duration(seconds: 1),
    ));
  }

  loaderGif() {
    return SizedBox(
      height: 70,
      width: 70,
      child: CircleLoader(url: imagePath.loader_2),
    );
  }

  Future<void> showProgress(BuildContext context, int i) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Center(
            child: Container(
              decoration: UIHelper.roundedBorderWithColor(10, 10, 10, 10, c.white),
              height: Screen.width(context) / 3.5,
              width: Screen.width(context) / 3.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  UIHelper.horizontalSpaceSmall,
                  Center(child: loaderGif()),
                  //  UIHelper.verticalSpaceMedium,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(i == 1 ? 'loading'.tr().toString() : 'downloading'.tr().toString(), style: TextStyle(color: c.text_color, fontSize: fs.h4, decoration: TextDecoration.none)),
                      JumpingText("...", style: TextStyle(color: c.text_color, fontSize: fs.h4, decoration: TextDecoration.none)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> hideProgress(BuildContext context) async {
    Navigator.pop(context, true);
  }

  ui.ColorFilter? getColorFilter(Color? color, ui.BlendMode colorBlendMode) {
    return color == null ? null : ui.ColorFilter.mode(color, colorBlendMode);
  }

  Future<void> showAlert(BuildContext mcontext, ContentType contentType, String message,
      {String? title,
      String? btnCount,
      String? btnText,
      String? btnmsg,
      var receiptList,
      String? file_path,
      String? mobile,
      String? email,
      double? titleFontSize,
      double? messageFontSize,
      String? mode}) async {
    await showDialog<void>(
      context: mcontext,
      barrierDismissible: btnCount != null ? false : true, // user must tap button!
      builder: (BuildContext context) {
        // Size
        final size = MediaQuery.of(context).size;

        ContentInfo contentInfo = getContentInfo(contentType);

        final hsl = HSLColor.fromColor(contentInfo.color);
        final hslDark = hsl.withLightness((hsl.lightness - 0.1).clamp(0.0, 1.0));

        return WillPopScope(
            onWillPop: () async {
              return btnCount != null ? false : true;
            },
            child: Center(
              child: Container(
                width: size.width,
                height: size.width * 0.45,
                margin: EdgeInsets.symmetric(horizontal: size.width * 0.045),
                decoration: UIHelper.roundedBorderWithColorWithShadow(20, contentInfo.color, contentInfo.color),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    // ***********************  Bottom Splash Icon *********************** //

                    Positioned(
                      bottom: 0,
                      left: size.width * 0.001,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                        ),
                        child: SvgPicture.asset(
                          imagePath.bubbles,
                          height: size.height * 0.06,
                          width: size.width * 0.05,
                          colorFilter: getColorFilter(hslDark.toColor(), ui.BlendMode.srcIn),
                        ),
                      ),
                    ),

                    // ***********************  Bubble With Icon *********************** //
                    Positioned(
                      top: -size.height * 0.035,
                      left: size.width * 0.08,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SvgPicture.asset(
                            imagePath.back,
                            height: size.height * 0.08,
                            colorFilter: getColorFilter(hslDark.toColor(), ui.BlendMode.srcIn),
                          ),
                          Positioned(
                            top: size.height * 0.025,
                            child: SvgPicture.asset(
                              contentInfo.assetPath,
                              height: size.height * 0.022,
                            ),
                          )
                        ],
                      ),
                    ),

                    // ***********************  Text Content *********************** //

                    Positioned(
                      top: 25,
                      child: Text(
                        mode == "payment_success" ? '' : title ?? contentInfo.title,
                        style: UIHelper.textDecoration(titleFontSize ?? fs.h3, c.white, bold: true),
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(bottom: size.width * 0.05, left: size.width * 0.05, right: size.width * 0.05, top: size.width * 0.07),
                      child: Text(
                        message,
                        style: UIHelper.textDecoration(messageFontSize ?? fs.h3, c.white),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                    ),

                    // ***********************  Close Icon button *********************** //

                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () async {
                          if (btnmsg == 'payment') {
                            if (preferencesService.paymentType == "Favourite Pay") {
                              try {
                                Utils().showProgress(context, 1);
                                await StartUpViewModel().getDemandList(mcontext);
                              } catch (e) {
                                Utils().showToast(context, "failed".tr(), "W");
                              } finally {
                                Utils().hideProgress(context);
                              }
                            } else {
                              if (await preferencesService.getString(key_isLogin) == "yes") {
                                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const Home()), (route) => false);
                              } else {
                                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const Splash()), (route) => false);
                              }
                            }
                          } else if (btnmsg == 'canceled') {
                            if (preferencesService.paymentType == "Favourite Pay") {
                              try {
                                Utils().showProgress(context, 1);
                                await StartUpViewModel().getDemandList(mcontext);
                              } catch (e) {
                                Utils().showToast(context, "failed".tr(), "W");
                              } finally {
                                Utils().hideProgress(context);
                              }
                            } else {
                              if (await preferencesService.getString(key_isLogin) == "yes") {
                                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const Home()), (route) => false);
                              } else {
                                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const Splash()), (route) => false);
                              }
                            }
                          } else if (btnmsg == 'apk') {
                            launchURL(await preferencesService.getString(s.key_apk));
                          } else {
                            debugPrint("....");
                          }
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.close_rounded,
                            size: 20,
                            color: c.white,
                          ),
                        ),
                      ),
                    ),

                    // ***********************  Action Buttons Content *********************** //

                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Row(children: [
                        Visibility(
                          visible: btnCount == '1' || btnCount == '2' ? true : false,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (btnmsg == 'payment') {
                                  if (preferencesService.paymentType == "Favourite Pay") {
                                    try {
                                      Utils().showProgress(context, 1);
                                      await StartUpViewModel().getDemandList(mcontext);
                                    } catch (e) {
                                      Utils().showToast(context, "failed".tr(), "W");
                                    } finally {
                                      Utils().hideProgress(context);
                                    }
                                    Navigator.of(context).pop();
                                  } else {
                                    Navigator.of(context).pop();
                                    if (await preferencesService.getString(key_isLogin) == "yes") {
                                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const Home()), (route) => false);
                                    } else {
                                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const Splash()), (route) => false);
                                    }
                                  }
                                  await StartUpViewModel().getReceipt(mcontext, receiptList, 'payment', preferencesService.selectedLanguage);
                                } else if (btnmsg == 'receipt') {
                                  Navigator.of(context).pop();
                                } else if (btnmsg == 'canceled') {
                                  if (preferencesService.paymentType == "Favourite Pay") {
                                    try {
                                      Utils().showProgress(context, 1);
                                      await StartUpViewModel().getDemandList(mcontext);
                                    } catch (e) {
                                      Utils().showToast(context, "failed".tr(), "W");
                                    } finally {
                                      Utils().hideProgress(context);
                                    }
                                    Navigator.of(context).pop();
                                  } else {
                                    Navigator.of(context).pop();
                                    if (await preferencesService.getString(key_isLogin) == "yes") {
                                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const Home()), (route) => false);
                                    } else {
                                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const Splash()), (route) => false);
                                    }
                                  }
                                } else if (btnmsg == 'apk') {
                                  launchURL(await preferencesService.getString(s.key_apk));
                                  Navigator.of(context).pop();
                                } else {
                                  performAction(btnmsg ?? '', context);
                                }
                              },
                              style: ButtonStyle(
                                elevation: MaterialStateProperty.all(5.0),
                                backgroundColor: MaterialStateProperty.all(c.white),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0), // Set the desired border radius here
                                  ),
                                ),
                              ),
                              child: Text(
                                btnmsg == 'payment' ? 'view_receipt'.tr().toString() : btnText ?? 'ok'.tr().toString(),
                                style: TextStyle(color: contentInfo.color, fontSize: 11),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: btnCount == '2' ? true : false,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: ButtonStyle(
                                elevation: MaterialStateProperty.all(5.0),
                                backgroundColor: MaterialStateProperty.all(c.white),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0), // Set the desired border radius here
                                  ),
                                ),
                              ),
                              child: Text(
                                'Cancel',
                                style: TextStyle(color: contentInfo.color, fontSize: 11),
                              ),
                            ),
                          ),
                        ),
                      ]),
                    )
                  ],
                ),
              ),
            ));
      },
    );
  }

  performAction(String type, BuildContext context) async {
    const MethodChannel channel = OptionalMethodChannel('open_settings');
    Navigator.of(context).pop();
    switch (type) {
      case 'appSetting':
      // openAppSettings();

      case 'openLocation':
        await channel.invokeMethod('openSettings', 'location_source');

      case 'openDate':
        await channel.invokeMethod('openSettings', 'date');

      case 'internet':
        await channel.invokeMethod('openSettings', 'network_operator');

      case 'wifi':
        await channel.invokeMethod('openSettings', 'wifi');
    }
  }

  String encryption(String plainText, String ENCRYPTION_KEY) {
    String ENCRYPTION_IV = '2SN22SkJGDyOAXUU';
    final key = encrypt.Key.fromUtf8(fixKey(ENCRYPTION_KEY));
    final iv = encrypt.IV.fromUtf8(ENCRYPTION_IV);
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return "${encrypted.base64}:${iv.base64}";
  }

  String decryption(String plainText, String ENCRYPTION_KEY) {
    final dateList = plainText.split(":");
    final key = encrypt.Key.fromUtf8(fixKey(ENCRYPTION_KEY));
    final iv = encrypt.IV.fromBase64(dateList[1]);
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'));
    final decrypted = encrypter.decrypt(encrypt.Encrypted.from64(dateList[0]), iv: iv);
    return decrypted;
  }

  String fixKey(String key) {
    if (key.length < 16) {
      int numPad = 16 - key.length;
      for (int i = 0; i < numPad; i++) {
        key += "0"; //0 pad to len 16 bytes
      }
      return key;
    }
    if (key.length > 16) {
      return key.substring(0, 16); //truncate to 16 bytes
    }
    return key;
  }

  void closeKeypad(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  bool isNumberValid(value) {
    return RegExp(r'^[6789]\d{9}$').hasMatch(value);
  }

  bool isEmailValid(value) {
    return RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(value);
  }

  String generateHmacSha256(String message, String S_key, bool flag) {
    String hashData = "";
    var key = utf8.encode(S_key);
    var jsonData = utf8.encode(message);
    var hmacSha256 = Hmac(sha256, key);
    var digest = hmacSha256.convert(jsonData);
    hashData = digest.toString();
    if (flag) {
      String encodedhashData = base64.encode(utf8.encode(hashData));
      return encodedhashData;
    }
    return hashData;
  }

  String jwt_Encode(String secretKey, String userName, String encodedhashData) {
    String token = "";
    DateTime currentTime = DateTime.now();
    DateTime expirationTime = currentTime.add(const Duration(minutes: 20));
    String exp = (expirationTime.millisecondsSinceEpoch / 1000).toString();
    Map payload = {"exp": exp, "signature": encodedhashData};
    final jwt = JWT(payload, issuer: "tnrd.tn.gov.in");
    token = jwt.sign(SecretKey(secretKey));
    debugPrint('Signed token: Bearer $token\n');
    return token;
  }

  String encodeBase64(String data) {
    String encoded = "";
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    encoded = stringToBase64.encode(data); // dXNlcm5hbWU6cGFzc3dvcmQ=
    String decoded = stringToBase64.decode(encoded);
    return encoded;
  }

  String decodeBase64(String data) {
    String decoded = "";
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    decoded = stringToBase64.decode(data);
    return decoded;
  }

  String jwt_Decode(String secretKey, String jwtToken) {
    String signature = "";
    try {
      final jwt = JWT.verify(jwtToken, SecretKey(secretKey));
      Map<String, dynamic> headerJWT = jwt.payload;
      String head_sign = headerJWT['signature'];
      List<int> bytes = base64.decode(head_sign);
      signature = utf8.decode(bytes);
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
    return signature;
  }

  Future<void> apiCalls(BuildContext context) async {
    try {
      await StartUpViewModel().getOpenServiceList(service_key_district_list_all, context);
      await StartUpViewModel().getOpenServiceList(service_key_block_list_all, context);
      await StartUpViewModel().getOpenServiceList(service_key_village_list_all, context);
      await StartUpViewModel().getMainServiceList("TaxType", context);
      await StartUpViewModel().getMainServiceList("FinYear", context);
      await StartUpViewModel().getMainServiceList("PaymentTypeList", context);
      await StartUpViewModel().getMainServiceList("GatewayList", context);
    } catch (error) {
      debugPrint('error (${error.toString()}) has been caught');
    }
  }

  //Atom Paynets Gateway HTML Page Renger
  Future<void> openNdpsPG(mcontext, String atomTokenId, String merchId, String emailId, String mobileNumber) async {
    String mode = "";
    String returnUrl = "";
    if (preferencesService.buildMode == "Local") {
      mode = Env.modeLocal;
      returnUrl = Env.returnUrlLocal;
    } else {
      mode = Env.modeLive;
      returnUrl = Env.returnUrlLive; ////return url production
    }

    Map payDetails = {key_atomTokenId: atomTokenId, key_merchId: merchId, key_emailId: emailId, key_mobileNumber: mobileNumber, key_returnUrl: returnUrl};
    Navigator.push(mcontext, MaterialPageRoute(builder: (context) => AtomPaynetsView(mode, json.encode(payDetails), mcontext, emailId, mobileNumber)));
  }

  String getDemadAmount(taxData, String taxTypeId) {
    String amount = "";
    switch (taxTypeId) {
      case '1':
        amount = taxData['demand'].toString();
        break;
      case '2':
        amount = taxData['watercharges'].toString();
        break;
      case '4':
        amount = taxData['profession_tax'].toString();
        break;
      case '5':
        amount = taxData['nontax_amount'].toString();
        break;
      case '6':
        amount = taxData['traders_rate'].toString();
        break;
    }
    return amount;
  }

  String getPaymentTokenDemandId(String taxTypeId) {
    String id = '';

    switch (taxTypeId) {
      case '1':
        id = 'property_demand_id';
        break;
      case '2':
        id = 'water_demand_details';
        break;
      case '4':
        id = 'professional_demand_id';
        break;
      case '5':
        id = 'non_demand_id';
        break;
      case '6':
        id = 'trade_demand_id';
        break;
    }

    return id;
  }

  String getDemandId(taxData, String taxTypeId) {
    String demandId = "";
    switch (taxTypeId) {
      case '1':
        demandId = taxData['demandid'].toString();
        break;
      case '2':
        demandId = taxData['wtdemandid'].toString();
        break;
      case '4':
        demandId = taxData['assesmentdemandid'].toString();
        break;
      case '5':
        demandId = taxData['assessment_demand_id'].toString();
        break;
      case '6':
        demandId = taxData['assessment_demand_id'].toString();
        break;
    }

    // taxData[rowIndex][key_demand].toString();
    return demandId;
  }

  Future<void> settingModalBottomSheet(BuildContext context, List finalList, String payType) async {
    preferencesService.paymentType = payType;
    print("finalList" + finalList.toString());
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: c.full_transparent,
        builder: (BuildContext bc) {
          return PaymentGateWayView(dataList: finalList, mcContext: context);
        });
  }

// *************** Village Name Get Widget ***********
  String getvillageAndBlockName(dynamic getData) {
    String street = "";
    street = ((getData[key_localbody_name] ?? '') + ", " + (getData[key_bname] ?? ''));
    return street;
  }

// *************** Door Number and Street Get Widget ***********
  String getDoorAndStreetName(dynamic getData, String selectedLang) {
    String street = "";
    switch (getData[key_taxtypeid].toString()) {
      case '1':
        street = getData['doorno'] != null && getData['doorno'].toString().isNotEmpty
            ? "${getData['doorno']}, "
            : "" + (selectedLang == 'en' ? (getData[key_street_name_en] ?? '') : (getData[key_street_name_ta] ?? ''));
        break;
      case '2':
        street = (getData["street_name"] ?? '');
        break;
      case '4':
        street = getData['doorno'] != null && getData['doorno'].toString().isNotEmpty ? "${getData['doorno']}, " : "" + (getData["street_name_t"] ?? '');
        break;
      case '5':
        street = getData['doorno'] != null && getData['doorno'].toString().isNotEmpty ? "${getData['doorno']}, " : "" + (getData["street_name"] ?? '');
        break;
      case '6':
        street = selectedLang == 'en' ? (getData["street_name_en"] ?? '') : (getData["street_name_ta"] ?? '');
        break;
    }
    return street;
  }

  Widget taxWiseReturnDataWidget(dynamic getData, Color clr) {
    String taxTypeId = getData[key_taxtypeid].toString();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UIHelper.verticalSpaceTiny,
        UIHelper.titleTextStyle(("${'vptax_id'.tr()} : ${getData[key_assessment_id].toString()}"), clr, fs.h5, false, true),
        UIHelper.verticalSpaceTiny,
        if (taxTypeId == "1") UIHelper.titleTextStyle(("${'assesment_number'.tr()} : ${getData[key_assessment_no].toString()}"), clr, fs.h5, false, true),
        if (taxTypeId == "2") UIHelper.titleTextStyle(("${'water_connection_number'.tr()} : ${getData[key_assessment_no].toString()}"), clr, fs.h5, false, true),
        if (taxTypeId == "4") UIHelper.titleTextStyle(("${'financialYear'.tr()} : ${getData['financialyear'].toString()}"), clr, fs.h5, false, true),
        if (taxTypeId == "4") UIHelper.verticalSpaceTiny,
        if (taxTypeId == "4") UIHelper.titleTextStyle(("${'assesment_number'.tr()} : ${getData[key_assessment_no].toString()}"), clr, fs.h5, false, true),
        if (taxTypeId == "5") UIHelper.titleTextStyle(("${'lease_number'.tr()} : ${getData[key_assessment_no].toString()}"), clr, fs.h5, false, true),
        if (taxTypeId == "6") UIHelper.titleTextStyle(("${'traders_code'.tr()} : ${getData[key_assessment_no].toString()}"), clr, fs.h5, false, true),
        UIHelper.verticalSpaceTiny,
      ],
    );
  }

  getResponsiveFontSize(BuildContext context, double screenWidth) {
    if (screenWidth < 400) {
      //Responsive For Smart Mobile Device Size
      fs.h1 = preferencesService.selectedLanguage == "ta" ? 18 : 20;
      fs.h2 = preferencesService.selectedLanguage == "ta" ? 16 : 18;
      fs.h3 = preferencesService.selectedLanguage == "ta" ? 14 : 16;
      fs.h4 = preferencesService.selectedLanguage == "ta" ? 12 : 14;
      fs.h5 = preferencesService.selectedLanguage == "ta" ? 11 : 13;
      fs.h6 = preferencesService.selectedLanguage == "ta" ? 10 : 12;
    } else if (screenWidth < 600) {
      //Responsive For Common Mobile Device Size
      fs.h1 = preferencesService.selectedLanguage == "ta" ? 20 : 18;
      fs.h2 = preferencesService.selectedLanguage == "ta" ? 18 : 16;
      fs.h3 = preferencesService.selectedLanguage == "ta" ? 16 : 14;
      fs.h4 = preferencesService.selectedLanguage == "ta" ? 14 : 12;
      fs.h5 = preferencesService.selectedLanguage == "ta" ? 13 : 14;
      fs.h6 = preferencesService.selectedLanguage == "ta" ? 12 : 13;
    } else if (screenWidth < 1200) {
      //Responsive For Tablet Device Size
      fs.h1 = preferencesService.selectedLanguage == "ta" ? 22 : 20;
      fs.h2 = preferencesService.selectedLanguage == "ta" ? 20 : 18;
      fs.h3 = preferencesService.selectedLanguage == "ta" ? 18 : 16;
      fs.h4 = preferencesService.selectedLanguage == "ta" ? 16 : 14;
      fs.h5 = preferencesService.selectedLanguage == "ta" ? 15 : 16;
      fs.h6 = preferencesService.selectedLanguage == "ta" ? 13 : 14;
    } else {
      // Responsive For Desktop Size
      fs.h1 = preferencesService.selectedLanguage == "ta" ? 24 : 22;
      fs.h2 = preferencesService.selectedLanguage == "ta" ? 22 : 20;
      fs.h3 = preferencesService.selectedLanguage == "ta" ? 20 : 18;
      fs.h4 = preferencesService.selectedLanguage == "ta" ? 18 : 16;
      fs.h5 = preferencesService.selectedLanguage == "ta" ? 17 : 18;
      return null;
    }
  }
}
