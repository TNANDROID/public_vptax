import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:public_vptax/Activity/Tax_Collection/taxCollection_details.dart';
import 'package:public_vptax/Layout/screen_size.dart';
import 'package:public_vptax/Layout/ui_helper.dart';
import 'package:public_vptax/Model/startup_model.dart';
import 'package:public_vptax/Resources/StringsKey.dart';
import 'package:public_vptax/Services/Preferenceservices.dart';
import 'package:public_vptax/Services/locator.dart';
import 'package:public_vptax/Resources/ColorsValue.dart' as c;
import 'package:stacked/stacked.dart';
import 'package:public_vptax/Resources/ImagePath.dart' as imagePath;

class TaxCollectionView extends StatefulWidget {
  TaxCollectionView({Key? key}) : super(key: key);

  @override
  _TaxCollectionViewState createState() => _TaxCollectionViewState();
}

class _TaxCollectionViewState extends State<TaxCollectionView> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  PreferenceService preferencesService = locator<PreferenceService>();

  String selectedDistrict = "";
  String selectedBlock = "";
  String selectedVillage = "";
  String selectedTaxType = "";
  int selectedEntryType = 1;

  Widget addInputFormControl(
      String nameField, String hintText, String fieldType) {
    return FormBuilderTextField(
      style: TextStyle(
          fontSize: 14.0, fontWeight: FontWeight.w400, color: c.grey_9),
      name: nameField,
      autocorrect: false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (value) {},
      decoration: InputDecoration(
        labelText: hintText,
        labelStyle: TextStyle(
            fontSize: 16.0, fontWeight: FontWeight.w800, color: c.black),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: UIHelper.getInputBorder(1, borderColor: c.grey_7),
        focusedBorder: UIHelper.getInputBorder(1, borderColor: c.grey_7),
        focusedErrorBorder: UIHelper.getInputBorder(1, borderColor: Colors.red),
        errorBorder: UIHelper.getInputBorder(1, borderColor: Colors.red),
        contentPadding: EdgeInsets.symmetric(
            vertical: 8, horizontal: 12), // Optional: Adjust padding
      ),
      validator:
          // fieldType == 'Email'
          //     ? FormBuilderValidators.compose([
          //         FormBuilderValidators.required(errorText: errorTxt),
          //         FormBuilderValidators.email(),
          //       ])
          //     :
          fieldType == key_mobileNumber
              ? FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                      errorText: hintText + " " + 'isEmpty'.tr().toString()),
                  FormBuilderValidators.minLength(10,
                      errorText: hintText + " " + 'isInvalid'.tr().toString()),
                  FormBuilderValidators.maxLength(10,
                      errorText: hintText + " " + 'isInvalid'.tr().toString()),
                  FormBuilderValidators.numeric(),
                ])
              : FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                      errorText: hintText + " " + 'isEmpty'.tr().toString()),
                ]),
      keyboardType: fieldType == key_mobileNumber || fieldType == key_number
          ? TextInputType.number
          : TextInputType.text,
    );
  }

  //Dropdown Input Field Widget
  Widget addInputDropdownField(
      int index, String inputHint, String fieldName, StartUpViewModel model) {
    List dropList = [];
    String keyCode = "";
    String titleText = "";
    String titleTextTamil = "";

    if (index == 0) {
      dropList = model.taxType.toList();
      keyCode = "taxCode";
      titleText = "taxname";
      titleTextTamil = "taxname";
    } else if (index == 1) {
      dropList = model.districtList;
      keyCode = key_dcode;
      titleText = key_dname;
      titleTextTamil = key_dname_ta;
    } else if (index == 2) {
      dropList = model.selectedBlockList;
      keyCode = key_bcode;
      titleText = key_bname;
      titleTextTamil = key_bname_ta;
    } else if (index == 3) {
      dropList = model.selectedVillageList;
      keyCode = key_pvcode;
      titleText = key_pvname;
      titleTextTamil = key_pvname_ta;
    } else {
      print("End.....");
    }
    return FormBuilderDropdown(
      style: TextStyle(
          fontSize: 14.0, fontWeight: FontWeight.w400, color: c.grey_8),
      decoration: InputDecoration(
        labelText: inputHint,
        labelStyle: TextStyle(
            fontSize: 16.0, fontWeight: FontWeight.w800, color: c.black),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: UIHelper.getInputBorder(1, borderColor: c.grey_7),
        focusedBorder: UIHelper.getInputBorder(1, borderColor: c.grey_7),
        focusedErrorBorder: UIHelper.getInputBorder(1, borderColor: Colors.red),
        errorBorder: UIHelper.getInputBorder(1, borderColor: Colors.red),
        contentPadding: EdgeInsets.symmetric(
            vertical: 8, horizontal: 12), // Optional: Adjust padding
      ),
      name: fieldName,
      initialValue: index == 0
          ? selectedTaxType
          : index == 1
              ? selectedDistrict
              : index == 2
                  ? selectedBlock
                  : selectedVillage,
      onTap: () async {
        if (index == 1) {
          selectedDistrict = "";
          selectedBlock = "";
          selectedVillage = "";
          model.selectedBlockList.clear();
          model.selectedVillageList.clear();
        } else if (index == 2) {
          selectedBlock = "";
          selectedVillage = "";
          model.selectedVillageList.clear();
        } else if (index == 3) {
          selectedVillage = "";
        } else {
          print("End of the Statement......");
        }
        setState(() {});
      },
      iconSize: 30,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(
            errorText: inputHint + " " + 'isEmpty'.tr().toString()),
      ]),
      items: dropList
          .map((item) => DropdownMenuItem(
                value: item[keyCode],
                child: Text(
                  preferencesService.getUserInfo("lang") == "en"
                      ? item[titleText].toString()
                      : item[titleTextTamil].toString(),
                  style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: c.grey_9),
                ),
              ))
          .toList(),
      onChanged: (value) async {
        if (index == 0) {
          selectedTaxType = value.toString();
        } else if (index == 1) {
          selectedDistrict = value.toString();
          await model.loadUIBlock(selectedDistrict);
        } else if (index == 2) {
          selectedBlock = value.toString();
          await model.loadUIVillage(selectedDistrict, selectedBlock);
        } else if (index == 3) {
          selectedVillage = value.toString();
        } else {
          print("End of the Statement......");
        }
        setState(() {});
      },
    );
  }

  Widget radioButtonWidget(int index, String title) {
    return Row(
      children: [
        Radio(
          value: index,
          groupValue: selectedEntryType,
          onChanged: (value) {
            selectedEntryType = int.parse(value.toString());
            setState(() {});
          },
        ),
        Expanded(
            child:
                UIHelper.titleTextStyle(title, Colors.black, 12, true, false)),
      ],
    );
  }

  Widget formControls(BuildContext context, StartUpViewModel model) {
    return Padding(
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Container(
                    width: Screen.width(context),
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: [
                        addInputDropdownField(
                            0, 'taxType'.tr().toString(), "taxtype", model),
                        UIHelper.verticalSpaceSmall,
                        radioButtonWidget(1, 'mobileNumber'.tr().toString()),
                        radioButtonWidget(
                            2, 'computerRegisterNumber'.tr().toString()),
                        radioButtonWidget(3, 'tryAnotherWay'.tr().toString()),
                        UIHelper.verticalSpaceSmall,
                        selectedEntryType == 1
                            ? Column(
                                children: [
                                  addInputFormControl(
                                      'mobile',
                                      'mobileNumber'.tr().toString(),
                                      key_mobileNumber),
                                  UIHelper.verticalSpaceSmall,
                                ],
                              )
                            : SizedBox(),
                        selectedEntryType == 2
                            ? Column(
                                children: [
                                  addInputFormControl(
                                      'computerRegNo',
                                      'computerRegisterNumber'.tr().toString(),
                                      key_number),
                                  UIHelper.verticalSpaceSmall,
                                ],
                              )
                            : SizedBox(),
                        selectedEntryType == 3
                            ? Column(
                                children: [
                                  addInputDropdownField(
                                      1,
                                      'districtName'.tr().toString(),
                                      "district",
                                      model),
                                  UIHelper.verticalSpaceSmall,
                                  if (model.selectedBlockList.length > 0)
                                    addInputDropdownField(
                                        2,
                                        'blockName'.tr().toString(),
                                        "block",
                                        model),
                                  if (model.selectedBlockList.length > 0)
                                    UIHelper.verticalSpaceSmall,
                                  if (model.selectedVillageList.length > 0)
                                    addInputDropdownField(
                                        3,
                                        'villageName'.tr().toString(),
                                        "village",
                                        model),
                                  if (model.selectedVillageList.length > 0)
                                    UIHelper.verticalSpaceSmall,
                                  UIHelper.verticalSpaceSmall,
                                  selectedTaxType == "01"
                                      ? addInputFormControl(
                                          'assesment',
                                          'assesmentNumber'.tr().toString(),
                                          key_number)
                                      : selectedTaxType == "02"
                                          ? addInputFormControl(
                                              'waterConnectionNumber',
                                              'waterConnectionNo'
                                                  .tr()
                                                  .toString(),
                                              key_number)
                                          : selectedTaxType == "03"
                                              ? Column(
                                                  children: [
                                                    addInputDropdownField(
                                                        4,
                                                        'financialYear'
                                                            .tr()
                                                            .toString(),
                                                        "vip",
                                                        model),
                                                    UIHelper.verticalSpaceSmall,
                                                    addInputFormControl(
                                                        'assesmentNumber',
                                                        'assesmentNumber'
                                                            .tr()
                                                            .toString(),
                                                        key_number),
                                                  ],
                                                )
                                              : selectedTaxType == "04"
                                                  ? addInputFormControl(
                                                      'lesseeNumber',
                                                      'lesseeNumber'
                                                          .tr()
                                                          .toString(),
                                                      key_number)
                                                  : Column(
                                                      children: [
                                                        addInputDropdownField(
                                                            4,
                                                            'financialYear'
                                                                .tr()
                                                                .toString(),
                                                            "vip",
                                                            model),
                                                        UIHelper
                                                            .verticalSpaceSmall,
                                                        addInputFormControl(
                                                            'tradeNumber',
                                                            'tradeNumber'
                                                                .tr()
                                                                .toString(),
                                                            key_number),
                                                      ],
                                                    ),
                                  UIHelper.verticalSpaceSmall,
                                ],
                              )
                            : SizedBox(),
                        Container(
                            width: Screen.width(context) / 2,
                            alignment: Alignment.center,
                            child: GestureDetector(
                              onTap: () async {
                                if (_formKey.currentState!.saveAndValidate()) {
                                  Map<String, dynamic> postParams =
                                      Map.from(_formKey.currentState!.value);
                                  postParams.removeWhere(
                                      (key, value) => value == null);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              TaxCollectionDetailsView()));
                                }
                              },
                              child: Container(
                                decoration: UIHelper.GradientContainer(
                                    10,
                                    10,
                                    10,
                                    10,
                                    [c.colorPrimary, c.colorPrimaryDark]),
                                padding: EdgeInsets.all(7),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    UIHelper.titleTextStyle(
                                        'submit'.tr().toString(),
                                        c.white,
                                        15,
                                        true,
                                        false),
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
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      top: true,
      child: ViewModelBuilder<StartUpViewModel>.reactive(
          onModelReady: (model) async {
            await model.getOpenServiceList("District");
            await model.getOpenServiceList("Block");
            await model.getOpenServiceList("Village");
          },
          builder: (context, model, child) {
            return model.isBusy
                ? Center(child: CircularProgressIndicator())
                : Container(
                    color: Colors.white,
                    width: Screen.width(context),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        UIHelper.verticalSpaceMedium,
                        Expanded(
                            child: SingleChildScrollView(
                          child: Container(
                            decoration:
                                UIHelper.roundedBorderWithColorWithShadow(
                                    20, c.grey_1, c.grey_3),
                            child: Column(
                              children: [
                                UIHelper.verticalSpaceMedium,
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
}
