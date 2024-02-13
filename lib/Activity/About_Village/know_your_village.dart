// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:public_vptax/Layout/custom_dropdown.dart' as custom;
import 'package:public_vptax/Activity/About_Village/assets_details.dart';
import 'package:public_vptax/Activity/About_Village/habitation_details.dart';
import 'package:public_vptax/Activity/About_Village/population_view.dart';
import 'package:public_vptax/Activity/About_Village/taxWise_details.dart';
import 'package:public_vptax/Layout/customclip.dart';
import 'package:public_vptax/Layout/screen_size.dart';
import 'package:public_vptax/Layout/ui_helper.dart';
import 'package:public_vptax/Resources/ColorsValue.dart' as c;
import 'package:public_vptax/Resources/ImagePath.dart' as imagepath;
import 'package:public_vptax/Resources/StringsKey.dart';
import 'package:stacked/stacked.dart';

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
  bool isAddressShow = false;
  dynamic selectedDistrict = {};
  dynamic selectedBlock = {};
  dynamic selectedVillage = {};

  PreferenceService preferencesService = locator<PreferenceService>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: c.white,
      appBar: UIHelper.getBar('know_your_village'),
      body: ViewModelBuilder<StartUpViewModel>.reactive(
          onViewModelReady: (model) async {},
          builder: (context, model, child) {
            return Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isAddressShow
                        ? Container(padding: EdgeInsets.fromLTRB(10, 5, 10, 5), child: customCardDesign())
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                              ]),
                              UIHelper.verticalSpaceSmall,
                            ],
                          ),
                    isSelectedAll
                        ? Expanded(child: SingleChildScrollView(child: Column(children: [habitationView(), PopulationView(), AssetDetailsView(), DCBView()])))
                        : Center(
                            child: Column(
                            children: [
                              UIHelper.verticalSpaceLarge,
                              Image.asset(imagepath.waiting1, fit: BoxFit.contain, height: Screen.width(context) / 3, width: Screen.width(context) / 3),
                              UIHelper.verticalSpaceMedium,
                              UIHelper.titleTextStyle('waiting_input'.tr().toString(), c.text_color, 12, true, true)
                            ],
                          ))
                  ],
                ));
          },
          viewModelBuilder: () => StartUpViewModel()),
    );
  }

//Custom Card Design
  Widget customCardDesign() {
    String address = "";
    if (preferencesService.selectedLanguage == "en") {
      address = selectedDistrict[key_dname] + ", " + selectedBlock[key_bname] + ", " + selectedVillage[key_pvname] + ".";
    } else {
      address = selectedDistrict[key_dname_ta].toString().trimRight() + ", " + selectedBlock[key_bname_ta].toString().trimRight() + ", " + selectedVillage[key_pvname_ta].toString().trimRight() + ".";
    }
    return Stack(children: [
      Container(
        color: c.colorPrimary,
        height: 45,
        width: 35,
      ),
      Stack(children: [
        Container(
          decoration: UIHelper.roundedBorderWithColor(10, 30, 10, 30, c.white, borderColor: c.colorPrimary, borderWidth: 2),
          height: 35,
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.only(left: 5),
          width: Screen.width(context),
          child: Row(children: [
            Icon(
              Icons.location_on,
              size: 25,
              color: c.colorPrimary,
            ),
            SizedBox(width: Screen.width(context) / 1.5, child: Text(address, overflow: TextOverflow.visible, style: TextStyle(color: c.text_color, fontSize: 10, fontWeight: FontWeight.normal))),
            // UIHelper.titleTextStyle(address, c.text_color, 12, true, true),
          ]),
        ),
        Positioned(
            right: 0,
            child: Container(
                margin: EdgeInsets.only(top: 5),
                decoration: UIHelper.roundedBorderWithColor(0, 30, 0, 30, c.colorPrimary),
                height: 35,
                width: 40,
                child: GestureDetector(
                  onTap: () {
                    isAddressShow = false;
                    setState(() {});
                  },
                  child: Icon(
                    Icons.restart_alt,
                    size: 25,
                    color: c.white,
                  ),
                )))
      ]),
    ]);
  }

  //Dropdown Input Field Widget
  Widget addInputDropdownField(int index, String inputHint, String fieldName, StartUpViewModel model) {
    List dropList = [];
    String titleText = "";
    String titleTextTamil = "";
    dynamic initValue = {};

    if (index == 1) {
      dropList = preferencesService.districtList;
      dropList.sort((a, b) {
        return a[preferencesService.selectedLanguage == 'en' ? key_dname : key_dname_ta].compareTo(b[preferencesService.selectedLanguage == 'en' ? key_dname : key_dname_ta]);
      });
      titleText = key_dname;
      titleTextTamil = key_dname_ta;
      initValue = selectedDistrict;
    } else if (index == 2) {
      dropList = model.selectedBlockList;
      dropList.sort((a, b) {
        return a[preferencesService.selectedLanguage == 'en' ? key_bname : key_bname_ta].compareTo(b[preferencesService.selectedLanguage == 'en' ? key_bname : key_bname_ta]);
      });
      titleText = key_bname;
      titleTextTamil = key_bname_ta;
      initValue = selectedBlock;
    } else if (index == 3) {
      dropList = model.selectedVillageList;
      dropList.sort((a, b) {
        return a[preferencesService.selectedLanguage == 'en' ? key_pvname : key_pvname_ta].compareTo(b[preferencesService.selectedLanguage == 'en' ? key_pvname : key_pvname_ta]);
      });
      titleText = key_pvname;
      titleTextTamil = key_pvname_ta;
      initValue = selectedVillage;
    } else {
      debugPrint("End.....");
    }
    return custom.FormBuilderDropdown(
      itemHeight: 30,
      menuMaxHeight: Screen.height(context)/1.5,
      decoration: InputDecoration(
        labelText: inputHint,
        constraints: BoxConstraints(maxHeight: 35),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelStyle: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, color: c.grey_7),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: UIHelper.getInputBorder(1, borderColor: c.grey_7, radius: 5),
        focusedBorder: UIHelper.getInputBorder(1, borderColor: c.grey_7, radius: 5),
        focusedErrorBorder: UIHelper.getInputBorder(1, borderColor: Colors.red),
        errorBorder: UIHelper.getInputBorder(1, borderColor: Colors.red),
        errorStyle: const TextStyle(fontSize: 10),
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 6), // Optional: Adjust padding
      ),
      name: fieldName,
      initialValue: initValue,
      autovalidateMode: custom.AutovalidateMode.onUserInteraction,
      validator: custom.FormBuilderValidators.compose([
        custom.FormBuilderValidators.required(errorText: "$inputHint ${'isEmpty'.tr()}"),
      ]),
      items: dropList
          .map((item) => custom.DropdownMenuItem(
                value: item,
                child: Text(
                  preferencesService.selectedLanguage == "en" ? item[titleText].toString() : item[titleTextTamil].toString(),
                  style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, color: c.text_color),
                  overflow: TextOverflow.ellipsis,
                ),
              ))
          .toList(),
      onChanged: (value) async {
        try{
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
          });
        } else if (index == 2) {
          model.selectedVillageList.clear();
          selectedVillage = {};
          selectedBlock = value;
          isSelectedAll = false;
          Future.delayed(Duration(milliseconds: 500), () {
            model.loadUIVillage(selectedDistrict[key_dcode].toString(), selectedBlock[key_bcode].toString());
            setState(() {});
          });
        } else if (index == 3) {
          selectedVillage = value;
          isAddressShow = true;
          isSelectedAll = true;
        } else {
          debugPrint("End.....");
        }

        setState(() {});
      } catch (e) {
      Utils().showToast(context, "Fail","W");
    } finally {
    Utils().hideProgress(context);
    }
      },
    );
  }
}
