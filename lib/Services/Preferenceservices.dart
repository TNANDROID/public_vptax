// ignore_for_file: file_names
import 'package:public_vptax/stream/streamed_list.dart';
import 'package:public_vptax/stream/streamed_map.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService {
  String userName = 'public';
  String userPassKey = '45af1c702e5c46acb5f4192cbeaba27c';
  String paymentType = "";
  String selectedLanguage = "ta";

  List<dynamic> districtList = [];
  List<dynamic> blockList = [];
  List<dynamic> villageList = [];
  List<dynamic> taxTypeList = [];
  List<dynamic> finYearList = [];
  List<dynamic> paymentTypeList = [];
  List<dynamic> gatewayList = [];

  final StreamedList<dynamic>? taxListStream = StreamedList<dynamic>(initialData: []);
  final StreamedMap<String, dynamic> totalAmountStream = StreamedMap<String, dynamic>(initialData: {});

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
    totalAmountStream.clear();
    taxListStream!.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}

class FS {
  double h1 = 0;
  double h2 = 0;
  double h3 = 0;
  double h4 = 0;
  double h5 = 0;
  double h6 = 0;
}
