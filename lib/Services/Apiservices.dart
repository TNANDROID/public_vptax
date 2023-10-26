import 'dart:convert';
import 'dart:io';
import 'package:http/io_client.dart';
import 'package:public_vptax/Resources/StringsKey.dart';
import 'package:public_vptax/Services/Preferenceservices.dart';
import 'package:public_vptax/Services/locator.dart';
import 'package:public_vptax/Utils/utils.dart';

import 'KeyStorage.dart';

// local
String endPointUrl = 'http://10.163.19.137:8090/vptax/project/webservices';

class ApiServices {
  Utils utils = Utils();
  final storageUtil = SecureStorageUtil();

  PreferenceService preferencesService = locator<PreferenceService>();
  String mainURL = "$endPointUrl/vptax_services_online.php";
  String openURL = "$endPointUrl/open_services/open_services.php";
  String pdfURL = "$endPointUrl/getReceipt.php";

  ioclientCertificate() async {
    HttpClient client = HttpClient(context: await utils.globalContext);
    client.badCertificateCallback = (X509Certificate cert, String host, int port) => false;
    IOClient ioClient = IOClient(client);
    return ioClient;
  }

  //**********************************************/
  //*********Main API Service Call********/
  //**********************************************/

  Future mainServiceFunction(dynamic jsonRequest) async {
    IOClient ioClient = await ioclientCertificate();
    String key = await storageUtil.read('userPassKey') ?? '';
    String userName = preferencesService.userName;
    String jsonString = jsonEncode(jsonRequest);
    String headerSignature = utils.generateHmacSha256(jsonString, key, true);
    String headerToken = utils.jwt_Encode(key, userName, headerSignature);
    var header = {"Content-Type": "application/json", "Authorization": "Bearer $headerToken"};

    var response = await ioClient.post(Uri.parse(mainURL), body: jsonString, headers: header);

    if (response.statusCode == 200) {
      var data = response.body;
      String? authorizationHeader = response.headers['authorization'];
      String? token = authorizationHeader?.split(' ')[1];
      String responceSignature = utils.jwt_Decode(key, token!);
      String responceData = utils.generateHmacSha256(data, key, false);
      if (responceSignature == responceData) {
        var jsonData = jsonDecode(data);
        return jsonData;
      }
      return false;
    }
  }

  //**********************************************/
  //*********Open Service API Call********/
  //**********************************************/

  Future<List> openServiceFunction(dynamic jsonRequest) async {
    IOClient ioClient = await ioclientCertificate();
    var response = await ioClient.post(Uri.parse(openURL), body: json.encode(jsonRequest));

    if (response.statusCode == 200) {
      var data = response.body;
      var jsonData = jsonDecode(data);
      var status = jsonData[key_status];
      var responseValue = jsonData[key_response];
      List<dynamic> resJsonarray = [];
      if (status == key_success && responseValue == key_success) {
        resJsonarray = jsonData[key_data];
        if (resJsonarray.isNotEmpty) {
          return resJsonarray;
        }
      }
    }
    return [];
  }
}
