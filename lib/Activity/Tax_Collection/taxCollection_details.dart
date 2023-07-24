import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:public_vptax/Layout/customclip.dart';
import 'package:public_vptax/Layout/screen_size.dart';
import 'package:public_vptax/Layout/ui_helper.dart';
import 'package:public_vptax/Model/startup_model.dart';
import 'package:public_vptax/Services/Preferenceservices.dart';
import 'package:public_vptax/Services/locator.dart';
import 'package:public_vptax/Resources/ColorsValue.dart' as c;
import 'package:stacked/stacked.dart';
import 'package:public_vptax/Resources/ImagePath.dart' as imagePath;

class TaxCollectionDetailsView extends StatefulWidget {
  TaxCollectionDetailsView({Key? key}) : super(key: key);

  @override
  _TaxCollectionDetailsViewState createState() =>
      _TaxCollectionDetailsViewState();
}

class _TaxCollectionDetailsViewState extends State<TaxCollectionDetailsView> {
  PreferenceService preferencesService = locator<PreferenceService>();

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
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        UIHelper.verticalSpaceMedium,
                        Expanded(
                            child: SingleChildScrollView(
                          child: Container(
                            decoration:
                                UIHelper.roundedBorderWithColorWithShadow(
                                    20, Colors.blueGrey),
                            padding: EdgeInsets.all(16),
                            child: Column(
                              children: [UIHelper.unEvenContainer(15)],
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
