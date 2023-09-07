// ignore_for_file: unnecessary_brace_in_string_interps, avoid_print, non_constant_identifier_names, use_build_context_synchronously, unused_local_variable

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:public_vptax/Model/startup_model.dart';
import 'package:public_vptax/Resources/StringsKey.dart';
import 'package:public_vptax/Utils/utils.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:public_vptax/Utils/ContentInfo.dart';

import 'Apiservices.dart';
import 'Preferenceservices.dart';
import 'locator.dart';
import '../Layout/Pdf_Viewer.dart';

class AtomPaynetsView extends StatefulWidget {
  final mode;
  final payDetails;
  final mcontext;
  final emailId;
  final mobileNumber;
  AtomPaynetsView(this.mode, this.payDetails, this.mcontext, this.emailId, this.mobileNumber);
  @override
  createState() => AtomPaynetsViewState(this.mode, this.payDetails, this.mcontext);
}

class AtomPaynetsViewState extends State<AtomPaynetsView> {
  ApiServices apiServices = locator<ApiServices>();
  StartUpViewModel model = StartUpViewModel();
  String selectedLang = "";

  final mode;
  final payDetails;
  final mcontext;
  final _key = UniqueKey();
  late WebViewController _controller;
  var transactionResult = "";
  final Completer<WebViewController> _controllerCompleter = Completer<WebViewController>();

  PreferenceService preferencesService = locator<PreferenceService>();
  var receiptList;

  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    initialize();
  }

  Future<void> initialize() async {
    selectedLang = await preferencesService.getUserInfo("lang");
  }

  AtomPaynetsViewState(this.mode, this.payDetails, this.mcontext);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _handleBackButtonAction(context),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          elevation: 0,
          toolbarHeight: 2,
        ),
        body: SafeArea(
            child: WebView(
          key: UniqueKey(),
          initialUrl: 'about:blank',
          onWebViewCreated: (WebViewController webViewController) {
            _controllerCompleter.future.then((value) => _controller = value);
            _controllerCompleter.complete(webViewController);
            debugPrint("payDetails from webview $payDetails");
            _loadHtmlFromAssets(mode);
          },
          navigationDelegate: (NavigationRequest request) async {
            if (request.url.startsWith("upi://")) {
              debugPrint("upi url started loading");
              try {
                // ignore: deprecated_member_use
                await launch(request.url);
              } catch (e) {
                closeWebView(context, "Transaction Status = cannot open UPI applications", ContentType.fail);
                throw 'custom error for UPI Intent';
              }
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          javascriptMode: JavascriptMode.unrestricted,
          onPageFinished: (String url) async {
            if (url.contains("AIPAYLocalFile")) {
              debugPrint(" AIPAYLocalFile Now url loaded: $url");
              await _controller.runJavascriptReturningResult("${"openPay('" + payDetails}')");
            }

            if (url.contains('/mobilesdk/param')) {
              final response = await _controller.runJavascriptReturningResult("document.getElementsByTagName('h5')[0].innerHTML");
              debugPrint("HTML response : $response");
              if (response.trim().contains("cancelTransaction")) {
                transactionResult = "Transaction Cancelled!";
              } else {
                final split = response.trim().split('|');
                final Map<int, String> values = {for (int i = 0; i < split.length; i++) i: split[i]};
                final encData = values[1]!.replaceAll('encData=', "");
                final merchId = values[2]!.replaceAll('merchId=', "");

                var returnData = {"encData": "$encData", "merchId": "$merchId"};

                // const platform = MethodChannel('flutter.dev/NDPSAESLibrary');
                //
                // try {
                //   final String result = await platform.invokeMethod('NDPSAESInit', {'AES_Method': 'decrypt', 'text': splitTwo[1].toString(), 'encKey': _responseDecryptionKey});
                //   var respJsonStr = result.toString();
                //   Map<String, dynamic> jsonInput = jsonDecode(respJsonStr);
                //   debugPrint("read full respone : $jsonInput");
                //
                //   //calling validateSignature function from atom_pay_helper file
                //   var checkFinalTransaction = Utils().validateSignature(jsonInput, _responsehashKey);
                //
                //   if (checkFinalTransaction) {
                //     if (jsonInput["payInstrument"]["responseDetails"]["statusCode"] == 'OTS0000' || jsonInput["payInstrument"]["responseDetails"]["statusCode"] == 'OTS0551') {
                //       debugPrint("Transaction success");
                //       transactionResult = "Transaction Success";
                //     } else {
                //       debugPrint("Transaction failed");
                //       transactionResult = "Transaction Failed";
                //     }
                //   } else {
                //     debugPrint("signature mismatched");
                //     transactionResult = "failed";
                //   }
                //   debugPrint("Transaction Response : $jsonInput");
                // } on PlatformException catch (e) {
                //   debugPrint("Failed to decrypt: '${e.message}'.");
                // }
                transactionResult = await getPaymentStatus(context, encData, merchId);
              }
              closeWebView(context, transactionResult, transactionResult.contains("Success") ? ContentType.success : ContentType.fail);
            }
          },
          gestureNavigationEnabled: true,
        )),
      ),
    );
  }

  validateSignature(Map data, resHashKey) {
    String signatureString = data["payInstrument"]["merchDetails"]["merchId"].toString() +
        data["payInstrument"]["payDetails"]["atomTxnId"].toString() +
        data['payInstrument']['merchDetails']['merchTxnId'].toString() +
        data['payInstrument']['payDetails']['totalAmount'].toStringAsFixed(2) +
        data['payInstrument']['responseDetails']['statusCode'].toString() +
        data['payInstrument']['payModeSpecificData']['subChannel'][0].toString() +
        data['payInstrument']['payModeSpecificData']['bankDetails']['bankTxnId'].toString();
    var bytes = utf8.encode(signatureString);
    var key = utf8.encode(resHashKey);
    var hmacSha512 = Hmac(sha512, key);
    var digest = hmacSha512.convert(bytes);
    var genSig = digest.toString();
    if (data['payInstrument']['payDetails']['signature'] == genSig) {
      return true;
    } else {
      return false;
    }
  }

  _loadHtmlFromAssets(mode) async {
    final localUrl = mode == 'uat' ? "assets/certificate/aipay_uat.html" : "assets/certificate/aipay_prod.html";
    String fileText = await rootBundle.loadString(localUrl);
    _controller.loadUrl(Uri.dataFromString(fileText, mimeType: 'text/html', encoding: Encoding.getByName('utf-8')).toString());
  }

  closeWebView(context, transactionResult, ContentType type) async {
    Navigator.pop(context);
    if (type == ContentType.success) {
      Utils().showAlert(mcontext, type,/*"$transactionResult"*/'payment_msg'.tr().toString(), btnCount: "1", btnmsg: 'payment', receiptList: receiptList,mode: 'payment_success');
    } else {
      String msg = "$transactionResult \n Please Check Transaction History for more Details";
      Utils().showAlert(mcontext, type, msg, btnCount: "1", btnmsg: 'canceled');
    }
  }

  Future<bool> _handleBackButtonAction(BuildContext context) async {
    debugPrint("_handleBackButtonAction called");
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Do you want to exit the payment ?'),
              actions: <Widget>[
                // ignore: deprecated_member_use
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('No'),
                ),
                // ignore: deprecated_member_use
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.of(context).pop();
                    Utils().showAlert(context, ContentType.fail, "Transaction cancelled!", btnmsg: 'canceled', mobile: widget.mobileNumber, email: widget.emailId); // Close current window
                    // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Transaction Status = Transaction cancelled")));
                  },
                  child: const Text('Yes'),
                ),
              ],
            ));
    return Future.value(true);
  }

  Future<String> getPaymentStatus(BuildContext context, encData, String merchId) async {
    var responceMessage = '';
    var requestData = {key_service_id: service_key_SaveCollectionList, key_merchId_server_side: merchId, key_encdata_server_side: encData};
    var response = await model.mainServicesAPIcall(context, requestData);
    if (response == key_fail) {
      receiptList = [];
    } else {
      var receiptResponce = response[key_data];
      if (receiptResponce[key_status] == key_success && receiptResponce[key_response] == key_success) {
        receiptList = receiptResponce[key_data];
        responceMessage = response[key_message];
      }
    }
    return responceMessage;
  }
}
