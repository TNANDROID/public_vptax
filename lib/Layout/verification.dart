// ignore_for_file: use_build_context_synchronously, file_names, unused_field

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:public_vptax/Layout/screen_size.dart';
import 'package:public_vptax/Layout/ui_helper.dart';
import 'package:public_vptax/Resources/ColorsValue.dart' as c;
import 'package:public_vptax/Utils/utils.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

class VerificationView extends StatefulWidget {
  final int fixedlength;
  final String pinString;
  final bool secureText;
  const VerificationView({super.key, required this.fixedlength, required this.pinString, required this.secureText});

  @override
  _VerificationViewState createState() => _VerificationViewState();
}

class _VerificationViewState extends State<VerificationView> with TickerProviderStateMixin {
  Utils utils = Utils();
  List pinToList = [];

  getOTPString(int index) {
    if (widget.pinString.isNotEmpty) {
      pinToList = widget.pinString.split('');
    } else {
      pinToList = [];
    }
    var intValue = widget.fixedlength - pinToList.length;
    for (var i = 1; i <= intValue; i++) {
      pinToList.add("E");
    }
    return pinToList[index];
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(widget.fixedlength, (index) {
          String otp = getOTPString(index);
          return Column(
            children: [
              widget.secureText
                  ? Container(
                      padding: EdgeInsets.all(5),
                      decoration: UIHelper.BottomBorderContainer(widget.pinString.length > index ? c.colorPrimary : c.grey_8),
                      child: Icon(
                        Icons.fiber_manual_record,
                        size: 25,
                        color: widget.pinString.length > index ? c.colorPrimary : c.grey_8,
                      ),
                    )
                  : Container(
                      padding: EdgeInsets.all(10),
                      width: 35,
                      decoration: UIHelper.roundedBorderWithColor(10, 10, 10, 10, c.white, borderColor: c.grey_6, borderWidth: 2),
                      child: UIHelper.titleTextStyle(otp == "E" ? "" : otp, c.colorPrimaryDark, 14, true, true),
                    )
            ],
          );
        }));
  }
}
