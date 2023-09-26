// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

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
import 'package:url_launcher/url_launcher.dart';

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
        print("requestData----:) $requestData");
        response = await apiServices.openServiceFunction(requestData);
        print("response----:) $response");
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
    } else if (type == "CollectionPaymentTokenList") {
      requestData = requestDataValue;
    }
    print("requestData collection ${jsonEncode(requestData)}");
    var response = await demandServicesAPIcall(context, requestData);

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
      return response;
    }
    setBusy(false);
  }

  //Auth Service API Call
  Future authendicationServicesAPIcall(BuildContext context, dynamic requestJson) async {
    setBusy(true);
    dynamic requestData = {key_data_content: requestJson};
    if (await Utils().isOnline()) {
      Utils().showProgress(context, 1);
      try {
        print("requestData----:) $requestData");
        var response = await apiServices.mainServiceFunction(requestData);
        print("response----:) $response");
        Utils().hideProgress(context);
        setBusy(false);
        return response;
      } catch (error) {
        setBusy(false);
        Utils().hideProgress(context);
        debugPrint('error : $error has been caught');
      }
    } else {
      Utils().showAlert(
        context,
        ContentType.fail,
        "noInternet".tr().toString(),
      );
    }
  }

  Future demandServicesAPIcall(BuildContext context, dynamic requestJson) async {
    setBusy(true);
    dynamic requestData = {key_data_content: requestJson};
    if (await Utils().isOnline()) {
      try {
        var response = await apiServices.mainServiceFunction(requestData);
        setBusy(false);
        return response;
      } catch (error) {
        setBusy(false);
        debugPrint('error : $error has been caught');
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
  Future<bool> getTransactionStatus(BuildContext context /* , String mobileNo, String email */) async {
    bool flag = false;
    dynamic requestData = {key_service_id: service_key_TransactionHistory, key_mobile_no: await preferencesService.getUserInfo(key_mobile_number), key_email_id: ''};
    try {
      Utils().showProgress(context, 1);
      var response = await demandServicesAPIcall(context, requestData);
      Utils().hideProgress(context);
      if (response[key_status] == key_success && response[key_response] == key_success) {
        preferencesService.TransactionList = response[key_data];
        if (preferencesService.TransactionList.isNotEmpty) {
          flag = true;
        }
      } else {
        Utils().showAlert(context, ContentType.warning, response[key_response].toString());
      }
    } catch (error) {
      debugPrint('error (${error.toString()}) has been caught');
      Utils().hideProgress(context);
    }
    return flag;
  }

  /// This Function used by Get Receipt PDF
  /* Future getReceipt(BuildContext context, receiptList, String setFlag, String language) async {
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
    var response = await demandServicesAPIcall(context, requestData);
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
  }*/
  Future getReceipt(BuildContext context, receiptList, String setFlag, String language) async {
    String urlParams =
        "taxtypeid=${base64Encode(utf8.encode(receiptList[key_taxtypeid].toString()))}&statecode=${base64Encode(utf8.encode(receiptList[key_state_code].toString()))}&dcode=${base64Encode(utf8.encode(receiptList[key_dcode].toString()))}&lbcode=${base64Encode(utf8.encode(receiptList[key_lbcode].toString()))}&bcode=${base64Encode(utf8.encode(receiptList[key_bcode].toString()))}&receipt_id=${base64Encode(utf8.encode(receiptList[key_receipt_id].toString()))}&receipt_no=${base64Encode(utf8.encode(receiptList[key_receipt_no].toString()))}&language_name=${base64Encode(utf8.encode(language))}";

    String key = preferencesService.userPassKey;

    String Signature = utils.generateHmacSha256(urlParams, key, true);

    String encodedParams = "${ApiServices().pdfURL}?$urlParams&sign=$Signature";

    await launch(encodedParams.toString());
  }

  Future getDemandList(BuildContext context) async {
    double property_total = 0.0;
    double water_total = 0.0;
    double professional_total = 0.0;
    double non_total = 0.0;
    double trade_total = 0.0;
    List sourceList = [];
    preferencesService.totalAmountStream.clear();
    preferencesService.taxListStream!.clear();
    try {
      dynamic requestJson = {
        key_service_id: service_key_getAllTaxAssessmentList,
        key_mobile_number: await preferencesService.getUserInfo(key_mobile_number),
        key_language_name: await preferencesService.getUserInfo("lang")
      };
      var responce = await demandServicesAPIcall(context, requestJson);
      if (responce[key_data] != null && responce[key_data].length > 0) {
        sourceList = responce[key_data].toList();

        for (var item in sourceList) {
          switch (item[key_taxtypeid].toString()) {
            case '1':
              property_total = property_total + double.parse(item["totaldemand"]);
              break;
            case '2':
              water_total = water_total + double.parse(item["totaldemand"]);
              break;
            case '4':
              professional_total = professional_total + double.parse(item["totaldemand"]);
              break;
            case '5':
              non_total = non_total + double.parse(item["totaldemand"]);
              break;
            case '6':
              trade_total = trade_total + double.parse(item["totaldemand"]);
              break;
          }
        }

        for (var item in sourceList) {
          dynamic getDemandRequest = {
            key_service_id: service_key_getAssessmentDemandList,
            key_taxtypeid: item[key_taxtypeid],
            key_assessment_id: item[key_assessment_id],
            key_dcode: item[key_dcode],
            key_bcode: item[key_bcode],
            key_pvcode: item[key_lbcode],
            key_language_name: await preferencesService.getUserInfo("lang"),
          };
          if (item[key_taxtypeid] == 4) {
            getDemandRequest[key_fin_year] = item[key_financialyear];
          }
          var getDemandResponce = await demandServicesAPIcall(context, getDemandRequest);
          if (getDemandResponce[key_response] == key_fail) {
            if (getDemandResponce[key_message] == "Demand Details Not Found") {
              item[key_DEMAND_DETAILS] = "Empty";
            } else if (getDemandResponce[key_message] == "Your previous transaction is pending. Please try after 60 minutes") {
              item[key_DEMAND_DETAILS] = "Pending";
            } else {
              item[key_DEMAND_DETAILS] = "Something Went Wrong";
            }
          } else {
            if (getDemandResponce[key_data] != null && getDemandResponce[key_data].length > 0) {
              item[key_DEMAND_DETAILS] = getDemandResponce[key_data];
            }
          }
        }
        sourceList.sort((a, b) {
          return a[key_taxtypeid].toString().compareTo(b[key_taxtypeid].toString());
        });
        preferencesService.totalAmountStream.value = {
          "property_total": property_total,
          "water_total": water_total,
          "professional_total": professional_total,
          "non_total": non_total,
          "trade_total": trade_total,
          "totalAmount": property_total + water_total + professional_total + non_total + trade_total,
        };
        preferencesService.taxListStream!.value = sourceList.toList();
      }
    } catch (error) {
      debugPrint('error : $error has been caught');
    }
  }
}
