// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:public_vptax/Resources/ImagePath.dart' as imagePath;
import 'package:public_vptax/Resources/StringsKey.dart';
import 'package:public_vptax/Services/Apiservices.dart';
import 'package:public_vptax/Services/Preferenceservices.dart';
import 'package:public_vptax/Services/env.dart';
import 'package:public_vptax/Services/locator.dart';
import 'package:public_vptax/Utils/ContentInfo.dart';
import 'package:public_vptax/Utils/utils.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

class StartUpViewModel extends BaseViewModel {
  PreferenceService preferencesService = locator<PreferenceService>();
  ApiServices apiServices = locator<ApiServices>();
  Utils utils = Utils();

  List<dynamic> selectedBlockList = [];
  List<dynamic> selectedVillageList = [];

//------------District Wise Block List Filter---------------//
  Future<void> loadUIBlock(String value) async {
    selectedBlockList.clear();
    for (var item in preferencesService.blockList) {
      if (item['dcode'].toString() == value) {
        selectedBlockList.add(item);
      }
    }
  }

//------------Block Wise Village List Filter---------------//
  Future<void> loadUIVillage(String distcode, String blockcode) async {
    selectedVillageList.clear();
    for (var item in preferencesService.villageList) {
      if (item['dcode'].toString() == distcode && item['bcode'].toString() == blockcode) {
        selectedVillageList.add(item);
      }
    }
   /* print("distcode"+distcode.toString());
    print("blockcode"+blockcode.toString());
    print("selectedVillageList"+selectedVillageList.toString());
    print("selectedVillageList"+preferencesService.villageList.toString());*/
  }

//------------Get Open Service API Function---------------//
  Future getOpenServiceList(String type, BuildContext context) async {
    try {
      print("OpenService Request----:) $type");
      var response = await apiServices.openServiceFunction({key_service_id: type});
      print("OpenService Response----:) $response");
      if (type == service_key_district_list_all) {
        preferencesService.districtList = response.toList();
      } else if (type == service_key_block_list_all) {
        preferencesService.blockList = response.toList();
      } else {
        preferencesService.villageList = response.toList();
      }
    } catch (error) {
      debugPrint('error (${error.toString()}) has been caught');
    }
  }

//------------Main Service Based List Fetch Function---------------//
  Future getMainServiceList(String type, BuildContext context, {String taxType = "1", String lang = "en"}) async {
    dynamic requestData = {};
    if (type == "TaxType") {
      requestData = {key_service_id: service_key_TaxTypeList};
    } else if (type == "FinYear") {
      requestData = {key_service_id: service_key_FinYearList};
    } else if (type == "PaymentTypeList") {
      requestData = {key_service_id: service_key_PaymentTypeList, key_dcode: "1", key_bcode: "1", key_pvcode: "1"};
    } else if (type == "GatewayList") {
      requestData = {key_service_id: service_key_GatewayList};
    }
    var response = await overAllMainService(context, requestData);

    List res_jsonArray = [];
    if (response != null && response.isNotEmpty){
      if (response[key_status] == key_success && response[key_response] == key_success) {
        res_jsonArray = response[key_data] ?? [];
      } else {
        Utils().showAlert(context, ContentType.warning, response[key_response].toString());
      }
    }else {
      Utils().showAlert(context, ContentType.fail, ("failed".tr().toString()));
    }

    if (type == "TaxType") {
      for (var item in res_jsonArray) {
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

      preferencesService.taxTypeList = res_jsonArray.toList();
    } else if (type == "FinYear") {
      preferencesService.finYearList = res_jsonArray.toList();
    } else if (type == "PaymentTypeList") {
      preferencesService.paymentTypeList = res_jsonArray.toList();
    } else if (type == "GatewayList") {
      preferencesService.gatewayList = res_jsonArray.toList();
    } else {
      return null;
    }
  }

//------------Main Service API Call---------------//
  Future overAllMainService(BuildContext context, dynamic requestJson) async {
    setBusy(true);
    dynamic requestData = {key_data_content: requestJson};
    if (await Utils().isOnline()) {
      try {
        print("MainService Request----:) ${jsonEncode(requestData)}");
        var response = await apiServices.mainServiceFunction(requestData);
        log("MainService Response----:) $response");
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

//------------PDF Receipt Generation Function---------------//
  Future getReceipt(BuildContext context, receiptList, String setFlag, String language) async {
    String urlParams =
        "taxtypeid=${base64Encode(utf8.encode(receiptList[key_taxtypeid].toString()))}&statecode=${base64Encode(utf8.encode(receiptList[key_state_code].toString()))}&dcode=${base64Encode(utf8.encode(receiptList[key_dcode].toString()))}&lbcode=${base64Encode(utf8.encode(receiptList[key_lbcode].toString()))}&bcode=${base64Encode(utf8.encode(receiptList[key_bcode].toString()))}&receipt_id=${base64Encode(utf8.encode(receiptList[key_receipt_id].toString()))}&receipt_no=${base64Encode(utf8.encode(receiptList[key_receipt_no].toString()))}&language_name=${base64Encode(utf8.encode(language))}";
    String? key =  Env.userPassKey;
    String Signature = utils.generateHmacSha256(urlParams, key!, true);
    String encodedParams = "${ApiServices().pdfURL}?$urlParams&sign=$Signature";
    await launch(encodedParams.toString());
  }

//------------Demand Fetch and Amount Calculation Function---------------//
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
        key_mobile_number: await preferencesService.getString(key_mobile_number),
        key_language_name: preferencesService.selectedLanguage
      };
      var response = await overAllMainService(context, requestJson);
      if (response != null && response.isNotEmpty){
        if (response[key_data] != null && response[key_data].length > 0) {
          sourceList = response[key_data].toList();

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
              key_language_name: preferencesService.selectedLanguage,
            };
            if (item[key_taxtypeid] == 4) {
              getDemandRequest[key_fin_year] = item[key_financialyear];
            }
            var getDemandResponce = await overAllMainService(context, getDemandRequest);
            if (response != null && response.isNotEmpty){
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
            }else {
              Utils().showAlert(context, ContentType.fail, ("failed".tr().toString()));
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
      }else {
        Utils().showAlert(context, ContentType.fail, ("failed".tr().toString()));
      }

    } catch (error) {
      debugPrint('error : $error has been caught');
    }
  }
}
