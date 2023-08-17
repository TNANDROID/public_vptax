import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:public_vptax/Activity/About_Village/assets_details.dart';
import 'package:public_vptax/Activity/About_Village/population_view.dart';
import 'package:public_vptax/Activity/About_Village/taxWise_details.dart';
import 'package:public_vptax/Activity/About_Village/village_work_details.dart';
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
  bool isSelectedAll = false;
  String selectedLang = "";
  dynamic selectedDistrict = {};
  dynamic selectedBlock = {};
  dynamic selectedVillage = {};

  PreferenceService preferencesService = locator<PreferenceService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: c.white,
      appBar: AppBar(backgroundColor: c.colorPrimary, centerTitle: true, elevation: 2, title: UIHelper.titleTextStyle('Your Village', c.white, 15, true, false)),
      body: ViewModelBuilder<StartUpViewModel>.reactive(
          onViewModelReady: (model) async {},
          builder: (context, model, child) {
            return Column(
              children: [
                Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        UIHelper.titleTextStyle("Know Your Village", c.text_color, 16, true, false),
                        UIHelper.verticalSpaceSmall,
                        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                          Expanded(flex: 2, child: addInputDropdownField(1, 'districtName'.tr().toString(), "district", model)),
                          UIHelper.horizontalSpaceSmall,
                          Expanded(flex: 2, child: model.selectedBlockList.isNotEmpty ? addInputDropdownField(2, 'blockName'.tr().toString(), "block", model) : SizedBox()),
                        ]),
                        UIHelper.verticalSpaceSmall,
                        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                          Expanded(flex: 2, child: model.selectedVillageList.isNotEmpty ? addInputDropdownField(3, 'villageName'.tr().toString(), "village", model) : SizedBox()),
                          Expanded(flex: 2, child: SizedBox()),
                        ])
                      ],
                    )),
                isSelectedAll ? Expanded(child: SingleChildScrollView(child: Column(children: [PopulationView(), WorkDetailsView(), AssetDetailsView(), DCBView()]))) : SizedBox()
                // : Expanded(
                //     child: Container(
                //     padding: EdgeInsets.all(5),
                //     margin: EdgeInsets.all(15),
                //     width: Screen.width(context),
                //     decoration: UIHelper.roundedBorderWithColorWithbgImage(0, c.white, "", imgOpacity: 0.4),
                //   ))
              ],
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
    dynamic initValue = {};

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
      initValue = selectedVillage;
    } else {
      print("End.....");
    }
    return FormBuilderDropdown(
      style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600, color: c.text_color),
      decoration: InputDecoration(
        labelText: inputHint,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelStyle: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, color: c.grey_7),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: UIHelper.getInputBorder(1, borderColor: c.grey_7),
        focusedBorder: UIHelper.getInputBorder(1, borderColor: c.grey_7),
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
                value: item,
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
          isSelectedAll = false;
          selectedDistrict = value;
          selectedBlock = {};
          selectedVillage = {};
          Future.delayed(Duration(milliseconds: 500), () {
            model.loadUIBlock(selectedDistrict[key_dcode].toString());
            setState(() {});
            Utils().hideProgress(context);
          });
        } else if (index == 2) {
          model.selectedVillageList.clear();
          selectedVillage = {};
          selectedBlock = value;
          isSelectedAll = false;
          Future.delayed(Duration(milliseconds: 500), () {
            model.loadUIVillage(selectedDistrict[key_dcode].toString(), selectedBlock[key_bcode].toString());

            setState(() {});
            Utils().hideProgress(context);
          });
        } else if (index == 3) {
          selectedVillage = value;
          isSelectedAll = true;
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
}
