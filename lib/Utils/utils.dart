// ignore_for_file: unused_local_variable, non_constant_identifier_names, file_names, camel_case_types, prefer_typing_uninitialized_variables, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, avoid_print, library_prefixes, use_build_context_synchronously, nullable_type_in_catch_clause

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:open_file/open_file.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:public_vptax/Activity/Payments/atom_paynets_gateway.dart';
import 'package:public_vptax/Services/Preferenceservices.dart';
import 'package:public_vptax/Services/locator.dart';
import 'package:public_vptax/Layout/ui_helper.dart';
import 'package:public_vptax/Resources/ImagePath.dart' as imagePath;
import 'package:public_vptax/Resources/ColorsValue.dart' as c;
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui' as ui;
import '../Activity/Auth/Home.dart';
import '../Activity/Auth/Pdf_Viewer.dart';
import '../Model/startup_model.dart';
import '../Model/transaction_model.dart';
import '../Resources/StringsKey.dart';
import 'ContentInfo.dart';
import '../../Services/Apiservices.dart';

class Utils {
  PreferenceService preferencesService = locator<PreferenceService>();

  Future<bool> isOnline() async {
    bool online = false;
    try {
      final result = await InternetAddress.lookup('example.com');
      online = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      print('Connection Available!');
    } on SocketException catch (_) {
      online = false;
      print('No internet!');
    }
    return online;
  }

  bool isPasswordValid(value) {
    return RegExp("^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#%^&+=])(?=\\S+).{4,}").hasMatch(value);
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

  void showToast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: UIHelper.titleTextStyle(msg, c.white, 13, true, false),
      duration: const Duration(seconds: 1),
      action: SnackBarAction(
        label: 'ACTION',
        onPressed: () {},
      ),
    ));
  }

  Future<void> showProgress(BuildContext context, int i) async {
    i == 1 ? showLoading(context, 'loading'.tr().toString()) : showLoading(context, 'downloading'.tr().toString());
  }

  Future<void> hideProgress(BuildContext context) async {
    Navigator.pop(context, true);
  }

  Future<void> showLoading(BuildContext context, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Center(
            child: SizedBox(
              height: 100,
              width: 100,
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Image.asset(
                          imagePath.spinner,
                          height: 70,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      UIHelper.titleTextStyle(message, c.card1, 12, true, false)
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

  Color getDarkerColor(Color color) {
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - 0.1).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  ui.ColorFilter? getColorFilter(Color? color, ui.BlendMode colorBlendMode) {
    return color == null ? null : ui.ColorFilter.mode(color, colorBlendMode);
  }

  Future<void> showAlert(BuildContext mcontext, ContentType contentType, String message,
      {String? title, String? btnCount, String? btnmsg, var receiptList, String? file_path, String? mobile, String? email, double? titleFontSize, double? messageFontSize}) async {
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
              return false;
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
                        title ?? contentInfo.title,
                        style: UIHelper.textDecoration(titleFontSize ?? 14, c.white, bold: true),
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(bottom: size.width * 0.05, left: size.width * 0.05, right: size.width * 0.05, top: size.width * 0.07),
                      child: Text(
                        message,
                        style: UIHelper.textDecoration(messageFontSize ?? 14, c.white),
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
                          Navigator.of(context).pop();
                          if (btnmsg == 'payment') {
                            getReceipt(mcontext, receiptList);
                          } else if (btnmsg == 'receipt') {
                            openFilePath(file_path!);
                          }else if (btnmsg == 'canceled') {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Home(
                                      isLogin: false,
                                    )),
                                    (route) => false);
                          }
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
                                  Navigator.of(context).pop();
                                  getReceipt(mcontext, receiptList);
                                } else if (btnmsg == 'receipt') {
                                  Navigator.of(context).pop();
                                  openFilePath(file_path!);
                                }else if (btnmsg == 'canceled') {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Home(
                                            isLogin: false,
                                          )),
                                          (route) => false);
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
                                btnmsg == 'payment' ? 'View Receipt' : 'OK',
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

  Future<void> getReceipt(BuildContext mcontext, receiptList) async {
    String selectedLang = await preferencesService.getUserInfo("lang");
    var receiptRequestData = {
      key_service_id: service_key_GetReceipt,
      key_receipt_id: receiptList[key_receipt_id].toString(),
      key_receipt_no: receiptList[key_receipt_no].toString(),
      key_taxtypeid: receiptList[key_taxtypeid].toString(),
      key_state_code: receiptList[key_state_code].toString(),
      key_dcode: receiptList[key_dcode].toString(),
      key_bcode: receiptList[key_bcode].toString(),
      key_pvcode: receiptList[key_lbcode].toString(),
      key_language_name: selectedLang
    };
    var GetReceiptList = {key_data_content: receiptRequestData};

    var response = await ApiServices().mainServiceFunction(GetReceiptList);
    print('response>>: ${response}');
    if (response[key_status] == key_success && response[key_response] == key_success) {
      var receiptResponce = response[key_data];
      var pdftoString = receiptResponce[key_receipt_content];
      Uint8List? pdf = const Base64Codec().decode(pdftoString);
      Navigator.of(mcontext).push(
        MaterialPageRoute(
            builder: (context) => PDF_Viewer(
                  pdfBytes: pdf,
                  flag: 'payment',
                )),
      );
    } else {
      Utils().showAlert(mcontext, ContentType.fail, response[key_message]);
    }
  }

  void openFilePath(String path) async {
    final result = await OpenFile.open(path);
  }

  performAction(String type, BuildContext context) async {
    const MethodChannel channel = MethodChannel('open_settings');
    switch (type) {
      case 'ok':
        Navigator.of(context).pop();

      case 'appSetting':
        openAppSettings();

      case 'openLocation':
        await channel.invokeMethod('openSettings', 'location_source');

      case 'openDate':
        await channel.invokeMethod('openSettings', 'date');

      case 'internet':
        await channel.invokeMethod('openSettings', 'network_operator');

      case 'wifi':
        await channel.invokeMethod('openSettings', 'wifi');

      default:
        Navigator.of(context).pop();
    }
  }

  String notNullString(String text) {
    if (text == "" || text == "null") {
      return "";
    } else {
      return text;
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
    print("Final Result: $decrypted");

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

  String getSha256(String value1, String user_password) {
    String value = textToMd5(user_password) + value1;
    var bytes = utf8.encode(value);
    return sha256.convert(bytes).toString();
  }

  String textToMd5(String text) {
    var bytes = utf8.encode(text);
    Digest md5Result = md5.convert(bytes);
    return md5Result.toString();
  }

  String generateRandomString(int length) {
    final random = Random();
    const availableChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final randomString = List.generate(length, (index) => availableChars[random.nextInt(availableChars.length)]).join();

    return randomString;
  }

  String checkNull(dynamic value) {
    return value == null ? '' : value.toString();
  }

  String splitStringByLength(String str, int length) {
    String streetname = '';

    for (int i = 0; i < str.length; i++) {
      if (i == (length + 1) || i == (length + 1) * 2 || i == (length + 1) * 3) {
        streetname += "\n${str[i]}";
      } else {
        streetname += str[i];
      }
    }

    return streetname;
  }

  void closeKeypad(BuildContext context) {
    // Unfocus the current focus node to close the keypad
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

    DateTime expirationTime = currentTime.add(const Duration(seconds: 20));

    String exp = (expirationTime.millisecondsSinceEpoch / 1000).toString();

    Map payload = {
      "exp": exp,
      "signature": encodedhashData,
    };

    final jwt = JWT(payload, issuer: "tnrd.tn.gov.in");

    token = jwt.sign(SecretKey(secretKey));

    print('Signed token: Bearer $token\n');

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
      // Verify a token
      final jwt = JWT.verify(jwtToken, SecretKey(secretKey));

      Map<String, dynamic> headerJWT = jwt.payload;

      String head_sign = headerJWT['signature'];

      List<int> bytes = base64.decode(head_sign);

      signature = utf8.decode(bytes);
    } on Exception catch (e) {
      print(e);
    }

    return signature;
  }

  Future<void> apiCalls(BuildContext context) async {
    try {
      await StartUpViewModel().getOpenServiceList("District");
      await StartUpViewModel().getOpenServiceList("Block");
      await StartUpViewModel().getOpenServiceList("Village");
      await StartUpViewModel().getMainServiceList("TaxType", context: context);
      await StartUpViewModel().getMainServiceList("FinYear", context: context);
      await StartUpViewModel().getMainServiceList("PaymentTypeList", dcode: "1", bcode: "1", pvcode: "1", context: context);
      await StartUpViewModel().getMainServiceList("GatewayList", context: context);
      // throw ('000');
    } catch (error) {
      print('error (${error.toString()}) has been caught');
    }
  }

  //Atom Paynets Gateway HTML Page Renger
  Future<void> openNdpsPG(mcontext, String atomTokenId, String merchId, String emailId, String mobileNumber) async {
    // String returnUrl = "https://payment.atomtech.in/mobilesdk/param"; ////return url production
    String returnUrl = "https://pgtest.atomtech.in/mobilesdk/param";

    // String payDetails = '{"atomTokenId": "15000000411719", "merchId": "8952", "emailId": "sd@gmail.com", "mobileNumber": "9698547875", "returnUrl": "$returnUrl"}';
    Map payDetails = {key_atomTokenId: atomTokenId, key_merchId: merchId, key_emailId: emailId, key_mobileNumber: mobileNumber, key_returnUrl: returnUrl};
    print("request>>" + json.encode(payDetails));
    Navigator.push(mcontext, MaterialPageRoute(builder: (context) => AtomPaynetsView("uat", json.encode(payDetails), mcontext,emailId,mobileNumber)));
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

    // taxData[rowIndex][s.key_demand].toString();
    return amount;
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

    // taxData[rowIndex][s.key_demand].toString();
    return demandId;
  }

  String getTaxAdvance(taxData, String taxTypeId) {
    String amount = "";
    switch (taxTypeId) {
      case '1':
        amount = taxData['property_available_advance'].toString();
        break;
      case '2':
        amount = taxData['water_available_advance'].toString();
        break;
      case '4':
        amount = taxData['professional_available_advance'].toString();
        break;
      case '5':
        amount = taxData['non_available_advance'].toString();
        break;
      case '6':
        amount = taxData['trade_available_advance'].toString();
        break;
    }

    // taxData[rowIndex][s.key_demand].toString();
    return amount;
  }
}
