// ignore_for_file: library_prefixes, prefer_const_constructors_in_immutables, library_private_types_in_public_api, prefer_typing_uninitialized_variables, prefer_const_constructors, avoid_print, deprecated_member_use, use_build_context_synchronously, file_names

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:public_vptax/Activity/Tax_Collection/taxCollection_details.dart';
import 'package:public_vptax/Layout/customclip.dart';
import 'package:public_vptax/Layout/screen_size.dart';
import 'package:public_vptax/Layout/ui_helper.dart';
import 'package:public_vptax/Model/startup_model.dart';
import 'package:public_vptax/Resources/ColorsValue.dart' as c;
import 'package:public_vptax/Resources/ImagePath.dart' as imagePath;
import 'package:public_vptax/Resources/StringsKey.dart';
import 'package:public_vptax/Services/Preferenceservices.dart';
import 'package:public_vptax/Services/locator.dart';
import 'package:public_vptax/Utils/utils.dart';
import 'package:stacked/stacked.dart';

import '../../Utils/ContentInfo.dart';

class TaxCollectionView extends StatefulWidget {
  final selectedTaxTypeData;
  final flag;
  TaxCollectionView({Key? key, this.selectedTaxTypeData, this.flag});

  @override
  _TaxCollectionViewState createState() => _TaxCollectionViewState();
}

class _TaxCollectionViewState extends State<TaxCollectionView> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  PreferenceService preferencesService = locator<PreferenceService>();
  TextEditingController etTextController = TextEditingController();
  List imgURLList = [imagePath.house, imagePath.water, imagePath.professional1, imagePath.nontax1, imagePath.trade];
  List<Color> colorsList = [c.followers, c.need_improvement_color, c.followingBg, c.colorAccentveryverylight, c.dot_dark_screen4];
  String selectedLang = "";
  String selectedDistrict = "";
  String selectedBlock = "";
  String selectedVillage = "";
  String selectedFinYear = "";
  int selectedTaxType = 0;
  var selectedTaxTypeData;
  int selectedEntryType = 0;
  int selectedIndex = 1;
  List taxlist = [];

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    selectedLang = await preferencesService.getUserInfo("lang");
    taxlist.clear();
    if (widget.flag == "1") {
      selectedTaxTypeData = widget.selectedTaxTypeData;
      selectedTaxType = selectedTaxTypeData[key_taxtypeid];
    } else {
      taxlist = preferencesService.taxTypeList;
      selectedTaxTypeData = taxlist[0];
      selectedTaxType = selectedTaxTypeData[key_taxtypeid];
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: c.colorPrimary,
          centerTitle: true,
          elevation: 2,
          title: Text(
            'quickPay'.tr().toString(),
            style: TextStyle(fontSize: 14),
          ),
        ),
        body: SafeArea(
          top: true,
          child: ViewModelBuilder<StartUpViewModel>.reactive(
              onModelReady: (model) async {},
              builder: (context, model, child) {
                return Container(
                    color: Colors.white,
                    width: Screen.width(context),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Expanded(
                            child: SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            /*decoration:
                                UIHelper.roundedBorderWithColorWithShadow(
                                    20, c.grey_3, c.grey_3),*/
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                taxWidgetGridView(),
                                radioButtonListWidget(),
                                formControls(context, model),
                              ],
                            ),
                          ),
                        )),
                      ],
                    ));
              },
              viewModelBuilder: () => StartUpViewModel()),
        ));
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

  //Dropdown Input Field Widget
  Widget addInputDropdownField(int index, String inputHint, String fieldName, StartUpViewModel model) {
    List dropList = [];
    String keyCode = "";
    String titleText = "";
    String titleTextTamil = "";
    String initValue = "";

    if (index == 1) {
      dropList = preferencesService.districtList;
      keyCode = key_dcode;
      titleText = key_dname;
      titleTextTamil = key_dname_ta;
      initValue = selectedDistrict;
    } else if (index == 2) {
      dropList = model.selectedBlockList;
      keyCode = key_bcode;
      titleText = key_bname;
      titleTextTamil = key_bname_ta;
      initValue = selectedBlock;
    } else if (index == 3) {
      dropList = model.selectedVillageList;
      keyCode = key_pvcode;
      titleText = key_pvname;
      titleTextTamil = key_pvname_ta;
      initValue = selectedBlock;
    } else if (index == 4) {
      dropList = preferencesService.finYearList;
      keyCode = key_fin_year;
      titleText = key_fin_year;
      titleTextTamil = key_fin_year;
      initValue = selectedFinYear;
    } else {
      print("End.....");
    }
    return FormBuilderDropdown(
      style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600, color: c.grey_10),
      decoration: InputDecoration(
        labelText: inputHint,
        labelStyle: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, color: c.grey_7),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: UIHelper.getInputBorder(1, borderColor: c.grey_7),
        focusedBorder: UIHelper.getInputBorder(1, borderColor: c.grey_7),
        focusedErrorBorder: UIHelper.getInputBorder(1, borderColor: Colors.red),
        errorBorder: UIHelper.getInputBorder(1, borderColor: Colors.red),
        errorStyle: TextStyle(fontSize: 10),
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12), // Optional: Adjust padding
      ),
      name: fieldName,
      initialValue: initValue,
      iconSize: 30,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: "$inputHint ${'isEmpty'.tr()}"),
      ]),
      items: dropList
          .map((item) => DropdownMenuItem(
                value: item[keyCode],
                child: Text(
                  selectedLang == "en" ? item[titleText].toString() : item[titleTextTamil].toString(),
                  style: TextStyle(fontSize: 11.0, fontWeight: FontWeight.w400, color: c.grey_9),
                ),
              ))
          .toList(),
      onChanged: (value) async {
        Utils().showProgress(context, 1);
        if (index == 1) {
          model.selectedBlockList.clear();
          model.selectedVillageList.clear();
          selectedDistrict = value.toString();
          selectedBlock = "";
          selectedVillage = "";
          Future.delayed(Duration(milliseconds: 500), () {
            model.loadUIBlock(selectedDistrict);
            setState(() {});
            Utils().hideProgress(context);
          });
        } else if (index == 2) {
          selectedBlock = value.toString();
          selectedVillage = "";
          model.selectedVillageList.clear();
          Future.delayed(Duration(milliseconds: 500), () {
            model.loadUIVillage(selectedDistrict, selectedBlock);

            setState(() {});
            Utils().hideProgress(context);
          });
        } else if (index == 3) {
          selectedVillage = value.toString();
          Future.delayed(Duration(milliseconds: 200), () {
            Utils().hideProgress(context);
          });
        } else if (index == 4) {
          selectedFinYear = value.toString();
          Future.delayed(Duration(milliseconds: 200), () {
            Utils().hideProgress(context);
          });
        } else {
          print("End of the Statement......");
        }

        setState(() {});
      },
    );
  }

  Widget radioButtonWidget(int index, String title) {
    return GestureDetector(
        onTap: () {
          selectedEntryType = index;
          setState(() {});
        },
        child: Stack(children: [
          Container(
              height: 70,
              width: Screen.width(context),
              padding: EdgeInsets.all(4),
              decoration: UIHelper.roundedBorderWithColor(120, 15, 120, 15, c.white, borderColor: selectedEntryType == index ? c.text_color : c.grey_4, borderWidth: 3),
              child: Container(
                height: 60,
                width: Screen.width(context),
                padding: EdgeInsets.only(left: 100),
                decoration: UIHelper.roundedBorderWithColor(120, 15, 120, 15, selectedEntryType == index ? c.grey_4 : c.grey_3),
                child: Center(child: UIHelper.titleTextStyle(title, selectedEntryType == index ? c.text_color : c.grey_7, 10, true, false)),
              )),
          ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Container(
                  color: selectedEntryType == index ? c.text_color : c.grey_3,
                  padding: EdgeInsets.all(3),
                  width: 70,
                  height: 70,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: UIHelper.circleWithColorWithShadow(30, selectedEntryType == index ? c.text_color : c.grey_3, selectedEntryType == index ? c.text_color : c.grey_3,
                            borderColor: c.white, borderWidth: 3),
                        width: 100,
                        height: 100,
                        child: Icon(
                          index == 1
                              ? Icons.phone_iphone_outlined
                              : index == 2
                                  ? Icons.laptop_mac_outlined
                                  : Icons.pin_outlined, // Use the icon you prefer (e.g., Icons.add, Icons.add_circle, etc.)
                          color: selectedEntryType == index ? c.white : c.grey_7,
                          size: 40,
                        ),
                      )))),
        ]));
  }

  Widget radioButtonListWidget() {
    return Visibility(
      visible: selectedTaxType > 0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UIHelper.titleTextStyle('select_anyOne'.tr().toString(), c.grey_9, 12, true, true),
          UIHelper.verticalSpaceSmall,
          radioButtonWidget(1, 'via_mobileNumber'.tr().toString()),
          UIHelper.verticalSpaceSmall,
          radioButtonWidget(2, 'via_e_taxNumber'.tr().toString()),
          UIHelper.verticalSpaceSmall,
          radioButtonWidget(3, 'via_assessNumber'.tr().toString()),
        ],
      ),
    );
  }

  Widget formControls(BuildContext context, StartUpViewModel model) {
    return Visibility(
      visible: selectedEntryType > 0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UIHelper.verticalSpaceMedium,
          UIHelper.titleTextStyle('enter_the_details'.tr().toString(), c.grey_9, 12, true, true),
          UIHelper.verticalSpaceMedium,
          FormBuilder(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    SizedBox(
                      width: Screen.width(context),
                      // padding: EdgeInsets.all(15),
                      child: Column(
                        children: [
                          selectedEntryType == 1
                              ? Column(
                                  children: [
                                    addInputFormControl('mobile', 'mobileNumber'.tr().toString(), key_mobile_number),
                                    UIHelper.verticalSpaceSmall,
                                  ],
                                )
                              : SizedBox(),
                          selectedEntryType == 2
                              ? Column(
                                  children: [
                                    addInputFormControl('computerRegNo', 'computerRegisterNumber'.tr().toString(), key_number),
                                    UIHelper.verticalSpaceSmall,
                                  ],
                                )
                              : SizedBox(),
                          selectedEntryType == 3
                              ? Column(
                                  children: [
                                    addInputDropdownField(1, 'districtName'.tr().toString(), "district", model),
                                    UIHelper.verticalSpaceSmall,
                                    if (model.selectedBlockList.isNotEmpty) addInputDropdownField(2, 'blockName'.tr().toString(), "block", model),
                                    if (model.selectedBlockList.isNotEmpty) UIHelper.verticalSpaceSmall,
                                    if (model.selectedVillageList.isNotEmpty) addInputDropdownField(3, 'villageName'.tr().toString(), "village", model),
                                    UIHelper.verticalSpaceSmall,
                                    selectedTaxType == 1
                                        ? addInputFormControl('assesment', 'assesmentNumber'.tr().toString(), key_number)
                                        : selectedTaxType == 2
                                            ? addInputFormControl('waterConnectionNumber', 'waterConnectionNo'.tr().toString(), key_number)
                                            : selectedTaxType == 4 && selectedVillage != ""
                                                ? Column(
                                                    children: [
                                                      addInputDropdownField(4, 'financialYear'.tr().toString(), "vip", model),
                                                      UIHelper.verticalSpaceSmall,
                                                      addInputFormControl('assesmentNumber', 'assesmentNumber'.tr().toString(), key_number),
                                                    ],
                                                  )
                                                : selectedTaxType == 5 && selectedVillage != ""
                                                    ? addInputFormControl('lesseeNumber', 'lesseeNumber'.tr().toString(), key_number)
                                                    : selectedVillage != ""
                                                        ? Column(
                                                            children: [
                                                              addInputDropdownField(4, 'financialYear'.tr().toString(), "vip", model),
                                                              UIHelper.verticalSpaceSmall,
                                                              addInputFormControl('tradeNumber', 'tradeNumber'.tr().toString(), key_number),
                                                            ],
                                                          )
                                                        : SizedBox(),
                                    UIHelper.verticalSpaceSmall,
                                  ],
                                )
                              : SizedBox(),
                          Container(
                              width: Screen.width(context) / 2,
                              alignment: Alignment.center,
                              child: GestureDetector(
                                onTap: () async {
                                  selectedEntryType == 1 ? etTextController.text = '9875235654' : null;
                                  validate();
                                },
                                child: Container(
                                  decoration: UIHelper.GradientContainer(10, 10, 10, 10, [c.colorPrimary, c.colorPrimaryDark]),
                                  padding: EdgeInsets.fromLTRB(15, 8, 15, 8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      UIHelper.titleTextStyle('submit'.tr().toString(), c.white, 13, true, false),
                                    ],
                                  ),
                                ),
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget taxWidgetGridData(dynamic data, int index) {
    String imgURL = imgURLList[index - 1];
    Color primaryClr = colorsList[index - 1];
    return GestureDetector(
        onTap: () {
          selectedTaxTypeData = data;
          selectedTaxType = selectedTaxTypeData[key_taxtypeid];
          selectedIndex = index;
          setState(() {});
        },
        child: Opacity(
            opacity: selectedIndex == index ? 1.0 : 0.5,
            child: Container(
              width: Screen.width(context) / 2.5,
              margin: EdgeInsets.all(3),
              padding: EdgeInsets.all(3),
              decoration: UIHelper.roundedBorderWithColorWithShadow(5, primaryClr, primaryClr, borderColor: selectedIndex == index ? c.red : c.full_transparent, borderWidth: 2),
              child: Row(
                children: [
                  Container(
                      width: 35,
                      height: 35,
                      padding: EdgeInsets.all(5),
                      decoration: UIHelper.roundedBorderWithColor(5, 5, 5, 5, selectedIndex == index ? c.white : c.need_improvement2),
                      child: Image.asset(
                        imgURL.toString(),
                        fit: BoxFit.contain,
                        height: 15,
                        width: 15,
                      )),
                  UIHelper.horizontalSpaceSmall,
                  Flexible(child: UIHelper.titleTextStyle(selectedLang == "en" ? data[key_taxtypedesc_en] : data[key_taxtypedesc_ta], c.white, 10, true, true)),
                ],
              ),
            )));
  }

  Widget taxWidgetGridView() {
    return taxlist.isNotEmpty
        ? Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
            UIHelper.titleTextStyle('select_taxtype'.tr().toString(), c.grey_9, 12, true, true),
            UIHelper.verticalSpaceMedium,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [taxWidgetGridData(taxlist[0], 1), taxWidgetGridData(taxlist[1], 2)],
            ),
            UIHelper.verticalSpaceSmall,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [taxWidgetGridData(taxlist[2], 3), taxWidgetGridData(taxlist[3], 4)],
            ),
            UIHelper.verticalSpaceSmall,
            Align(alignment: Alignment.center, child: taxWidgetGridData(taxlist[4], 5)),
            UIHelper.verticalSpaceMedium,
          ])
        : SizedBox();
  }

  Future<void> validate() async {
    if (selectedTaxType > 0) {
      if (selectedEntryType > 0) {
        if (_formKey.currentState!.saveAndValidate()) {
          Map<String, dynamic> postParams = Map.from(_formKey.currentState!.value);
          postParams.removeWhere((key, value) => value == null);

          try {
            dynamic request = {
              key_service_id: service_key_DemandSelectionList,
              key_mode_type: selectedEntryType,
              key_taxtypeid: selectedTaxTypeData[key_taxtypeid].toString(),
              key_language_name: selectedLang,
              if (selectedEntryType == 1)
                key_mobile_number: etTextController.text
              else if (selectedEntryType == 2)
                key_assessment_id: etTextController.text
              else ...{
                key_assessment_no: etTextController.text,
                key_dcode: selectedDistrict,
                key_bcode: selectedBlock,
                key_pvcode: selectedVillage,
                if (selectedTaxTypeData[key_taxtypeid] == 4) key_fin_year: selectedFinYear
              }
            };

            await StartUpViewModel()
                .getMainServiceList("TaxCollectionDetails", requestDataValue: request, context: context, taxType: selectedTaxTypeData[key_taxtypeid].toString(), lang: selectedLang);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => TaxCollectionDetailsView(
                          selectedTaxTypeData: selectedTaxTypeData,
                          isTaxDropDown: selectedEntryType == 1 ? true : false,
                          isHome: false,
                          dcode: selectedDistrict,
                          bcode: selectedBlock,
                          pvcode: selectedVillage,
                          mobile: etTextController.text,
                          selectedEntryType: selectedEntryType,
                        ))).then((value) => {});
            // throw ('000');
          } catch (error) {
            print('error (${error.toString()}) has been caught');
          }
        }
      } else {
        Utils().showAlert(context, ContentType.warning, 'select_all_field'.tr().toString(), btnCount: "1", btnmsg: "ok");
      }
    } else {
      Utils().showAlert(context, ContentType.warning, 'select_taxtype'.tr().toString(), btnCount: "1", btnmsg: "ok");
    }
  }
}
