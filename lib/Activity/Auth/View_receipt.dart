import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:http/io_client.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:public_vptax/Layout/ui_helper.dart';
import 'package:public_vptax/Resources/ColorsValue.dart' as c;
import 'package:public_vptax/Resources/ImagePath.dart' as imagePath;
import 'package:public_vptax/Resources/StringsKey.dart' as s;
import 'package:public_vptax/Services/Preferenceservices.dart';
import 'package:public_vptax/Services/locator.dart';
import 'package:public_vptax/Utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

import '../../Layout/customgradientbutton.dart';
import '../../Model/startup_model.dart';
import '../../Resources/StringsKey.dart';
import '../../Services/Apiservices.dart';
import '../../Utils/ContentInfo.dart';

class ViewReceipt extends StatefulWidget {
  @override
  State<ViewReceipt> createState() => _ViewReceiptState();
}
class _ViewReceiptState extends State<ViewReceipt> {
  @override
  Utils utils = Utils();
  ApiServices apiServices = ApiServices();
  late StartUpViewModel model;
  late SharedPreferences prefs;
  var dbClient;
  List districtItems = [];
  String selectedDistrict = "";
  String selectedBlock = "";
  String selectedvillage = "";
  String selectedTaxType = "";
  bool taxFlag=false;
  bool districtFlag=false;
  bool blockFlag=false;
  bool villageFlag=false;
  bool listvisbility = false;
  String finalOTP = '';
  String userPassKey = "";
  String userDecriptKey = "";
  Uint8List? pdf;
  PreferenceService preferencesService = locator<PreferenceService>();
  final  TextEditingController assessmentController = TextEditingController();
  final  TextEditingController receiptController = TextEditingController();
  final  scrollController = ScrollController();
  TextEditingController mobileController = TextEditingController();
  OtpFieldController OTPcontroller = OtpFieldController();
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
    taxFlag=true;
    districtFlag = true;
    blockFlag=true;
    villageFlag=true;
    districtItems.add(defaultSelectedDistrict);
    receiptController.addListener(() {
      if (receiptController.text.isNotEmpty) {
        assessmentController.clear();
      }
    });
    assessmentController.addListener(() {
      if (assessmentController.text.isNotEmpty) {
        receiptController.clear();
      }
    });
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
  Widget addInputDropdownField(int index, String inputHint, String fieldName,StartUpViewModel model
      ) {
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
      dropList = districtlist;
      keyCode = "dcode";
      titleText ="dname";
      titleTextTamil ="dname";
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
    }
    return FormBuilderDropdown(
      style: TextStyle(
          fontSize: 12, fontWeight: FontWeight.w400, color: c.grey_8),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 5),
        suffixIcon: Icon(
          Icons.arrow_drop_down,
          color: c.grey_8,
        ),
        constraints: BoxConstraints(maxHeight: 35),
        hintText: inputHint,
        hintStyle: TextStyle(
          fontSize: 11,
          color: c.red
        ),
        filled: true,
        fillColor: c.need_improvement2,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: c.need_improvement2, width: 10.0),
          borderRadius: BorderRadius.circular(18),
        ),
        focusedBorder:
        UIHelper.getInputBorder(1, borderColor: c.dot_light_screen_lite),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 10.0),
          borderRadius: BorderRadius.circular(
              20), // Increase the radius to adjust the height
        ),
      ),
      icon: Container(width: 0, height: 0),

      name: fieldName,
      initialValue: index == 0
          ? selectedTaxType
          : index == 1
          ? selectedDistrict
          : index == 2
          ? selectedBlock
          : selectedvillage,
      onTap: () async {
        if (index == 0) {
          selectedDistrict = "";
          selectedBlock = "";
          selectedvillage = "";
        } else if (index == 1) {
          selectedBlock = "";
          selectedvillage = "";
        } else if (index == 2) {
          selectedvillage = "";
        }
        setState(() {});
      },
      // iconSize: 28,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(
            errorText:inputHint)
      ]),
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
        if(index==0)
          {
            selectedTaxType=value.toString();
            selectedDistrict = "";
            selectedBlock = "";
            selectedvillage = "";
          }
       else if (index == 1) {
          selectedDistrict = value.toString();

        } else if (index == 2) {
          selectedBlock = value.toString();
        } else if (index == 3) {
          selectedvillage = value.toString();
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
            body: SafeArea(
              top: true,
              child: ViewModelBuilder<StartUpViewModel>.reactive(
                  onModelReady: (model) async {},
                  builder: (context, model, child) {
                    return Container(
                        child:dropdowncard(context, model),);
                  },
                  viewModelBuilder: () => StartUpViewModel()),
            )));
  }
  Widget dropdowncard(BuildContext context,StartUpViewModel model) {
    return SingleChildScrollView(
      controller: scrollController,
      scrollDirection: Axis.vertical,
      child: Column(
          children: [
            Container(
              transform: Matrix4.translationValues(0.0,-50.0,0.0),
              height: MediaQuery.of(context).size.height/2,
              child: Image.asset(
                imagePath.house_tax,
                fit: BoxFit.fitWidth,
                width: MediaQuery.of(context).size.width,
              ),
            ),
            Container(
                transform: Matrix4.translationValues(-6.0,-120.0,10.0),
                margin: EdgeInsets.only(left: 25,right: 15,top:5),
                padding:  EdgeInsets.only(top: 10,left: 5,right: 5,bottom: 50),
                // height: MediaQuery.of(context).size.height/1.5,
                // padding: EdgeInsets.only(left: 12,top: 20),
                decoration:
                UIHelper.roundedBorderWithColorWithShadow(
                    15,c.white,c.white,borderColor: Colors.transparent,borderWidth: 5),
                child:  Column(
                    children: [
                      Visibility(
                        visible: taxFlag ? true : false,
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
                              child: addInputDropdownField(0, 'select_taxtype'.tr().toString(),'',model),
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
                              addInputDropdownField(1, 'select_District'.tr().toString(), "", model),
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
                              child:addInputDropdownField(2, 'select_Block'.tr().toString(), "", model),
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
                              child:addInputDropdownField(3, 'select_VillagePanchayat'.tr().toString(),"villagePanchayat",model),
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
                                        'assesmentNumber'.tr().toString()+" : ",
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
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
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
                                      Text("("+'or'.tr().toString()+")",style: TextStyle(fontSize: 12),)
                                    ]
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
                                              focusNode: FocusNode(
                                                  canRequestFocus: false
                                              ),
                                              controller: receiptController,
                                              inputFormatters: <TextInputFormatter>[
                                                FilteringTextInputFormatter.digitsOnly,
                                              ],
                                              keyboardType: TextInputType.number,
                                              decoration: const InputDecoration(
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
                              ])),])),
            Container(
                transform: Matrix4.translationValues(5.0,-150.0,10.0),
                child:InkWell(
                  onTap: ()
                  {
                    /*scrollController.animateTo(0,
                        duration: Duration(milliseconds: 500), curve: Curves.easeInOut);*/
                  },
                  child: TextButton(
                    child:Padding(
                        padding: EdgeInsets.only(left: 5,right: 5),
                        child: Text("submit".tr().toString(),
                            style: TextStyle(color: c.white, fontSize: 13))
                    ),
                    style: TextButton.styleFrom(
                        fixedSize: const Size(130, 20),
                        shape:StadiumBorder(),
                        backgroundColor: c.colorPrimary
                    ),
                    onPressed: () {
                      setState(() {
                        Validate();
                        scrollController.animateTo(400,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.linearToEaseOut,
                        );
                      });
                    },
                  ),
                )
            ),
            listview()
          ]
      ),
    );
  }
  Widget listview()
  {
    return  Visibility(
        visible:listvisbility,
      child: Container(
          transform: Matrix4.translationValues(-5.0,-80.0,10.0),
          padding: EdgeInsets.only(left: 10,right: 10),
          child: AnimationLimiter(
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
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
                                            'receiptno'.tr().toString()+":",
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
                                                    fontWeight: FontWeight.bold,color: c.grey_9
                                                )
                                            ),
                                            InkWell(
                                              onTap: ()
                                              {
                                                _settingModalBottomSheet(context);
                                                print("download_tamil".tr().toString()+"\n"+"tamil_1".tr().toString()+"\n");
                                              },
                                              child: Padding(padding: EdgeInsets.only(left: 25),
                                                child:Image.asset(imagePath.download,height: 17,width: 17,),),
                                            )
                                          ],
                                        )
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
                                              _settingModalBottomSheet(context);
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
    );
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
              utils.showAlert(context, ContentType.warning,'enter_assessment_number'.tr().toString());
            }
          }
          else{
            utils.showAlert(context, ContentType.warning,'select_VillagePanchayat'.tr().toString());
          }
        }
        else{
          utils.showAlert(context, ContentType.warning,'select_Block'.tr().toString());
        }
      }
      else{
        utils.showAlert(context, ContentType.warning,'select_District'.tr().toString());
      }
    }
    else
    {
      utils.showAlert(context, ContentType.warning, "select_taxtype".tr().toString(),
      );
    }
  }
  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: c.full_transparent,
        builder: (BuildContext bc) {
          return Wrap(
            children: <Widget>[
              Container(
                // padding:EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 10),
                // margin: EdgeInsets.only(
                //     bottom: 10,top: 10,left: 10,right: 10),
                  decoration: UIHelper.GradientContainer(
                      30.0,30,0,0, [c.white, c.white]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        alignment:Alignment.center,
                        child: Text(
                            "Enter  OTP"
                        ),
                      ),
                      Visibility(
                        visible: true,
                        child: Column(
                          children: [
                            Padding(
                              // padding:EdgeInsets.all(25),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 5),
                              child: OTPTextField(
                                onChanged: (pin) {
                                  print("Changed: " + pin);
                                },
                                onCompleted: (pin) {
                                  utils.closeKeypad(context);
                                  finalOTP = pin;
                                },
                                width: 250,
                                controller: OTPcontroller,
                                length: 6,
                                fieldStyle: FieldStyle.box,
                                fieldWidth:35,
                              ),
                            ),
                          ],
                        ),
                      ),
                      CustomGradientButton(
                        onPressed: () async {
                          if (await utils.isOnline()) {
                            Navigator.pop(context);
                            utils.showAlert(context, ContentType.success, "Receipt Downloaded Successfully");
                          } else {
                            utils.showAlert(
                              context,
                              ContentType.fail,
                              "noInternet".tr().toString(),
                            );
                          }
                        },
                        // btnPadding: 5,
                        width: 90,
                        height: 40,
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            'verifyOTP'.tr().toString(),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ],
          );
        }
    );
  }

}
