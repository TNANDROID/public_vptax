// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:public_vptax/Activity/Auth/Pdf_Viewer.dart';
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

  bool responceFlag_TaxCollectionDetails = false;

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
      if (item['dcode'].toString() == distcode && item['bcode'].toString() == blockcode) {
        selectedVillageList.add(item);
      }
    }
  }

  // Get District List
  Future getOpenServiceList(String type, BuildContext context) async {
    setBusy(true);
    var response;
    dynamic requestData = {};
    if (type == "District") {
      requestData = {key_service_id: service_key_district_list_all};
    } else if (type == "Block") {
      requestData = {key_service_id: service_key_block_list_all};
    } else {
      requestData = {key_service_id: service_key_village_list_all};
    }
    if (await Utils().isOnline()) {
      try {
        Utils().showProgress(context, 1);
        response = await apiServices.openServiceFunction(requestData);
        Utils().hideProgress(context);
      } catch (error) {
        debugPrint('error (${error.toString()}) has been caught');
        Utils().hideProgress(context);
      }
    } else {
      Utils().showAlert(
        context,
        ContentType.fail,
        "noInternet".tr().toString(),
      );
    }

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

  Future getMainServiceList(String type,
      {String dcode = "1", String bcode = "1", String pvcode = "1", String taxType = "1", String lang = "en", dynamic requestDataValue, required BuildContext context}) async {
    setBusy(true);
    dynamic requestData = {};
    if (type == "TaxType") {
      requestData = {key_service_id: service_key_TaxTypeList};
    } else if (type == "FinYear") {
      requestData = {key_service_id: service_key_FinYearList};
    } else if (type == "PaymentTypeList") {
      requestData = {key_service_id: service_key_PaymentTypeList, key_dcode: dcode, key_bcode: bcode, key_pvcode: pvcode};
    } else if (type == "GatewayList") {
      requestData = {key_service_id: service_key_GatewayList};
    } else if (type == "TaxCollectionDetails") {
      requestData = requestDataValue;
    } else if (type == "CollectionPaymentTokenList") {
      requestData = requestDataValue;
    }
    var response = await mainServicesAPIcall(context, requestData);

    if (type == "TaxType") {
      var status = response[key_status];
      var response_value = response[key_response];
      List res_jsonArray = [];
      if (status == key_success && response_value == key_success) {
        res_jsonArray = response[key_data];
      } else {
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
    } else if (type == "FinYear") {
      var status = response[key_status];
      var response_value = response[key_response];
      List res_jsonArray = [];
      if (status == key_success && response_value == key_success) {
        res_jsonArray = response[key_data];
      } else {
        Utils().showAlert(context, ContentType.warning, response_value.toString());
      }
      finYearList = res_jsonArray;
      preferencesService.finYearList = finYearList.toList();
    } else if (type == "PaymentTypeList") {
      var status = response[key_status];
      var response_value = response[key_response];
      List res_jsonArray = [];
      if (status == key_success && response_value == key_success) {
        res_jsonArray = response[key_data];
      } else {
        Utils().showAlert(context, ContentType.warning, response_value.toString());
      }
      PaymentTypeList = res_jsonArray;
      preferencesService.PaymentTypeList = PaymentTypeList.toList();
    } else if (type == "GatewayList") {
      var status = response[key_status];
      var response_value = response[key_response];
      List res_jsonArray = [];
      if (status == key_success && response_value == key_success) {
        res_jsonArray = response[key_data];
      } else {
        Utils().showAlert(context, ContentType.warning, response_value.toString());
      }
      GatewayList = res_jsonArray;
      preferencesService.GatewayList = GatewayList.toList();
    } else if (type == "TaxCollectionDetails") {
      responceFlag_TaxCollectionDetails = true;
      preferencesService.setUserInfo(key_total_assesment, "0");
      preferencesService.setUserInfo(key_pending_assessment, "0");
      var status = response[key_status];
      var response_value = response[key_response];
      List res_jsonArray = [];
      preferencesService.taxCollectionDetailsList = [];
      if (status == key_success && response_value == key_success) {
        var tot_ass = response[key_total_assesment];
        var pen_ass = response[key_pending_assessment];
        res_jsonArray = response[key_data_set];
        for (int i = 0; i < res_jsonArray.length; i++) {
          res_jsonArray[i][key_ASSESSMENT_DETAILS].forEach((item) {
            item[key_tax_total] = 0.00;
            item[key_swm_total] = 0.00;
            item[key_tax_pay] = 0.00;
            item[key_swm_pay] = 0.00;
            if (item[key_no_of_demand_available] > 0) {
              item[key_DEMAND_DETAILS].forEach((item2) {
                item2[key_flag] = false;
              });
            }
          });
          for (var sampletaxData in res_jsonArray[i][key_ASSESSMENT_DETAILS]) {
            taxCollectionDetailsList.add(sampletaxData);
          }
        }

        preferencesService.taxCollectionDetailsList = taxCollectionDetailsList;
        preferencesService.setUserInfo(key_total_assesment, tot_ass.toString());
        preferencesService.setUserInfo(key_pending_assessment, pen_ass.toString());
      } else {
        responceFlag_TaxCollectionDetails = false;
        preferencesService.taxCollectionDetailsList = [];
        preferencesService.setUserInfo(key_total_assesment, "0");
        preferencesService.setUserInfo(key_pending_assessment, "0");
        Utils().showAlert(context, ContentType.warning, response[key_message].toString() ?? response_value.toString());
      }
    } else if (type == "CollectionPaymentTokenList") {
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
        return pay_params;
      } else if (response_value == key_fail) {
        Utils().showAlert(context, ContentType.warning, response[key_message].toString());
      } else {
        Utils().showAlert(context, ContentType.warning, response_value.toString());
      }
    }
    setBusy(false);
  }

  //Main Service API Call
  Future mainServicesAPIcall(BuildContext context, dynamic requestJson) async {
    dynamic requestData = {key_data_content: requestJson};
    if (await Utils().isOnline()) {
      try {
        var response = await apiServices.mainServiceFunction(requestData);
        var status = response[key_status].toString();
        var responseValue = response[key_response].toString();

        if (status == key_success && responseValue == key_success) {
          return response;
        } else {
          return responseValue;
        }
      } catch (error) {
        debugPrint('error (${error.toString()}) has been caught');
      }
    } else {
      Utils().showAlert(
        context,
        ContentType.fail,
        "noInternet".tr().toString(),
      );
    }
  }

  /// This Function used by Get Transaction Status
  Future<bool> getTransactionStatus(BuildContext context, String mobileNo, String email) async {
    bool flag = false;
    dynamic requestData = {key_service_id: service_key_TransactionHistory, key_mobile_no: mobileNo, key_email_id: email};
    try {
      Utils().showProgress(context, 1);
      var response = await mainServicesAPIcall(context, requestData);
      if (response[key_status] == key_success && response[key_response] == key_success) {
        preferencesService.TransactionList = response[key_data];
        if (preferencesService.TransactionList.isNotEmpty) {
          flag = true;
        }
      } else {
        Utils().showAlert(context, ContentType.warning, response[key_response].toString());
      }

      Utils().hideProgress(context);
    } catch (error) {
      debugPrint('error (${error.toString()}) has been caught');
      Utils().hideProgress(context);
    }
    return flag;
  }

  /// This Function used by Get Receipt PDF
  Future getReceipt(BuildContext context, receiptList, String setFlag, String language) async {
    Utils().showProgress(context, 1);
    var requestData = {
      key_service_id: service_key_GetReceipt,
      key_receipt_id: receiptList[key_receipt_id].toString(),
      key_receipt_no: receiptList[key_receipt_no].toString(),
      key_taxtypeid: receiptList[key_taxtypeid].toString(),
      key_state_code: receiptList[key_state_code].toString(),
      key_dcode: receiptList[key_dcode].toString(),
      key_bcode: receiptList[key_bcode].toString(),
      key_pvcode: receiptList[key_lbcode].toString(),
      key_language_name: language
    };
    var response = await mainServicesAPIcall(context, requestData);
    Utils().hideProgress(context);
    if (response[key_status] == key_success && response[key_response] == key_success) {
      var receiptResponce = response[key_data];
      var pdftoString = receiptResponce[key_receipt_content];
      Uint8List? pdf = const Base64Codec().decode(pdftoString);
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => PDF_Viewer(
                  pdfBytes: pdf,
                  flag: setFlag,
                )),
      );
    } else {
      Utils().showAlert(context, ContentType.fail, response[key_message]);
    }
  }
}
