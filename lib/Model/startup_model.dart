import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:public_vptax/Resources/StringsKey.dart';
import 'package:public_vptax/Services/Apiservices.dart';
import 'package:public_vptax/Services/Preferenceservices.dart';
import 'package:public_vptax/Services/locator.dart';
import 'package:public_vptax/Utils/utils.dart';
import 'package:stacked/stacked.dart';

class StartUpViewModel extends BaseViewModel {
  PreferenceService preferencesService = locator<PreferenceService>();
  ApiServices apiServices = locator<ApiServices>();
  Utils utils = Utils();

  List<dynamic> districtList = [];
  List<dynamic> blockList = [];
  List<dynamic> villageList = [];
  List<dynamic> selectedBlockList = [];
  List<dynamic> selectedVillageList = [];
  List<dynamic> taxType = [
    {"taxCode": "01", "taxname": "Property Tax"},
    {"taxCode": "02", "taxname": "Water Charges"},
    {"taxCode": "03", "taxname": "Professional Tax"},
    {"taxCode": "04", "taxname": "Non Tax"},
    {"taxCode": "05", "taxname": "TradeLicence"},
  ];


  Future<void> loadUIBlock(String value) async {
    selectedBlockList.clear();
    for (var item in preferencesService.blockList) {
      if (item['dcode'].toString() == value) {
        selectedBlockList.add(item);
      }
    }
  }

  Future<void> loadUIVillage(String distcode, String blockcode) async {
    selectedVillageList.clear();
    for (var item in preferencesService.villageList) {
      if (item['dcode'].toString() == distcode &&
          item['bcode'].toString() == blockcode) {
        selectedVillageList.add(item);
      }
    }
  }

  // Get District List
  Future getOpenServiceList(String type) async {
    setBusy(true);
    dynamic requestData = {};
    if (type == "District") {
      requestData = {key_service_id: "district_list_all"};
    } else if (type == "Block") {
      requestData = {key_service_id: "block_list_all"};
    } else {
      requestData = {key_service_id: "village_list_all"};
    }
    var response = await apiServices.openServiceFunction(requestData);
    print("response>>"+response.toString());
    if (type == "District") {
      districtList = response;
      preferencesService.districtList = districtList.toList();
    } else if (type == "Block") {
      blockList = response;
      preferencesService.blockList = blockList.toList();
    } else {
      villageList = response;
      preferencesService.villageList = villageList.toList();
    }
    setBusy(false);
  }
}
