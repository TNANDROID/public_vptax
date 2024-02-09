// ignore_for_file: file_names
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:public_vptax/stream/streamed_list.dart';
import 'package:public_vptax/stream/streamed_map.dart';

class PreferenceService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  String userName = 'public';
  String paymentType = "";
  String selectedLanguage = "ta";
  String buildMode = "Local";
  // String buildMode = "LiveDemo";
  // String buildMode = "Live";

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
  Future<void> setString(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

// Get User Info
  Future<String> getString(String key) async {
    String getStr = await _storage.read(key: key) ?? '';
    if (getStr != '') {
      return getStr;
    }
    return '';
  }

//Remove all Data
  Future cleanAllPreferences() async {
    totalAmountStream.clear();
    taxListStream!.clear();
    _storage.deleteAll();
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
