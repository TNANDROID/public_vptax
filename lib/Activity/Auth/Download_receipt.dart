import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:public_vptax/Layout/ui_helper.dart';
import 'package:public_vptax/Resources/ColorsValue.dart' as c;
import 'package:public_vptax/Resources/ImagePath.dart' as imagePath;
import 'package:public_vptax/Services/Preferenceservices.dart';
import 'package:public_vptax/Services/locator.dart';
import 'package:public_vptax/Utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Utils/ContentInfo.dart';


class DownloadReceipt extends StatefulWidget {
  @override
  State<DownloadReceipt> createState() => _DownloadReceiptState();
}
class _DownloadReceiptState extends State<DownloadReceipt> {
  @override
  Utils utils = Utils();
  var dbClient;
  bool listvisbility = false;
  bool tamilvisibility=false;
  bool englishvisibility=false;
  int selectedEntryType = 1;
  PreferenceService preferencesService = locator<PreferenceService>();
  TextEditingController assessmentController = TextEditingController();
  TextEditingController receiptController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }
  Future<bool> _onWillPop() async {
    Navigator.of(context, rootNavigator: true).pop(context);
    return true;
  }
  Widget radioButtonWidget(int index, String title) {
    return GestureDetector(
        onTap: () {
          selectedEntryType = index;
          setState(() {});
          listvisbility=false;
        },
        child: ClipPath(
            child: Card(
                elevation: 4,
                child: Container(
                    width: 100,
                    padding: EdgeInsets.all(9),
                    color: selectedEntryType == index
                        ? c.blueAccent
                        : c.need_improvement2,
                    child: Row(
                      children: [
                        UIHelper.horizontalSpaceSmall,
                        Icon(
                          selectedEntryType == index
                              ? Icons.radio_button_checked_rounded
                              : Icons.radio_button_off_rounded,
                          color: c.grey_9,
                          size: 20,
                        ),
                        UIHelper.horizontalSpaceSmall,
                        Expanded(
                            child: UIHelper.titleTextStyle(
                                title, c.grey_9, 12, true, false)),
                      ],
                    )))));
  }

  Widget radioButtonListWidget() {
    return Padding(
      padding: EdgeInsets.only(left: 20),
      child:  Row(
        children: [
          radioButtonWidget(1, 'tamil'.tr().toString()),
          UIHelper.verticalSpaceMedium,
          UIHelper.horizontalSpaceMedium,
          radioButtonWidget(2, 'english'.tr().toString()),
          UIHelper.verticalSpaceMedium,
        ],
      ),
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
                'download_receipt'.tr().toString(),
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
                  transform: Matrix4.translationValues(-6.0,-100.0,10.0),
                  margin: EdgeInsets.only(left: 30,right: 15,top:5),
                  padding:  EdgeInsets.only(top: 15,left: 10,right: 10,bottom: 30),
                  // height: MediaQuery.of(context).size.height/1.5,
                  // padding: EdgeInsets.only(left: 12,top: 20),
                  decoration:
                  UIHelper.roundedBorderWithColorWithShadow(
                      15,c.white,c.white,borderColor: Colors.transparent,borderWidth: 5),
                  child:  Column(
                    children: [
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
                                  color: c.need_improvement2,
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
                                        border:InputBorder.none
                                    ),
                                    style: TextStyle(
                                        fontSize: 12
                                    ),
                                  ),
                                ),
                              )),
                        ],
                      ),
                      Row(
                          mainAxisAlignment:
                          MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(top:10),
                                child: Text(
                                  "select_language".tr().toString(),
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.normal,
                                      color: c.grey_10),
                                  overflow: TextOverflow.clip,
                                  maxLines: 2,
                                  softWrap: true,
                                ),
                              ),
                            ),
                          ]),
                      Row(
                        children: [
                          Padding(padding: EdgeInsets.only(left: 10,top: 10),
                            child:radioButtonListWidget(),
                          )
                        ],
                      )
                    ],
                  )
                ),
                Container(
                  transform: Matrix4.translationValues(5.0,-125.0,10.0),
                  child: TextButton(
                    child:Padding(
                        padding: EdgeInsets.only(left: 5,right: 5),
                        child: Text("download".tr().toString(),
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
                      });
                    },
                  ),
                ),
                Visibility(
                  visible:listvisbility,
                  child: Container(
                      transform: Matrix4.translationValues(-5.0,-80.0,10.0),
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
                                                Visibility(
                                                  visible:selectedEntryType==1?tamilvisibility=true:false,
                                                  child: Container(
                                                      child: Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          UIHelper.horizontalSpaceSmall,
                                                          Text(
                                                              'download_receipt'.tr().toString()+"\n"+"tamil_1".tr().toString()+"\n",
                                                              style:
                                                              TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.bold,color: c.grey_9
                                                              )
                                                          ),
                                                          InkWell(
                                                            onTap: ()
                                                            {
                                                              print("download_receipt".tr().toString()+"\n"+"tamil_1".tr().toString()+"\n");
                                                            },
                                                            child: Padding(padding: EdgeInsets.only(left: 15),
                                                              child:Image.asset(imagePath.download,height: 17,width: 17,),),
                                                          )
                                                        ],
                                                      )
                                                  ),
                                                ),
                                                Visibility(
                                                  visible:selectedEntryType==2?englishvisibility=true:false,
                                                    child: Container(
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      UIHelper.horizontalSpaceSmall,
                                                      Text(
                                                        'download_receipt'.tr().toString()+"\n"+"english_1".tr().toString()+"\n",
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
                                                          print('download_receipt'.tr().toString()+"english_1".tr().toString());
                                                        },
                                                        child: Padding(padding: EdgeInsets.only(left: 15),
                                                          child:Image.asset(imagePath.download,height: 17,width: 17,),),
                                                      )
                                                    ],
                                                  ),
                                                )),
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

}