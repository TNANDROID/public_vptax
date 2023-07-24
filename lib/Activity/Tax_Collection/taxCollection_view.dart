import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
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

  Widget addInputFormControl(
      String nameField, String hintText, String errorTxt) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UIHelper.titleTextStyle("$hintText", c.grey_10, 15, true, false),
        FormBuilderTextField(
          //  style: loginInputTitleStyle,
          name: nameField,
          autocorrect: false,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: (value) {},
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 10),
            //hintText: hintText,
            //   hintStyle: loginInputHintTitleStyle,
            filled: true,
            fillColor: Colors.white,
            enabledBorder: UIHelper.getInputBorder(1, borderColor: c.grey_7),
            focusedBorder: UIHelper.getInputBorder(1, borderColor: c.grey_7),
            focusedErrorBorder:
                UIHelper.getInputBorder(1, borderColor: Colors.red),
            errorBorder: UIHelper.getInputBorder(1, borderColor: Colors.red),
          ),
          validator: hintText == 'Email Id'
              ? FormBuilderValidators.compose([
                  FormBuilderValidators.required(errorText: errorTxt),
                  FormBuilderValidators.email(),
                ])
              : hintText == 'Mobile No'
                  ? FormBuilderValidators.compose([
                      FormBuilderValidators.required(errorText: errorTxt),
                      FormBuilderValidators.minLength(10),
                      FormBuilderValidators.maxLength(10),
                      FormBuilderValidators.numeric(),
                    ])
                  : FormBuilderValidators.compose([
                      FormBuilderValidators.required(errorText: errorTxt),
                    ]),
          keyboardType: hintText == 'Mobile No' || hintText == "Assesment No"
              ? TextInputType.number
              : TextInputType.text,
        )
      ],
    );
  }

  //Dropdown Input Field Widget
  Widget addInputDropdownField(int index, String inputHint, String fieldName,
      String errorText, StartUpViewModel model) {
    List dropList = [];

    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UIHelper.titleTextStyle("$inputHint", c.grey_10, 15, true, false),
          FormBuilderDropdown(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 10),
              // hintText: inputHint,
              // hintStyle: TextStyle(fontSize: 12),
              filled: true,
              fillColor: Colors.white,
              enabledBorder: UIHelper.getInputBorder(1, borderColor: c.grey_6),
              focusedBorder: UIHelper.getInputBorder(1, borderColor: c.grey_6),
              focusedErrorBorder:
                  UIHelper.getInputBorder(1, borderColor: Colors.red),
              errorBorder: UIHelper.getInputBorder(1, borderColor: Colors.red),
            ),
            name: fieldName,
            // initialValue: index == 0
            //     ? selectedDistrict
            //     : index == 1
            //         ? selectedBlock
            //         : index == 2
            //             ? selectedVillage
            //             : index == 3
            //                 ? selectedHabitation
            //                 : selectedStreet,
            onTap: () async {
              // if (index == 0) {
              //   selectedDistrict = "";
              //   selectedBlock = "";
              //   selectedVillage = "";
              //   selectedHabitation = "";
              //   selectedStreet = "";
              //   model.selectedBlockList.clear();
              // } else if (index == 1) {
              //   selectedBlock = "";
              //   selectedVillage = "";
              //   selectedHabitation = "";
              //   selectedStreet = "";
              // } else if (index == 2) {
              //   selectedVillage = "";
              //   selectedHabitation = "";
              //   selectedStreet = "";
              // } else if (index == 3) {
              //   selectedHabitation = "";
              //   selectedStreet = "";
              // } else if (index == 4) {
              //   selectedStreet = "";
              // } else {
              //   print("End of the Statement......");
              // }
              // setState(() {});
            },
            iconSize: 28,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(errorText: errorText),
            ]),
            items: dropList
                .map((item) => DropdownMenuItem(
                      value: item["keyCode"],
                      child: Text(
                        preferencesService.selectedLanguage == "en"
                            ? item["titleText"].toString()
                            : item["titleText"].toString(),
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ))
                .toList(),
            onChanged: (value) async {
              // if (index == 0) {
              //   selectedDistrict = value.toString();
              //   model.selectedBlockList.clear();
              //   await model.loadUIBlock(value.toString());
              // } else if (index == 1) {
              //   selectedBlock = value.toString();
              //   //  loadUIVillage(value.toString());
              //   habitationItems.clear();
              //   streetItems.clear();
              //   houseList.clear();
              // } else if (index == 2) {
              //   selectedVillage = value.toString();
              //   //  loadUIHabitaion(value.toString());
              //   streetItems = [];
              //   houseList = [];
              // } else if (index == 3) {
              //   selectedHabitation = value.toString();
              //   // loadUIStreet(value.toString());
              //   houseList = [];
              // } else if (index == 4) {
              //   selectedStreet = value.toString();
              //   //  loadWorkList(value.toString());
              // } else {
              //   print("End of the Statement......");
              // }
              // setState(() {});
            },
          )
        ]);
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
                        addInputFormControl('name', 'Name', "Required"),
                        UIHelper.verticalSpaceSmall,
                        addInputFormControl('mobile', 'Mobile No', "Required"),
                        UIHelper.verticalSpaceSmall,
                        addInputFormControl('email', 'Email Id', "Required"),
                        UIHelper.verticalSpaceSmall,
                        addInputDropdownField(
                            0, "District Name", "district", "Required", model),
                        UIHelper.verticalSpaceSmall,
                        addInputDropdownField(
                            1, "District Name", "district", "Required", model),
                        UIHelper.verticalSpaceSmall,
                        addInputDropdownField(
                            2, "District Name", "district", "Required", model),
                        UIHelper.verticalSpaceSmall,
                        addInputDropdownField(
                            3, "District Name", "district", "Required", model),
                        UIHelper.verticalSpaceSmall,
                        addInputFormControl(
                            'assesment', 'Assesment No', "Required"),
                        UIHelper.verticalSpaceSmall,
                        Container(
                            width: Screen.width(context) / 2,
                            alignment: Alignment.center,
                            child: SizedBox(
                                width: 100,
                                height: 40,
                                child: GestureDetector(
                                  onTap: () async {
                                    if (_formKey.currentState!
                                        .saveAndValidate()) {
                                      Map<String, dynamic> postParams =
                                          Map.from(
                                              _formKey.currentState!.value);

                                      //  Navigator.pushReplacement(
                                      //       context,
                                      //       MaterialPageRoute(
                                      //           builder: (_) =>
                                      //               Landing()));
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        UIHelper.titleTextStyle(
                                            "Submit", c.white, 15, true, false),
                                      ],
                                    ),
                                  ),
                                )))
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
          builder: (context, model, child) {
            return model.isBusy
                ? CircularProgressIndicator()
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
                                    20, c.grey_3),
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
