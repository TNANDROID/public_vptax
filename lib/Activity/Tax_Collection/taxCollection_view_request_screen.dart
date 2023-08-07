import 'dart:io';
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
import 'package:public_vptax/Resources/StringsKey.dart';
import 'package:public_vptax/Services/Preferenceservices.dart';
import 'package:public_vptax/Services/locator.dart';
import 'package:public_vptax/Resources/ColorsValue.dart' as c;
import 'package:public_vptax/Utils/utils.dart';
import 'package:stacked/stacked.dart';
import 'package:public_vptax/Resources/ImagePath.dart' as imagePath;
import '../../Utils/ContentInfo.dart';

class TaxCollectionView extends StatefulWidget {
  TaxCollectionView({Key? key}) : super(key: key);

  @override
  _TaxCollectionViewState createState() => _TaxCollectionViewState();
}

class _TaxCollectionViewState extends State<TaxCollectionView> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> form_key = GlobalKey<FormBuilderState>();
  PreferenceService preferencesService = locator<PreferenceService>();
  TextEditingController mobileController = TextEditingController();
  String selectedLang = "";
  String selectedDistrict = "";
  String selectedBlock = "";
  String selectedVillage = "";
  String selectedFinYear = "";
  int selectedTaxType = 0;
  var selectedTaxTypeData;
  int selectedEntryType = 0;
  List taxlist = [];

  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    selectedLang = await preferencesService.getUserInfo("lang");
    taxlist.clear();
    taxlist = preferencesService.taxTypeList;
    setState(() {});
  }

  Widget addInputFormControl(
      String nameField, String hintText, String fieldType) {
    return FormBuilderTextField(
      key: form_key,
      controller: mobileController,
      style: TextStyle(
          fontSize: 12.0, fontWeight: FontWeight.w400, color: c.grey_9),
      name: nameField,
      autocorrect: false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (value) {},
      decoration: InputDecoration(
        labelText: hintText,
        labelStyle: TextStyle(
            fontSize: 11.0, fontWeight: FontWeight.w600, color: c.grey_7),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: UIHelper.getInputBorder(1, borderColor: c.grey_7),
        focusedBorder: UIHelper.getInputBorder(1, borderColor: c.grey_7),
        focusedErrorBorder: UIHelper.getInputBorder(1, borderColor: Colors.red),
        errorBorder: UIHelper.getInputBorder(1, borderColor: Colors.red),
        errorStyle: TextStyle(fontSize: 10),
        contentPadding: EdgeInsets.symmetric(
            vertical: 8, horizontal: 12), // Optional: Adjust padding
      ),
        validator: fieldType == key_mobileNumber
            ? ((value) {
          if (value == "" || value == null) {
            return hintText + " " + 'isEmpty'.tr().toString();
          }
          if (!Utils().isNumberValid(value)) {
            return hintText + " " + 'isInvalid'.tr().toString();
          }
          return null;
        })
        // FormBuilderValidators.compose([
        //     FormBuilderValidators.required(
        //         errorText: hintText + " " + 'isEmpty'.tr().toString()),
        //     FormBuilderValidators.minLength(10,
        //         errorText: hintText + " " + 'isInvalid'.tr().toString()),
        //     FormBuilderValidators.maxLength(10,
        //         errorText: hintText + " " + 'isInvalid'.tr().toString()),
        //     FormBuilderValidators.numeric(),
        //   ])
            : FormBuilderValidators.compose([
          FormBuilderValidators.required(
              errorText: hintText + " " + 'isEmpty'.tr().toString()),
        ]),
      inputFormatters: fieldType == key_mobileNumber
          ? [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ]
          : [],
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

    if (index == 1) {
      dropList = preferencesService.districtList;
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
    } else if (index == 4) {
      dropList = preferencesService.finYearList;
      keyCode = key_fin_year;
      titleText = key_fin_year;
      titleTextTamil = key_fin_year;
    } else {
      print("End.....");
    }
    return FormBuilderDropdown(
      style: TextStyle(
          fontSize: 12.0, fontWeight: FontWeight.w600, color: c.grey_10),
      decoration: InputDecoration(
        labelText: inputHint,
        labelStyle: TextStyle(
            fontSize: 12.0, fontWeight: FontWeight.w400, color: c.grey_7),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: UIHelper.getInputBorder(1, borderColor: c.grey_7),
        focusedBorder: UIHelper.getInputBorder(1, borderColor: c.grey_7),
        focusedErrorBorder: UIHelper.getInputBorder(1, borderColor: Colors.red),
        errorBorder: UIHelper.getInputBorder(1, borderColor: Colors.red),
        errorStyle: TextStyle(fontSize: 10),
        contentPadding: EdgeInsets.symmetric(
            vertical: 8, horizontal: 12), // Optional: Adjust padding
      ),
      name: fieldName,
      initialValue: index == 1
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
        } else if (index == 4) {
          selectedFinYear = "";
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
                  selectedLang == "en"
                      ? item[titleText].toString()
                      : item[titleTextTamil].toString(),
                  style: TextStyle(
                      fontSize: 11.0,
                      fontWeight: FontWeight.w400,
                      color: c.grey_9),
                ),
              ))
          .toList(),
      onChanged: (value) async {
        if (index == 1) {
          selectedDistrict = value.toString();
          await model.loadUIBlock(selectedDistrict);
        } else if (index == 2) {
          selectedBlock = value.toString();
          await model.loadUIVillage(selectedDistrict, selectedBlock);
        } else if (index == 3) {
          selectedVillage = value.toString();
        } else if (index == 4) {
          selectedFinYear = value.toString();
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
          selectedTaxType > 0?selectedEntryType = index:Utils().showAlert(context, ContentType.warning, 'select_taxtype'.tr().toString());

          setState(() {});
        },
        child: ClipPath(
            clipper: LeftTriangleClipper(),
            child: Card(
                elevation: 2,
                child: Container(
                    width: Screen.width(context),
                    padding: EdgeInsets.all(7),
                    color: selectedEntryType == index
                        ? c.need_improvement
                        : c.bg,
                    child: Row(
                      children: [
                        UIHelper.horizontalSpaceSmall,
                        Icon(
                          selectedEntryType == index
                              ? Icons.radio_button_checked_rounded
                              : Icons.radio_button_off_rounded,
                          color: c.grey_9,
                          size: 17,
                        ),
                        UIHelper.horizontalSpaceSmall,
                        Expanded(
                            child: UIHelper.titleTextStyle(
                                title, c.grey_9, 12, false, false)),
                      ],
                    )))));
  }

  Widget radioButtonListWidget() {
    return Column(
      children: [
        radioButtonWidget(1, 'via_mobileNumber'.tr().toString()),
        UIHelper.verticalSpaceSmall,
        radioButtonWidget(2, 'via_e_taxNumber'.tr().toString()),
        UIHelper.verticalSpaceSmall,
        radioButtonWidget(3, 'via_assessNumber'.tr().toString()),
      ],
    );
  }

  Widget formControls(BuildContext context, StartUpViewModel model) {
    return FormBuilder(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Container(
                width: Screen.width(context),
                // padding: EdgeInsets.all(15),
                child: Column(
                  children: [
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
                              selectedTaxType == 1
                                  ? addInputFormControl(
                                      'assesment',
                                      'assesmentNumber'.tr().toString(),
                                      key_number)
                                  : selectedTaxType == 2
                                      ? addInputFormControl(
                                          'waterConnectionNumber',
                                          'waterConnectionNo'.tr().toString(),
                                          key_number)
                                      : selectedTaxType == 3
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
                                          : selectedTaxType == 4
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
                                                    UIHelper.verticalSpaceSmall,
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
                            validate();
                          },
                          child: Container(
                            decoration: UIHelper.GradientContainer(10, 10, 10,
                                10, [c.colorPrimary, c.colorPrimaryDark]),
                            padding: EdgeInsets.fromLTRB(15,8,15,8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                UIHelper.titleTextStyle(
                                    'submit'.tr().toString(),
                                    c.white,
                                    13,
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
    );
  }

  Widget taxWidgetGridData(String imgURL, dynamic data, int index, double val) {
    return GestureDetector(
        onTap: () {
          selectedTaxType = index;
          selectedTaxTypeData=taxlist[index-1];
          setState(() {});
        },
        child: Container(
          width: Screen.width(context) / val,
          margin: EdgeInsets.all(5),
          decoration:
          UIHelper.roundedBorderWithColorWithShadow(
              5, selectedTaxType==index ?c.need_improvement:c.white, selectedTaxType==index ?c.need_improvement:c.white),
          child: Row(children: [
            Container(
                width: 35,
                height: 35,
                padding: EdgeInsets.all(5),
                decoration:
                UIHelper.roundedBorderWithColor(
                    5,5,5,5, selectedTaxType==index ?c.white:c.need_improvement2),
                child: Image.asset(
                  imgURL.toString(),
                  fit: BoxFit.contain,
                  height: 15,
                  width: 15,
                )),
            UIHelper.horizontalSpaceSmall,
            Flexible(
                child: UIHelper.titleTextStyle(
                    selectedLang == "en"
                        ? data[key_taxtypedesc_en]
                        : data[key_taxtypedesc_ta], c.grey_9, 10, true, true)),
          ],),
        )

     );
  }

  Widget taxWidgetGridView() {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          taxWidgetGridData(imagePath.house, taxlist[0], 1,2.5),
          taxWidgetGridData(imagePath.water, taxlist[1], 2,2.5)
        ],
      ),
      UIHelper.verticalSpaceSmall,
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          taxWidgetGridData(imagePath.professional1, taxlist[2], 3,2.5),
          taxWidgetGridData(imagePath.nontax1, taxlist[3], 4,2.5)
        ],
      ),
      UIHelper.verticalSpaceSmall,
      taxWidgetGridData(imagePath.trade, taxlist[4], 5,2)
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: c.colorPrimary,
          centerTitle: true,
          elevation: 2,
          title: Container(
            child: Text(
              'quickPay'.tr().toString(),
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
                    color: Colors.white,
                    width: Screen.width(context),
                    padding: EdgeInsets.all(16),
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
                                UIHelper.titleTextStyle(
                                    'select_taxtype'.tr().toString(),
                                    c.grey_9,
                                    12,
                                    true,
                                    true),
                                UIHelper.verticalSpaceMedium,
                                taxWidgetGridView(),
                                UIHelper.verticalSpaceMedium,
                                UIHelper.titleTextStyle(
                                    'select_anyOne'.tr().toString(),
                                    c.grey_9,
                                    12,
                                    true,
                                    true),
                                UIHelper.verticalSpaceMedium,
                                radioButtonListWidget(),
                                UIHelper.verticalSpaceMedium,
                                UIHelper.titleTextStyle(
                                    'enter_the_details'.tr().toString(),
                                    c.grey_9,
                                    12,
                                    true,
                                    true),
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

  void validate() {
    if(selectedTaxType >0){
      if(selectedEntryType >0){
        if (_formKey.currentState!.saveAndValidate()) {
          Map<String, dynamic> postParams =
          Map.from(_formKey.currentState!.value);
          postParams
              .removeWhere((key, value) => value == null);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => TaxCollectionDetailsView(selectedTaxTypeData:
                  selectedTaxTypeData,isHome: false
                  )));

        }
      }else{
        Utils().showAlert(context,ContentType.warning,'select_all_field'.tr().toString());
      }
    }else{
      Utils().showAlert(context,ContentType.warning,'select_taxtype'.tr().toString());
    }

  }
}
