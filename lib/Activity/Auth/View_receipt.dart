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
                        'View Receipt Details',
                        style: TextStyle(fontSize: 15),
                      ),
            ),
          ),
        body:SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                  children: [
                    Container(
                      /*child: Image.asset(
                        // imagePath.house_tax,
                       , fit: BoxFit.fitWidth,
                        width: MediaQuery.of(context).size.width,
                        height: 250,
                      ),*/
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 150,left: 20,right: 20),
                      padding: EdgeInsets.all(20),
                      decoration:
                      UIHelper.roundedBorderWithColorWithShadow(
                          15,c.white,borderColor: Colors.transparent,borderWidth: 5),
                      child:  Column(
                        children: [
                          Visibility(
                            visible: districtFlag ? true : false,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    'Tax Type'.tr().toString()+" : ",
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
                                    child: FormBuilderDropdown(
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(left: 10),
                                        hintText: "Select Tax Type",
                                        hintStyle: TextStyle(fontSize: 11),
                                        filled: true,
                                        fillColor: Colors.white,
                                        enabledBorder: UIHelper.getInputBorder(1, borderColor: c.grey_6),
                                        focusedBorder: UIHelper.getInputBorder(1, borderColor: c.grey_6),
                                      ),
                                      name: "Select Tax Type",
                                      onTap: () async {
                                      },
                                      iconSize: 28,
                                      items: <DropdownMenuItem<int>>[
                                        DropdownMenuItem(
                                          child:Text(
                                            'Property Tax',
                                            style: TextStyle(
                                                fontSize: 11
                                            ),),value: 1,
                                        ),
                                        DropdownMenuItem(
                                          child:Text(
                                            'Water Charges',
                                            style: TextStyle(
                                                fontSize: 11
                                            ),),
                                          value: 2,
                                        ),
                                        DropdownMenuItem(
                                          child:Text(
                                            'Professional Tax',
                                            style: TextStyle(
                                                fontSize: 11
                                            ),),
                                          value: 3,
                                        ),
                                        DropdownMenuItem(
                                          child:Text(
                                            'Non Tax',
                                            style: TextStyle(
                                                fontSize: 11
                                            ),),
                                          value: 4,
                                        ),
                                        DropdownMenuItem(
                                          child:Text(
                                            'Trade License',
                                            style: TextStyle(
                                                fontSize: 11
                                            ),),
                                          value: 5,
                                        ),
                                      ],
                                      onChanged: (value) async {

                                      },
                                    )
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
                                    'District'.tr().toString()+" : ",
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
                                    FormBuilderDropdown(
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(left: 10),
                                        hintText: "Select District",
                                        hintStyle: TextStyle(fontSize: 12),
                                        filled: true,
                                        fillColor: Colors.white,
                                        enabledBorder: UIHelper.getInputBorder(1, borderColor: c.grey_6),
                                        focusedBorder: UIHelper.getInputBorder(1, borderColor: c.grey_6),
                                      ),
                                      name: "Select District",
                                      onTap: () async {
                                      },
                                      iconSize: 28,
                                      items: <DropdownMenuItem<int>>[
                                        DropdownMenuItem(
                                          child:Text(
                                            'Thanjavur',
                                            style: TextStyle(
                                                fontSize: 11
                                            ),),
                                          value: 1,
                                        ),
                                        DropdownMenuItem(
                                          child:Text(
                                            'Tiruvarur',style: TextStyle(
                                              fontSize: 11
                                          ),),
                                          value: 2,
                                        ),
                                        DropdownMenuItem(
                                          child:Text(
                                            'Ariyalur',style: TextStyle(
                                              fontSize: 11
                                          ),),
                                          value: 3,
                                        ),
                                      ],
                                      onChanged: (value) async {
                                      },
                                    )
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
                                    'Block'.tr().toString()+" : ",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: c.grey_10),
                                  ),
                                ),
                                UIHelper.horizontalSpaceMedium,
                                Container(
                                    margin: EdgeInsets.only(left: 55),
                                    width:150,
                                    height: 25,
                                    child:
                                    FormBuilderDropdown(
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(left: 10),
                                        hintText: "Select Block",
                                        hintStyle: TextStyle(fontSize: 12),
                                        filled: true,
                                        fillColor: Colors.white,
                                        enabledBorder: UIHelper.getInputBorder(1, borderColor: c.grey_6),
                                        focusedBorder: UIHelper.getInputBorder(1, borderColor: c.grey_6),
                                      ),
                                      name: "Select Block",
                                      onTap: () async {
                                      },
                                      iconSize: 28,
                                      /*autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(errorText: "Pleas Select Block "),
                                ]),*/
                                      items: <DropdownMenuItem<int>>[
                                        DropdownMenuItem(
                                          child:Text(
                                            'Thanjavur',
                                            style: TextStyle(
                                                fontSize: 11
                                            ),),
                                          value: 1,
                                        ),
                                        DropdownMenuItem(
                                          child:Text(
                                            'Tiruvarur',
                                            style: TextStyle(
                                                fontSize: 11
                                            ),),
                                          value: 2,
                                        ),
                                        DropdownMenuItem(
                                          child:Text(
                                            'Ariyalur',
                                            style: TextStyle(
                                                fontSize: 11
                                            ),),
                                          value:3,
                                        ),
                                      ],
                                      onChanged: (value) async {
                                      },
                                    )
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
                                    'Village Panchayat'.tr().toString()+" : ",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: c.grey_10),
                                  ),
                                ),
                                Container(
                                    margin: EdgeInsets.only(left: 10),
                                    width:145,
                                    height: 25,
                                    child:
                                    FormBuilderDropdown(
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(left: 4),
                                        hintText: "Select Village Pancha...",
                                        hintStyle: TextStyle(fontSize: 12),
                                        filled: true,
                                        fillColor: Colors.white,
                                        enabledBorder: UIHelper.getInputBorder(1, borderColor: c.grey_6),
                                        focusedBorder: UIHelper.getInputBorder(1, borderColor: c.grey_6),
                                      ),
                                      name: "Select Village Panchayat",
                                      onTap: () async {
                                      },
                                      iconSize: 28,
                                      items: <DropdownMenuItem<int>>[
                                        DropdownMenuItem(
                                          child:Text(
                                            'Thanjavur',
                                            style: TextStyle(
                                                fontSize: 11
                                            ),),
                                          value: 1,
                                        ),
                                        DropdownMenuItem(
                                          child:Text(
                                            'Tiruvarur',
                                            style: TextStyle(
                                                fontSize: 11
                                            ),),
                                          value: 2,
                                        ),
                                        DropdownMenuItem(
                                          child:Text(
                                            'Ariyalur',
                                            style: TextStyle(
                                                fontSize: 11
                                            ),),
                                          value: 3,
                                        ),
                                      ],
                                      onChanged: (value) async {
                                      },
                                    )
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
                                        'Assesment No'.tr().toString()+" : ",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: c.grey_10),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 5),
                                      height:25,
                                      width: 55,
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
                                      padding: EdgeInsets.only(left:3),
                                      child: Text(
                                        "("+'OR'.tr().toString()+")",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: c.grey_10),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(left: 5),
                                      child: Text(
                                        'Receipt No'.tr().toString()+" : ",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: c.grey_10),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 5),
                                      height:25,
                                      width: 55,
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
                                child: Text("Submit".tr().toString(),
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
                                            height: 150,
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
                                                   padding: EdgeInsets.only(left: 10,),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            'Collection Date:'.tr().toString(),
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
                                                  padding: EdgeInsets.only(left: 10),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          'Receipt Number'.tr().toString(),
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
                                                        "Download Receipt (In Tamil)",
                                                        style:
                                                        TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                          FontWeight
                                                              .bold,
                                                          color: c.grey_9,
                                                        ),
                                                      ),
                                                      /*Padding(padding: EdgeInsets.only(bottom:15,left: 25),
                                                        child:Image.asset(imagePath.download,height: 17,width: 17,),),*/
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      UIHelper.horizontalSpaceSmall,
                                                      Text(
                                                        "Download Receipt (In English)",
                                                        style:
                                                        TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                          FontWeight
                                                              .bold,
                                                          color: c.grey_9,
                                                        ),
                                                      ),
                                                      /*Padding(padding: EdgeInsets.only(bottom:10,left: 15),
                                                        child:Image.asset(imagePath.download,height: 17,width: 17,),),*/
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