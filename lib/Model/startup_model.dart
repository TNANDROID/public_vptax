import 'dart:convert';

import 'package:public_tax/Resources/StringsKey.dart';
import 'package:public_tax/Services/Apiservices.dart';
import 'package:public_tax/Services/Preferenceservices.dart';
import 'package:public_tax/Services/locator.dart';
import 'package:public_tax/Utils/utils.dart';
import 'package:stacked/stacked.dart';

class StartUpViewModel extends BaseViewModel {
  PreferenceService preferencesService = locator<PreferenceService>();
  ApiServices apiServices = locator<ApiServices>();
  Utils utils = Utils();

  List<dynamic> districtList = [];
  List<dynamic> blockList = [];
  List<dynamic> selectedBlockList = [];

  // Get District List
  Future getDistrictList() async {
    setBusy(true);
    Map request = {
      key_scode: await preferencesService.getUserInfo(key_scode),
      key_service_id: service_key_district_list_all,
    };

    var response = await apiServices.masterServiceFunction(request);
    if (response.statusCode == 200) {
      var data = response.body;
      var jsonData = jsonDecode(data);
      var enc_data = jsonData[key_enc_data];
      var decrpt_data = utils.decryption(
          enc_data, await preferencesService.getUserInfo(key_user_passKey));

      var distData = jsonDecode(decrpt_data);

      var status = distData[key_status];
      var response_value = distData[key_response];
      if (status == key_ok && response_value == key_ok) {
        List<dynamic> res_jsonArray = distData[key_json_data];
        if (res_jsonArray.isNotEmpty) {
          res_jsonArray.sort((a, b) {
            return a[key_dname]
                .toString()
                .toLowerCase()
                .compareTo(b[key_dname].toLowerCase());
          });
          districtList = res_jsonArray.toList();
        }
      }
    }
    setBusy(false);
  }

  Future<void> getBlockList() async {
    dynamic request = {
      key_scode: await preferencesService.getUserInfo(key_scode),
      key_service_id: service_key_block_list_all,
    };

    var response = await apiServices.masterServiceFunction(request);
    if (response.statusCode == 200) {
      var data = response.body;
      var jsonData = jsonDecode(data);
      var enc_data = jsonData[key_enc_data];
      var decrpt_data = utils.decryption(
          enc_data, await preferencesService.getUserInfo(key_user_passKey));

      var distData = jsonDecode(decrpt_data);

      var status = distData[key_status];
      var response_value = distData[key_response];

      if (status == key_ok && response_value == key_ok) {
        List<dynamic> res_jsonArray = distData[key_json_data];

        if (res_jsonArray.isNotEmpty) {
          res_jsonArray.sort((a, b) {
            return a[key_bname]
                .toLowerCase()
                .compareTo(b[key_bname].toLowerCase());
          });
          blockList = res_jsonArray.toList();
        }
      }
    }
  }

  Future<void> loadUIBlock(String value) async {
    selectedBlockList.clear();
    selectedBlockList = blockList.where((e) {
      return e['dcode'].toString().toLowerCase().contains(value.toLowerCase());
    }).toList();
  }
}
