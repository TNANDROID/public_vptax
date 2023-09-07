// ignore_for_file: library_prefixes, prefer_const_constructors_in_immutables, library_private_types_in_public_api, prefer_typing_uninitialized_variables, prefer_const_constructors, avoid_print, deprecated_member_use, use_build_context_synchronously, file_names, non_constant_identifier_names, use_key_in_widget_constructors, prefer_adjacent_string_concatenation, avoid_function_literals_in_foreach_calls

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:public_vptax/Layout/screen_size.dart';
import 'package:public_vptax/Layout/ui_helper.dart';
import 'package:public_vptax/Model/startup_model.dart';
import 'package:public_vptax/Resources/ColorsValue.dart' as c;
import 'package:public_vptax/Utils/ContentInfo.dart';
import 'package:public_vptax/Utils/utils.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import '../../Resources/StringsKey.dart' as s;
import 'package:public_vptax/Services/Preferenceservices.dart';
import 'package:public_vptax/Services/locator.dart';
import 'package:stacked/stacked.dart';
import 'package:public_vptax/Resources/ImagePath.dart' as imagePath;

import '../../Resources/StringsKey.dart';

class AllYourTaxDetails extends StatefulWidget {
  final selectedTaxTypeData;
  final isHome;
  final dcode;
  final bcode;
  final pvcode;
  final isTaxDropDown;
  final selectedEntryType;
  final mobile;
  AllYourTaxDetails({Key? key, this.selectedTaxTypeData, this.isHome, this.dcode, this.bcode, this.pvcode, this.isTaxDropDown, this.selectedEntryType, this.mobile});

  @override
  _AllYourTaxDetailsState createState() => _AllYourTaxDetailsState();
}

class _AllYourTaxDetailsState extends State<AllYourTaxDetails> with TickerProviderStateMixin {
  //Animation
  late AnimationController _controller;
  late Animation<double> _animation;

  PreferenceService preferencesService = locator<PreferenceService>();
  TextEditingController etTextController = TextEditingController();

  List isSelectAll = [];
  //Strings
  String selectedLang = "";
  String mobile_widget = "";
  String islogin = "";

  //List
  List isShowFlag = [];
  List mainList = [];
  List sampleDataList = [];
  List taxTypeList = [];

  //int Double
  double main_totalAmount = 0.00;
  int main_count = 0;
  int totalAssessment = 0;
  int pendingAssessment = 0;
  int totalAllAssessment = 0;
  int pendingAllAssessment = 0;
  int totalAssessment_property = 0;
  int pendingAssessment_property = 0;
  int totalAssessment_water = 0;
  int pendingAssessment_water = 0;
  int totalAssessment_professional = 0;
  int pendingAssessment_professional = 0;
  int totalAssessment_non = 0;
  int pendingAssessment_non = 0;
  int totalAssessment_trade = 0;
  int pendingAssessment_trade = 0;

  double totalAmountToPay = 0.00;

  bool numIsLoading = false;

  ScrollController controller_scroll = ScrollController();

  var selectedTaxTypeData;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    dynamic val = {key_taxtypeid: 0, key_taxtypedesc_en: "All Taxes", key_taxtypedesc_ta: "அனைத்து வரிகள்", key_img_path: imagePath.all};
    taxTypeList.add(val);
    taxTypeList.addAll(preferencesService.taxTypeList);
    selectedTaxTypeData = taxTypeList[0];
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

  void getCount() {
    main_count = 0;
    if (preferencesService.addedTaxPayList.isNotEmpty) {
      for (var prefSelectData in preferencesService.addedTaxPayList) {
        if (prefSelectData[s.key_no_of_demand_available] > 0) {
          for (var prefSelectedTaxData in prefSelectData[s.key_DEMAND_DETAILS]) {
            if (prefSelectedTaxData[s.key_flag] == true) {
              main_count++;
            }
          }
        }
        // for (var prefSelectedTaxData in prefSelectData['swmData']) {
        //   if (prefSelectedTaxData[s.key_flag] == true) {
        //     main_count++;
        //   }
        // }
      }
    }
    totalAmountToPay = 0.00;
    if (mainList.isNotEmpty) {
      for (var data in mainList) {
        if (data[s.key_no_of_demand_available] > 0) {
          for (var demanData in data[s.key_DEMAND_DETAILS]) {
            totalAmountToPay = totalAmountToPay + double.parse(Utils().getDemadAmount(demanData, data[key_taxtypeid].toString()));
          }
        }
      }
    }
    main_totalAmount = 0.00;
    for (int i = 0; i < mainList.length; i++) {
      main_totalAmount = main_totalAmount + mainList[i][s.key_tax_pay] + mainList[i][s.key_swm_pay];
    }
  }

  Future<void> initialize() async {
    selectedLang = await preferencesService.getUserInfo("lang");
    islogin = await preferencesService.getUserInfo(s.key_isLogin);
    mobile_widget = islogin == "yes" ? await preferencesService.getUserInfo("mobile_number") : "";
    etTextController.text = widget.mobile;
    await getTaxDetails();
    await filterDataList();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
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
                      'tax_details_yours'.tr().toString(),
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: ViewModelBuilder<StartUpViewModel>.reactive(
            builder: (context, model, child) {
              return Container(
                  color: c.need_improvement2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 0),
                                padding: EdgeInsets.symmetric(horizontal: 0),
                                child: TextFormField(
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: c.grey_9),
                                  controller: etTextController,
                                  onChanged: (value) {},
                                  decoration: InputDecoration(
                                    constraints: BoxConstraints(maxHeight: 40),
                                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                                    suffixIcon: IconButton(
                                        onPressed: () async {
                                          Utils().closeKeypad(context);
                                          etTextController.text = "9875235654";
                                          numIsLoading = true;
                                          setState(() {});

                                          if (await Utils().isOnline()) {
                                            if (etTextController.text != "" && Utils().isNumberValid(etTextController.text)) {
                                              await getTaxDetails();
                                              await filterDataList();
                                              numIsLoading = false;
                                              setState(() {});
                                            } else {
                                              Utils().showAlert(context, ContentType.warning, 'enter_mobile_number'.tr().toString(), btnCount: "1", btnmsg: "ok");
                                            }
                                          } else {
                                            Utils().showAlert(context, ContentType.fail, 'no_internet'.tr().toString());
                                          }
                                        },
                                        icon: numIsLoading
                                            ? SizedBox(
                                                width: 15,
                                                height: 15,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color: c.colorAccentlight,
                                                ),
                                              )
                                            : Icon(
                                                Icons.arrow_circle_right_outlined,
                                                color: c.colorPrimaryDark,
                                                size: 28,
                                              )),
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: 'Enter Mobile Number',
                                    hintStyle: TextStyle(fontSize: 11),
                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.1, color: c.white), borderRadius: BorderRadius.circular(10.0)),
                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: c.colorPrimary), borderRadius: BorderRadius.circular(10.0)),
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(left: 15),
                                decoration: UIHelper.roundedBorderWithColorWithShadow(5, c.white, c.white),
                                child: Row(
                                  children: [
                                    Container(
                                        width: 30,
                                        height: 30,
                                        padding: EdgeInsets.all(5),
                                        decoration: UIHelper.roundedBorderWithColor(5, 5, 5, 5, c.colorPrimary),
                                        child: Image.asset(
                                          selectedTaxTypeData[key_img_path].toString(),
                                          fit: BoxFit.contain,
                                          height: 15,
                                          width: 15,
                                        )),
                                    UIHelper.horizontalSpaceSmall,
                                    Container(width: 100, margin: EdgeInsets.only(left: 5), child: addInputDropdownField()),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: selectedTaxTypeData[s.key_taxtypeid].toString() == "0" || pendingAssessment > 0,
                        child: Container(
                          margin: EdgeInsets.only(top: 5, left: 20, right: 20, bottom: 10),
                          decoration: UIHelper.GradientContainer(20, 20, 20, 20, [c.subscription_type_red_color, c.subscription_type_red_color], intwid: 0),
                          child: Container(
                            margin: EdgeInsets.only(left: 5, bottom: 3),
                            decoration: UIHelper.roundedBorderWithColor(20, 20, 20, 20, c.white),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(5),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          UIHelper.titleTextStyle("total_assessment".tr().toString(), c.grey_10, 10, true, true),
                                          UIHelper.titleTextStyle(" $totalAssessment", c.grey_10, 14, true, true),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: pendingAssessment > 0,
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(5),
                                    margin: EdgeInsets.only(
                                      top: 5,
                                    ),
                                    decoration: UIHelper.GradientContainer(0, 0, 18, 18, [c.red_new_light, c.red_new_light], intwid: 0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            UIHelper.titleTextStyle("pending_assessment_transaction".tr().toString(), c.grey_10, 11, true, true),
                                            UIHelper.titleTextStyle(" $pendingAssessment", c.grey_10, 14, true, true),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        UIHelper.titleTextStyle(getWarningHint(), c.subscription_type_red_color, 10, true, true),
                                        SizedBox(
                                          height: 5,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: mainList.isNotEmpty,
                        child: Expanded(
                            child: GroupedListView<dynamic, String>(
                          elements: mainList,
                          useStickyGroupSeparators: true,
                          floatingHeader: true,
                          shrinkWrap: true,
                          groupBy: (element) => element[key_taxtypeid].toString(),
                          groupSeparatorBuilder: (element) => stickyHeader(element),
                          indexedItemBuilder: (context, dynamic element, mainIndex) => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 500),
                                child: Container(
                                  width: Screen.width(context),
                                  decoration: BoxDecoration(color: c.blue_new, borderRadius: BorderRadius.circular(20)),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: Container(
                                          constraints: const BoxConstraints(maxWidth: 130, maxHeight: 80),
                                          decoration: BoxDecoration(color: c.blue_new_light, borderRadius: BorderRadius.circular(20)),
                                          // decoration: BoxDecoration(color: c.blue_new, borderRadius: BorderRadius.circular(130), border: Border.all(color: c.blue_new_light, width: 35)),
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.all(0),
                                            child: StreamBuilder<Object>(
                                                stream: null,
                                                builder: (context, snapshot) {
                                                  return Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                          padding: EdgeInsets.fromLTRB(15, 15, 5, 15),
                                                          decoration: BoxDecoration(color: c.white, borderRadius: BorderRadius.circular(20)),
                                                          width: Screen.width(context) - 40,
                                                          child: headerCardUIWidget(mainIndex)),
                                                    ],
                                                  );
                                                }),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                          itemComparator: (item1, item2) => item1[key_assessment_no].compareTo(item2[key_assessment_no]), // optional
                        )
                            /* child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: mainList.length,
                                  itemBuilder: (context, mainIndex) {
                                    return Column(
                                      children: [
                                        headerCardUIWidget(mainIndex),
                                        UIHelper.verticalSpaceMedium,
                                      ],
                                    );
                                  }),*/
                            ),
                      ),
                      Visibility(
                          visible: mainList.isEmpty,
                          child: Expanded(
                            child: Center(child: Container(margin: EdgeInsets.only(top: 30), child: UIHelper.titleTextStyle("no_record".tr().toString(), c.grey_9, 12, true, true))),
                          )),
                      Visibility(visible: /*!widget.isHome*/ true, child: payWidget())
                    ],
                  ));
            },
            viewModelBuilder: () => StartUpViewModel()));
  }

  Widget addInputFormControl(String nameField, String hintText, String fieldType) {
    return FormBuilderTextField(
      style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, color: c.grey_9),
      name: nameField,
      controller: etTextController,
      autocorrect: false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (value) {},
      decoration: InputDecoration(
        labelText: hintText,
        labelStyle: TextStyle(fontSize: 11.0, fontWeight: FontWeight.w600, color: c.grey_7),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: UIHelper.getInputBorder(1, borderColor: c.grey_7),
        focusedBorder: UIHelper.getInputBorder(1, borderColor: c.grey_7),
        focusedErrorBorder: UIHelper.getInputBorder(1, borderColor: Colors.red),
        errorBorder: UIHelper.getInputBorder(1, borderColor: Colors.red),
        errorStyle: TextStyle(fontSize: 10),
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12), // Optional: Adjust padding
      ),
      validator: fieldType == key_mobile_number
          ? ((value) {
              if (value == "" || value == null) {
                return "$hintText ${'isEmpty'.tr()}";
              }
              if (!Utils().isNumberValid(value)) {
                return "$hintText ${'isInvalid'.tr()}";
              }
              return null;
            })
          : FormBuilderValidators.compose([
              FormBuilderValidators.required(errorText: "$hintText ${'isEmpty'.tr()}"),
            ]),
      inputFormatters: fieldType == key_mobile_number
          ? [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ]
          : [],
      keyboardType: fieldType == key_mobile_number || fieldType == key_number ? TextInputType.number : TextInputType.text,
    );
  }

  Widget stickyHeader(var taxTypeId) {
    var TaxList = preferencesService.taxTypeList;

    String TaxHeader = '';
    String Taximgpath = '';
    for (var list in TaxList) {
      if (list[key_taxtypeid].toString() == taxTypeId) {
        TaxHeader = selectedLang == 'en' ? list[key_taxtypedesc_en] : list[key_taxtypedesc_ta];
        Taximgpath = list[key_img_path];
      }
    }

    String totalTaxCount = getTaxWiseAssesmemtCount(taxTypeId);

    /*return Container(
      margin:EdgeInsets.only(top: 5),
      padding: EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
      width: MediaQuery.of(context).size.width,
      color: c.need_improvement2,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10),
            width: MediaQuery.of(context).size.width / 1.6,
            padding: EdgeInsets.only(left: 50, right: 20, top: 10, bottom: 10),
            decoration: UIHelper.roundedBorderWithColor(20, 20, 20, 20, c.primary_text_color2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                UIHelper.titleTextStyle(TaxHeader, c.white, 12, true, false),
                Container(
                  width: 25,
                  height: 25,
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(border: Border.all(width: 1, color: c.white), borderRadius: BorderRadius.circular(20)),
                  child: Center(
                    child: UIHelper.titleTextStyle(totalTaxCount, c.white, 12, true, false),
                  ),
                )
              ],
            ),
          ),
          Container(
            decoration: UIHelper.circleWithColorWithShadow(0, c.yello, c.unsatisfied1, borderColor: c.white, borderWidth: 2),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Image.asset(
                Taximgpath,
                fit: BoxFit.contain,
                height: 30,
                width: 30,
              ),
            ),
          ),
        ],
      ),
    );*/
    return Container(
      margin: EdgeInsets.only(top: 0),
      padding: EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
      child: Container(
        margin: EdgeInsets.only(left: MediaQuery.of(context).size.width / 4, right: MediaQuery.of(context).size.width / 4),
        padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
        decoration: UIHelper.roundedBorderWithColor(20, 20, 20, 20, c.primary_text_color2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: UIHelper.titleTextStyle(TaxHeader /*+" ( "+totalTaxCount+" )"*/, c.white, 12, true, true)),
            Container(
              width: 25,
              height: 25,
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(color: c.white, border: Border.all(width: 1, color: c.white), borderRadius: BorderRadius.circular(20)),
              child: Center(
                child: UIHelper.titleTextStyle(totalTaxCount, c.grey_10, 12, true, false),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget headerCardUIWidget(int mainIndex) {
    return Column(
      children: [
        Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      imagePath.user,
                      color: c.grey_8,
                      height: 15,
                      width: 15,
                    ),
                    UIHelper.horizontalSpaceTiny,
                    SizedBox(
                      width: Screen.width(context) / 2,
                      child: Flex(
                        direction: Axis.horizontal,
                        children: [Flexible(child: UIHelper.titleTextStyle(mainList[mainIndex][s.key_name] ?? '', c.grey_9, 12, true, false))],
                      ),
                    ),
                    UIHelper.horizontalSpaceSmall,
                  ],
                ),
                UIHelper.verticalSpaceSmall,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on,
                      color: c.grey_8,
                      size: 15,
                    ),
                    UIHelper.horizontalSpaceTiny,
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          UIHelper.titleTextStyle(getDoorAndStreetName(mainIndex, mainList[mainIndex][key_taxtypeid].toString()), c.grey_8, 11, false, false),
                          UIHelper.titleTextStyle(getvillageAndBlockName(mainIndex, mainList[mainIndex][key_taxtypeid].toString()), c.grey_8, 11, false, false),
                          UIHelper.titleTextStyle(mainList[mainIndex][s.key_district_name] ?? '', c.grey_8, 11, false, false)
                        ],
                      ),
                    ),
                    UIHelper.horizontalSpaceSmall,
                  ],
                ),
                UIHelper.verticalSpaceTiny,
                Container(alignment: Alignment.centerLeft, child: taxWiseReturnDataWidget(mainIndex, c.grey_8)),
              ],
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: InkWell(
                onTap: () {
                  setState(() {
                    if (isShowFlag.contains(mainIndex)) {
                      isShowFlag.remove(mainIndex);
                    } else {
                      isShowFlag.add(mainIndex);
                    }
                  });
                },
                child: Icon(
                  isShowFlag.contains(mainIndex) ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                  size: 30,
                ),
              ),
            ),
            Visibility(
              visible: getTotalToPay(mainIndex) == "0.0",
              child: Positioned(
                right: 0,
                child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: UIHelper.roundedBorderWithColorWithShadow(5, c.white, c.white),
                    child: Image.asset(
                      getTaxImage(mainIndex),
                      fit: BoxFit.contain,
                      height: 40,
                      width: 40,
                    )),
              ),
            ),
            Visibility(
              visible: getTotalToPay(mainIndex) != "0.0",
              child: Positioned(
                right: 0,
                child: GestureDetector(
                    onTap: () {
                      if (!getFlagStatus(mainList[mainIndex][key_assessment_id].toString()) || islogin == "yes") {
                        if (isSelectAll.contains(mainIndex)) {
                          isSelectAll.remove(mainIndex);
                          for (var item in mainList[mainIndex][key_DEMAND_DETAILS]) {
                            item[s.key_flag] = false;
                          }
                        } else {
                          isSelectAll.add(mainIndex);
                          for (var item in mainList[mainIndex][key_DEMAND_DETAILS]) {
                            item[s.key_flag] = true;
                          }
                        }
                      } else {
                        Utils().showAlert(context, ContentType.fail, 'pay_previous'.tr().toString());
                      }

                      double totAmt = 0.00;
                      double swmtotAmt = 0.00;
                      for (var item in mainList[mainIndex][key_DEMAND_DETAILS]) {
                        if (item[s.key_flag] == true) {
                          if (item[s.key_taxtypeid].toString() == "1") {
                            if (item[s.key_taxtypeid].toString() == mainList[mainIndex][s.key_taxtypeid].toString()) {
                              totAmt = totAmt + double.parse(Utils().getDemadAmount(item, mainList[mainIndex][key_taxtypeid].toString()));
                            } else {
                              swmtotAmt = swmtotAmt + double.parse(Utils().getDemadAmount(item, mainList[mainIndex][key_taxtypeid].toString()));
                            }
                          } else {
                            totAmt = totAmt + double.parse(Utils().getDemadAmount(item, mainList[mainIndex][key_taxtypeid].toString()));
                          }
                        }
                      }
                      mainList[mainIndex][s.key_tax_total] = totAmt;
                      mainList[mainIndex][s.key_tax_pay] = getTotal(mainList[mainIndex][s.key_tax_total], double.parse(Utils().getTaxAdvance(mainList[mainIndex], mainList[mainIndex][key_taxtypeid])));

                      if (mainList[mainIndex][s.key_taxtypeid].toString() == "1") {
                        mainList[mainIndex][s.key_swm_total] = swmtotAmt;
                        mainList[mainIndex][s.key_swm_pay] = getTotal(mainList[mainIndex][s.key_swm_total], double.parse(mainList[mainIndex][s.key_swm_available_advance].toString()));
                      }
                      getCount();
                      setState(() {});
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        UIHelper.titleTextStyle("Select All asdas", c.text_color, 12, false, true),
                        UIHelper.horizontalSpaceSmall,
                        Image.asset(
                          getImageString(mainIndex) ? imagePath.tick : imagePath.unchecked,
                          color: getImageString(mainIndex) ? c.account_status_green_color : c.text_color,
                          height: 20,
                          width: 20,
                        ),
                        UIHelper.horizontalSpaceSmall,
                      ],
                    )),
              ),
            ),
          ],
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 500),
          curve: Curves.linear,
          child: Visibility(
            visible: isShowFlag.contains(mainIndex),
            child: propertyTaxCollectionWidget(mainIndex),
          ),
        ),
      ],
    );
  }

  getImageString(int mainIndex) {
    if (mainList[mainIndex][s.key_no_of_demand_available] > 0) {
      for (var item in mainList[mainIndex][s.key_DEMAND_DETAILS]) {
        if (item[s.key_flag] == true) {
          return true;
        } else {
          return false;
        }
      }
    }
    return false;
  }

  Widget taxWiseReturnDataWidget(int mainIndex, Color clr) {
    return mainList[mainIndex][key_taxtypeid].toString() == "1"
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UIHelper.titleTextStyle(("${'computerRegisterNumber'.tr()} : ${mainList[mainIndex][s.key_assessment_id].toString() ?? ""}"), clr, 12, false, true),
              UIHelper.verticalSpaceTiny,
              UIHelper.titleTextStyle(("${'building_licence_number'.tr()} : ${mainList[mainIndex][s.key_building_licence_no].toString() ?? ""}"), clr, 12, false, true),
              UIHelper.verticalSpaceTiny,
              UIHelper.titleTextStyle(("${'assesment_number'.tr()} : ${mainList[mainIndex][s.key_assessment_no].toString() ?? ""}"), clr, 12, false, true),
              UIHelper.verticalSpaceTiny,
              UIHelper.titleTextStyle(("${'pending_payment'.tr()} : \u{20B9} ${getTotalToPay(mainIndex)}"), c.grey_10, 12, true, true),
            ],
          )
        : mainList[mainIndex][key_taxtypeid].toString() == "2"
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UIHelper.titleTextStyle(("${'computerRegisterNumber'.tr()} : ${mainList[mainIndex][s.key_assessment_id].toString() ?? ""}"), clr, 12, false, true),
                  UIHelper.verticalSpaceTiny,
                  UIHelper.titleTextStyle(("${'water_connection_number'.tr()} : ${mainList[mainIndex][s.key_assessment_no].toString() ?? ""}"), clr, 12, false, true),
                  UIHelper.verticalSpaceTiny,
                  UIHelper.titleTextStyle(("${'pending_payment'.tr()} : \u{20B9} ${getTotalToPay(mainIndex)}"), c.grey_10, 12, true, true),
                ],
              )
            : mainList[mainIndex][key_taxtypeid].toString() == "4"
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UIHelper.titleTextStyle(("${'computerRegisterNumber'.tr()} : ${mainList[mainIndex][s.key_assessment_id].toString() ?? ""}"), clr, 12, false, true),
                      UIHelper.verticalSpaceTiny,
                      UIHelper.titleTextStyle(("${'financialYear'.tr()} : ${mainList[mainIndex]['financialyear'].toString() ?? ""}"), clr, 12, false, true),
                      UIHelper.verticalSpaceTiny,
                      UIHelper.titleTextStyle(("${'assesment_number'.tr()} : ${mainList[mainIndex][s.key_assessment_no].toString() ?? ""}"), clr, 12, false, true),
                      UIHelper.verticalSpaceTiny,
                      UIHelper.titleTextStyle(("${'pending_payment'.tr()} : \u{20B9} ${getTotalToPay(mainIndex)}"), c.grey_10, 12, true, true),
                    ],
                  )
                : mainList[mainIndex][key_taxtypeid].toString() == "5"
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          UIHelper.titleTextStyle(("${'computerRegisterNumber'.tr()} : ${mainList[mainIndex][s.key_assessment_id].toString() ?? ""}"), clr, 12, false, true),
                          UIHelper.verticalSpaceTiny,
                          UIHelper.titleTextStyle(("${'lease_number'.tr()} : ${mainList[mainIndex][s.key_assessment_no].toString() ?? ""}"), clr, 12, false, true),
                          UIHelper.verticalSpaceTiny,
                          UIHelper.titleTextStyle(("${'lease_state'.tr()} : ${mainList[mainIndex]['lease_statename'].toString() ?? ""}"), clr, 12, false, true),
                          UIHelper.verticalSpaceTiny,
                          UIHelper.titleTextStyle(("${'lease_district'.tr()} : ${mainList[mainIndex]['lease_districtname'].toString() ?? ""}"), clr, 12, false, true),
                          UIHelper.verticalSpaceTiny,
                          UIHelper.titleTextStyle(
                              ("${'lease_duration'.tr()} : ${mainList[mainIndex]['from_date'].toString() ?? ""} - ${mainList[mainIndex]['to_date'].toString() ?? ""}"), clr, 12, false, true),
                          UIHelper.verticalSpaceTiny,
                          UIHelper.titleTextStyle(("${'pending_payment'.tr()} : \u{20B9} ${getTotalToPay(mainIndex)}"), c.grey_10, 12, true, true),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          UIHelper.titleTextStyle(("${'computerRegisterNumber'.tr()} : ${mainList[mainIndex][s.key_assessment_id].toString() ?? ""}"), clr, 12, false, true),
                          UIHelper.verticalSpaceTiny,
                          UIHelper.titleTextStyle(("${'traders_code'.tr()} : ${mainList[mainIndex][s.key_assessment_no].toString() ?? ""}"), clr, 12, false, true),
                          UIHelper.verticalSpaceTiny,
                          UIHelper.titleTextStyle(("${'pending_payment'.tr()} : \u{20B9} ${getTotalToPay(mainIndex)}"), c.grey_10, 12, true, true),
                        ],
                      );
  }

  Widget propertyTaxCollectionWidget(int mainIndex) {
    List demandList = mainList[mainIndex][s.key_DEMAND_DETAILS] ?? [];
    List taxData = [];
    List swmData = [];
    if (demandList.isNotEmpty) {
      for (int i = 0; i < demandList.length; i++) {
        if (mainList[mainIndex][key_taxtypeid].toString() == "1") {
          if (demandList[i][s.key_taxtypeid].toString() == mainList[mainIndex][key_taxtypeid].toString()) {
            taxData.add(demandList[i]);
          } else {
            swmData.add(demandList[i]);
          }
        } else {
          taxData.add(demandList[i]);
        }
      }
    }

    int countActiveItems = taxData.where((item) => item[s.key_flag] == true).length;
    if (countActiveItems == taxData.length) {
      isSelectAll.add(mainIndex);
    } else {
      isSelectAll.remove(mainIndex);
    }

    dynamic calcOfHeight = taxData.length / 2;
    int roundedValueOfHeight = calcOfHeight.ceil();
    int swmHeight = swmData.length * 30;
    return Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.only(top: 5),
        decoration: UIHelper.GradientContainer(5, 5, 5, 5, [c.need_improvement2, c.need_improvement2]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Visibility(
                visible: taxData.isNotEmpty,
                child: Row(
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: 15),
                        alignment: Alignment.centerLeft,
                        child: UIHelper.titleTextStyle("${'total'.tr()} : \u{20B9} ${getTotalToPay(mainIndex)}", c.grey_10, 12, false, false)),
                    Expanded(
                      child: GestureDetector(
                          onTap: () {
                            if (!getFlagStatus(mainList[mainIndex][key_assessment_id].toString()) || islogin == "yes") {
                              if (isSelectAll.contains(mainIndex)) {
                                isSelectAll.remove(mainIndex);
                                for (var item in taxData) {
                                  item[s.key_flag] = false;
                                }
                              } else {
                                isSelectAll.add(mainIndex);
                                for (var item in taxData) {
                                  item[s.key_flag] = true;
                                }
                              }
                            } else {
                              Utils().showAlert(context, ContentType.fail, 'pay_previous'.tr().toString());
                            }

                            double totAmt = 0;
                            for (var item in taxData) {
                              if (item[s.key_flag] == true) {
                                totAmt = totAmt + double.parse(Utils().getDemadAmount(item, mainList[mainIndex][key_taxtypeid].toString()));
                              }
                            }
                            mainList[mainIndex][s.key_tax_total] = totAmt;
                            mainList[mainIndex][s.key_tax_pay] =
                                getTotal(mainList[mainIndex][s.key_tax_total], double.parse(Utils().getTaxAdvance(mainList[mainIndex], mainList[mainIndex][key_taxtypeid])));

                            main_totalAmount = 0;
                            for (int i = 0; i < mainList.length; i++) {
                              main_totalAmount = main_totalAmount + mainList[i][s.key_tax_pay] + mainList[i][s.key_swm_pay];
                            }
                            setState(() {});
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              UIHelper.titleTextStyle("Select All", c.text_color, 12, false, true),
                              UIHelper.horizontalSpaceSmall,
                              Image.asset(
                                isSelectAll.contains(mainIndex) ? imagePath.tick : imagePath.unchecked,
                                color: isSelectAll.contains(mainIndex) ? c.account_status_green_color : c.text_color,
                                height: 20,
                                width: 20,
                              ),
                              UIHelper.horizontalSpaceSmall,
                            ],
                          )),
                    )
                  ],
                )),
            UIHelper.verticalSpaceSmall,
            Visibility(
                visible: taxData.isNotEmpty,
                child: SizedBox(
                    height: roundedValueOfHeight * 72,
                    child: ResponsiveGridList(
                        listViewBuilderOptions: ListViewBuilderOptions(physics: NeverScrollableScrollPhysics()),
                        horizontalGridMargin: 15,
                        verticalGridMargin: 0,
                        minItemWidth: Screen.width(context) / 4,
                        children: List.generate(
                          taxData.length,
                          (index) {
                            String finYearStr = "";
                            if (mainList[mainIndex][key_taxtypeid].toString() == "4") {
                              finYearStr = taxData[index]['financialyear'];
                            } else {
                              finYearStr = taxData[index][key_fin_year];
                            }
                            String durationStr = taxData[index][key_installment_group_name].toString().trim();
                            bool isStatus = false;
                            if (taxData[index][s.key_flag] == true) {
                              isStatus = true;
                            } else {
                              isStatus = false;
                            }

                            return GestureDetector(
                                onTap: () {
                                  if (!getFlagStatus(mainList[mainIndex][key_assessment_id].toString()) || islogin == "yes") {
                                    if (index == 0 || taxData[index - 1][s.key_flag] == true) {
                                      if (taxData[index][s.key_flag] == true) {
                                        for (int i = 0; i < taxData.length; i++) {
                                          if (i >= index) {
                                            if (taxData[i][s.key_flag] == true) {
                                              taxData[i][s.key_flag] = false;
                                              mainList[mainIndex][s.key_tax_total] =
                                                  mainList[mainIndex][s.key_tax_total] - double.parse(Utils().getDemadAmount(taxData[i], mainList[mainIndex][key_taxtypeid].toString()));

                                              mainList[mainIndex][s.key_tax_pay] = getTotal(
                                                  mainList[mainIndex][s.key_tax_total], double.parse(Utils().getTaxAdvance(mainList[mainIndex], mainList[mainIndex][key_taxtypeid].toString())));
                                            }
                                            if (taxData[0][s.key_flag] == false) {
                                              preferencesService.setUserInfo(key_isChecked, "");
                                            }
                                          }
                                        }
                                      } else {
                                        taxData[index][s.key_flag] = true;
                                        mainList[mainIndex][s.key_tax_total] =
                                            mainList[mainIndex][s.key_tax_total] + double.parse(Utils().getDemadAmount(taxData[index], mainList[mainIndex][key_taxtypeid].toString()));
                                        mainList[mainIndex][s.key_tax_pay] =
                                            getTotal(mainList[mainIndex][s.key_tax_total], double.parse(Utils().getTaxAdvance(mainList[mainIndex], mainList[mainIndex][key_taxtypeid].toString())));
                                      }
                                    } else {
                                      Utils().showAlert(context, ContentType.fail, 'pay_pending_year'.tr().toString());
                                    }
                                  } else {
                                    Utils().showAlert(context, ContentType.fail, 'pay_previous'.tr().toString());
                                  }

                                  int countActiveItems = taxData.where((item) => item[s.key_flag] == true).length;
                                  if (countActiveItems == taxData.length) {
                                    isSelectAll.add(mainIndex);
                                  } else {
                                    isSelectAll.remove(mainIndex);
                                  }

                                  setState(() {
                                    dynamic selectedDemandDetails = mainList[mainIndex];
                                    List selectedDemandDetailsList = selectedDemandDetails[key_DEMAND_DETAILS];
                                    bool hasActiveFlag = selectedDemandDetailsList.any((json) => json[key_flag] == true);

                                    if (hasActiveFlag && islogin == "yes") {
                                      preferencesService.addedTaxPayList.removeWhere((element) => element[key_assessment_id].toString() == mainList[mainIndex][key_assessment_id].toString());
                                      preferencesService.addedTaxPayList.add(selectedDemandDetails);
                                    }
                                    getCount();
                                    repeatOnce();

/*
                                    if (islogin == "yes") {
                                      preferencesService.addedTaxPayList.removeWhere((element) => element[key_assessment_id].toString() == mainList[mainIndex][key_assessment_id].toString());
                                      dynamic selectedDemandDetails = mainList[mainIndex];
                                      List selectedDemandDetailsList = selectedDemandDetails[key_DEMAND_DETAILS];
                                      bool hasActiveFlag = selectedDemandDetailsList.any((json) => json[key_flag] == true);

                                      if (hasActiveFlag) {
                                        preferencesService.addedTaxPayList.add(selectedDemandDetails);
                                      }

                                      // element[key_DEMAND_DETAILS].forEach((e) {
                                      //   if (e[key_flag] == true) {
                                      //     preferencesService.addedTaxPayList.add(element);
                                      //   }
                                      // });
                                    }
*/
                                  });
                                },
                                child: Stack(
                                  children: [
                                    Column(
                                      children: [
                                        SizedBox(height: 5),
                                        Container(
                                            padding: EdgeInsets.all(5.0),
                                            decoration: isStatus
                                                ? UIHelper.roundedBorderWithColorWithShadow(5, c.need_improvement, c.need_improvement)
                                                : UIHelper.roundedBorderWithColorWithShadow(5, c.white, c.white),
                                            height: 50,
                                            child: Column(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "$finYearStr ( $durationStr )",
                                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.normal, color: isStatus ? c.white : c.grey_8),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                // UIHelper.titleTextStyle(finYearStr + " ( $durationStr )", isStatus ? c.white : c.grey_8, 10, false, true),
                                                Expanded(
                                                  child: Container(
                                                      padding: EdgeInsets.all(0),
                                                      child: Center(
                                                          child: UIHelper.titleTextStyle("\u{20B9} ${Utils().getDemadAmount(taxData[index], mainList[mainIndex][key_taxtypeid].toString())}",
                                                              isStatus ? c.white : c.grey_10, 12, false, false))),
                                                ),
                                              ],
                                            ))
                                      ],
                                    ),
                                    Positioned(
                                        right: 5,
                                        child: Container(
                                            decoration: isStatus
                                                ? UIHelper.circleWithColorWithShadow(0, c.green_new, c.satisfied, borderColor: c.white, borderWidth: 2)
                                                : UIHelper.circleWithColorWithShadow(0, c.yello, c.unsatisfied1, borderColor: c.white, borderWidth: 2),
                                            height: 14,
                                            width: 14))
                                  ],
                                ));
                          },
                        )))),
            Visibility(
              visible: taxData.isEmpty,
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                child: UIHelper.titleTextStyle('no_demand'.tr().toString(), c.black, 11, false, false),
              ),
            ),
            demandCalculationWidget(mainIndex),
            Visibility(
                visible: swmData.isNotEmpty && mainList[mainIndex][key_taxtypeid].toString() == "1",
                child: Column(
                  children: [
                    UIHelper.verticalSpaceSmall,
                    UIHelper.titleTextStyle("swmUserCharges".tr().toString(), c.grey_9, 11, false, true),
                    UIHelper.verticalSpaceSmall,
                    Container(
                        margin: EdgeInsets.only(top: 5),
                        height: swmHeight + 0.02,
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: swmData.length,
                          itemBuilder: (context, rowIndex) {
                            int siNo = rowIndex + 1;
                            return SizedBox(
                                height: 30,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(padding: EdgeInsets.all(8.0), child: Center(child: UIHelper.titleTextStyle("$siNo", c.grey_8, 12, false, true))),
                                    ),
                                    Expanded(
                                        flex: 3,
                                        child: Container(padding: EdgeInsets.all(8.0), child: Center(child: UIHelper.titleTextStyle(swmData[rowIndex]['fin_year'], c.grey_8, 12, false, true)))),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                          padding: EdgeInsets.all(8.0),
                                          child: Center(
                                              child: UIHelper.titleTextStyle(Utils().getDemadAmount(swmData[rowIndex], mainList[mainIndex][key_taxtypeid].toString()), c.grey_8, 12, false, true))),
                                    ),
                                    rowIndex == 0 || taxData[rowIndex - 1][s.key_flag] == true
                                        ? Expanded(
                                            flex: 1,
                                            child: Container(
                                                padding: EdgeInsets.all(8.0),
                                                child: Center(
                                                  child: Checkbox(
                                                    side: BorderSide(width: 1, color: c.grey_6),
                                                    value: swmData[rowIndex][s.key_flag],
                                                    onChanged: (v) {
                                                      if (!getFlagStatus(mainList[mainIndex][key_assessment_id].toString()) || islogin == "yes") {
                                                        if (rowIndex == 0 || swmData[rowIndex - 1][s.key_flag] == true) {
                                                          if (swmData[rowIndex][s.key_flag] == true) {
                                                            for (int i = 0; i < swmData.length; i++) {
                                                              if (i >= rowIndex) {
                                                                swmData[i][s.key_flag] = false;
                                                                mainList[mainIndex][s.key_swm_total] = mainList[mainIndex][s.key_swm_total] -
                                                                    double.parse(Utils().getDemadAmount(swmData[i], mainList[mainIndex][key_taxtypeid].toString()));
                                                                mainList[mainIndex][s.key_swm_pay] = getTotal(mainList[mainIndex][s.key_swm_total], mainList[mainIndex][s.key_swm_available_advance]);
                                                              }
                                                            }
                                                          } else {
                                                            swmData[rowIndex][s.key_flag] = true;
                                                            mainList[mainIndex][s.key_swm_total] = mainList[mainIndex][s.key_swm_total] +
                                                                double.parse(Utils().getDemadAmount(swmData[rowIndex], mainList[mainIndex][key_taxtypeid].toString()));
                                                            mainList[mainIndex][s.key_swm_pay] = getTotal(mainList[mainIndex][s.key_swm_total], mainList[mainIndex][s.key_swm_available_advance]);
                                                          }
                                                        } else {
                                                          Utils().showAlert(context, ContentType.fail, 'pay_pending_year'.tr().toString());
                                                        }
                                                      } else {
                                                        Utils().showAlert(context, ContentType.fail, 'pay_previous'.tr().toString());
                                                      }

                                                      setState(() {
                                                        dynamic selectedDemandDetails = mainList[mainIndex];
                                                        List selectedDemandDetailsList = selectedDemandDetails[key_DEMAND_DETAILS];
                                                        bool hasActiveFlag = selectedDemandDetailsList.any((json) => json[key_flag] == true);

                                                        if (hasActiveFlag && islogin == "yes") {
                                                          preferencesService.addedTaxPayList
                                                              .removeWhere((element) => element[key_assessment_id].toString() == mainList[mainIndex][key_assessment_id].toString());
                                                          preferencesService.addedTaxPayList.add(selectedDemandDetails);
                                                        }

                                                        /* preferencesService.addedTaxPayList.clear();
                                                    mainList.forEach((element) {
                                                      element[key_DEMAND_DETAILS].forEach((e) {
                                                        if (e[key_flag] == true) {
                                                          preferencesService.addedTaxPayList.add(element);
                                                        }
                                                      });
                                                    });*/

                                                        getCount();
                                                        repeatOnce();
                                                      });
                                                    },
                                                  ),
                                                )),
                                          )
                                        : Expanded(
                                            child: SizedBox(
                                            width: 5,
                                          )),
                                  ],
                                ));
                          },
                        )),
                    UIHelper.verticalSpaceSmall,
                    demandCalculationWidgetForSWM(mainIndex),
                  ],
                )),
          ],
        ));
  }

  Widget demandCalculationWidget(int mainIndex) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // UIHelper.titleTextStyle("${'total'.tr()} : \u{20B9} "+getTotalToPay(mainIndex), c.grey_10, 12, false, false),
            UIHelper.titleTextStyle("${'selected'.tr()} : \u{20B9} ${mainList[mainIndex][s.key_tax_total]}", c.grey_10, 12, false, false),
            UIHelper.horizontalSpaceSmall,
            /* UIHelper.titleTextStyle("${'demand'.tr()} : \u{20B9} ${mainList[mainIndex][s.key_tax_total]}", c.grey_10, 12, false, false),
            UIHelper.titleTextStyle("${'advance'.tr()} : \u{20B9} ${Utils().getTaxAdvance(mainList[mainIndex], selectedTaxTypeData['taxtypeid'].toString())}", c.grey_10, 12, false, false),
          */
          ],
        ),
        UIHelper.verticalSpaceSmall,
        /* UIHelper.titleTextStyle('payable'.tr().toString()+" : "+"\u{20B9} "+mainList[mainIndex][s.key_tax_pay].toString(), c.grey_8, 11, true, false),
      UIHelper.verticalSpaceTiny,*/
      ],
    );
  }

  Widget demandCalculationWidgetForSWM(int mainIndex) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            UIHelper.titleTextStyle("${'total'.tr()} : \u{20B9} ${getTotalToPaySWM(mainIndex)}", c.grey_10, 12, false, false),
            UIHelper.titleTextStyle("${'selected'.tr()} : \u{20B9} ${mainList[mainIndex][s.key_swm_total]}", c.grey_10, 12, false, false),
            /* UIHelper.titleTextStyle("${'demand'.tr()} : \u{20B9} ${mainList[mainIndex][s.key_swm_total]}", c.black, 11, false, false),
            UIHelper.titleTextStyle("${'advance'.tr()} : \u{20B9} ${mainList[mainIndex][s.key_swm_available_advance]}", c.black, 11, false, false),
          */
          ],
        ),
        UIHelper.verticalSpaceSmall,
        /*UIHelper.titleTextStyle('payable'.tr().toString()+" : "+"\u{20B9} "+mainList[mainIndex][s.key_swm_pay].toString(), c.grey_8, 11, true, false),
      UIHelper.verticalSpaceTiny,*/
      ],
    );
  }

  /* Widget addToPayWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: Container(
            margin: EdgeInsets.only(top: 10, bottom: 15, left: 15),
            decoration: UIHelper.roundedBorderWithColorWithShadow(5, c.white, c.white),
            child: Row(
              children: [
                Container(
                    width: 35,
                    height: 35,
                    padding: EdgeInsets.all(5),
                    decoration: UIHelper.roundedBorderWithColor(5, 5, 5, 5, c.colorPrimary),
                    child: Image.asset(
                      selectedTaxTypeData[key_img_path].toString(),
                      fit: BoxFit.contain,
                      height: 15,
                      width: 15,
                    )),
                UIHelper.horizontalSpaceSmall,
                Container(width: 110, margin: EdgeInsets.only(left: 5), child: addInputDropdownField()),
              ],
            ),
          ),
        ),
        Visibility(
          visible: !widget.isHome,
          child: Expanded(
            flex: 1,
            child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: MediaQuery.of(context).size.width / 2.5,
                  margin: EdgeInsets.only(top: 10, bottom: 15, right: 15),
                  decoration: UIHelper.GradientContainer(5, 5, 5, 5, [c.grey_8, c.grey_8]),
                  padding: EdgeInsets.fromLTRB(5, 8, 0, 8),
                  child: Row(
                    // Wrap with Row to add the plus icon
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add, // Use the icon you prefer (e.g., Icons.add, Icons.add_circle, etc.)
                        color: c.white,
                        size: 15,
                      ),
                      SizedBox(width: 3),
                      Flexible(
                          child: UIHelper.titleTextStyle(
                        "new".tr().toString() + (selectedLang == "en" ? selectedTaxTypeData["taxtypedesc_en"] : selectedTaxTypeData["taxtypedesc_ta"]) + "new2".tr().toString(),
                        c.white,
                        10,
                        true,
                        true,
                      )) // Add a small space between the icon and the text
                      ,
                    ],
                  ),
                )),
          ),
        ),
        /* Visibility(
          visible: widget.isHome,
          child: Expanded(
              flex: 1,
              child: Stack(
                children: [
                  Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          preferencesService.addedTaxPayList.isNotEmpty
                              ? Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => TaxPayDetailsView(),
                                ))
                              : Utils().showAlert(context, ContentType.warning, 'no_record'.tr().toString());
                        },
                        child: Container(
                            margin: EdgeInsets.only(top: 15, right: 30, bottom: 15),
                            decoration: UIHelper.GradientContainer(5, 5, 5, 5, [c.grey_7, c.grey_7]),
                            padding: EdgeInsets.fromLTRB(10, 5, 10, 8),
                            child: UIHelper.titleTextStyle("added_to_pay".tr().toString(), c.white, 12, true, true)),
                      )),
                  Positioned(
                      top: 1,
                      right: 1,
                      child: Transform.scale(
                          scale: _animation.value,
                          child: Container(
                            margin: EdgeInsets.only(right: 15),
                            child: Container(
                                decoration: UIHelper.circleWithColorWithShadow(360, c.account_status_green_color, c.account_status_green_color),
                                padding: EdgeInsets.fromLTRB(10, 5, 10, 8),
                                child: UIHelper.titleTextStyle((main_count).toString(), c.white, 12, true, true)),
                          )))
                ],
              )),
        ), */
      ],
    );
  } */

  /* Widget assetCountWidget() {
    return Visibility(
        visible: totalAssessment > 0,
        child: Container(
          margin: EdgeInsets.only(top: 5, left: 20, right: 20, bottom: 15),
          decoration: UIHelper.GradientContainer(20, 20, 20, 20, [c.subscription_type_red_color, c.subscription_type_red_color], intwid: 0),
          child: Container(
            margin: EdgeInsets.only(left: 5, bottom: 3),
            decoration: UIHelper.roundedBorderWithColor(20, 20, 20, 20, c.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 5,
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      UIHelper.titleTextStyle("total_assessment".tr().toString(), c.grey_10, 11, true, true),
                      UIHelper.titleTextStyle(" $totalAssessment", c.grey_10, 14, true, true),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Visibility(
                  visible: pendingAssessment > 0,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.only(
                      top: 5,
                    ),
                    decoration: UIHelper.GradientContainer(0, 0, 18, 18, [c.red_new_light, c.red_new_light], intwid: 0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            UIHelper.titleTextStyle("pending_assessment_transaction".tr().toString(), c.grey_10, 11, true, true),
                            UIHelper.titleTextStyle(" $pendingAssessment", c.grey_10, 14, true, true),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        UIHelper.titleTextStyle(getWarningHint(), c.subscription_type_red_color, 11, true, true),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  } */

  Widget addInputDropdownField() {
    return FormBuilderDropdown(
      enabled: widget.isTaxDropDown ? true : false,
      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: c.grey_8),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 0),
        constraints: BoxConstraints(maxHeight: 35),
        hintText: 'select_taxtype'.tr().toString(),
        hintStyle: TextStyle(
          fontSize: 11,
        ),
        filled: true,
        fillColor: c.full_transparent,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: c.full_transparent, width: 0.0),
          borderRadius: BorderRadius.circular(0),
        ),
        focusedBorder: UIHelper.getInputBorder(0, borderColor: c.full_transparent),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 0.0),
          borderRadius: BorderRadius.circular(0), // Increase the radius to adjust the height
        ),
      ),
      initialValue: selectedTaxTypeData,
      iconSize: widget.isTaxDropDown ? 28 : 0,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: FormBuilderValidators.compose([FormBuilderValidators.required(errorText: "")]),
      items: taxTypeList
          .map((item) => DropdownMenuItem(
                value: item,
                child: Text(
                  selectedLang == "en" ? item[s.key_taxtypedesc_en].toString() : item[s.key_taxtypedesc_ta].toString(),
                  style: TextStyle(fontSize: 11.0, fontWeight: FontWeight.w400, color: c.black),
                ),
              ))
          .toList(),
      onChanged: (value) async {
        isShowFlag = [];
        isSelectAll = [];
        totalAmountToPay = 0.00;
        selectedTaxTypeData = value;
        filterDataList();
        getTaxWiseAssesmemtCount(selectedTaxTypeData[s.key_taxtypeid].toString());
        setState(() {});
      },
      name: 'TaxType',
    );
  }

  Widget payWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: UIHelper.GradientContainer(15, 15, 0, 0, [c.colorPrimary, c.colorAccentlight]),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 5, left: 5, right: 5),
              padding: EdgeInsets.all(5),
              child: Row(
                children: [
                  Container(
                      padding: EdgeInsets.all(5.0),
                      width: 90,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          UIHelper.titleTextStyle("${'total'.tr()} : ", c.white, selectedLang == "en" ? 13 : 11, true, true),
                          Container(
                              margin: EdgeInsets.only(top: 5),
                              padding: EdgeInsets.all(5.0),
                              decoration: UIHelper.roundedBorderWithColorWithShadow(5, c.grey, c.grey),
                              height: 25,
                              width: 80,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Container(padding: EdgeInsets.all(0), child: Center(child: UIHelper.titleTextStyle("\u{20B9} $totalAmountToPay", c.grey_10, 12, false, false))),
                                  ),
                                ],
                              )),
                        ],
                      )),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      UIHelper.titleTextStyle("${'selected_to_pay'.tr()} : ", c.white, selectedLang == "en" ? 13 : 10, true, true),
                      Container(
                          margin: EdgeInsets.only(top: 5),
                          padding: EdgeInsets.all(5.0),
                          decoration: UIHelper.roundedBorderWithColorWithShadow(5, c.white, c.white),
                          height: 25,
                          width: 100,
                          child: Column(
                            children: [
                              Expanded(
                                child: Container(padding: EdgeInsets.all(0), child: Center(child: UIHelper.titleTextStyle("\u{20B9} $main_totalAmount", c.grey_10, 12, false, false))),
                              ),
                            ],
                          )),
                    ],
                  ))
                ],
              ),
            ),
          ),
          /* Align(
            alignment: Alignment.centerLeft,
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 10, left: 20, right: 20),
              padding: EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  UIHelper.titleTextStyle("${'total_amount_to_pay'.tr()} : ", c.white, 11, true, true),
                  UIHelper.titleTextStyle("\u{20B9} $totalAmountToPay", c.white, 14, true, true),
                ],
              ),
            ),
          )  ,
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 0, left: 20, right: 20),
              padding: EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  UIHelper.titleTextStyle("${'selected_to_pay'.tr()} : ", c.white, 11, true, true),
                  UIHelper.titleTextStyle("\u{20B9} $main_totalAmount", c.white, 14, true, true),
                ],
              ),
            ),
          ),*/
          // child: UIHelper.titleTextStyle("${'total_amount_to_pay'.tr()} : \u{20B9} $main_totalAmount", c.white, 12, true, true))),
          Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                  onTap: () {
                    List finalList = [];
                    for (int i = 0; i < mainList.length; i++) {
                      mainList[i][key_tax_total] > 0 ? finalList.add(mainList[i]) : null;
                    }
                    finalList.isNotEmpty ? Utils().settingModalBottomSheet(context, finalList) : Utils().showAlert(context, ContentType.warning, 'select_demand'.tr().toString());
                  },
                  child: Container(
                      margin: EdgeInsets.only(top: 0, right: 20, bottom: 10),
                      decoration: UIHelper.GradientContainer(5, 5, 5, 5, [c.account_status_green_color, c.account_status_green_color]),
                      padding: EdgeInsets.fromLTRB(20, 5, 20, 7),
                      child: UIHelper.titleTextStyle("pay".tr().toString(), c.white, 12, true, true)))),
        ],
      ),
    );
  }

  double getTotal(double d1, double d2) {
    double s = 0.00;
    double ss = 0.00;
    ss = d1 - d2;
    ss > 0 ? s = ss : s = 0.00;
    return s;
  }

  Future<void> filterDataList() async {
    main_count = 0;
    mainList.clear();
    for (var sampletaxData in sampleDataList) {
      if ((selectedTaxTypeData[s.key_taxtypeid].toString() == "0") || (sampletaxData[s.key_taxtypeid].toString() == selectedTaxTypeData[s.key_taxtypeid].toString())) {
        if (preferencesService.addedTaxPayList.isNotEmpty && widget.isHome) {
          for (var addtaxData in preferencesService.addedTaxPayList) {
            if (addtaxData[s.key_dcode] == sampletaxData[s.key_dcode] &&
                addtaxData[s.key_bcode] == sampletaxData[s.key_bcode] &&
                addtaxData[s.key_pvcode] == sampletaxData[s.key_pvcode] &&
                addtaxData[s.key_taxtypeid] == sampletaxData[s.key_taxtypeid] &&
                addtaxData[s.key_assessment_id] == sampletaxData[s.key_assessment_id] &&
                addtaxData[s.key_assessment_no] == sampletaxData[s.key_assessment_no] &&
                (addtaxData[key_no_of_demand_available] > 0) &&
                (sampletaxData[key_no_of_demand_available] > 0)) {
              for (var addtaxListData in addtaxData[s.key_DEMAND_DETAILS]) {
                for (var sampleSelectedList in sampletaxData[s.key_DEMAND_DETAILS]) {
                  if (Utils().getDemandId(addtaxListData, sampletaxData[s.key_taxtypeid].toString()) == Utils().getDemandId(sampleSelectedList, sampletaxData[s.key_taxtypeid].toString()) &&
                      (Utils().getDemadAmount(addtaxListData, sampletaxData[s.key_taxtypeid].toString()) == Utils().getDemadAmount(sampleSelectedList, sampletaxData[s.key_taxtypeid].toString()))) {
                    sampleSelectedList[s.key_flag] = addtaxListData[s.key_flag];
                    if (addtaxListData[s.key_flag] == true) {
                      if (sampletaxData[s.key_taxtypeid].toString() == "1") {
                        if (sampletaxData[s.key_taxtypeid].toString() == addtaxListData[s.key_taxtypeid].toString()) {
                          sampletaxData[s.key_tax_total] = sampletaxData[s.key_tax_total] + double.parse(Utils().getDemadAmount(addtaxListData, addtaxData[s.key_taxtypeid].toString()));
                        } else {
                          sampletaxData[s.key_swm_total] = sampletaxData[s.key_swm_total] + double.parse(Utils().getDemadAmount(addtaxListData, addtaxData[s.key_taxtypeid].toString()));
                        }
                      } else {
                        sampletaxData[s.key_tax_total] = sampletaxData[s.key_tax_total] + double.parse(Utils().getDemadAmount(addtaxListData, addtaxData[s.key_taxtypeid].toString()));
                      }
                    }
                  }
                }
              }

              /*for (var addtaxListData in addtaxData['swmData']) {
                for (var sampleSelectedList in sampletaxData['swmData']) {
                  if (addtaxListData[s.key_fin_year] == sampleSelectedList[s.key_fin_year] && addtaxListData[s.key_amount] == sampleSelectedList[s.key_amount]) {
                    sampleSelectedList[s.key_flag] = addtaxListData[s.key_flag];
                  }
                }
              } */
            }
          }
        }
        mainList.add(sampletaxData);
      }
    }
    print("mainList>>$mainList");

    getCount();

/*
    for (int m = 0; m < preferencesService.addedTaxPayList.length; m++) {
      for (int j = 0;
          j <
              preferencesService
                  .addedTaxPayList[m][s.key_DEMAND_DETAILS].length;
          j++) {
        if (preferencesService.addedTaxPayList[m][s.key_DEMAND_DETAILS][j]
                [s.key_flag] ==
            true) {
          main_count = main_count + 1;
        }
      }
      // for (int j = 0; j < preferencesService.addedTaxPayList[m]['swmData'].length; j++) {
      //   if (preferencesService.addedTaxPayList[m]['swmData'][j][s.key_flag] == true) {
      //     main_count = main_count + 1;
      //   }
      // }
    }
*/
  }

  String getTaxImage(int typeId) {
    String taxTypeID = mainList[typeId][s.key_taxtypeid].toString();
    List selectedTaxitem = taxTypeList.where((element) => element[s.key_taxtypeid].toString() == taxTypeID).toList();
    return selectedTaxitem[0][s.key_img_path].toString();
  }

  Future<void> getTaxDetails() async {
    sampleDataList.clear();
    totalAssessment = 0;
    pendingAssessment = 0;
    totalAllAssessment = 0;
    pendingAllAssessment = 0;
    totalAssessment_property = 0;
    pendingAssessment_property = 0;
    totalAssessment_water = 0;
    pendingAssessment_water = 0;
    totalAssessment_professional = 0;
    pendingAssessment_professional = 0;
    totalAssessment_non = 0;
    pendingAssessment_non = 0;
    totalAssessment_trade = 0;
    pendingAssessment_trade = 0;
    try {
      Utils().showProgress(context, 1);
      for (var sampletaxData in taxTypeList) {
        if (sampletaxData[key_taxtypeid] != 0) {
          dynamic request = {
            s.key_service_id: s.service_key_DemandSelectionList,
            s.key_mode_type: 1,
            s.key_taxtypeid: sampletaxData[key_taxtypeid],
            s.key_mobile_number: islogin == "yes" ? mobile_widget : etTextController.text.toString().trim(),
            s.key_language_name: selectedLang
          };
          await StartUpViewModel()
              .getMainServiceList("TaxCollectionDetails", requestDataValue: request, context: context, taxType: selectedTaxTypeData[s.key_taxtypeid].toString(), lang: selectedLang);
          sampleDataList.addAll(preferencesService.taxCollectionDetailsList);
          totalAllAssessment = totalAllAssessment + int.parse(await preferencesService.getUserInfo(key_total_assesment));
          pendingAllAssessment = pendingAllAssessment + int.parse(await preferencesService.getUserInfo(key_pending_assessment));

          switch (sampletaxData[key_taxtypeid].toString()) {
            case '1':
              totalAssessment_property = int.parse(await preferencesService.getUserInfo(key_total_assesment));
              pendingAssessment_property = int.parse(await preferencesService.getUserInfo(key_pending_assessment));
              break;
            case '2':
              totalAssessment_water = int.parse(await preferencesService.getUserInfo(key_total_assesment));
              pendingAssessment_water = int.parse(await preferencesService.getUserInfo(key_pending_assessment));
              break;
            case '4':
              totalAssessment_professional = int.parse(await preferencesService.getUserInfo(key_total_assesment));
              pendingAssessment_professional = int.parse(await preferencesService.getUserInfo(key_pending_assessment));
              break;
            case '5':
              totalAssessment_non = int.parse(await preferencesService.getUserInfo(key_total_assesment));
              pendingAssessment_non = int.parse(await preferencesService.getUserInfo(key_pending_assessment));
              break;
            case '6':
              totalAssessment_trade = int.parse(await preferencesService.getUserInfo(key_total_assesment));
              pendingAssessment_trade = int.parse(await preferencesService.getUserInfo(key_pending_assessment));
              break;
          }
        }
      }
      totalAssessment = totalAllAssessment;
      pendingAssessment = pendingAllAssessment;
      print("sampleDataList>>$sampleDataList");
      print("sampleDataList>>${sampleDataList.length}");
      Utils().hideProgress(context);
      // throw ('000');
    } catch (error) {
      Utils().hideProgress(context);
      debugPrint('error (${error.toString()}) has been caught');
    }
  }

  String getvillageAndBlockName(int mainIndex, String taxTypeId) {
    String street = "";
    street = ((mainList[mainIndex][s.key_localbody_name] ?? '') + ", " + (mainList[mainIndex][s.key_bname] ?? ''));
    return street;
  }

  String getDoorAndStreetName(int mainIndex, String taxTypeId) {
    String street = "";
    switch (taxTypeId) {
      case '1':
        street = (mainList[mainIndex][s.key_door_no] ?? '') + ", " + (selectedLang == 'en' ? (mainList[mainIndex][s.key_street_name_en] ?? '') : (mainList[mainIndex][s.key_street_name_ta] ?? ''));
        break;
      case '2':
        street = selectedLang == 'en' ? (mainList[mainIndex]["street_name"] ?? '') : (mainList[mainIndex]["street_name"] ?? '');
        break;
      case '4':
        street = (mainList[mainIndex]['doorno'] ?? '') + ", " + (selectedLang == 'en' ? (mainList[mainIndex]["street_name_t"] ?? '') : (mainList[mainIndex]["street_name_t"] ?? ''));
        break;
      case '5':
        street = (mainList[mainIndex]['doorno'] ?? '') + ", " + (selectedLang == 'en' ? (mainList[mainIndex]["street_name"] ?? '') : (mainList[mainIndex]["street_name"] ?? ''));
        break;
      case '6':
        street = selectedLang == 'en' ? (mainList[mainIndex]["street_name_en"] ?? '') : (mainList[mainIndex]["street_name_ta"] ?? '');
        break;
    }
    return street;
  }

  bool getFlagStatus(String assId) {
    bool flag = false;
    if (mainList.isNotEmpty) {
      for (var data in mainList) {
        if (data[key_assessment_id].toString() != assId) {
          if (data[key_no_of_demand_available] > 0) {
            for (var demanData in data[s.key_DEMAND_DETAILS]) {
              if (demanData[s.key_flag] == true) {
                flag = true;
              }
            }
          }
        }
      }
    }
    return flag;
  }

  String getTotalToPay(int mainIndex) {
    double totAmt = 0.00;
    if (mainList.isNotEmpty) {
      if (mainList[mainIndex][key_no_of_demand_available] > 0) {
        for (var demanData in mainList[mainIndex][s.key_DEMAND_DETAILS]) {
          totAmt = totAmt + double.parse(Utils().getDemadAmount(demanData, mainList[mainIndex][key_taxtypeid].toString()));
        }
      }
    }
    return totAmt.toString();
  }

  String getTotalToPaySWM(int mainIndex) {
    double totAmt = 0.00;
    if (mainList.isNotEmpty) {
      for (var data in mainList) {
        if (data[s.key_no_of_demand_available] > 0) {
          for (var demanData in data[s.key_DEMAND_DETAILS]) {
            if (data[s.key_taxtypeid].toString() == "1") {
              if (data[s.key_taxtypeid].toString() != demanData[s.key_taxtypeid].toString()) {
                totAmt = totAmt + double.parse(Utils().getDemadAmount(demanData, data[key_taxtypeid].toString()));
              }
            }
          }
        }
      }
    }
    return totAmt.toString();
  }

  String getTaxWiseAssesmemtCount(String taxTypeId) {
    switch (taxTypeId) {
      case '0':
        totalAssessment = totalAllAssessment;
        pendingAssessment = pendingAllAssessment;
        break;
      case '1':
        totalAssessment = totalAssessment_property;
        pendingAssessment = pendingAssessment_property;
        break;
      case '2':
        totalAssessment = totalAssessment_water;
        pendingAssessment = pendingAssessment_water;
        break;
      case '4':
        totalAssessment = totalAssessment_professional;
        pendingAssessment = pendingAssessment_professional;
        break;
      case '5':
        totalAssessment = totalAssessment_non;
        pendingAssessment = pendingAssessment_non;
        break;
      case '6':
        totalAssessment = totalAssessment_trade;
        pendingAssessment = pendingAssessment_trade;
        break;
    }
    return totalAssessment.toString();
  }

  String getWarningHint() {
    String hint = "";
    switch (selectedTaxTypeData[key_taxtypeid].toString()) {
      case '0':
        hint = "transaction_warning_hint".tr().toString();
        break;
      case '1':
        hint = "property_hint".tr().toString();
        break;
      case '2':
        hint = "water_hint".tr().toString();
        break;
      case '4':
        hint = "professional_hint".tr().toString();
        break;
      case '5':
        hint = "non_hint".tr().toString();
        break;
      case '6':
        hint = "trade_hint".tr().toString();
        break;
    }
    return hint;
  }
}
