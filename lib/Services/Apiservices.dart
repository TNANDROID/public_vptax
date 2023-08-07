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
 //  String endPointURL = "https://tnrd.tn.gov.in/project/webservices_forms";

 // local
  String mainURL = "http://10.163.19.158/vptax/project/webservices/vptax_services_online.php";
  String masterURL = "http://10.163.19.158/tnrd/project/webservices_forms/master_services/master_services_v_1_6.php";
  String openURL = "http://10.163.19.158/tnrd/project/webservices_forms/open_services/open_services.php";
  String loginURL = "http://10.163.19.158/tnrd/project/webservices_forms/login_service/login_services.php";

 /*// live
  String mainURL = "https://vptax.tnrd.tn.gov.in/vptax/project/webservices/vptax_services_online.php";
  String masterURL = "https://tnrd.tn.gov.in/project/webservices_forms/master_services/master_services_v_1_6.php";
  String openURL = "https://tnrd.tn.gov.in/project/webservices_forms/open_services/open_services.php";
  String loginURL = "https://tnrd.tn.gov.in/project/webservices_forms/login_service/login_services.php";*/


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
        Uri.parse(loginURL),
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
        Uri.parse(masterURL),
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

    HttpClient _client = HttpClient(context: await Utils().globalContext);
    _client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => false;

    IOClient _ioClient = new IOClient(_client);

    Map<String, String> header = {
      "Content-Type": "application/json",
    };
    print("Header>>>>>>"+header.toString());
    var response = await _ioClient.post(
        Uri.parse(mainURL),
        body: json.encode(jsonRequest),headers: header);

    print("response>>>>>>"+response.toString());
    List<dynamic> res_jsonArray = [];
    if (response.statusCode == 200) {
      var data = response.body;
      var jsonData = jsonDecode(data);
      var mainData = jsonData[key_main_data];
      var status = mainData[key_status];
      print("response>>>>>>"+mainData.toString());

      var response_value = mainData[key_response];
      if (status == key_success && response_value == key_success) {
        res_jsonArray = mainData[key_data];
        print("response1>>>>>>"+res_jsonArray.toString());

        if (res_jsonArray.isNotEmpty) {
          print("response2>>>>>>"+res_jsonArray.toString());

          return res_jsonArray;
        }
      }
    }
    print("response>>>>>>"+res_jsonArray.toString());

    return res_jsonArray;
  }
  /**********************************************/
  /*********Open Service API Call********/
  /**********************************************/

  Future<List> openServiceFunction(dynamic jsonRequest) async {
    IOClient _ioClient = await ioclientCertificate();

    var response = await _ioClient.post(
        Uri.parse(openURL),
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
