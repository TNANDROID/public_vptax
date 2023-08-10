import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:public_vptax/Layout/customgradientbutton.dart';
import 'package:public_vptax/Layout/screen_size.dart';
import 'package:public_vptax/Layout/ui_helper.dart';
import 'package:public_vptax/Resources/ImagePath.dart' as imagepath;
import 'package:public_vptax/Resources/ColorsValue.dart' as c;

class KYVDashboard extends StatefulWidget {
  const KYVDashboard({super.key});

  @override
  State<KYVDashboard> createState() => _KYVDashboardState();
}

class _KYVDashboardState extends State<KYVDashboard> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        body: SizedBox(
          width: Screen.width(context),
          height: Screen.height(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AnimatedSize(
                duration: const Duration(milliseconds: 500),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(15, 40, 15, 15),
                  decoration: UIHelper.GradientContainer(0, 0, 35, 35, [c.colorAccentlight, c.colorPrimaryDark], stop1: 0.2, stop2: 0.8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          dashKYV('Population Details', imagepath.group),
                          dashKYV('Work Details', imagepath.download_receipt),
                        ],
                      ),
                      UIHelper.verticalSpaceMedium,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          dashKYV('Asset Details', imagepath.utils),
                          dashKYV('DCB', imagepath.trade),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget dashKYV(String headerText, String imgPath) {
    return Container(
      width: 120,
      height: 90,
      decoration: UIHelper.roundedBorderWithColorWithShadow(15, c.white, c.white),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image.asset(
            imgPath,
            width: 35,
            height: 35,
            fit: BoxFit.cover,
          ),
          Text(
            headerText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
              color: c.text_color,
              fontStyle: FontStyle.normal,
              decorationStyle: TextDecorationStyle.wavy,
            ),
          ),
        ],
      ),
    );
  }
}
