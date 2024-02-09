import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/io_client.dart';
import 'package:public_vptax/Resources/StringsKey.dart';
import 'package:public_vptax/Services/Preferenceservices.dart';
import 'package:public_vptax/Services/env.dart';
import 'package:public_vptax/Services/locator.dart';
import 'package:public_vptax/Utils/utils.dart';

String endPointUrl = PreferenceService().buildMode=="Local"?Env.endPointUrlLocal:
                     PreferenceService().buildMode=="LiveDemo"?Env.endPointUrlLiveDemo:Env.endPointUrlLive;


class ApiServices {
  Utils utils = Utils();

  PreferenceService preferencesService = locator<PreferenceService>();

  String? loginURL = endPointUrl+Env.loginURL;
  String? mainURL = endPointUrl+Env.mainURL;
  String? openURL = endPointUrl+Env.openURL;
  String? pdfURL = endPointUrl+Env.pdfURL;

  ioclientCertificate() async {
    HttpClient client = HttpClient(context: await utils.globalContext);
    client.badCertificateCallback = (X509Certificate cert, String host, int port) => false;
    IOClient ioClient = IOClient(client);
    return ioClient;
  }

  //**********************************************/
  //*********Login API Service Call********/
  //**********************************************/
  Future loginServiceFunction(String type, dynamic request) async {
    log("$type- url>>$loginURL");
    log("$type- request>>${json.encode(request)}");
    IOClient ioClient = IOClient();
    var response = await ioClient.post(Uri.parse(loginURL!), body: request);

    if (response.statusCode == 200) {
      String data = response.body;
      var decodedData = json.decode(data);
      log("$type- response>>$decodedData");
      if (decodedData != null) {
        return decodedData;
      } else {
        return false;
      }
    }
  }


//**********************************************/
  //*********Main API Service Call********/
  //**********************************************/

  Future mainServiceFunction(dynamic jsonRequest) async {
    IOClient ioClient = await ioclientCertificate();
    String? key =  Env.userPassKey;
    String userName = preferencesService.userName;
    String jsonString = jsonEncode(jsonRequest);
    String headerSignature = utils.generateHmacSha256(jsonString, key!, true);
    String headerToken = utils.jwt_Encode(key, userName, headerSignature);
    var header = {"Content-Type": "application/json", "Authorization": "Bearer $headerToken"};
    print("MainService mainURL----:) $mainURL");

    var response = await ioClient.post(Uri.parse(mainURL!), body: jsonString, headers: header);
    print("MainService statusCode----:) ${response.statusCode}");
    print("MainService body----:) ${response.body}");
    if (response.statusCode == 200) {
      var data = response.body;
      print("MainService data----:) ${jsonDecode(data)}");

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
    print("MainService openURL----:) $openURL");

    var response = await ioClient.post(Uri.parse(openURL!), body: json.encode(jsonRequest));

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
