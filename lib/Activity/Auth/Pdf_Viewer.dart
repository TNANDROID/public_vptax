import 'dart:io';
import 'dart:typed_data';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:public_vptax/Activity/Auth/Home.dart';
import 'package:public_vptax/Resources/ColorsValue.dart' as c;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../Utils/utils.dart';
import 'package:public_vptax/Utils/ContentInfo.dart';

class PDF_Viewer extends StatefulWidget {
  final pdfBytes;
  final flag;
  PDF_Viewer({this.pdfBytes, this.flag});

  @override
  State<PDF_Viewer> createState() => _PDF_ViewerState();
}

class _PDF_ViewerState extends State<PDF_Viewer> {
  Future<bool> _onWillPop() async {
    if (widget.flag != null && widget.flag == 'payment') {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => Home(
                    isLogin: false,
                  )),
          (route) => false);
    } else {
      Navigator.of(context).pop();
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => _onWillPop(),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: c.colorPrimary,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => {
                if (widget.flag != null && widget.flag == 'payment')
                  {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Home(
                                  isLogin: false,
                                )),
                        (route) => false)
                  }
                else
                  {Navigator.of(context).pop()}
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.file_download_rounded, color: Colors.white),
                onPressed: () => {downloadPDF(widget.pdfBytes)},
              )
            ],
            title: Text(
              'receipt'.tr().toString(),
              style: TextStyle(fontSize: 14),
            ),
            centerTitle: true, // like this!
          ),
          body: SfPdfViewer.memory(widget.pdfBytes),
        ));
  }

  // ********************************************* Download PDF Func ***************************************//

  Future<void> downloadPDF(Uint8List pdfBytes) async {
    bool flag = false;
    PermissionStatus status;

    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      var sdkInt = androidInfo.version.sdkInt;
      if (sdkInt >= 30) {
        status = await Permission.manageExternalStorage.request();
        if (status != PermissionStatus.granted) {
          await showAppSettings(context, 'storage_permission'.tr().toString());
        } else {
          flag = true;
        }
      } else {
        status = await Permission.storage.request();
        if (status != PermissionStatus.granted) {
          await showAppSettings(context, 'storage_permission'.tr().toString());
        } else {
          flag = true;
        }
      }
    } else if (Platform.isIOS) {
      flag = true;
    } else {
      throw Exception('Unsupported platform');
    }

    if (flag) {
      Directory? downloadDirectory;

      if (Platform.isAndroid) {
        downloadDirectory = Directory('/storage/emulated/0/Download');
        if (!await downloadDirectory.exists()) {
          downloadDirectory = await getExternalStorageDirectory();
        }
      } else if (Platform.isIOS) {
        downloadDirectory = await getApplicationDocumentsDirectory();
      }

      downloadDirectory ??= await getApplicationDocumentsDirectory();

      String downloadsPath = downloadDirectory.path;

      Directory downloadsDir = Directory(downloadsPath);
      if (!downloadsDir.existsSync()) {
        downloadsDir.createSync();
      }

      try {
        setPDFDirectory(downloadsDir, pdfBytes);
      } catch (e) {
        return;
      }
    }
  }

  // ********************************************* Notification PDF Func ***************************************//

  /*  Future<void> showNotification(
        String title, String message, String payload) async {
      await AwesomeNotifications.initialize(
        // set the icon to null if you want to use the default app icon
        // resource://drawable/logo
        null,
        [
          NotificationChannel(
              channelKey: 'view_pdf',
              channelName: 'PDF',
              channelDescription: 'channel_description',
              importance: NotificationImportance.Max,
              icon: null)
        ],
        debug: true,
      );

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 10,
          channelKey: 'view_pdf', //Same as above in initilize,
          title: title,
          body: message,
          wakeUpScreen: true,
          fullScreenIntent: true,
          criticalAlert: true,
          //Other parameters
        ),
        // actionButtons: <NotificationActionButton>[
        //   NotificationActionButton(key: 'view', label: 'View'),
        // ],
      );

      await AwesomeNotifications().setListeners(
        onActionReceivedMethod: (receivedAction) {
   _openFilePath(payload);

          // if (receivedAction.buttonKeyPressed == "view") {
          //   _openFilePath(payload);
          // }
          throw ("DOne");
        },
      );
    }*/

  Future<void> showAppSettings(BuildContext context, String msg) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(msg, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: c.black)),
          actions: <Widget>[
            TextButton(
              child: Text('Allow Permission', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: c.primary_text_color2)),
              onPressed: () async {
                await openAppSettings();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void setPDFDirectory(Directory downloadsDir, Uint8List pdfBytes) async {
    String fileName;

    fileName = "Tax Receipt_${DateFormat('dd-MM-yyyy_HH-mm-ss').format(DateTime.now())}";
    // Save the PDF bytes to a file in the downloads folder
    File pdfFile = File('${downloadsDir.path}/$fileName.pdf');
    await pdfFile.writeAsBytes(pdfBytes);
    Utils().showAlert(context, ContentType.success, 'download_receipt_success'.tr().toString(), btnCount: "1", btnmsg: 'receipt', file_path: pdfFile.path);
  }
}
