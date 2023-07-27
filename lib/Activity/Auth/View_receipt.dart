import 'dart:async';
import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:public_vptax/Layout/ui_helper.dart';
import 'package:public_vptax/Resources/ColorsValue.dart' as c;
import 'package:public_vptax/Resources/ImagePath.dart' as imagePath;
import 'package:public_vptax/Services/Apiservices.dart';
import 'package:public_vptax/Services/Preferenceservices.dart';
import 'package:public_vptax/Services/locator.dart';
import 'package:public_vptax/Utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

import '../../Model/startup_model.dart';
import '../../Resources/StringsKey.dart';

class ViewReceipt extends StatefulWidget {
  @override
  State<ViewReceipt> createState() => _ViewReceiptState();
}
class _ViewReceiptState extends State<ViewReceipt> {
  @override
  Utils utils = Utils();
  late SharedPreferences prefs;
  var dbClient;
  List districtItems = [];
  List blockItems = [];
  List villageItems = [];
  String selectedDistrict = "";
  String selectedBlock = "";
  String selectedvillage = "";
  String selectedTaxType = "";
  bool districtFlag=false;
  bool blockFlag=false;
  bool villageFlag=false;
  bool districtError=false;
  bool blockError=false;
  bool villageError=false;
  bool isLoadingD = false;
  bool isLoadingB = false;
  bool isLoadingV = false;
  bool listvisbility = false;
  PreferenceService preferencesService = locator<PreferenceService>();
  List<dynamic> taxType = [
    {"taxCode": "01", "taxname": 'propertyTax'.tr().toString()},
    {"taxCode": "02", "taxname": 'waterCharges'.tr().toString()},
    {"taxCode": "03", "taxname": 'professionalTax'.tr().toString()},
    {"taxCode": "04", "taxname": 'nonTax'.tr().toString()},
    {"taxCode": "05", "taxname": 'tradeLicense'.tr().toString()},
  ];
  List<dynamic> districtlist = [
    {"dcode": "01", "dname": 'Ariyalur'},
    {"dcode": "02", "dname": 'Coimbatore'},
    {"dcode": "03", "dname": 'Kancheepuram'},
    {"dcode": "04", "dname": 'Tanjavur'},
    {"dcode": "05", "dname": 'Thiruvarur'},
  ];
  List<dynamic> blockList = [
    {"bcode": "01", "bname": 'Ariyalur'},
    {"bcode": "02", "bname": 'Coimbatore'},
    {"bcode": "03", "bname": 'Kancheepuram'},
    {"bcode": "04", "bname": 'Tanjavur'},
    {"bcode": "05", "bname": 'Thiruvarur'},
  ];
  List<dynamic> villageList = [
    {"pvcode": "01", "pvname": 'Ariyalur'},
    {"pvcode": "02", "pvname": 'Coimbatore'},
    {"pvcode": "03", "pvname": 'Kancheepuram'},
    {"pvcode": "04", "pvname": 'Tanjavur'},
    {"pvcode": "05", "pvname": 'Thiruvarur'},
  ];
  Map<String, String> defaultSelectedDistrict = {

  };
  @override
  void initState() {
    super.initState();
    initialize();
  }
  Future<void> initialize() async {
    prefs = await SharedPreferences.getInstance();
    districtFlag = true;
    blockFlag=true;
    villageFlag=true;
    districtItems.add(defaultSelectedDistrict);
    setState(() {
      prefs.getString("lang")!= null &&  prefs.getString("lang")!="" &&  prefs.getString("lang")=="en"?
      context.setLocale(Locale('en', 'US')):
      context.setLocale(Locale('ta', 'IN'));

    });
    /*List<Map> dlist =
    // await dbClient.rawQuery('SELECT * FROM ' + table_District);
    print(dlist.toString());
    districtItems.add(defaultSelectedDistrict);
    districtItems.addAll(dlist);
    selectedDistrict = defaultSelectedDistrict[key_dcode]!;*/
  }
  Future<bool> _onWillPop() async {
    Navigator.of(context, rootNavigator: true).pop(context);
    return true;
  }
  //Dropdown Input Field Widget
  Widget addInputDropdownField(int index, String inputHint, String fieldName,
      String errorText) {
    List dropList = [];
    String keyCode = "";
    String titleText = "";
    String titleTextTamil = "";

    if (index == 0) {
      dropList = taxType;
      keyCode = "taxCode";
      titleText = "taxname";
      titleTextTamil = "taxname";
    } else if (index == 1) {
      dropList =districtlist;
      keyCode = "dcode";
      titleText = "dname";
      titleTextTamil = "dname";
    } else if (index == 2) {
      dropList =blockList;
      keyCode = "bcode";
      titleText = "bname";
      titleTextTamil = "bname";
    } else if (index == 3) {
      dropList =villageList;
      keyCode = "pvcode";
      titleText = "pvname";
      titleTextTamil = "pvname";
    } else {
      print("End.....");
    }
    return FormBuilderDropdown(
      style: TextStyle(
          fontSize: 12, fontWeight: FontWeight.w400, color: c.grey_8),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 5),
          hintText: inputHint,
          hintStyle: TextStyle(fontSize: 11),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: UIHelper.getInputBorder(1, borderColor: c.grey_6),
          focusedBorder: UIHelper.getInputBorder(1, borderColor: c.grey_6),
        ),
        name: fieldName,
      initialValue: index == 0
          ? selectedTaxType
          : index == 1
          ? selectedDistrict
          : index == 2
          ? selectedBlock
          : selectedvillage,
      onTap: () async {
        if (index == 1) {
          selectedDistrict = "";
          selectedBlock = "";
          selectedvillage = "";
          // model.selectedBlockList.clear();
          // model.selectedVillageList.clear();
        } else if (index == 2) {
          selectedBlock = "";
          selectedvillage = "";
          // model.selectedVillageList.clear();
        } else if (index == 3) {
          selectedvillage = "";
        } else {
          print("End of the Statement......");
        }
        setState(() {});
      },
      iconSize: 28,
      items: dropList.map((item) => DropdownMenuItem(
        value: item[keyCode],
        child: Text(
          preferencesService.getUserInfo("lang") == "en"
              ? item[titleText].toString()
              : item[titleTextTamil].toString(),
          style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
              color: c.grey_8),
        ),
      ))
          .toList(),
      onChanged: (value) async {
        if (index == 0) {
          selectedTaxType = value.toString();
          selectedDistrict="";
          selectedBlock="";
          selectedvillage="";
        } else if (index == 1) {
          selectedDistrict = value.toString();
          selectedBlock="";
          selectedvillage="";
          // await model.loadUIBlock(selectedDistrict);
        } else if (index == 2) {
          selectedBlock = value.toString();
          selectedvillage="";
          // await model.loadUIVillage(selectedDistrict, selectedBlock);
        } else if (index == 3) {
          selectedvillage = value.toString();
        } else {
          print("End of the Statement......");
        }
        setState(() {});
      },
    );
  }
  @override
  Widget build (BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: c.colorPrimary,
            centerTitle: true,
            elevation: 2,
            title:Container(
                      child: Text(
                        'view_receipt_details'.tr().toString(),
                        style: TextStyle(fontSize: 14),
                      ),
            ),
          ),
        body:SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                  children: [
                    Container(
                      child: Image.asset(
                        imagePath.house_tax,
                        fit: BoxFit.fitWidth,
                        width: MediaQuery.of(context).size.width,
                        height: 250,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 150,left: 10,right: 10),
                      padding: EdgeInsets.only(left: 20,right: 20,top: 20),
                      decoration:
                      UIHelper.roundedBorderWithColorWithShadow(
                          15,c.white,c.white,borderColor: Colors.transparent,borderWidth: 5),
                      child:  Column(
                        children: [
                          Visibility(
                            visible: districtFlag ? true : false,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    'taxType'.tr().toString()+" : ",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: c.grey_10),
                                  ),
                                ),
                                UIHelper.horizontalSpaceMedium,
                                Container(
                                    margin: EdgeInsets.only(left: 35),
                                    width:150,
                                    height: 25,
                                    child: addInputDropdownField(
                                        0, 'select_taxtype'.tr().toString(),
                                        'taxType'.tr().toString(), "Required"),
                                )
                              ],
                            ),
                          ),
                          UIHelper.verticalSpaceSmall,
                          Visibility(
                            visible: districtFlag ? true : false,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    'district'.tr().toString()+" : ",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: c.grey_10),
                                  ),
                                ),
                                UIHelper.horizontalSpaceMedium,
                                Container(
                                    margin: EdgeInsets.only(left: 45),
                                    width:150,
                                    height: 25,
                                    child:
                                    addInputDropdownField(1, 'select_District'.tr().toString(),'district', "Required"),
                                )
                              ],
                            ),
                          ),
                          UIHelper.verticalSpaceSmall,
                          Visibility(
                            visible: blockFlag ? true : false,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    'block'.tr().toString()+" : ",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: c.grey_10),
                                  ),
                                ),
                                UIHelper.horizontalSpaceMedium,
                                Container(
                                    margin: EdgeInsets.only(left: 50),
                                    width:150,
                                    height: 25,
                                    child:
                                    addInputDropdownField(
                                        2, 'select_Block'.tr().toString(),
                                        "block", "Required"),
                                )
                              ],
                            ),
                          ),
                          UIHelper.verticalSpaceSmall,
                          Visibility(
                            visible: villageFlag ? true : false,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    'villagePanchayat'.tr().toString()+" : ",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: c.grey_10),
                                  ),
                                ),
                                Container(
                                    margin: EdgeInsets.only(left: 12),
                                    width:145,
                                    height: 25,
                                    child:
                                    addInputDropdownField(
                                        3, 'select_VillagePanchayat'.tr().toString(),
                                        "villagePanchayat", "Required"),
                                )
                              ],
                            ),
                          ),
                          Visibility(
                            visible: districtFlag ? true : false,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      child: Text(
                                        'assesmentNo'.tr().toString()+" : ",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: c.grey_10),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 5),
                                      height:25,
                                      width:45,
                                      decoration: BoxDecoration(
                                        color: c.grey_3,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                        ),

                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 5,left: 3),
                                        child: TextFormField(
                                          minLines: 1,
                                          decoration: const InputDecoration(
                                              hintStyle: TextStyle(
                                                fontSize: 12,
                                              ),
                                              border:InputBorder.none
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                UIHelper.verticalSpaceLarge,
                                UIHelper.horizontalSpaceTiny,
                                Row(
                                  children: [
                                    Container(
                                      child: Text(
                                        "("+'or'.tr().toString()+")",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: c.grey_10),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(left: 4),
                                      child: Text(
                                        'receiptno'.tr().toString()+" : ",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: c.grey_10),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 5),
                                      height:25,
                                      width: 45,
                                     decoration: BoxDecoration(
                                        color: c.grey_3,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                        ),

                                     ),
                                     child: Padding(
                                       padding: EdgeInsets.only(top: 5,left: 5),
                                       child: TextFormField(
                                         minLines: 1,
                                         decoration: const InputDecoration(
                                             border:InputBorder.none
                                         ),
                                       ),
                                     ),
                                    ),
                                   /* Container(
                                      // margin: EdgeInsets.only(top: 5,left: 5,bottom: 10),
                                      padding: EdgeInsets.only(left: 20,right: 13,top: 10),
                                      decoration:
                                      UIHelper.roundedBorderWithColorWithShadow(
                                          10,c.white,borderColor: Colors.transparent,borderWidth: 5),)*/
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                              child: TextButton(
                                child: Text("submit".tr().toString(),
                                    style: TextStyle(color: c.white, fontSize: 13)),
                                style: ButtonStyle(
                                    backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        c.colorPrimary),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(25),
                                            topRight: Radius.circular(25),
                                            bottomLeft: Radius.circular(25),
                                            bottomRight: Radius.circular(25),
                                          ),
                                        ))),
                                onPressed: () {
                                  // ValidatePassword();
                                },
                              )),
                        ],
                      ),
                    ),
                  ]
              ),
              Visibility(
                visible: true,
                child: Container(
                    padding: EdgeInsets.only(left: 10,right: 10,top: 20),
                    margin: EdgeInsets.only(top: 15),
                    child: AnimationLimiter(
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount:1,
                        // itemCount: houseList == null ? 0 : houseList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return  AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 800),
                            child: SlideAnimation(
                              horizontalOffset: 200.0,
                              child: FlipAnimation(
                                child: InkWell(
                                  onTap: () { },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: c.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                        ),
                                        border: Border.all(
                                            color: c.colorPrimary,width: 2
                                        )
                                    ),
                                    margin:  EdgeInsets.symmetric(horizontal:10, vertical: 10),
                                    child: Row(
                                      children: [
                                        Container(
                                            width: 100,
                                            height: 180,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                  colors: [
                                                    c.colorPrimary,
                                                    c.colorPrimaryDark,
                                                  ],
                                                  begin: const FractionalOffset(0.0, 0.0),
                                                  end: const FractionalOffset(1.0, 0.0),
                                                  stops: [1.0, 0.0],
                                                  tileMode: TileMode.clamp),
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(0),
                                                topRight: Radius.circular(110),
                                                bottomRight: Radius.circular(110),
                                                bottomLeft: Radius.circular(0),
                                              ),
                                            ),
                                        ),
                                        Container(
                                            child:  Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                   padding: EdgeInsets.only(left: 10,top: 10),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            'collectionDate'.tr().toString(),
                                                            style:
                                                            TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                              color: c.grey_9,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                              height: 5),
                                                          Text(
                                                            "",
                                                            style:
                                                            TextStyle(
                                                              fontSize: 13,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                              color: c.grey_10,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.only(left: 12),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          'receiptno'.tr().toString(),
                                                          style:
                                                          TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                            FontWeight
                                                                .normal,
                                                            color: Colors
                                                                .black,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                            height: 5),
                                                        Text(
                                                          "",
                                                          style:
                                                          TextStyle(
                                                            fontSize: 13,
                                                            fontWeight:
                                                            FontWeight
                                                                .bold,
                                                            color: c.grey_10,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                ),
                                                Container(
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      UIHelper.horizontalSpaceSmall,
                                                      Text(
                                                        'download_tamil'.tr().toString()+"\n"+"tamil_1".tr().toString()+"\n",
                                                        style:
                                                        TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                          FontWeight
                                                              .bold,
                                                          color: c.grey_9,
                                                        ),
                                                      ),
                                                      Padding(padding: EdgeInsets.only(left: 25),
                                                        child:Image.asset(imagePath.download,height: 17,width: 17,),),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      UIHelper.horizontalSpaceSmall,
                                                      Text(
                                                        'download_english'.tr().toString()+"\n"+"english_1".tr().toString()+"\n",
                                                        style:
                                                        TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                          FontWeight
                                                              .bold,
                                                          color: c.grey_9,
                                                        ),
                                                      ),
                                                      Padding(padding: EdgeInsets.only(left: 25),
                                                        child:Image.asset(imagePath.download,height: 17,width: 17,),),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),)
                                      ],
                                    ),

                                  ),),),
                            ),
                          );
                        },
                      ),
                    )),
              )
            ],
          ),
      ),
    ));
  }
}