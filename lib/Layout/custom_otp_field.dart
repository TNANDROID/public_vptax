// ignore_for_file: use_build_context_synchronously, file_names, unused_field

import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:public_vptax/Layout/screen_size.dart';
import 'package:public_vptax/Utils/utils.dart';

class CustomOTP extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final int length;

  const CustomOTP({super.key, this.onChanged, required this.length});

  @override
  _CustomOTPState createState() => _CustomOTPState();
}

class _CustomOTPState extends State<CustomOTP> with TickerProviderStateMixin {
  Utils utils = Utils();

  @override
  Widget build(BuildContext context) {
    return OTPTextField(
      onChanged: (pin) {
        if (pin.length == widget.length) {
          widget.onChanged!(pin);
        } else {
          widget.onChanged!("");
        }
        setState(() {});
      },
      onCompleted: (pin) {
        utils.closeKeypad(context);
      },
      width: Screen.width(context) - 100,
      length: widget.length,
      fieldStyle: FieldStyle.box,
      fieldWidth: 40,
    );
  }
}
