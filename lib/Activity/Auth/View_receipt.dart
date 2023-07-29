import 'dart:async';
import 'dart:convert';
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
  bool taxFlag=false;
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
  TextEditingController assessmentController = TextEditingController();
  TextEditingController receiptController = TextEditingController();
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
          constraints: BoxConstraints(
            maxHeight: 30
          ),
          hintText: inputHint,
          hintStyle: TextStyle(fontSize: 11),
          filled: true,
          fillColor: c.need_improvement2,
          enabledBorder: OutlineInputBorder(
            borderSide:BorderSide(color: c.need_improvement1, width: 0.0),
            borderRadius:BorderRadius.circular(8),
          ),
          focusedBorder: UIHelper.getInputBorder(1, borderColor: c.dot_light_screen_lite),
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
          listvisbility=false;
          assessmentController.text="";
          receiptController.text="";
        } else if (index == 1) {
          selectedDistrict = value.toString();
          selectedBlock="";
          selectedvillage="";
          listvisbility=false;
          assessmentController.text="";
          receiptController.text="";
          // await model.loadUIBlock(selectedDistrict);
        } else if (index == 2) {
          selectedBlock = value.toString();
          selectedvillage="";
          listvisbility=false;
          assessmentController.text="";
          receiptController.text="";
          // await model.loadUIVillage(selectedDistrict, selectedBlock);
        } else if (index == 3) {
          selectedvillage = value.toString();
          listvisbility=false;
          assessmentController.text="";
          receiptController.text="";
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
                    Container(
                      height: MediaQuery.of(context).size.height/2,
                      child: Image.asset(
                        imagePath.house_tax,
                        fit: BoxFit.fitWidth,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
              Container(
                transform: Matrix4.translationValues(-6.0,-70.0,10.0),
                margin: EdgeInsets.only(left: 25,right: 15,top:5),
                padding:  EdgeInsets.only(top: 10,left: 5,right: 5),
                height: MediaQuery.of(context).size.height/1.8,
                // padding: EdgeInsets.only(left: 12,top: 20),
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
                          Expanded(
                            flex:1,
                            child: Text(
                              'taxType'.tr().toString()+" : ",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: c.grey_10),
                            ),
                          ),
                          UIHelper.horizontalSpaceMedium,
                          Expanded(
                            flex: 2,
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
                          Expanded(
                            flex:1,
                            child: Text(
                              'district'.tr().toString()+" : ",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: c.grey_10),
                            ),
                          ),
                          UIHelper.horizontalSpaceMedium,
                          Expanded(
                            flex: 2,
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
                          Expanded(
                            flex:1,
                            child: Text(
                              'block'.tr().toString()+" : ",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: c.grey_10),
                            ),
                          ),
                          UIHelper.horizontalSpaceMedium,
                          Expanded(
                            flex: 2,
                            child:addInputDropdownField(
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

                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              'villagePanchayat'.tr().toString()+" : ",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: c.grey_10),
                            ),
                          ),
                          UIHelper.horizontalSpaceMedium,
                          Expanded(
                            flex: 2,
                            child: addInputDropdownField(
                                3, 'select_VillagePanchayat'.tr().toString(),
                                "villagePanchayat", "Required"),
                          )
                        ],
                      ),
                    ),
                    UIHelper.verticalSpaceSmall,
                    Container(
                      decoration:UIHelper.roundedBorderWithColorWithShadow(
                          15,c.need_improvement2,c.need_improvement2,borderColor: Colors.transparent,borderWidth: 5),
                      padding: EdgeInsets.only(top: 15,bottom: 10,left: 10,right: 10),
                      child:Column(
                       children: [
                         Row(
                           children: [
                             Expanded(
                               flex: 1,
                               child: Text(
                                 'assesmentNo'.tr().toString()+" : ",
                                 style: TextStyle(
                                     fontSize: 12,
                                     color: c.grey_10),
                               ),
                             ),
                             Expanded(
                               flex: 2,
                               child: Container(
                                 padding: EdgeInsets.only(top: 5),
                                 height:25,
                                 width:45,
                                 decoration: BoxDecoration(
                                   color: c.white,
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
                                     controller: assessmentController,
                                     inputFormatters: <TextInputFormatter>[
                                       FilteringTextInputFormatter.digitsOnly
                                     ],
                                     decoration: const InputDecoration(
                                         hintStyle: TextStyle(
                                           fontSize: 12,
                                         ),
                                         border:InputBorder.none
                                     ),
                                     style: TextStyle(
                                         fontSize: 12
                                     ),
                                   ),
                                 ),
                               ),
                             ),
                           ],
                         ),
                         UIHelper.verticalSpaceSmall,
                         Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Text("("+'or'.tr().toString()+")",style: TextStyle(
                                 fontSize: 12
                             ),)
                           ],
                         ),
                         UIHelper.verticalSpaceSmall,
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceAround,
                           children: [
                             Expanded(
                               flex:1,
                               child: Text(
                                 'receiptno'.tr().toString()+" : ",
                                 style: TextStyle(
                                     fontSize: 12,
                                     color: c.grey_10),
                               ),
                             ),
                             Expanded(
                                 flex: 2,
                                 child: Container(
                                   padding: EdgeInsets.only(top: 5),
                                   height:25,
                                   width:45,
                                   decoration: BoxDecoration(
                                     color: c.white,
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
                                       controller: receiptController,
                                       inputFormatters: <TextInputFormatter>[
                                         FilteringTextInputFormatter.digitsOnly
                                       ],
                                       decoration: const InputDecoration(
                                           hintStyle: TextStyle(
                                             fontSize: 12,
                                           ),
                                           border:InputBorder.none
                                       ),
                                       style: TextStyle(
                                           fontSize: 12
                                       ),
                                     ),
                                   ),
                                 ))
                           ],
                         ),
                       ],
                      )
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 5),
                      child: TextButton(
                        child: Text("submit".tr().toString(),
                            style: TextStyle(color: c.white, fontSize: 13)),
                        style: TextButton.styleFrom(
                            fixedSize: const Size(120, 20),
                            shape:StadiumBorder(),
                            backgroundColor: c.colorPrimary
                        ),
                        onPressed: () {
                          setState(() {
                            Validate();

                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
              Visibility(
                visible:listvisbility,
                child: Container(
                    transform: Matrix4.translationValues(-5.0,-50.0,10.0),
                    padding: EdgeInsets.only(left: 10,right: 10),
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
                                          height: 185,
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
                                              topLeft: Radius.circular(5),
                                              topRight: Radius.circular(110),
                                              bottomRight: Radius.circular(110),
                                              bottomLeft: Radius.circular(5),
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
                                                        FontWeight.bold,
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
                                                        FontWeight.bold,
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
                                                    InkWell(
                                                      onTap: (){
                                                        print('download_tamil'.tr().toString()+"tamil_1".tr().toString());
                                                      },
                                                     child: Padding(padding: EdgeInsets.only(left: 25),
                                                        child:Image.asset(imagePath.download,height: 17,width: 17,),),
                                                    )
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
                                                        FontWeight.bold,
                                                        color: c.grey_9,
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: (){
                                                        print('download_english'.tr().toString()+"english_1".tr().toString());
                                                      },
                                                      child: Padding(padding: EdgeInsets.only(left: 25),
                                                        child:Image.asset(imagePath.download,height: 17,width: 17,),),
                                                    )
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
  Validate() {
   if(selectedTaxType!=null && selectedTaxType !="")
     {
       if(selectedDistrict!=null && selectedDistrict!="")
       {
         if(selectedBlock!=null && selectedBlock!="")
         {
           if(selectedvillage !=null && selectedvillage !="")
           {
            if((assessmentController.text!=""||receiptController.text!="")&&(assessmentController.text!=null||receiptController.text!=null))
              {
                listvisbility=true;
              }
            else
              {
                listvisbility=false;
                utils.showAlert(context,'enter_assessment_number'.tr().toString());
              }
           }
           else{
             utils.showAlert(context,'select_VillagePanchayat'.tr().toString());
           }
         }
         else{
           utils.showAlert(context,  "select_Block".tr().toString());
         }
       }
       else{
         utils.showAlert(context, 'select_District'.tr().toString());
       }
     }
   else
     {
       utils.showAlert(context, 'select_taxtype'.tr().toString());
     }
  }
}