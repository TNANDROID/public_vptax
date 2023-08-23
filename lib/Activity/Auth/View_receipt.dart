import 'dart:async';
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
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
  Uint8List? pdf;
  PreferenceService preferencesService = locator<PreferenceService>();
  final  TextEditingController assessmentController = TextEditingController();
  final  TextEditingController receiptController = TextEditingController();
  final  scrollController = ScrollController();
  OtpFieldController OTPcontroller = OtpFieldController();
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
    // districtItems.add(defaultSelectedDistrict);
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
    String initValue="";
    if (index == 0) {
      dropList=preferencesService.taxTypeList;;
      print("tax type>>>"+dropList.toString());
      keyCode = key_taxtypeid;
      titleText = key_taxtypedesc_en;
      titleTextTamil = key_taxtypedesc_ta;
      initValue=selectedTaxType;
    } else if (index == 1) {
      dropList = preferencesService.districtList;
      print("districtList>>>"+dropList.toString());
      keyCode = key_dcode;
      titleText = key_dname;
      titleTextTamil = key_dname_ta;
      initValue = selectedDistrict;
    } else if (index == 2) {
      dropList =model.selectedBlockList;
      print("blockList>>>"+dropList.toString());
      keyCode = key_bcode;
      titleText = key_bname;
      titleTextTamil = key_bname_ta;
      initValue = selectedBlock;
    } else if (index == 3) {
      dropList =model.selectedVillageList;
      print("villageList>>>"+dropList.toString());
      keyCode = key_pvcode;
      titleText = key_pvname;
      titleTextTamil = key_pvname_ta;
      initValue=selectedvillage;
    }
    return
      FormBuilderDropdown(
      style: TextStyle(
          fontSize: 12, fontWeight: FontWeight.w400, color: c.grey_8),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 5,top: 6),
        suffixIcon: Icon(
          Icons.arrow_drop_down,
          color: c.grey_8,
        ),
        constraints: BoxConstraints(maxHeight: 35),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelText: inputHint,
        labelStyle: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, color: c.grey_9),
        filled: true,
        fillColor: c.full_transparent,
        enabledBorder:OutlineInputBorder(
          borderSide: BorderSide(color: c.need_improvement2, width: 25.0),
          borderRadius: BorderRadius.circular(18),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 25.0,color: c.need_improvement2),
          borderRadius: BorderRadius.circular(
              20), // Increase the radius to adjust the height
        ),
        focusedErrorBorder:OutlineInputBorder(
          borderSide: BorderSide(width: 10.0),
          borderRadius: BorderRadius.circular(
              20), // Increase the radius to adjust the height
        ),
      ),
      icon: Container(width: 0, height: 0),

      name: fieldName,
        initialValue: initValue,

       /* onTap: () async {
        if (index == 0) {
          selectedDistrict="";
          selectedBlock = "";
          listvisbility=false;
          receiptController.text="";
          assessmentController.text="";
          selectedvillage = "";
        } else if (index == 1) {
          selectedBlock = "";
          selectedvillage = "";
          listvisbility=false;
          receiptController.text="";
          assessmentController.text="";
        } else if (index == 2) {
          selectedvillage = "";
          listvisbility=false;
          receiptController.text="";
          assessmentController.text="";
        }
        setState(() {});
      },*/
      // iconSize: 28,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText:inputHint)
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
        print("onchanged>>>>>"+index.toString());
        if(index==0)
        {
          selectedTaxType=value.toString();
          selectedDistrict="";
          selectedBlock="";
          selectedvillage="";
        }
        else if (index == 1) {
         selectedDistrict=value.toString();
         model.loadUIBlock(selectedDistrict);
        } else if (index == 2) {
          selectedBlock = value.toString();
          model.loadUIVillage(selectedDistrict, selectedBlock);
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
                              child: addInputDropdownField(0, 'select_taxtype'.tr().toString(),"tax_type",model),
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
                              addInputDropdownField(1, 'select_District'.tr().toString(), "district", model),
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
                              child:addInputDropdownField(2, 'select_Block'.tr().toString(), "block", model),
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
          padding: EdgeInsets.only(left: 22,right: 22),
          child: AnimationLimiter(
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount:1,
              itemBuilder: (BuildContext context, int index) {
                return  AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 800),
                  child: SlideAnimation(
                    horizontalOffset: 200.0,
                    child: FlipAnimation(
                      child:Stack(
                          children: [
                            Container(
                              height: 220,
                              decoration: UIHelper.roundedBorderWithColorWithShadow(
                                  10,c.white,c.white,borderColor: Colors.transparent,borderWidth: 0),
                              child: Row(
                                children: [
                                Expanded(flex: 1,
                                    child: Container(
                                  decoration: BoxDecoration(
                                      color: c.colorAccentlight,
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10))
                                  ),
                                  )),
                                Expanded(
                                    flex: 3,
                                    child: Container(decoration: BoxDecoration(
                                    color: c.white,
                                    borderRadius: BorderRadius.only(topRight: Radius.circular(10),
                                        bottomRight: Radius.circular(10))
                                ),)),
                              ],),
                            ),
                            Container(
                              margin: EdgeInsets.all(10.0),
                                color: c.full_transparent,
                            child:
                            Column(
                              children: [
                              Row(
                                children: [
                                  Padding(padding: EdgeInsets.only(left: 7,top: 5),
                                  child: Text(
                                    'receiptno'.tr().toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: c.white
                                    ),
                                  ),),
                                  UIHelper.horizontalSpaceSmall,
                                  Padding(padding: EdgeInsets.only(top: 5),
                                  child: Text(
                                    '123456',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: c.primary_text_color2
                                    ),
                                  ),)
                                ],
                              ),
                                UIHelper.verticalSpaceSmall,
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                   children: [
                                     InkWell(
                                       child:Stack(
                                        children: [
                                          Container(
                                            width:280,
                                            padding: EdgeInsets.all(5),
                                            margin: EdgeInsets.only(left: 0,right: 10,bottom: 0,top: 10),
                                            decoration: UIHelper.roundedBorderWithColorWithShadow(10, c.white, c.white,borderColor: c.full_transparent,borderWidth: 0),
                                            child: Column(
                                              children: [
                                                Padding(
                                                    padding: EdgeInsets.only(top: 7,left: 5,right: 5),
                                                  child:Text(
                                                    'download_tamil'.tr().toString(),
                                                    overflow: TextOverflow.ellipsis,
                                                    style:TextStyle(
                                                      fontSize: 12,
                                                      color: c.text_color,
                                                      fontWeight: FontWeight.w500
                                                    )
                                                  )
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(top: 5,bottom: 5),
                                                   child:Text(
                                                    'tamil_1'.tr().toString(),
                                                     style: TextStyle(
                                                       fontWeight: FontWeight.w500,
                                                       color: c.text_color,
                                                       fontSize: 12,
                                                     ),
                                                   )
                                               ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            transform: Matrix4.translationValues(-8,25,0),
                                            decoration: UIHelper.circleWithColorWithShadow(300, c.white, c.white),
                                            child: Image.asset(imagePath.download_img,height: 25,width: 25,),
                                          )
                                        ],
                                         ),
                                       onTap: (){
                                         print("Receipt Downloaded Successfully");
                                         _settingModalBottomSheet(context);
                                       },
                                     )
                                   ],
                               ),
                                UIHelper.verticalSpaceMedium,
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                 children: [
                                   InkWell(
                                     child:  Stack(
                                       children: [
                                         Container(
                                             width:280,
                                             padding: EdgeInsets.all(5),
                                             margin: EdgeInsets.only(left: 0,right:10,bottom: 25,top:6),
                                             decoration: UIHelper.roundedBorderWithColorWithShadow(
                                                 10,c.white,c.white,borderColor:c.full_transparent,borderWidth: 0),
                                             child: Column(
                                               children: [
                                                 Padding(
                                                   padding: EdgeInsets.only(top: 7,left: 5,right: 5),
                                                   child: Text(
                                                     'download_english'.tr().toString(),
                                                     overflow: TextOverflow.ellipsis,
                                                     textAlign: TextAlign.right,
                                                     style: TextStyle(
                                                         color: c.text_color,
                                                         fontWeight: FontWeight.w500,
                                                         fontSize: 12,
                                                     ),
                                                   ),
                                                 ),
                                                Padding(
                                                  padding: EdgeInsets.only(top: 5,bottom: 5),
                                                child: Text(
                                                  'english_1'.tr().toString(),
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: c.text_color
                                                  ),
                                                ),)
                                               ],
                                             )
                                         ),
                                         Container(
                                           transform: Matrix4.translationValues(-11,22,0),
                                           decoration: UIHelper.circleWithColorWithShadow(300, c.white, c.white),
                                           child:Image.asset(imagePath.download_img,height: 25,width: 25,), //Icon
                                         ),
                                       ],),
                                     onTap: (){
                                       print('Receipt Downloaded Successfully');
                                       _settingModalBottomSheet(context);
                                     },
                                   )
                                 ],
                               ),
                                // UIHelper.verticalSpaceMedium,
                            ],)
                            )
                          ])

                    ),
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
                      Container(
                        height: 40,
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.only(left: 0,right:10,bottom: 15,top: 5),
                          decoration: UIHelper.roundedBorderWithColorWithShadow(
                              10,c.colorAccentlight,c.colorAccentlight,borderColor: Colors.transparent,borderWidth: 0),
                         child:InkWell(
                                         child:  Padding(
                                         padding: EdgeInsets.only(left: 5,top: 5,bottom: 5,right: 5),
                                         child:  Text(
                                         'verifyOTP'.tr().toString(),
                                         textAlign: TextAlign.center,
                                         overflow: TextOverflow.ellipsis,
                                         style: TextStyle(
                                         color: c.white,
                                          fontWeight: FontWeight.w500,
                                         fontSize: 13,
                                         decorationStyle: TextDecorationStyle.wavy
                                         ),
                                         ),
                                         ),
                           onTap: ()async{
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
                         )
                      ),
                     /* CustomGradientButton(
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
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),*/
                    ],
                  )),
            ],
          );
        }
    );
  }
  Future<void> get_PDF() async {
    utils.showProgress(context, 1);

    Map jsonRequest = {
      s.key_service_id: "get_pdf",
      "work_id":"7815241" ,
      "inspection_id": "162890",
    };
    Map encrypted_request = {
      s.key_user_name: "9595959595",
      s.key_data_content: jsonRequest,
    };
    print("getPDF_request_encrpt>>" + encrypted_request.toString());
    var response = await apiServices.mainServiceFunction(encrypted_request);


    utils.hideProgress(context);

    String data = response.body;
    var userData = jsonDecode(data);
    var status = userData[s.key_status];
    var response_value = userData[s.key_response];

    if (status == s.key_ok && response_value == s.key_ok) {
      var pdftoString = userData[s.key_json_data];
      pdf = const Base64Codec().decode(pdftoString['pdf_string']);
    }
  }
// Future<void> getpdf() async {
//   String? key = key_user_passKey;
//   Map request = {
//     s.key_service_id: "get_pdf",
//     "work_id": "7815241",
//     "inspection_id": "162890"
//   };
//   Map jsonrequest = {
//     s.key_user_name: "9595959595",
//     s.key_data_content: request
//   };
//   String jsonString = jsonEncode(jsonrequest);
//
//   String headerSignature = utils.generateHmacSha256(jsonString, key!, true);
//
//   String header_token = utils.jwt_Encode(key, "9595959595"!, headerSignature);
//
//   HttpClient _client = HttpClient(context: await Utils().globalContext);
//   _client.badCertificateCallback =
//       (X509Certificate cert, String host, int port) => false;
//
//
//   Map<String, String> header = {
//     "Content-Type": "application/json",
//     "Authorization": "Bearer $header_token"
//   };
//
//   var response = await apiServices.mainServiceFunction(jsonrequest);
//   print("getPDF_request_encrpt>>" + jsonrequest.toString());
//
//   utils.hideProgress(context);
//
//
//   String data = response.body;
//
//   print("getPDF_response>>" + data);
//
//   String? authorizationHeader = response.headers['authorization'];
//
//   String? token = authorizationHeader?.split(' ')[1];
//
//   print("getPDF Authorization -  $token");
//
//   String responceSignature = utils.jwt_Decode(key, token!);
//
//   String responceData = utils.generateHmacSha256(data, key, false);
//
//   print("getPDF responceSignature -  $responceSignature");
//
//   print("getPDF responceData -  $responceData");
//
//   if (responceSignature == responceData) {
//     print("getPDF responceSignature - Token Verified");
//     var userData = jsonDecode(data);
//
//     var status = userData[s.key_status];
//     var response_value = userData[s.key_response];
//     print(response_value.statusCode);
//     if(response_value.statuscode==200)
//       {
//         if (status == s.key_ok && response_value == s.key_ok) {
//           var pdftoString = userData[s.key_json_data];
//           pdf = const Base64Codec().decode(pdftoString['pdf_string']);
//         }
//       }
//   }
// }
}
