// ignore_for_file: file_names

import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService {
  String userName = 'public';
  String userPassKey = '45af1c702e5c46acb5f4192cbeaba27c';

  List<dynamic> districtList = [];
  List<dynamic> blockList = [];
  List<dynamic> villageList = [];
  List<dynamic> taxTypeList = [];
  List<dynamic> finYearList = [];
  List<dynamic> PaymentTypeList = [];
  List<dynamic> GatewayList = [];
  List<dynamic> addedTaxPayList = [];
  List<dynamic> taxCollectionDetailsList = [];
  List<dynamic> TransactionList = [];

  //Set User Info
  Future<bool> setUserInfo(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
    return true;
  }

// Get User Info
  Future<String> getUserInfo(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String getStr = await prefs.getString(key) ?? '';
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
    GatewayList = [];
    addedTaxPayList = [];
    taxCollectionDetailsList = [];
    TransactionList = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
