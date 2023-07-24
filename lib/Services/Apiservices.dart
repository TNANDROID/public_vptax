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
  dynamic header = {
    "Content-Type": "application/json",
    "Accept": "application/json",
  };

  String endPointURL =
      "http://10.163.19.137:8090/tnrd/project/webservices_forms";
  //String endPointURL = "https://tnrd.tn.gov.in/project/webservices_forms/";
  //String endPointURL = "http://10.163.19.140:8080/rdweb/project/webservices_forms";

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
    var response = await _ioClient.post(
        Uri.parse('$endPointURL/login_service/login_services.php'),
        body: jsonRequest);

    return response;
  }

  /**********************************************/
  /*********Master API Service Call********/
  /**********************************************/

  Future masterServiceFunction(dynamic jsonRequest) async {
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
    return response;
  }

  /**********************************************/
  /*********Main API Service Call********/
  /**********************************************/

  Future mainServiceFunction(dynamic jsonRequest) async {
    IOClient _ioClient = await ioclientCertificate();

    dynamic encrpted_request = {
      key_user_name: await preferencesService.getUserInfo(key_user_name),
      key_data_content: utils.encryption(jsonEncode(jsonRequest),
          await preferencesService.getUserInfo(key_user_passKey)),
    };
    var response = await _ioClient.post(
        Uri.parse('$endPointURL/village/SBM/SBM_services.php'),
        body: json.encode(encrpted_request));
    return response;
  }
}
