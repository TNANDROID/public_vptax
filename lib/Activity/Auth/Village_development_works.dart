import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:public_vptax/Layout/customclip.dart';
import 'package:public_vptax/Layout/ui_helper.dart';
import 'package:public_vptax/Resources/ColorsValue.dart' as c;
import 'package:public_vptax/Resources/ImagePath.dart' as imagePath;
import 'package:public_vptax/Services/Preferenceservices.dart';
import 'package:public_vptax/Services/locator.dart';
import '../../Layout/Read_more_or_less.dart';
import '../../Resources/StringsKey.dart';

class Villagedevelopment extends StatefulWidget {
  @override
  State<Villagedevelopment> createState() => _VillagedevelopmentState();
}
class _VillagedevelopmentState extends State<Villagedevelopment> {

  PreferenceService preferencesService = locator<PreferenceService>();
  String selectedFinYear = "";
  final _controller = ScrollController();
  bool flag = true;
  bool cardvisibility = false;
  bool totalworkvisibility=true;
  bool notstartedvisibility=false;
  bool progressvisibility=false;
  bool completedvisibility=false;
  List worklist=[];
  final List items = [
    '01',
    '02',
    '03',
    '04',
    '05',
  ];
  List workitems=[
    {'id':0,'name':'total_works'.tr().toString(),},
    {'id':1,'name':'not_started_work'.tr().toString()},
    {'id':2,'name':'work_in_progress'.tr().toString()},
    {'id':3,'name':'completed_work'.tr().toString()},
  ];
  List showFlag = [];
  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.position.atEdge) {
        bool isTop = _controller.position.pixels == 0;
        if (isTop) {
          setState(() {
            flag = true;
          });
        } else {
          setState(() {
            flag = false;
          });
        }
      }
    });
    worklist.addAll(workitems);
    print("worklist values>>>>"+worklist.toString());
  }
  Future<bool> _onWillPop() async {
    Navigator.of(context, rootNavigator: true).pop(context);
    return true;
  }
  Widget addInputDropdownField() {
    List dropList = [];
    dropList = preferencesService.finYearList;
    return FormBuilderDropdown(
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelText: 'financialYear'.tr().toString(),
        labelStyle: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, color: c.grey_7),
        filled: true,
        constraints: BoxConstraints(maxHeight: 30),
        fillColor: Colors.white,
        enabledBorder:OutlineInputBorder(borderSide: BorderSide(color: c.white, width: 20.0), borderRadius: BorderRadius.circular(12),),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 20.0,color: c.white),borderRadius: BorderRadius.circular(12),),
        focusedErrorBorder:OutlineInputBorder(borderSide: BorderSide(width: 20.0),borderRadius: BorderRadius.circular(12),),
        errorStyle: TextStyle(fontSize: 10),
        contentPadding: EdgeInsets.only(left: 10,top: 5),
      ),
      name: 'financial_year',
      initialValue: selectedFinYear,
      iconSize: 27,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      items: dropList.map((item) => DropdownMenuItem(
        value: item[key_fin_year],
        child: Text(
          item[key_fin_year].toString(),
          style: TextStyle(fontSize: 11.0, fontWeight: FontWeight.w400, color: c.grey_9),
        ),
      ))
          .toList(),
      onChanged: (value) async {
        selectedFinYear = value.toString();
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
          'work_details'.tr().toString(),
          style: TextStyle(fontSize: 14),
        ),
      ),
    ),
    body: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        padding: EdgeInsets.only(top: 15,left: 10,right: 10,bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding:EdgeInsets.only(top: 15,left: 15,right: 25,bottom: 10) ,
              decoration: UIHelper.roundedBorderWithColorWithShadow(
                  12,c.grey_out,c.grey_out,borderColor:c.grey_out,borderWidth: 0),
              child: Row(
                children: [
                  Expanded(
                    flex:2,
                    child: Text(
                      'select_finyear'.tr().toString(),
                      style: TextStyle(
                          fontSize: 12,
                          color: c.grey_10),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: addInputDropdownField(),
                  )
                ],
              ),
            ),
           Container(
             width:MediaQuery.of(context).size.width,
             // padding: EdgeInsets.only(top: 5),
             margin:EdgeInsets.only(top: 25),
             // decoration: UIHelper.roundedBorderWithColorWithShadow(0,c.grey_out, c.grey_out ,borderWidth: 0),
              child: _workdetails(context),
           ),
            Container(
              padding:EdgeInsets.only(top: 15,left: 5,right: 5,),
              // child:Text(workitems[i][])),
              child: Text('work_details'.tr().toString(),style: TextStyle(color: c.primary_text_color2),),),
            Container(
              width: MediaQuery.of(context).size.width,
              child:  card(),
            ),
          ],
        ),
      ),
    )
    )
    );
}
Widget _workdetails(BuildContext context){
    return SingleChildScrollView(
      controller: _controller,
       scrollDirection: Axis.horizontal,
        child: Container(
            decoration: BoxDecoration(
                color: c.white,
                borderRadius: BorderRadius.only(topRight: Radius.circular(0),
                    topLeft: Radius.circular(0),
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(0)),
                border: Border.all(color: c.colorPrimaryDark,width: 1.5)
            ),
            child: Row(
                children: [
                  InkWell(
                    onTap: (){
                      totalworkvisibility=true;
                      progressvisibility=false;
                      notstartedvisibility=false;
                      completedvisibility=false;
                      setState(() {
                        cardvisibility=true;
                        card();
                        workitems[0]['name'].toString();
                      });
                    },
                    child: CustomPaint(
                      foregroundPainter: BorderPainter(),
                      child: ClipPath(
                        clipper: RightTriangleClipper(),
                        child: Container(
                            width: 150,
                            height: 58,
                            padding: EdgeInsets.only(top: 10,left: 0,right: 20),
                            decoration: totalworkvisibility?UIHelper.roundedBorderWithColorWithShadow(0, c.colorPrimary, c.colorPrimary):UIHelper.roundedBorderWithColorWithShadow(0, c.white, c.white),
                            child:Column(
                              children: [
                                Text(
                                  workitems[0]['name'].toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 11,
                                      color: c.primary_text_color2
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 25,top: 15),
                                  child:  Text(
                                    '10',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        color: c.primary_text_color2
                                    ),
                                    // textAlign: TextAlign.center,
                                  ),)
                              ],
                            )
                          // color: c.need_improvement,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      totalworkvisibility=false;
                      notstartedvisibility=true;
                      progressvisibility=false;
                      completedvisibility=false;
                      setState(() {
                        cardvisibility=true;
                        card();
                        print("Not Started>>>>");
                      });
                    },
                    child: CustomPaint(
                      foregroundPainter: BorderPainter(),
                      child: ClipPath(
                        clipper: RightTriangleClipper(),
                        child: Container(
                            width: 150,
                            height: 58,
                            padding: EdgeInsets.only(top: 5,left: 15,right: 0),
                            decoration: notstartedvisibility?UIHelper.roundedBorderWithColorWithShadow(0, c.colorPrimary, c.colorPrimary):UIHelper.roundedBorderWithColorWithShadow(0, c.white, c.white),
                           child:Column(
                             children: [
                               Text(
                                 workitems[1]['name'].toString(),
                                 style: TextStyle(
                                     fontWeight: FontWeight.w500,
                                     fontSize: 11,
                                     color: c.primary_text_color2
                                 ),
                               ),
                               Padding(
                                 padding: EdgeInsets.only(right: 50,top: 6),
                                 child:  Text(
                                   '4',
                                   style: TextStyle(
                                       fontWeight: FontWeight.w500,
                                       fontSize: 12,
                                       color: c.primary_text_color2
                                   ),
                                   textAlign: TextAlign.center,
                                 ),)
                             ],
                           )
                          // color: c.need_improvement,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      progressvisibility=true;
                      totalworkvisibility=false;
                      notstartedvisibility=false;
                      completedvisibility=false;
                      setState(() {
                        cardvisibility=true;
                        card();
                        print("Work In Progress>>>>");
                      });
                    },
                    child: CustomPaint(
                      foregroundPainter: BorderPainter(),
                      child: ClipPath(
                        clipper: RightTriangleClipper(),
                        child: Container(
                            width: 150,
                            height: 58,
                            padding: EdgeInsets.only(left: 10,right: 15),
                            decoration: progressvisibility?UIHelper.roundedBorderWithColorWithShadow(0, c.colorPrimary, c.colorPrimary):UIHelper.roundedBorderWithColorWithShadow(0, c.white, c.white),
                            // decoration: UIHelper.roundedBorderWithColorWithShadow(0, c.white, c.white),
                            child:Column(
                              children: [
                                Text(
                                  workitems[2]['name'].toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 11,
                                      color: c.primary_text_color2
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 50,),
                                  child:  Text(
                                    '3',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        color: c.primary_text_color2
                                    ),
                                    textAlign: TextAlign.center,
                                  ),)
                              ],
                            )
                          // color: c.need_improvement,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      completedvisibility=true;
                      progressvisibility=false;
                      totalworkvisibility=false;
                      notstartedvisibility=false;
                      setState(() {
                        cardvisibility=true;
                        card();
                        print("Completed Work>>>>");
                      });
                    },
                    child: ClipPath(
                      // clipper: RightTriangleClipper(),
                      child: Container(
                          width: 110,
                          height: 58,
                          padding: EdgeInsets.only(left: 10,right: 0,top: 5),
                          decoration: completedvisibility?UIHelper.roundedBorderWithColorWithShadow(0, c.colorPrimary, c.colorPrimary):UIHelper.roundedBorderWithColorWithShadow(0, c.white, c.white),
                          // decoration: UIHelper.roundedBorderWithColorWithShadow(0, c.white, c.white),
                          child:Column(
                            children: [
                              Text(
                                workitems[3]['name'].toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11,
                                    color: c.primary_text_color2
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(right: 25,top: 6),
                                child:  Text(
                                  '3',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      color: c.primary_text_color2
                                  ),
                                  // textAlign: TextAlign.center,
                                ),)
                            ],
                          )
                        // color: c.need_improvement,
                      ),
                    ),
                  )
                ]))
      );

}
Widget card() {
  return  Visibility(
    visible:cardvisibility,
    child: Container(
        margin: EdgeInsets.only(top: 10,left: 10,right: 10),
        child: ListView.builder(
          physics:NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount:items.length,
          itemBuilder: (BuildContext context, int index) {
            // Color itemColor = index % 2 == 0 ? c.dark_pink : c.need_improvement;
            Color itemColor =c.colorPrimary ;
            ListTile(
              leading: Text('${index + 1}'), // Display serial number
              title: Text(items[index],),
            );
            return Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
              decoration: UIHelper.roundedBorderWithColorWithShadow(
                  25,c.white,c.white,borderColor: Colors.transparent,borderWidth: 0),
              child: AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 800),
                child: SlideAnimation(
                  horizontalOffset: 200.0,
                  child: FlipAnimation(
                      child:Column(
                        children: [
                          Stack(
                              children: [
                                Container(
                                  height: 120,
                                  padding: EdgeInsets.only(left: 8),
                                  decoration: UIHelper.roundedBorderWithColorWithShadow(
                                      25,c.white,c.white,borderColor: Colors.transparent,borderWidth: 0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          flex: 1,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: c.white,
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(20),
                                                    bottomLeft: Radius.circular(25))
                                            ),
                                            child: Text(
                                              items[index],textAlign: TextAlign.center,
                                            ),
                                          )),
                                      Expanded(
                                          flex: 3,
                                          child: Container(decoration: BoxDecoration(
                                              color: itemColor,
                                              borderRadius: BorderRadius.only(topRight: Radius.circular(20),
                                                  bottomRight: Radius.circular(25))
                                          ),
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(top: 8),
                                                    transform: Matrix4.translationValues(-10, 0, 0),
                                                    alignment: Alignment.topLeft,
                                                    child: Image.asset(imagePath.rightarrow,height: 30,width: 35,color: c.white,),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(top: 30,left: 15),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Expanded(
                                                          flex: 1,
                                                          child: Text(
                                                            'habitation_name'.tr().toString(),
                                                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal, color: c.white),
                                                            overflow: TextOverflow.clip,
                                                            maxLines: 1,
                                                            softWrap: true,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 0,
                                                          child: Text(
                                                            ' : ',
                                                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal, color: c.white),
                                                            overflow: TextOverflow.clip,
                                                            maxLines: 1,
                                                            softWrap: true,
                                                          ),
                                                        ),
                                                        Expanded(
                                                            flex:1,
                                                            child: Container(
                                                              child: Text("Angambakkam",
                                                                style: TextStyle(
                                                                    fontSize: 13,
                                                                    fontWeight: FontWeight.w500,
                                                                    color: c.white
                                                                ),),
                                                            ))
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                      margin: EdgeInsets.only(top: 55,left: 15),
                                                      child:Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Expanded(
                                                            flex: 1,
                                                            child: Text(
                                                              "Work Type Name",
                                                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal, color: c.white),
                                                              overflow: TextOverflow.clip,
                                                              maxLines: 1,
                                                              softWrap: true,
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 0,
                                                            child: Text(
                                                              ' : ',
                                                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal, color: c.white),
                                                              overflow: TextOverflow.clip,
                                                              maxLines: 1,
                                                              softWrap: true,
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 1,
                                                            child: Container(
                                                              margin: EdgeInsets.fromLTRB(10,0, 10, 0),
                                                              child: ExpandableText(
                                                                'New Housing Work Scheme for PMAY',
                                                                trimLines: 2,
                                                                txtcolor:"1",
                                                              ),
                                                            ),),
                                                          Padding(
                                                            padding: EdgeInsets.only(right:5),
                                                            child:  InkWell(
                                                              child:Image.asset(imagePath.downarrow,height: 18,width: 18,color: c.white,),
                                                              // child:  showFlag.contains(index)?Image.asset(imagePath.downarrow,height: 18,width: 18,color: c.white,),
                                                              onTap: (){
                                                                setState(() {
                                                                if(showFlag.contains(index))
                                                                  {
                                                                    showFlag.remove(index);
                                                                  }
                                                                else
                                                                  {
                                                                    showFlag.add(index);
                                                                  }
                                                                });
                                                                print("Work Type name tapped");
                                                              },
                                                            ),)
                                                        ],
                                                      )
                                                  ),
                                                ],
                                              )
                                          )),
                                    ],),
                                ),
                                Container(
                                  margin: EdgeInsets.all(10.0),
                                  color: c.full_transparent,
                                ),
                              ]),
                          card_design(context,index)

                        ],
                      )
                  ),
                ),
              ),
            );
          },
        )),
  );
}
  Widget card_design(BuildContext context,int index) {
    return Visibility(
      visible:showFlag.contains(index),
      child:AnimationLimiter(
         child: Container(
              child:  ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 1,
                itemBuilder: (context,index) {
                 Color itemColor=c.unsatisfied1;
                  // final item = villagelist[mainIndex][key_workdetails][index];
                  return Container(
                    child: AnimationConfiguration.staggeredList(
                      position:index,
                      duration: const Duration(milliseconds: 800),
                      child: SlideAnimation(
                        horizontalOffset: 200.0,
                        child: FlipAnimation(
                          child: Container(
                              margin: EdgeInsets.fromLTRB(15, 10, 15, 15),
                              padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                              decoration: BoxDecoration(
                                  color: itemColor,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  )),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          'work_id'.tr().toString(),
                                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: c.grey_8),
                                          overflow: TextOverflow.clip,
                                          maxLines: 2,
                                          softWrap: true,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 0,
                                        child: Text(
                                          ' : ',
                                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal, color: c.grey_8),
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                        ),
                                      ),
                                      UIHelper.horizontalSpaceSmall,
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          "123456",
                                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: c.grey_8),
                                          overflow: TextOverflow.clip,
                                          maxLines: 1,
                                          softWrap: true,
                                        ),
                                      ),
                                    ],
                                  ),
                                  UIHelper.verticalSpaceSmall,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          'scheme_group_name'.tr().toString(),
                                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal, color: c.grey_8),
                                          overflow: TextOverflow.clip,
                                          maxLines: 2,
                                          softWrap: true,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 0,
                                        child: Text(
                                          ' : ',
                                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal, color: c.grey_8),
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                        ),
                                      ),
                                      UIHelper.horizontalSpaceSmall,
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          margin: EdgeInsets.fromLTRB(0,0, 10, 0),
                                          child: ExpandableText(
                                            'New Housing Work Scheme for PMAY,Housing Scheme Under',
                                            trimLines: 2,
                                            txtcolor:"2",
                                          ),
                                        ),),
                                    ],
                                  ),
                                  UIHelper.verticalSpaceSmall,
                                  Row(
                                    children: [
                                      Expanded(
                                        flex:1,
                                        child: Text(
                                          'financial_year'.tr().toString(),
                                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: c.grey_8),
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                        ),),
                                      Expanded(
                                        flex: 0,
                                        child: Text(
                                          ' : ',
                                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal, color: c.grey_8),
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                        ),
                                      ),
                                      UIHelper.horizontalSpaceSmall,
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          "2021-2022",
                                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: c.grey_8),
                                          overflow: TextOverflow.clip,
                                        ),
                                      ),
                                    ],
                                  ),
                                  UIHelper.verticalSpaceSmall,
                                  Row(
                                    children: [
                                      Expanded(
                                        flex:1,
                                        child: Text(
                                          'as_value'.tr().toString(),
                                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: c.grey_8),
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                        ),),
                                      Expanded(
                                        flex: 0,
                                        child: Text(
                                          ' : ',
                                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal, color: c.grey_8),
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                        ),
                                      ),
                                      UIHelper.horizontalSpaceSmall,
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          "100000",
                                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: c.grey_8),
                                          overflow: TextOverflow.clip,
                                        ),
                                      ),
                                    ],
                                  ),
                                  UIHelper.verticalSpaceSmall,
                                  Row(
                                    children: [
                                      Expanded(
                                        flex:1,
                                        child: Text(
                                          'scheme_name'.tr().toString(),
                                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: c.grey_8),
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                        ),),
                                      Expanded(
                                        flex: 0,
                                        child: Text(
                                          ' : ',
                                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal, color: c.grey_8),
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                        ),
                                      ),
                                      UIHelper.horizontalSpaceSmall,
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          "PMAY",
                                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: c.grey_8),
                                          overflow: TextOverflow.clip,
                                        ),
                                      ),
                                    ],
                                  ),
                                  UIHelper.verticalSpaceSmall,
                                  Row(
                                    children: [
                                      Expanded(
                                        flex:1,
                                        child: Text(
                                          'amount_spent_so_far'.tr().toString(),
                                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: c.grey_8),
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                          maxLines: 3,
                                        ),),
                                      Expanded(
                                        flex: 0,
                                        child: Text(
                                          ' : ',
                                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal, color: c.grey_8),
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                        ),
                                      ),
                                      UIHelper.horizontalSpaceSmall,
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          "50000",
                                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: c.grey_8),
                                          overflow: TextOverflow.clip,
                                        ),
                                      ),
                                    ],
                                  ),
                                  UIHelper.verticalSpaceSmall,
                                  Row(
                                    children: [
                                      Expanded(
                                        flex:1,
                                        child: Text(
                                          'status'.tr().toString(),
                                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: c.grey_8),
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                        ),),
                                      Expanded(
                                        flex: 0,
                                        child: Text(
                                          ' : ',
                                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal, color: c.grey_8),
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                        ),
                                      ),
                                      UIHelper.horizontalSpaceSmall,
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          "Completed",
                                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: c.grey_8),
                                          overflow: TextOverflow.clip,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                        ),
                      ),
                    ),
                  );
                },
              )
          )
      ),
    );
}
}