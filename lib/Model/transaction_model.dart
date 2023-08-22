// ignore_for_file: avoid_print, use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:public_vptax/Resources/StringsKey.dart';
import '../Services/Apiservices.dart';
import '../Services/Preferenceservices.dart';
import '../Services/locator.dart';
import '../Utils/ContentInfo.dart';
import '../Utils/utils.dart';

class TransactionModel extends BaseViewModel {
  PreferenceService preferencesService = locator<PreferenceService>();
  ApiServices apiServices = locator<ApiServices>();
  Utils utils = Utils();

  Future<bool> getTransactionStatus(BuildContext context, String mobileNo, String email) async {
    var response;
    bool flag = false;

    dynamic fieldData = {key_service_id: service_key_TransactionHistory, key_mobile_no: mobileNo, key_email_id: email};

    dynamic requestData = {key_data_content: fieldData};

    print("requestData>>$requestData");

    if (await Utils().isOnline()) {
      try {
        Utils().showProgress(context, 1);
        response = await apiServices.mainServiceFunction(requestData);

        var status = response[key_status];
        var responseValue = response[key_response];
        List resJsonArray = [];

        if (status == key_success && responseValue == key_success) {
          resJsonArray = response[key_data];

          preferencesService.TransactionList = resJsonArray;
          if (preferencesService.TransactionList.isNotEmpty) {
            flag = true;
          }
        } else {
          Utils().showAlert(context, ContentType.warning, responseValue.toString());
        }
        Utils().hideProgress(context);
      } catch (error) {
        print('error (${error.toString()}) has been caught');
        Utils().hideProgress(context);
      }
    } else {
      Utils().showAlert(
        context,
        ContentType.fail,
        "noInternet".tr().toString(),
      );
    }

    return flag;
  }
}
