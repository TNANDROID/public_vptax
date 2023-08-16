import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:public_vptax/Utils/utils.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AtomPaynetsView extends StatefulWidget {
  final mode;
  final payDetails;
  AtomPaynetsView(this.mode, this.payDetails);
  @override
  createState() => _AtomPaynetsViewState(this.mode, this.payDetails);
}

class _AtomPaynetsViewState extends State<AtomPaynetsView> {
  final mode;
  final payDetails;
  final _key = UniqueKey();
  late WebViewController _controller;

  final Completer<WebViewController> _controllerCompleter = Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  _AtomPaynetsViewState(this.mode, this.payDetails);

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
                _closeWebView(context, "Transaction Status = cannot open UPI applications");
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
              await _controller.runJavascriptReturningResult("openPay('" + payDetails + "')");
            }

            if (url.contains('/mobilesdk/param')) {
              final response = await _controller.runJavascriptReturningResult("document.getElementsByTagName('h5')[0].innerHTML");
              debugPrint("HTML response : $response");
              var transactionResult = "";
              if (response.trim().contains("cancelTransaction")) {
                transactionResult = "Transaction Cancelled!";
              } else {
                final split = response.trim().split('|');
                final Map<int, String> values = {for (int i = 0; i < split.length; i++) i: split[i]};
                final encData = values[1]!.replaceAll('encData=', "");
                final merchId = values[2]!.replaceAll('merchId=', "");

                var returnData = {"merchId": "$merchId", "encData": "$encData"};
                print("returnData--------------" + returnData.toString());

                // const platform = MethodChannel('flutter.dev/NDPSAESLibrary');

                // try {
                //   final String result = await platform.invokeMethod('NDPSAESInit', {'AES_Method': 'decrypt', 'text': splitTwo[1].toString(), 'encKey': _responseDecryptionKey});
                //   var respJsonStr = result.toString();
                //   Map<String, dynamic> jsonInput = jsonDecode(respJsonStr);
                //   debugPrint("read full respone : $jsonInput");

                //   //calling validateSignature function from atom_pay_helper file
                //   var checkFinalTransaction = Utils().validateSignature(jsonInput, _responsehashKey);

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
                transactionResult = "Waiting..!";
              }

              _closeWebView(context, transactionResult);
            }
          },
          gestureNavigationEnabled: true,
        )),
      ),
    );
  }

  _loadHtmlFromAssets(mode) async {
    final localUrl = mode == 'uat' ? "assets/certificate/aipay_uat.html" : "assets/certificate/aipay_prod.html";
    String fileText = await rootBundle.loadString(localUrl);
    _controller.loadUrl(Uri.dataFromString(fileText, mimeType: 'text/html', encoding: Encoding.getByName('utf-8')).toString());
  }

  _closeWebView(context, transactionResult) {
    // ignore: use_build_context_synchronously
    Navigator.pop(context); // Close current window
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Transaction Status = $transactionResult")));
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
                    Navigator.of(context).pop(); // Close current window
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Transaction Status = Transaction cancelled")));
                  },
                  child: const Text('Yes'),
                ),
              ],
            ));
    return Future.value(true);
  }
}