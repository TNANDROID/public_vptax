import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:public_vptax/Resources/StringsKey.dart';
import 'package:public_vptax/Services/Apiservices.dart';
import 'package:public_vptax/Services/Preferenceservices.dart';
import 'package:public_vptax/Services/locator.dart';
import 'package:public_vptax/Utils/ContentInfo.dart';
import 'package:public_vptax/Utils/utils.dart';
import 'package:stacked/stacked.dart';
import 'package:public_vptax/Resources/ImagePath.dart' as imagePath;


class StartUpViewModel extends BaseViewModel {
  PreferenceService preferencesService = locator<PreferenceService>();
  ApiServices apiServices = locator<ApiServices>();
  Utils utils = Utils();

  List<dynamic> districtList = [];
  List<dynamic> blockList = [];
  List<dynamic> villageList = [];
  List<dynamic> selectedBlockList = [];
  List<dynamic> selectedVillageList = [];
  List<dynamic> finYearList = [];
  List<dynamic> taxTypeList = [];
  List<dynamic> PaymentTypeList = [];
  List<dynamic> GatewayList = [];
  List<dynamic> taxCollectionDetailsList = [];


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
      requestData = {key_service_id: service_key_district_list_all};
    } else if (type == "Block") {
      requestData = {key_service_id: service_key_block_list_all};
    } else {
      requestData = {key_service_id: service_key_village_list_all};
    }
    print("requestData>>"+jsonEncode(requestData));

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
  Future getMainServiceList(String type,{String dcode = "1",String bcode= "1",String pvcode= "1",String taxType= "1",String lang= "en", dynamic requestDataValue,required BuildContext context}) async {
    setBusy(true);
    dynamic requestData = {};
    var response;
    if (type == "TaxType") {
      dynamic request = {key_service_id: service_key_TaxTypeList};
      requestData = {key_data_content:request};
    } else if (type == "FinYear") {
      dynamic request = {key_service_id: service_key_FinYearList};
      requestData = {key_data_content: request};
    }else if (type == "PaymentTypeList") {
      dynamic request = {key_service_id: service_key_PaymentTypeList,key_dcode:dcode, key_bcode:bcode, key_pvcode:pvcode};
      requestData = {key_data_content: request};
    }else if (type == "GatewayList") {
      dynamic request = {key_service_id: service_key_GatewayList};
      requestData = {key_data_content: request};
    }else if (type == "TaxCollectionDetails") {
      requestData = {key_data_content: requestDataValue};
    }else if (type == "CollectionPaymentTokenList") {
      requestData = {key_data_content: requestDataValue};
    }
    print("requestData>>"+requestData.toString());
    if (await Utils().isOnline()) {
      try {
        Utils().showProgress(context, 1);
         response = await apiServices.mainServiceFunction(requestData);
        Utils().hideProgress(context);
      } catch (error) {
        print('error (${error.toString()}) has been caught');
        Utils().hideProgress(context);
      }
      }else {
      Utils().showAlert(
        context,
        ContentType.fail,
        "noInternet".tr().toString(),
      );
    }



    if (type == "TaxType") {
      var status = response[key_status];
      var response_value = response[key_response];
      List res_jsonArray = [];
      if (status == key_success && response_value == key_success) {
        res_jsonArray = response[key_data];
        print("response_TaxType>>>>>>"+res_jsonArray.toString());
      }else{
        Utils().showAlert(context, ContentType.warning, response_value.toString());
      }
      taxTypeList = res_jsonArray;
      for (var item in taxTypeList) {
        switch (item['taxtypeid']) {
          case 1:
            item['img_path'] = imagePath.house;
            break;
          case 2:
            item['img_path'] = imagePath.water;
            break;
          case 4:
            item['img_path'] = imagePath.professional1;
            break;
          case 5:
            item['img_path'] = imagePath.nontax1;
            break;
          case 6:
            item['img_path'] = imagePath.trade;
            break;
          default:
            item['img_path'] = imagePath.property;
        }
      }

      preferencesService.taxTypeList = taxTypeList.toList();
    }
    else if (type == "FinYear") {
      var status = response[key_status];
      var response_value = response[key_response];
      List res_jsonArray = [];
      if (status == key_success && response_value == key_success) {
        res_jsonArray = response[key_data];
        print("response_FinYear>>>>>>"+res_jsonArray.toString());
      }else{
        Utils().showAlert(context, ContentType.warning, response_value.toString());
      }
      finYearList = res_jsonArray;
      preferencesService.finYearList = finYearList.toList();
    }
    else if (type == "PaymentTypeList") {
      var status = response[key_status];
      var response_value = response[key_response];
      List res_jsonArray = [];
      if (status == key_success && response_value == key_success) {
        res_jsonArray = response[key_data];
        print("response_PaymentTypeList>>>>>>"+res_jsonArray.toString());
      }else{
        Utils().showAlert(context, ContentType.warning, response_value.toString());
      }
      PaymentTypeList = res_jsonArray;
      preferencesService.PaymentTypeList = PaymentTypeList.toList();
    }
    else if (type == "GatewayList") {
      var status = response[key_status];
      var response_value = response[key_response];
      List res_jsonArray = [];
      if (status == key_success && response_value == key_success) {
        res_jsonArray = response[key_data];
        print("response_GatewayList>>>>>>"+res_jsonArray.toString());
      }else{
        Utils().showAlert(context, ContentType.warning, response_value.toString());
      }
      GatewayList = res_jsonArray;
      preferencesService.GatewayList = GatewayList.toList();
    }
    else if (type == "TaxCollectionDetails") {
      var status = response[key_status];
      var response_value = response[key_response];
      List res_jsonArray = [];
      preferencesService.taxCollectionDetailsList = [];
      if (status == key_success && response_value == key_success) {
        res_jsonArray = response[key_data_set];
        print("response_TaxCollectionDetails1>>>>>>"+res_jsonArray.toString());
        for(int i = 0; i < res_jsonArray.length; i++) {

          res_jsonArray[i][key_ASSESSMENT_DETAILS].forEach((item) {
            item[key_tax_total] = 0.00;
            item[key_swm_total] = 0.00;
            item[key_tax_pay] = 0.00;
            item[key_swm_pay] = 0.00;
            item[key_DEMAND_DETAILS].forEach((item2) {
              item2[key_flag] = false;
              // Additional calculations or logic can be added here if needed
            });
            // Additional calculations or logic can be added here if needed
          });
          for (var sampletaxData in res_jsonArray[i][key_ASSESSMENT_DETAILS]) {
            taxCollectionDetailsList.add(sampletaxData);
          }
        }

        print("response_TaxCollectionDetails2>>>>>>"+taxCollectionDetailsList.toString());

        preferencesService.taxCollectionDetailsList = taxCollectionDetailsList;
      }else{
        preferencesService.taxCollectionDetailsList = [];
        Utils().showAlert(context, ContentType.warning, response_value.toString());
      }
    }
    else if (type == "CollectionPaymentTokenList") {
     /* response={
          "STATUS": "SUCCESS",
          "RESPONSE": "SUCCESS",
          "pay_params": {
            "a": "Mjc5MjQ3MDQtZGYzYy05ZGQ1LTZhOWQtYzdlMWFhZTVhNjQ4",
            "b": "MTUwMDAwMDA0MTE3MTk=",
            "c": "OTAw",
            "d": "c2RAZ21haWwuY29t",
            "e": "OTY5ODU0Nzg3NQ==",
            "f": "MjAyMy0wOC0xMSAxMTozMTo1OA==",
            "g": "ODk1Mg=="
        }
      };*/
      var status = response[key_status];
      var response_value = response[key_response];
      if (status == key_success && response_value == key_success) {
        dynamic pay_params = response['pay_params'];
        print("response_CollectionPaymentTokenList>>>>>>"+response_value.toString());

        return pay_params;

      }else{
        Utils().showAlert(context, ContentType.warning, response_value.toString());
      }
    }
    setBusy(false);
  }
}
