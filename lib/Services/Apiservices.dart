import 'dart:convert';
import 'dart:io';
import 'package:http/io_client.dart';
import 'package:public_vptax/Resources/StringsKey.dart';
import 'package:public_vptax/Services/Preferenceservices.dart';
import 'package:public_vptax/Services/locator.dart';
import 'package:public_vptax/Utils/utils.dart';
import 'package:public_vptax/Resources/StringsKey.dart' as s;

class ApiServices {
  Utils utils = Utils();
  PreferenceService preferencesService = locator<PreferenceService>();
  dynamic header = {
    "Content-Type": "application/json",
    "Accept": "application/json",
  };

  // Live Demo
  // String endPointURL =
  //     "https://vptax.tnrd.tn.gov.in/vptax_test/project/webservices";

  // // Local
  // String endPointURL = "http://10.163.19.137:8090/tnrd/project/webservices_forms";

 // live
  String endPointURL = "https://tnrd.tn.gov.in/project/webservices_forms";


  ioclientCertificate() async {
    HttpClient _client = HttpClient(context: await utils.globalContext);
    _client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => false;
    IOClient _ioClient = IOClient(_client);
    return _ioClient;
  }

  /**********************************************/
  /*********Login API Service Call********/
  /**********************************************/

  Future loginServiceFunction(dynamic jsonRequest) async {
    IOClient _ioClient = await ioclientCertificate();
    HttpClient _client = HttpClient(context: await utils.globalContext);
    _client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => false;
    var response = await _ioClient.post(
        Uri.parse('$endPointURL/login_service/login_services.php'),
        body: jsonRequest);

    return response;
  }

  /**********************************************/
  /*********Master API Service Call********/
  /**********************************************/

  Future<List> masterServiceFunction(dynamic jsonRequest) async {
    IOClient _ioClient = await ioclientCertificate();

    dynamic encrpted_request = {
      key_user_name: await preferencesService.getUserInfo(key_user_name),
      key_data_content: utils
          .encryption(jsonEncode(jsonRequest),
              await preferencesService.getUserInfo(key_user_passKey))
          .toString()
    };
    var response = await _ioClient.post(
        Uri.parse('$endPointURL/master_services/master_services_v_1_6.php'),
        body: json.encode(encrpted_request));

    if (response.statusCode == 200) {
      var data = response.body;
      var jsonData = jsonDecode(data);
      var enc_data = jsonData[key_enc_data];
      var decrpt_data = utils.decryption(
          enc_data, await preferencesService.getUserInfo(key_user_passKey));

      var distData = jsonDecode(decrpt_data);

      var status = distData[key_status];
      var response_value = distData[key_response];
      List<dynamic> res_jsonArray = [];
      if (status == key_ok && response_value == key_ok) {
        res_jsonArray = distData[key_json_data];
        if (res_jsonArray.isNotEmpty) {
          return res_jsonArray;
        }
      }
    }
    return [];
  }

  /**********************************************/
  /*********Main API Service Call********/
  /**********************************************/

  Future mainServiceFunction(dynamic jsonRequest) async {
    String userName = "9595959595";
    String key =preferencesService.getUserInfo(s.key_user_passKey).toString();
    print("KEY_VALUE>>>>"+key);
    String jsonString = jsonEncode(jsonRequest);
    String headerSignature = utils.generateHmacSha256(jsonString, key!, true);

    String header_token = utils.jwt_Encode(key, userName!, headerSignature);
    HttpClient _client = HttpClient(context: await Utils().globalContext);
    _client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => false;

    IOClient _ioClient = new IOClient(_client);

    Map<String, String> header = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $header_token"
    };
    print("Header>>>>>>"+header.toString());
    var response = await _ioClient.post(
        Uri.parse('$endPointURL/work_inspection/inspection_services_v_1_9_jwt.php'),
        body: json.encode(jsonRequest),headers: header);

    print("Status_code>>>>>>"+response.statusCode.toString());
    String data = response.body;

    print("getPDF_response>>" + data);
    String? authorizationHeader = response.headers['authorization'];
    print("authorizationHeader>>" + response.headers['authorization'].toString());
    String? token = authorizationHeader?.split(' ')[1];

    print("getPDF Authorization -  $token");

    String responceSignature = utils.jwt_Decode(key, token!);

    String responceData = utils.generateHmacSha256(data, key, false);

    print("getPDF responceSignature -  $responceSignature");

    print("getPDF responceData -  $responceData");

    if (responceSignature == responceData) {
      print("getPDF responceSignature - Token Verified");
      return response;
    }
  }
  /**********************************************/
  /*********Open Service API Call********/
  /**********************************************/

  Future<List> openServiceFunction(dynamic jsonRequest) async {
    IOClient _ioClient = await ioclientCertificate();

    var response = await _ioClient.post(
        Uri.parse('$endPointURL/open_services/open_services.php'),
        body: json.encode(jsonRequest));
    if (response.statusCode == 200) {
      var data = response.body;
      var jsonData = jsonDecode(data);
      var status = jsonData[key_status];

      var response_value = jsonData[key_response];
      List<dynamic> res_jsonArray = [];
      if (status == key_ok && response_value == key_ok) {
        res_jsonArray = jsonData[key_json_data];
        if (res_jsonArray.isNotEmpty) {
          return res_jsonArray;
        }
      }
    }
    return [];
  }
}
