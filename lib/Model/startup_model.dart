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

  // Get District List
  Future getDistrictList() async {
    setBusy(true);
    Map request = {
      key_scode: await preferencesService.getUserInfo(key_scode),
      key_service_id: service_key_district_list_all,
    };
    districtList = await apiServices.masterServiceFunction(request);
    preferencesService.districtList = districtList.toList();
    setBusy(false);
  }

  Future<void> getBlockList() async {
    dynamic request = {
      key_scode: await preferencesService.getUserInfo(key_scode),
      key_service_id: service_key_block_list_all,
    };
    blockList = await apiServices.masterServiceFunction(request);
    preferencesService.blockList = blockList.toList();
  }

  Future<void> loadUIBlock(String value) async {
    selectedBlockList.clear();
    selectedBlockList = preferencesService.blockList.where((e) {
      return e['dcode'].toString().toLowerCase().contains(value.toLowerCase());
    }).toList();
  }

  Future<void> loadUIVillage(String distcode, String blockcode) async {
    selectedVillageList.clear();
    selectedVillageList = preferencesService.villageList.where((e) {
      return e['dcode']
              .toString()
              .toLowerCase()
              .contains(distcode.toLowerCase()) &&
          e['bcode'].toString().toLowerCase().contains(blockcode.toLowerCase());
    }).toList();
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
    if (type == "District") {
      districtList = response;
      preferencesService.districtList = districtList.toList();
    } else if (type == "Block") {
      blockList = response;
    } else {
      villageList = response;
    }
    setBusy(false);
  }
}
