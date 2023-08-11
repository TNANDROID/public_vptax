import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:public_vptax/Layout/customgradientbutton.dart';
import 'package:public_vptax/Layout/screen_size.dart';
import 'package:public_vptax/Layout/ui_helper.dart';
import 'package:public_vptax/Resources/ImagePath.dart' as imagepath;
import 'package:public_vptax/Resources/ColorsValue.dart' as c;
import 'package:stacked/stacked.dart';
import 'package:public_vptax/Resources/StringsKey.dart';
import '../../Model/startup_model.dart';
import '../../Services/Preferenceservices.dart';
import '../../Services/locator.dart';
import '../../Utils/utils.dart';

class KYVDashboard extends StatefulWidget {
  const KYVDashboard({super.key});

  @override
  State<KYVDashboard> createState() => _KYVDashboardState();
}

class _KYVDashboardState extends State<KYVDashboard> {
  int selectedIndex = 0;

  //String
  String selectedLang = "";
  String selectedDistrict = "";
  String selectedBlock = "";
  String selectedVillage = "";

  PreferenceService preferencesService = locator<PreferenceService>();

  Future<void> onBackpress() async {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ViewModelBuilder<StartUpViewModel>.reactive(
          onViewModelReady: (model) async {},
          builder: (context, model, child) {
            return Container(
              width: Screen.width(context),
              height: Screen.height(context),
              color: c.inputGrey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(15, 30, 15, 15),
                    decoration: UIHelper.GradientContainer(0, 0, 35, 35, [c.colorAccentlight, c.colorPrimaryDark], stop1: 0.2, stop2: 0.8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: InkWell(
                            onTap: () {
                              onBackpress();
                            },
                            child: Icon(
                              Icons.arrow_circle_left_outlined,
                              size: 30,
                              color: c.white,
                            ),
                          ),
                        ),
                        UIHelper.verticalSpaceMedium,
                        addInputDropdownField(1, 'districtName'.tr().toString(), "district", model),
                        UIHelper.verticalSpaceMedium,
                        if (model.selectedBlockList.isNotEmpty) addInputDropdownField(2, 'blockName'.tr().toString(), "block", model),
                        if (model.selectedBlockList.isNotEmpty) UIHelper.verticalSpaceMedium,
                        if (model.selectedVillageList.isNotEmpty) addInputDropdownField(3, 'villageName'.tr().toString(), "village", model),
                        UIHelper.verticalSpaceMedium,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            dashKYV(0, 'Population Details', imagepath.group),
                            dashKYV(1, 'Work Details', imagepath.download_receipt),
                          ],
                        ),
                        UIHelper.verticalSpaceMedium,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            dashKYV(2, 'Asset Details', imagepath.utils),
                            dashKYV(3, 'DCB', imagepath.trade),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
          viewModelBuilder: () => StartUpViewModel()),
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
    } else {
      print("End.....");
    }
    return FormBuilderDropdown(
      style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600, color: c.text_color),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        enabledBorder: UIHelper.getInputBorder(1, borderColor: c.white),
        focusedBorder: UIHelper.getInputBorder(1, borderColor: c.white),
        focusedErrorBorder: UIHelper.getInputBorder(1, borderColor: Colors.red),
        errorBorder: UIHelper.getInputBorder(1, borderColor: Colors.red),
        errorStyle: const TextStyle(fontSize: 10),
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12), // Optional: Adjust padding
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
                  style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, color: c.text_color),
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
        } else {
          print("End of the Statement......");
        }

        setState(() {});
      },
    );
  }

  Widget dashKYV(int index, String headerText, String imgPath) {
    return InkWell(
      onTap: () {
        selectedIndex = index;
        setState(() {});
      },
      child: Card(
        elevation: selectedIndex == index ? 15 : 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Set the desired radius
        ),
        child: Container(
          width: 120,
          height: 90,
          decoration: selectedIndex == index ? UIHelper.roundedBorderWithColorWithShadow(15, c.colorAccent2, c.colorAccent2) : UIHelper.roundedBorderWithColorWithShadow(15, c.white, c.white),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ColorFiltered(
                colorFilter: selectedIndex == index ? const ColorFilter.mode(Colors.transparent, BlendMode.color) : ColorFilter.mode(c.inputGrey, BlendMode.saturation),
                child: Image.asset(
                  imgPath,
                  width: 35,
                  height: 35,
                  fit: BoxFit.cover,
                ),
              ),
              Text(
                headerText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold,
                  color: selectedIndex == index ? c.text_color : c.grey_8,
                  fontStyle: FontStyle.normal,
                  decorationStyle: TextDecorationStyle.wavy,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
