// ignore_for_file: unused_local_variable, non_constant_identifier_names, file_names, camel_case_types, prefer_typing_uninitialized_variables, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, avoid_print, library_prefixes, use_build_context_synchronously, nullable_type_in_catch_clause

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:open_settings/open_settings.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:public_vptax/Services/Preferenceservices.dart';
import 'package:public_vptax/Services/locator.dart';
import 'package:public_vptax/Layout/ui_helper.dart';
import 'package:public_vptax/Resources/ImagePath.dart' as imagePath;
import 'package:public_vptax/Resources/ColorsValue.dart' as c;
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui' as ui;
import '../Resources/StringsKey.dart';
import 'ContentInfo.dart';

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
    return RegExp(
            "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#%^&+=])(?=\\S+).{4,}")
        .hasMatch(value);
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

  // Future<void> gotoLoginPageFromSplash(BuildContext context) async {
  //   Timer(
  //       const Duration(seconds: 2),
  //       () => Navigator.pushReplacement(
  //           context, MaterialPageRoute(builder: (context) => Login())));
  // }

//  void gotoHomePage(BuildContext context) {
//     Navigator.pushReplacement(
//         context, MaterialPageRoute(builder: (context) => Home()));
//   }

  Future<void> hideSoftKeyBoard(BuildContext context) async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  Future<void> showalertforOffline(BuildContext context, String msg,
      String username, String password) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Center(
            child: Container(
              height: 320,
              margin: const EdgeInsets.all(50),
              decoration: BoxDecoration(
                  color: c.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 1.0), //(x,y)
                      blurRadius: 5.0,
                    ),
                  ]),
              child: Column(
                children: [
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                        color: c.yellow_new,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15))),
                    child: Center(
                      child: Image.asset(
                        imagePath.warning,
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: c.white,
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          UIHelper.titleTextStyle(
                              'Warning', c.text_color, 18, true, false),
                          UIHelper.verticalSpaceSmall,
                          UIHelper.titleTextStyle(
                              msg, c.black, 15, true, false),
                          UIHelper.verticalSpaceMedium,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Visibility(
                                visible: true,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                c.green_new),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ))),
                                    onPressed: () {
                                      OpenSettings.openWIFISetting();
                                      Navigator.pop(context, false);
                                    },
                                    child: UIHelper.titleTextStyle(
                                        "Settings", c.white, 13, true, false)),
                              ),
                              Visibility(
                                visible: true,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                c.primary_text_color2),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ))),
                                    onPressed: () {
                                      Navigator.pop(context, false);
                                      offlineMode(username, password, context);
                                    },
                                    child: UIHelper.titleTextStyle(
                                        "Continue With Off-Line",
                                        c.white,
                                        13,
                                        true,
                                        false)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
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
    i == 1
        ? showLoading(context, 'loading'.tr().toString())
        : showLoading(context, 'downloading'.tr().toString());
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
                      SpinKitFadingCircle(
                        color: c.primary_text_color2,
                        duration: const Duration(seconds: 1, milliseconds: 500),
                        size: 50,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      UIHelper.titleTextStyle(
                          message, c.primary_text_color2, 12, true, false)
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

  Future<void> showAlerts(
      BuildContext context, ContentType contentType, String message,
      [String? title, double? titleFontSize, double? messageFontSize]) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        // Size
        final size = MediaQuery.of(context).size;
        double rightSpace = size.width * 0.12;
        double leftSpace = size.width * 0.12;

        ContentInfo contentInfo = getContentInfo(contentType);

        final hsl = HSLColor.fromColor(contentInfo.color);
        final hslDark =
            hsl.withLightness((hsl.lightness - 0.1).clamp(0.0, 1.0));

        return Center(
          child: Container(
            width: size.width,
            height: size.width * 0.45,
            margin: EdgeInsets.symmetric(horizontal: size.width * 0.045),
            decoration: UIHelper.roundedBorderWithColorWithShadow(
                20, contentInfo.color, contentInfo.color),
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
                      colorFilter:
                          getColorFilter(hslDark.toColor(), ui.BlendMode.srcIn),
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
                        colorFilter: getColorFilter(
                            hslDark.toColor(), ui.BlendMode.srcIn),
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
                    style: UIHelper.textDecoration(titleFontSize ?? 18, c.white,
                        bold: true),
                  ),
                ),

                Container(
                  margin: EdgeInsets.all(size.width * 0.05),
                  child: Text(
                    message,
                    style:
                        UIHelper.textDecoration(messageFontSize ?? 15, c.white),
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),

                // ***********************  Close Icon button *********************** //

                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
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
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        print("object");
                      },
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(5.0),
                        backgroundColor: MaterialStateProperty.all(c.white),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                20.0), // Set the desired border radius here
                          ),
                        ),
                      ),
                      child: Text(
                        'Go to Settings',
                        style:
                            TextStyle(color: contentInfo.color, fontSize: 11),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> showAlert(BuildContext context, String msg) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(msg),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> offlineMode(
      String username, String password, BuildContext context) async {
    String userName = await preferencesService.getUserInfo(key_user_name);
    String passWord = await preferencesService.getUserInfo(key_user_pwd);
    if (username == userName && password == passWord) {
      //  gotoHomePage(context);
    } else {
      showAlert(context, 'no_offline_data'.tr().toString());
    }
  }

  String encryption(String plainText, String ENCRYPTION_KEY) {
    String ENCRYPTION_IV = '2SN22SkJGDyOAXUU';
    final key = encrypt.Key.fromUtf8(fixKey(ENCRYPTION_KEY));
    final iv = encrypt.IV.fromUtf8(ENCRYPTION_IV);
    final encrypter = encrypt.Encrypter(
        encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'));
    final encrypted = encrypter.encrypt(plainText, iv: iv);

    return "${encrypted.base64}:${iv.base64}";
  }

  String decryption(String plainText, String ENCRYPTION_KEY) {
    final dateList = plainText.split(":");
    final key = encrypt.Key.fromUtf8(fixKey(ENCRYPTION_KEY));
    final iv = encrypt.IV.fromBase64(dateList[1]);

    final encrypter = encrypt.Encrypter(
        encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'));
    final decrypted =
        encrypter.decrypt(encrypt.Encrypted.from64(dateList[0]), iv: iv);
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
    final randomString = List.generate(length,
            (index) => availableChars[random.nextInt(availableChars.length)])
        .join();

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
}
