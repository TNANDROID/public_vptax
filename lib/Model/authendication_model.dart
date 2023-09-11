// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:public_vptax/Resources/StringsKey.dart';
import 'package:public_vptax/Services/Apiservices.dart';
import 'package:public_vptax/Services/Preferenceservices.dart';
import 'package:public_vptax/Services/locator.dart';
import 'package:public_vptax/Utils/ContentInfo.dart';
import 'package:public_vptax/Utils/utils.dart';

class AuthViewModel {
  PreferenceService preferencesService = locator<PreferenceService>();
  ApiServices apiServices = locator<ApiServices>();
  Utils utils = Utils();

  //Authendication Service API Call
  Future authendication(BuildContext context, dynamic requestJson) async {
    dynamic requestData = {key_data_content: requestJson};
    if (await Utils().isOnline()) {
      Utils().showProgress(context, 1);
      try {
        var response = await apiServices.mainServiceFunction(requestData);
        Utils().hideProgress(context);
        var status = response[key_status].toString();
        var responseValue = response[key_response].toString();
        if (status == key_success && responseValue == key_success) {
          return response;
        } else {
          return responseValue;
        }
      } catch (error) {
        Utils().hideProgress(context);
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
}
