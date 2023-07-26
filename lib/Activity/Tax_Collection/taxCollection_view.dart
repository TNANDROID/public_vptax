import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:public_vptax/Activity/Tax_Collection/taxCollection_details.dart';
import 'package:public_vptax/Layout/screen_size.dart';
import 'package:public_vptax/Layout/ui_helper.dart';
import 'package:public_vptax/Model/startup_model.dart';
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
      String nameField, String hintText, String fieldType, String errorTxt) {
    return FormBuilderTextField(
      style: TextStyle(
          fontSize: 14.0, fontWeight: FontWeight.w400, color: c.grey_8),
      name: nameField,
      autocorrect: false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (value) {},
      decoration: InputDecoration(
        labelText: hintText,
        labelStyle: TextStyle(
            fontSize: 14.0, fontWeight: FontWeight.w400, color: Colors.black),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: UIHelper.getInputBorder(1, borderColor: c.grey_7),
        focusedBorder: UIHelper.getInputBorder(1, borderColor: c.grey_7),
        focusedErrorBorder: UIHelper.getInputBorder(1, borderColor: Colors.red),
        errorBorder: UIHelper.getInputBorder(1, borderColor: Colors.red),
        contentPadding: EdgeInsets.symmetric(
            vertical: 8, horizontal: 12), // Optional: Adjust padding
      ),
      validator: fieldType == 'Email'
          ? FormBuilderValidators.compose([
              FormBuilderValidators.required(errorText: errorTxt),
              FormBuilderValidators.email(),
            ])
          : fieldType == 'Mobile Number'
              ? FormBuilderValidators.compose([
                  FormBuilderValidators.required(errorText: errorTxt),
                  FormBuilderValidators.minLength(10),
                  FormBuilderValidators.maxLength(10),
                  FormBuilderValidators.numeric(),
                ])
              : FormBuilderValidators.compose([
                  FormBuilderValidators.required(errorText: errorTxt),
                ]),
      keyboardType: fieldType == 'Mobile Number' || fieldType == "Number"
          ? TextInputType.number
          : TextInputType.text,
    );
  }

  //Dropdown Input Field Widget
  Widget addInputDropdownField(int index, String inputHint, String fieldName,
      String errorText, StartUpViewModel model) {
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
      keyCode = "dcode";
      titleText = "dname";
      titleTextTamil = "lldname";
    } else if (index == 2) {
      dropList = model.selectedBlockList;
      keyCode = "bcode";
      titleText = "bname";
      titleTextTamil = "llbname";
    } else if (index == 3) {
      dropList = model.selectedVillageList;
      keyCode = "pvcode";
      titleText = "pvname";
      titleTextTamil = "pvname";
    } else {
      print("End.....");
    }
    return FormBuilderDropdown(
      style: TextStyle(
          fontSize: 14.0, fontWeight: FontWeight.w400, color: c.grey_8),
      decoration: InputDecoration(
        labelText: inputHint,
        labelStyle: TextStyle(
            fontSize: 14.0, fontWeight: FontWeight.w400, color: Colors.black),
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
        FormBuilderValidators.required(errorText: errorText),
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
                      color: c.grey_8),
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
                        addInputDropdownField(0, 'taxType'.tr().toString(),
                            "taxtype", "Required", model),
                        UIHelper.verticalSpaceSmall,
                        radioButtonWidget(1, 'mobileNumber'.tr().toString()),
                        radioButtonWidget(
                            2, 'computerRegisterNumber'.tr().toString()),
                        radioButtonWidget(3, 'tryAnotherWay'.tr().toString()),
                        UIHelper.verticalSpaceSmall,
                        // addInputFormControl('name', 'name'.tr().toString(),
                        //     "String", "Required"),
                        // UIHelper.verticalSpaceSmall,
                        selectedEntryType == 1
                            ? Column(
                                children: [
                                  addInputFormControl(
                                      'mobile',
                                      'mobileNumber'.tr().toString(),
                                      "Mobile Number",
                                      "Required"),
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
                                      "Number",
                                      "Required"),
                                  UIHelper.verticalSpaceSmall,
                                ],
                              )
                            : SizedBox(),

                        // addInputFormControl(
                        //     'email',
                        //     'emailAddress'.tr().toString(),
                        //     "Email",
                        //     "Required"),
                        // UIHelper.verticalSpaceSmall,
                        selectedEntryType == 3
                            ? Column(
                                children: [
                                  addInputDropdownField(
                                      1,
                                      'districtName'.tr().toString(),
                                      "district",
                                      "Required",
                                      model),
                                  UIHelper.verticalSpaceSmall,
                                  if (model.selectedBlockList.length > 0)
                                    addInputDropdownField(
                                        2,
                                        'blockName'.tr().toString(),
                                        "block",
                                        "Required",
                                        model),
                                  if (model.selectedBlockList.length > 0)
                                    UIHelper.verticalSpaceSmall,
                                  if (model.selectedVillageList.length > 0)
                                    addInputDropdownField(
                                        3,
                                        'villageName'.tr().toString(),
                                        "village",
                                        "Required",
                                        model),
                                  if (model.selectedVillageList.length > 0)
                                    UIHelper.verticalSpaceSmall,
                                  UIHelper.verticalSpaceSmall,
                                  selectedTaxType == "01"
                                      ? addInputFormControl(
                                          'assesment',
                                          'assesmentNumber'.tr().toString(),
                                          "Number",
                                          "Required")
                                      : selectedTaxType == "02"
                                          ? addInputFormControl(
                                              'waterConnectionNumber',
                                              'waterConnectionNo'
                                                  .tr()
                                                  .toString(),
                                              "Number",
                                              "Required")
                                          : selectedTaxType == "03"
                                              ? Column(
                                                  children: [
                                                    addInputDropdownField(
                                                        4,
                                                        'financialYear'
                                                            .tr()
                                                            .toString(),
                                                        "vip",
                                                        "Required",
                                                        model),
                                                    UIHelper.verticalSpaceSmall,
                                                    addInputFormControl(
                                                        'assesmentNumber',
                                                        'assesmentNumber'
                                                            .tr()
                                                            .toString(),
                                                        "Number",
                                                        "Required"),
                                                  ],
                                                )
                                              : selectedTaxType == "04"
                                                  ? addInputFormControl(
                                                      'lesseeNumber',
                                                      'lesseeNumber'
                                                          .tr()
                                                          .toString(),
                                                      "Number",
                                                      "Required")
                                                  : Column(
                                                      children: [
                                                        addInputDropdownField(
                                                            4,
                                                            'financialYear'
                                                                .tr()
                                                                .toString(),
                                                            "vip",
                                                            "Required",
                                                            model),
                                                        UIHelper
                                                            .verticalSpaceSmall,
                                                        addInputFormControl(
                                                            'tradeNumber',
                                                            'tradeNumber'
                                                                .tr()
                                                                .toString(),
                                                            "Number",
                                                            "Required"),
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
                                  print("tested-------------" +
                                      postParams.toString());
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
                                    20, c.grey_3, c.grey_3),
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
