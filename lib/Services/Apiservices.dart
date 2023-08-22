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

  // local
  String mainURL = "http://10.163.19.158/vptax/project/webservices/vptax_services_online.php";
  String openURL = "http://10.163.19.137:8090/vptax/project/webservices/open_services/open_services.php";

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
    HttpClient _client = HttpClient(context: await Utils().globalContext);
    _client.badCertificateCallback = (X509Certificate cert, String host, int port) => false;

    IOClient _ioClient = new IOClient(_client);

    Map<String, String> header = {
      "Content-Type": "application/json",
    };
    print("Header>>>>>>" + header.toString());
    var response = await _ioClient.post(Uri.parse(mainURL), body: json.encode(jsonRequest), headers: header);

    print("response>>>>>>" + response.toString());
    var mainData;
    if (response.statusCode == 200) {
      var data = response.body;
      var jsonData = jsonDecode(data);
      mainData = jsonData[key_main_data];
      print("response>>>>>>" + mainData.toString());
      return mainData;
    }
  }
  /**********************************************/
  /*********Open Service API Call********/
  /**********************************************/

  Future<List> openServiceFunction(dynamic jsonRequest) async {
    IOClient _ioClient = await ioclientCertificate();

    var response = await _ioClient.post(Uri.parse(openURL), body: json.encode(jsonRequest));
    print("response>>" + response.toString());

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
