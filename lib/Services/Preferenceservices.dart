// ignore_for_file: file_names

import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService {
  List<dynamic> districtList = [];
  List<dynamic> blockList = [];
  List<dynamic> villageList = [];
  List<dynamic> taxTypeList = [];
  List<dynamic> finYearList = [];
  List<dynamic> PaymentTypeList = [];
  List<dynamic> addedTaxPayList = [];
  //Set User Info
  Future<bool> setUserInfo(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
    return true;
  }

// Get User Info
  Future<String> getUserInfo(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String getStr = prefs.getString(key) ?? '';
    if (getStr != '') {
      return getStr;
    }
    return '';
  }

//Remove all Data
  Future cleanAllPreferences() async {
     districtList = [];
     blockList = [];
     villageList = [];
     taxTypeList = [];
     finYearList = [];
     PaymentTypeList = [];
     addedTaxPayList = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
