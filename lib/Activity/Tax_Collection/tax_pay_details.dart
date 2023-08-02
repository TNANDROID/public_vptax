import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:public_vptax/Resources/ColorsValue.dart' as c;
import 'package:public_vptax/Services/Preferenceservices.dart';
import 'package:public_vptax/Services/locator.dart';
import 'package:stacked/stacked.dart';
import 'package:public_vptax/Resources/ImagePath.dart' as imagePath;

import '../../Layout/ui_helper.dart';
import '../../Model/startup_model.dart';

class TaxPayDetailsView extends StatefulWidget {
  final mainList;
  final selectedTaxTypeData;
  TaxPayDetailsView({Key? key, this.mainList, this.selectedTaxTypeData});

  @override
  _TaxPayDetailsViewState createState() =>
      _TaxPayDetailsViewState();
}

class _TaxPayDetailsViewState extends State<TaxPayDetailsView> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  PreferenceService preferencesService = locator<PreferenceService>();
  String selectedLang = "";
  List mainDataList = [];

  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );

    // Create a curved animation with Curves.bounceOut
    _animation = CurvedAnimation(parent: _controller, curve: Curves.bounceOut);

    // Add a listener to rebuild the widget when the animation value changes
    _animation.addListener(() {
      setState(() {});
    });

    // Start the animation
    _controller.forward();
    initialize();
  }

  void repeatOnce() {
    _controller.reset();
    _controller.forward();
  }

  Future<void> initialize() async {
    selectedLang = await preferencesService.getUserInfo("lang");
    for (int i = 0; i < widget.mainList.length; i++) {
      if(widget.mainList[i]['total'] > 0 || widget.mainList[i]['swm_total'] > 0){
        mainDataList.add(widget.mainList[i]);
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: c.white,
        appBar: AppBar(
          backgroundColor: c.colorPrimary,
          centerTitle: true,
          elevation: 2,
          title: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: AlignmentDirectional.center,
                  child: Container(
                    transform: Matrix4.translationValues(-30.0, 0.0, 0.0),
                    alignment: Alignment.center,
                    child: Text(
                      selectedLang == "en"
                          ? widget.selectedTaxTypeData["taxtypedesc_en"]
                          : widget.selectedTaxTypeData["taxtypedesc_ta"],
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          top: true,
          child: ViewModelBuilder<StartUpViewModel>.reactive(
              builder: (context, model, child) {
                return SingleChildScrollView(
                    child:Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.all(5),
                    child: Column(
                      children: [
                        UIHelper.verticalSpaceSmall,
                         ListView.builder(
                           shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: mainDataList.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.all( 10),
                              decoration: UIHelper.roundedBorderWithColorWithShadow(
                                  3, c.need_improvement1, c.need_improvement1,
                                  borderWidth: 0),
                              padding: EdgeInsets.all(5),
                              child:Column(children: [
                                UIHelper.verticalSpaceSmall,
                                taxWiseReturnDataWidget(index),
                                UIHelper.verticalSpaceSmall,
                                Visibility(
                                  visible: mainDataList[index]['total'] > 0,
                                    child: Container(
                                  padding: EdgeInsets.only(top: 10,bottom: 10,left: 10,right: 10),child: Column(children: [
                                  UIHelper.titleTextStyle(
                                      selectedLang == "en"
                                          ? widget.selectedTaxTypeData["taxtypedesc_en"]
                                          : widget.selectedTaxTypeData["taxtypedesc_ta"],
                                      c.grey_9,
                                      12,
                                      true,true),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 4,
                                        child: Container(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              "demand_selected".tr().toString(),
                                              style: TextStyle(
                                                  color: c.grey_10,
                                                  fontSize: 10,
                                                  decoration: TextDecoration.none,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.right,
                                            )),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                            decoration: BoxDecoration(
                                              color: c.white,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10),
                                                bottomRight: Radius.circular(10),
                                                bottomLeft: Radius.circular(10),
                                              ),
                                            ),
                                            padding: EdgeInsets.fromLTRB(10, 5, 10, 8),
                                            margin: EdgeInsets.all(5),
                                            child: UIHelper.titleTextStyle(
                                                getDemandTotal(),
                                                c.grey_9,
                                                13,
                                                true,
                                                true)),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 4,
                                        child: Container(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              "advance".tr().toString(),
                                              style: TextStyle(
                                                  color: c.grey_10,
                                                  fontSize: 10,
                                                  decoration: TextDecoration.none,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.right,
                                            )),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                            decoration: BoxDecoration(
                                              color: c.white,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10),
                                                bottomRight: Radius.circular(10),
                                                bottomLeft: Radius.circular(10),
                                              ),
                                            ),
                                            padding: EdgeInsets.fromLTRB(10, 5, 10, 8),
                                            margin: EdgeInsets.all(5),
                                            child: UIHelper.titleTextStyle(
                                                "\u{20B9}" + mainDataList[index]['tax_advance'].toString(),
                                                c.grey_9,
                                                14,
                                                true,
                                                true)),
                                      ),
                                    ],
                                  ),Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              "amount_to_pay".tr().toString(),
                                              style: TextStyle(
                                                  color: c.grey_10,
                                                  fontSize: 10,
                                                  decoration: TextDecoration.none,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.right,
                                            )),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                            decoration: BoxDecoration(
                                              color: c.white,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10),
                                                bottomRight: Radius.circular(10),
                                                bottomLeft: Radius.circular(10),
                                              ),
                                            ),
                                            padding: EdgeInsets.fromLTRB(10, 5, 10, 8),
                                            margin: EdgeInsets.all(10),
                                            child: UIHelper.titleTextStyle(
                                                "\u{20B9}" + "main.toString()",
                                                c.grey_9,
                                                14,
                                                true,
                                                true)),
                                      ),
                                    ],
                                  ),

                                ],))
                                ),
                                Visibility(
                                  visible: mainDataList[index]['swm_total'] > 0,
                                    child: Container(
                                    decoration:UIHelper.roundedBorderWithColorWithShadow(
                                        15,c.need_improvement2,c.need_improvement2,borderColor: Colors.transparent,borderWidth: 5),
                                    padding: EdgeInsets.only(top: 15,bottom: 10,left: 10,right: 10),child: Column(children: [
                                  UIHelper.titleTextStyle(
                                      'swm_charges'.tr().toString(),
                                      c.grey_9,
                                      12,
                                      true,true),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              "demand_selected".tr().toString(),
                                              style: TextStyle(
                                                  color: c.grey_10,
                                                  fontSize: 12,
                                                  decoration: TextDecoration.none,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.right,
                                            )),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                            decoration: BoxDecoration(
                                              color: c.white,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10),
                                                bottomRight: Radius.circular(10),
                                                bottomLeft: Radius.circular(10),
                                              ),
                                            ),
                                            padding: EdgeInsets.fromLTRB(10, 5, 10, 8),
                                            margin: EdgeInsets.all(10),
                                            child: UIHelper.titleTextStyle(
                                                getDemandTotal(),
                                                c.grey_9,
                                                13,
                                                true,
                                                true)),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              "advance".tr().toString(),
                                              style: TextStyle(
                                                  color: c.grey_10,
                                                  fontSize: 10,
                                                  decoration: TextDecoration.none,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.right,
                                            )),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                            decoration: BoxDecoration(
                                              color: c.white,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10),
                                                bottomRight: Radius.circular(10),
                                                bottomLeft: Radius.circular(10),
                                              ),
                                            ),
                                            margin: EdgeInsets.all(10),
                                            child: UIHelper.titleTextStyle(
                                                "\u{20B9}" + mainDataList[index]['swm_advance'].toString(),
                                                c.grey_9,
                                                14,
                                                true,
                                                true)),
                                      ),
                                    ],
                                  ),Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              "amount_to_pay".tr().toString(),
                                              style: TextStyle(
                                                  color: c.grey_10,
                                                  fontSize: 10,
                                                  decoration: TextDecoration.none,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.right,
                                            )),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                            decoration: BoxDecoration(
                                              color: c.white,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10),
                                                bottomRight: Radius.circular(10),
                                                bottomLeft: Radius.circular(10),
                                              ),
                                            ),
                                            margin: EdgeInsets.all(10),
                                            child: UIHelper.titleTextStyle(
                                                "\u{20B9}" + "main.toString()",
                                                c.grey_9,
                                                14,
                                                true,
                                                true)),
                                      ),
                                    ],
                                  ),

                                ],))
                                )


                              ],) ,
                            );
                          },
                        ),

                    Container(
                    margin: EdgeInsets.only(top: 10),
                decoration: UIHelper.roundedBorderWithColorWithShadow(
                3, c.account_status_green_color, c.account_status_green_color,
                borderWidth: 0),
                padding: EdgeInsets.all(8),
                      child: UIHelper.titleTextStyle(
                          'pay'.tr().toString(),
                          c.white,
                          13,
                          true,true),

                    )
                      ],
                    )));
              },
              viewModelBuilder: () => StartUpViewModel()),
        ));
  }
  Widget taxWiseReturnDataWidget(int mainIndex) {
    return widget.selectedTaxTypeData["taxtypeid"] == 1
        ?UIHelper.titleTextStyle(
        "Building Licence Number : " +
            mainDataList[mainIndex]['building_licence_number'],
        c.grey_9,
        12,
        true,true)
        : widget.selectedTaxTypeData["taxtypeid"] == 2
        ? UIHelper.titleTextStyle(
        "Water Connection Number : " +
            mainDataList[mainIndex]['assesment_no'],
        c.grey_9,
        12,
        true,
        true)
        : widget.selectedTaxTypeData["taxtypeid"] == 3
        ? UIHelper.titleTextStyle(
        "Assesment Number : " + mainDataList[mainIndex]['assesment_no'],
        c.grey_9,
        12,
        true,
        true)
        : widget.selectedTaxTypeData["taxtypeid"] == 4
        ? UIHelper.titleTextStyle(
        "Lease Number : " + mainDataList[mainIndex]['assesment_no'],
        c.grey_9,
        12,
        true,
        true)
        : UIHelper.titleTextStyle(
        "Traders Code : " + mainDataList[mainIndex]['assesment_no'],
        c.grey_9,
        12,
        true,
        true);
  }

  String getDemandTotal() {
    String s="";

    return s;
  }


}