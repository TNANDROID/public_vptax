// ignore_for_file: unused_local_variable, non_constant_identifier_names, file_names, camel_case_types, prefer_typing_uninitialized_variables, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, avoid_print, library_prefixes, use_build_context_synchronously, nullable_type_in_catch_clause

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:crypto/crypto.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:datetime_setting/datetime_setting.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:public_vptax/Activity/Auth/Splash.dart';
import 'package:public_vptax/Layout/ui_helper.dart';
import 'package:public_vptax/Resources/ColorsValue.dart' as c;
import 'package:public_vptax/Resources/ImagePath.dart' as imagePath;
import 'package:public_vptax/Services/Preferenceservices.dart';
import 'package:public_vptax/Services/atom_paynets_service.dart';
import 'package:public_vptax/Services/locator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Resources/StringsKey.dart' as s;

import '../Activity/Auth/Home.dart';
import '../Layout/customgradientbutton.dart';
import '../Model/startup_model.dart';
import '../Resources/StringsKey.dart';
import 'ContentInfo.dart';
import 'package:public_vptax/Layout/screen_size.dart';

class Utils {
  PreferenceService preferencesService = locator<PreferenceService>();

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

  void showToast(BuildContext context, String msg, String type) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: type == "S" ? c.account_status_green_color : c.grey_10,
      content: UIHelper.titleTextStyle(msg, type == "S" ? c.white : c.white, 13, true, false),
      duration: const Duration(seconds: 1),
/*      action: SnackBarAction(
        label: 'ACTION',
        onPressed: () {},
      ),*/
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
                      UIHelper.titleTextStyle(message, c.colorAccent, 12, true, false)
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
                            String selectedLang = await preferencesService.getUserInfo("lang");
                            await StartUpViewModel().getReceipt(mcontext, receiptList, 'payment', selectedLang);
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => const Home(),
                                ),
                                (route) => false);
                          } else if (btnmsg == 'receipt') {
                            openFilePath(file_path!);
                          } else if (btnmsg == 'canceled') {
                            if (await preferencesService.getUserInfo(s.key_isLogin) == "yes") {
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const Home()), (route) => false);
                            } else {
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const Splash()), (route) => false);
                            }
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
                                  String selectedLang = await preferencesService.getUserInfo("lang");
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (context) => const Home(),
                                      ),
                                      (route) => false);
                                  await StartUpViewModel().getReceipt(mcontext, receiptList, 'payment', selectedLang);
                                } else if (btnmsg == 'receipt') {
                                  Navigator.of(context).pop();
                                  openFilePath(file_path!);
                                } else if (btnmsg == 'canceled') {
                                  if (await preferencesService.getUserInfo(s.key_isLogin) == "yes") {
                                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const Home()), (route) => false);
                                  } else {
                                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const Splash()), (route) => false);
                                  }
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

  void openFilePath(String path) async {
    // final result = await OpenFile.open(path);
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

    DateTime expirationTime = currentTime.add(const Duration(minutes: 20));

    String exp = (expirationTime.millisecondsSinceEpoch / 1000).toString();

    Map payload = {
      "exp": exp,
      "signature": encodedhashData,
    };

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
      // Verify a token
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
    //  showProgress(context, 1);
    try {
      await StartUpViewModel().getOpenServiceList("District", context);
      await StartUpViewModel().getOpenServiceList("Block", context);
      await StartUpViewModel().getOpenServiceList("Village", context);
      await StartUpViewModel().getMainServiceList("TaxType", context: context);
      await StartUpViewModel().getMainServiceList("FinYear", context: context);
      await StartUpViewModel().getMainServiceList("PaymentTypeList", dcode: "1", bcode: "1", pvcode: "1", context: context);
      await StartUpViewModel().getMainServiceList("GatewayList", context: context);
      // hideProgress(context);
    } catch (error) {
      debugPrint('error (${error.toString()}) has been caught');
      //   hideProgress(context);
    }
  }

  //Atom Paynets Gateway HTML Page Renger
  Future<void> openNdpsPG(mcontext, String atomTokenId, String merchId, String emailId, String mobileNumber) async {
    // String returnUrl = "https://payment.atomtech.in/mobilesdk/param"; ////return url production
    String returnUrl = "https://pgtest.atomtech.in/mobilesdk/param";

    // String payDetails = '{"atomTokenId": "15000000411719", "merchId": "8952", "emailId": "sd@gmail.com", "mobileNumber": "9698547875", "returnUrl": "$returnUrl"}';
    Map payDetails = {key_atomTokenId: atomTokenId, key_merchId: merchId, key_emailId: emailId, key_mobileNumber: mobileNumber, key_returnUrl: returnUrl};
    Navigator.push(mcontext, MaterialPageRoute(builder: (context) => AtomPaynetsView("uat", json.encode(payDetails), mcontext, emailId, mobileNumber)));
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

  TextEditingController nameTextController = TextEditingController();
  TextEditingController mobileTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  bool _isKeyboardFocused = false;
  Future<void> settingModalBottomSheet(BuildContext mcontext, List finalList) async {
    int selected_id = -1;
    String isLogin = await preferencesService.getUserInfo(key_isLogin);
    if (isLogin == "yes") {
      nameTextController.text = await preferencesService.getUserInfo(key_name);
      mobileTextController.text = await preferencesService.getUserInfo(key_mobile_number);
      emailTextController.text = await preferencesService.getUserInfo(key_email);
    }
    String selectedLang = await preferencesService.getUserInfo("lang");
    List list = preferencesService.GatewayList;
    List paymentType = preferencesService.PaymentTypeList;
    return showModalBottomSheet(
        context: mcontext,
        isScrollControlled: true,
        backgroundColor: c.full_transparent,
        builder: (BuildContext bc) {
          return StatefulBuilder(builder: (BuildContext context, StateSetter mystate) {
            _isKeyboardFocused = MediaQuery.of(context).viewInsets.bottom > 0;
            return Wrap(
              children: <Widget>[
                Container(
                    decoration: UIHelper.GradientContainer(50.0, 50, 0, 0, [c.white, c.white]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            margin: const EdgeInsets.only(top: 20, bottom: 10),
                            child: Text(('payment_mode'.tr().toString() + (selectedLang == 'en' ? paymentType[0][key_paymenttype_en] : paymentType[0][key_paymenttype_ta])),
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                              margin: const EdgeInsets.only(top: 5, left: 20, bottom: 5),
                              child: Text('select_payment_gateway'.tr().toString(), style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal, color: c.black))),
                        ),
                        Container(
                            child: AnimationLimiter(
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
                                                      mystate(() {
                                                        selected_id = list[index][key_gateway_id];
                                                      });
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Align(
                                                          alignment: Alignment.centerLeft,
                                                          child: selected_id == list[index][key_gateway_id]
                                                              ? Image.asset(
                                                                  imagePath.tick,
                                                                  color: c.account_status_green_color,
                                                                  height: 25,
                                                                  width: 25,
                                                                )
                                                              : Image.asset(
                                                                  imagePath.unchecked,
                                                                  color: c.grey_9,
                                                                  height: 25,
                                                                  width: 25,
                                                                ),
                                                        ),
                                                        IconButton(
                                                            onPressed: () {},
                                                            icon: Image.asset(
                                                              imagePath.payment_gateway,
                                                              height: 25,
                                                              width: 25,
                                                            )),
                                                        Text(
                                                          list[index][key_gateway_name],
                                                          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12, color: c.grey_9),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                            ),
                                          ));
                                    }))),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                              margin: const EdgeInsets.only(top: 10, left: 20, bottom: 5),
                              child: Text(isLogin == "yes" ? "Payment Details" : 'enter_the_details'.tr().toString(), style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal, color: c.black))),
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
                            /*margin: EdgeInsets.only(left: 5, right: 20),
                      padding: EdgeInsets.only(bottom: 30, right: 10),*/
                            child: CustomGradientButton(
                              onPressed: () async {
                                if (selected_id > 0) {
                                  if (_formKey.currentState!.saveAndValidate()) {
                                    Map<String, dynamic> postParams = Map.from(_formKey.currentState!.value);
                                    postParams.removeWhere((key, value) => value == null);
                                    Navigator.of(context).pop();
                                    getPaymentToken(mcontext, finalList, selected_id, selectedLang);
                                  }
                                } else {
                                  Utils().showAlert(context, ContentType.fail, 'select_anyOne_gateway'.tr().toString());
                                  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('select_anyOne_gateway'.tr().toString())));
                                }
                              },
                              width: 120,
                              height: 40,
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  "continue".tr().toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14,
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
                    )),
              ],
            );
          });
        });
  }

  Widget addInputFormControl(String nameField, String hintText, String fieldType, String isLogin) {
    return FormBuilderTextField(
      enabled: isLogin == "yes" ? false : true,
      style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w400, color: c.grey_9),
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
        labelStyle: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600, color: c.grey_7),
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

  Future<void> getPaymentToken(BuildContext context, List selList, int selected_id, String selectedLang) async {
    List finalList = selList;
    Utils().showProgress(context, 1);

    try {
      dynamic request = {};

      String taxType = finalList[0][s.key_taxtypeid].toString();
      var property_demand_id = [];

      for (var data in finalList[0][s.key_DEMAND_DETAILS]) {
        if (data[s.key_flag] == true) {
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
        {
          s.key_assessment_no: finalList[0][s.key_assessment_no].toString(),
          demand_id: property_demand_id,
        }
      ];
      dynamic assessment_demand_list = {
        'Assessment_Details': Assessment_Details,
      };
      request = {
        s.key_service_id: s.service_key_CollectionPaymentTokenList,
        s.key_language_name: selectedLang,
        s.key_taxtypeid: finalList[0][s.key_taxtypeid].toString(),
        s.key_dcode: finalList[0][s.key_dcode].toString(),
        s.key_bcode: finalList[0][s.key_bcode].toString(),
        s.key_pvcode: finalList[0][s.key_lbcode].toString(),
        if (finalList[0][s.key_taxtypeid].toString() == "4") s.key_fin_year: finalList[0][s.key_financialyear].toString(),
        s.key_assessment_no: finalList[0][s.key_assessment_no].toString(),
        s.key_paymenttypeid: 5,
        s.key_name: nameTextController.text,
        s.key_mobile_no: mobileTextController.text,
        s.key_email_id: emailTextController.text,
        s.key_payment_gateway: selected_id,
        'assessment_demand_list': assessment_demand_list,
      };
      dynamic response =
          await StartUpViewModel().getMainServiceList("CollectionPaymentTokenList", requestDataValue: request, context: context, taxType: finalList[0][s.key_taxtypeid].toString(), lang: selectedLang);
      Utils().hideProgress(context);
      print("response2>>$response");
      var status = response[key_status];
      String response_value = response[key_response];
      if (status == key_success && response_value == key_success) {
        dynamic pay_params = response['pay_params'];
        String transaction_unique_id = Utils().decodeBase64(pay_params['a'].toString());
        String atomTokenId = Utils().decodeBase64(pay_params['b'].toString());
        String req_payment_amount = Utils().decodeBase64(pay_params['c'].toString());
        String public_transaction_email_id = Utils().decodeBase64(pay_params['d'].toString());
        String public_transaction_mobile_no = Utils().decodeBase64(pay_params['e'].toString());
        String txmStartTime = Utils().decodeBase64(pay_params['f'].toString());
        String merchId = Utils().decodeBase64(pay_params['g'].toString());

        await Utils().openNdpsPG(context, atomTokenId, merchId, public_transaction_email_id, public_transaction_mobile_no);
      } else if (response_value == key_fail) {
        Utils().showAlert(context, ContentType.warning, response[key_message].toString());
      } else {
        Utils().showAlert(context, ContentType.warning, response_value.toString());
      }

      // throw ('000');
    } catch (error) {
      Utils().hideProgress(context);
      debugPrint('error (${error.toString()}) has been caught');
    }
  }

  DateTime? selectedFromDate;
  DateTime? selectedToDate;
  List<DateTime> selectedfromDateRange = [];
  List<DateTime> selectedtoDateRange = [];
  int calendarSelectedIndex = 0;
  Future<Map<String, dynamic>> ShowCalenderDialog(BuildContext context) async {
    Map<String, dynamic> jsonValue = {"fromDate": "", "toDate": "", "flag": false};

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
            margin: MediaQuery.of(context).size.height < 700
                ? const EdgeInsets.all(10)
                : EdgeInsets.only(left: 15, right: 15, top: MediaQuery.of(context).size.height / 6, bottom: MediaQuery.of(context).size.height / 6),
            child: Material(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      calendarSelectedIndex = 0;
                                    });
                                  },
                                  child: Container(
                                    width: 150,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'from_date'.tr().toString(),
                                        style: TextStyle(
                                          color: calendarSelectedIndex == 0 ? Colors.black : Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 400),
                                  decoration: BoxDecoration(
                                      border: Border(bottom: BorderSide(width: calendarSelectedIndex == 0 ? 2.0 : 1.0, color: calendarSelectedIndex == 0 ? c.primary_text_color2 : Colors.white))),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (selectedFromDate != null) {
                                      setState(() {
                                        calendarSelectedIndex = 1;
                                      });
                                    } else {
                                      showAlert(context, ContentType.warning, "select_from_date".tr().toString());
                                    }
                                  },
                                  child: Container(
                                    width: 150,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'to_date'.tr().toString(),
                                        style: TextStyle(
                                          color: calendarSelectedIndex == 1 ? Colors.black : Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 400),
                                  decoration: BoxDecoration(
                                      border: Border(bottom: BorderSide(width: calendarSelectedIndex == 0 ? 2.0 : 1.0, color: calendarSelectedIndex == 1 ? c.primary_text_color2 : Colors.white))),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      calendarSelectedIndex == 0
                          ? calendarWidget(context, 0, selectedFromDate ?? DateTime.now(), setState)
                          : AnimatedContainer(
                              duration: const Duration(seconds: 1, milliseconds: 500),
                              child: Center(child: calendarWidget(context, 1, selectedFromDate ?? DateTime.now(), setState)),
                            ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  calendarSelectedIndex = 0;
                                  selectedFromDate = null;
                                  selectedToDate = null;
                                  selectedfromDateRange.clear();
                                  selectedtoDateRange.clear();
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                ),
                                child: Padding(
                                    padding: const EdgeInsets.only(top: 2, bottom: 2),
                                    child: Text(
                                      "cancel".tr().toString(),
                                      style: TextStyle(
                                        color: c.colorPrimary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                              ),
                              const SizedBox(width: 16),
                              ElevatedButton(
                                onPressed: () {
                                  if (selectedToDate != null && selectedFromDate != null) {
                                    calendarSelectedIndex = 0;
                                    jsonValue = {"fromDate": selectedFromDate, "toDate": selectedToDate, "flag": true};
                                    selectedfromDateRange.clear();
                                    selectedtoDateRange.clear();
                                    selectedFromDate = null;
                                    selectedToDate = null;
                                    Navigator.of(context).pop();
                                  } else {
                                    if (selectedFromDate == null) {
                                      showAlert(context, ContentType.warning, 'select_from_date'.tr().toString());
                                    } else if (selectedToDate == null) {
                                      showAlert(context, ContentType.warning, 'select_to_date'.tr().toString());
                                    } else {
                                      print("Something Went Wrong....");
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                ),
                                child: Padding(
                                    padding: const EdgeInsets.only(top: 2, bottom: 2),
                                    child: Text(
                                      "ok".tr().toString(),
                                      style: TextStyle(
                                        color: c.colorPrimary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
            ));
      },
    );
    return jsonValue;
  }

  @override
  Widget calendarWidget(BuildContext context, int index, DateTime initialDate, setState) {
    //Date Time
    return CalendarDatePicker2(
      config: CalendarDatePicker2Config(
        firstDate: index == 0 ? DateTime(2000) : initialDate,
        lastDate: DateTime.now(),
        currentDate: initialDate,
        selectedDayHighlightColor: c.colorAccent,
        weekdayLabels: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
        weekdayLabelTextStyle: const TextStyle(color: Color(0xFF07b3a5), fontWeight: FontWeight.bold, fontSize: 10),
        firstDayOfWeek: 1,
        controlsHeight: 50,
        controlsTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
        dayTextStyle: const TextStyle(
          fontSize: 10,
          color: Color(0xFF252b34),
          fontWeight: FontWeight.bold,
        ),
        disabledDayTextStyle: const TextStyle(color: Colors.grey, fontSize: 10),
      ),
      value: index == 0 ? selectedfromDateRange : selectedtoDateRange,
      onValueChanged: (value) async {
        if (index == 0) {
          selectedfromDateRange.clear();
          selectedfromDateRange.add(value[0]!);
          selectedFromDate = value[0];
          if (selectedFromDate != null) {
            selectedToDate = null;
            selectedtoDateRange.clear();
          }
          calendarSelectedIndex = 1;
          setState(() {});
        } else {
          selectedToDate = value[0];
          selectedtoDateRange.clear();
          selectedtoDateRange.add(value[0]!);
        }
      },
      displayedMonthDate: index == 0 ? initialDate : selectedToDate ?? DateTime.now(),
    );
  }
}
