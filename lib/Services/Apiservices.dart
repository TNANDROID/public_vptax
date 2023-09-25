import 'dart:convert';
import 'dart:io';
import 'package:http/io_client.dart';
import 'package:public_vptax/Resources/StringsKey.dart';
import 'package:public_vptax/Services/Preferenceservices.dart';
import 'package:public_vptax/Services/locator.dart';
import 'package:public_vptax/Utils/utils.dart';

class ApiServices {
  Utils utils = Utils();
  PreferenceService preferencesService = locator<PreferenceService>();

  // local
  String mainURL = "http://10.163.19.137:8090/vptax/project/webservices/vptax_services_online.php";
  String openURL = "http://10.163.19.137:8090/vptax/project/webservices/open_services/open_services.php";
  String pdfURL = "http://10.163.19.137:8090/vptax/project/webservices/getReceipt.php";

  ioclientCertificate() async {
    HttpClient _client = HttpClient(context: await utils.globalContext);
    _client.badCertificateCallback = (X509Certificate cert, String host, int port) => false;
    IOClient _ioClient = IOClient(_client);
    return _ioClient;
  }

  /**********************************************/
  /*********Main API Service Call********/
  /**********************************************/

  Future mainServiceFunction(dynamic jsonRequest) async {
    IOClient _ioClient = await ioclientCertificate();

    String key = preferencesService.userPassKey;

    String userName = preferencesService.userName;

    String jsonString = jsonEncode(jsonRequest);

    String headerSignature = utils.generateHmacSha256(jsonString, key, true);

    String header_token = utils.jwt_Encode(key, userName, headerSignature);

    var header = {"Content-Type": "application/json", "Authorization": "Bearer $header_token"};

    var response = await _ioClient.post(Uri.parse(mainURL), body: jsonString, headers: header);
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
  /**********************************************/
  /*********Open Service API Call********/
  /**********************************************/

  Future<List> openServiceFunction(dynamic jsonRequest) async {
    IOClient _ioClient = await ioclientCertificate();

    var response = await _ioClient.post(Uri.parse(openURL), body: json.encode(jsonRequest));
    if (response.statusCode == 200) {
      var data = response.body;
      var jsonData = jsonDecode(data);
      var status = jsonData[key_status];

      var response_value = jsonData[key_response];
      List<dynamic> res_jsonArray = [];
      if (status == key_success && response_value == key_success) {
        res_jsonArray = jsonData[key_data];
        if (res_jsonArray.isNotEmpty) {
          return res_jsonArray;
        }
      }
    }
    return [];
  }
}
