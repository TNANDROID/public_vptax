import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:public_vptax/Resources/ColorsValue.dart' as c;
import 'package:stacked/stacked.dart';
import '../../Resources/StringsKey.dart' as s;
import 'package:public_vptax/Resources/ImagePath.dart' as imagePath;
import 'package:public_vptax/Utils/utils.dart';
import 'package:public_vptax/Utils/ContentInfo.dart';

import 'package:public_vptax/Layout/screen_size.dart';
import 'package:public_vptax/Layout/ui_helper.dart';
import 'package:public_vptax/Model/startup_model.dart';

import '../../Resources/StringsKey.dart';
import '../../Services/Preferenceservices.dart';
import '../../Services/locator.dart';

class YourTaxDetails extends StatefulWidget {
  final mobile;
  const YourTaxDetails({super.key, this.mobile});

  @override
  State<YourTaxDetails> createState() => _YourTaxDetailsState();
}

class _YourTaxDetailsState extends State<YourTaxDetails> {
  PreferenceService preferencesService = locator<PreferenceService>();
  TextEditingController etTextController = TextEditingController();
  String selectedLang = "";
  String islogin = "";
  List taxTypeList = [];
  var selectedTaxTypeData;
  List mainList = [];

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    selectedLang = await preferencesService.getUserInfo("lang");
    islogin = await preferencesService.getUserInfo(s.key_isLogin);
    dynamic val={key_taxtypeid:0,key_taxtypedesc_en:"All Taxes",key_taxtypedesc_ta:"அனைத்து வரிகள்",key_img_path:imagePath.all};
    taxTypeList.add(val);
    taxTypeList .addAll(preferencesService.taxTypeList);
    selectedTaxTypeData  =taxTypeList[0];
    islogin == "yes" ?await getTaxDetails():null;
    setState(() {});
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
                  color: c.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Visibility(
                       visible: islogin != "yes" ,
                       child: Container(
                  margin: EdgeInsets.fromLTRB(20, 20, 20, 10),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.start,
                           crossAxisAlignment: CrossAxisAlignment.center,
                           children: [
                           Container(
                             child: addInputFormControl('mobile', 'mobileNumber'.tr().toString(), key_mobile_number),
                           width: MediaQuery.of(context).size.width/1.5,),
                           UIHelper.horizontalSpaceSmall,
                           InkWell(
                             onTap: () async {
                               await getTaxDetails();
                             },
                             child:Image.asset(
                             imagePath.submit,
                             height: 35,
                             width: 35,
                           ) ,),

                         ],),
                       ),
                     ),
                     UIHelper.verticalSpaceSmall,
                     Container(
                       width: MediaQuery.of(context).size.width/1.7,
                       margin: EdgeInsets.only(top: 5, bottom: 15, left: 20),
                       decoration: UIHelper.roundedBorderWithColorWithShadow(5, c.white, c.white),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.start,
                         children: [
                           Container(
                               width: 35,
                               height: 35,
                               padding: EdgeInsets.all(5),
                               decoration: UIHelper.roundedBorderWithColor(5, 5, 5, 5, c.colorPrimary),
                               child: Image.asset(
                                 selectedTaxTypeData["img_path"].toString(),
                                 fit: BoxFit.contain,
                                 height: 15,
                                 width: 15,
                               )),
                           UIHelper.horizontalSpaceSmall,
                           Container(width: MediaQuery.of(context).size.width/2.5, margin: EdgeInsets.only(left: 5), child: addInputDropdownField()),
                         ],
                       ),
                     )
                   ],
                  ));
            },
            viewModelBuilder: () => StartUpViewModel()));
  }
  Widget addInputDropdownField() {
    return FormBuilderDropdown(
      enabled: true ,
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
      iconSize:  28 ,
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
        selectedTaxTypeData = value;
        filterDataList();
        setState(() {});
      },
      name: 'TaxType',
    );
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
  Future<void> getTaxDetails() async {
    try {
      for (var sampletaxData in taxTypeList) {
        if(sampletaxData[key_taxtypeid]!=0){
          dynamic request = {
            s.key_service_id: s.service_key_DemandSelectionList,
            s.key_mode_type: 1,
            s.key_taxtypeid: taxTypeList[0],
            s.key_mobile_number: islogin == "yes" ?widget.mobile:etTextController.text.toString().trim(),
            s.key_language_name: selectedLang
          };
          await StartUpViewModel().getMainServiceList("TaxCollectionDetails", requestDataValue: request, context: context, taxType: selectedTaxTypeData[s.key_taxtypeid].toString(), lang: selectedLang);
          mainList.addAll( preferencesService.taxCollectionDetailsList);
        }
      }

      // throw ('000');
    } catch (error) {
      debugPrint('error (${error.toString()}) has been caught');
    }
  }

  void filterDataList() {}

}
