// ignore_for_file: use_build_context_synchronously, file_names, unused_field

import 'package:flutter/material.dart';
import 'package:public_vptax/Layout/screen_size.dart';
import 'package:public_vptax/Layout/ui_helper.dart';
import 'package:public_vptax/Resources/ColorsValue.dart' as c;
import 'package:responsive_grid_list/responsive_grid_list.dart';

class CustomNumberBoard extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final onCompleted;
  final int length;
  final String initialValue;
  const CustomNumberBoard({super.key, required this.initialValue, required this.length, required this.onChanged, required this.onCompleted});

  @override
  _CustomNumberBoardState createState() => _CustomNumberBoardState();
}

class _CustomNumberBoardState extends State<CustomNumberBoard> with TickerProviderStateMixin {
  List<String> numbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "E", "0", "back"];
  String pin = "";

  @override
  void initState() {
    super.initState();
    pin = widget.initialValue;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: UIHelper.roundedBorderWithColorWithShadow(10, c.grey_2, c.grey_2),
        padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
        margin: EdgeInsets.only(top: 10),
        height: 300,
        child: ResponsiveGridList(
          listViewBuilderOptions: ListViewBuilderOptions(physics: NeverScrollableScrollPhysics()),
          horizontalGridMargin: 0,
          verticalGridMargin: 0,
          minItemWidth: Screen.width(context) / 4,
          children: List.generate(numbers.length, (index) {
            String getData = numbers[index];
            return Column(
              children: [
                GestureDetector(
                    onTap: () {
                      if (getData == "back") {
                        if (pin.isNotEmpty) {
                          pin = pin.substring(0, pin.length - 1);
                        }
                        widget.onChanged!(pin);
                      } else {
                        if (pin.length <= widget.length - 1) {
                          pin = pin + getData;
                          widget.onChanged!(pin);
                        }
                        if (pin.length == widget.length) {
                          widget.onCompleted();
                        }
                      }
                    },
                    child: getData == "E"
                        ? SizedBox(
                            height: 50,
                            width: Screen.width(context) / 3,
                          )
                        : Container(
                            decoration: UIHelper.roundedBorderWithColorWithShadow(10, c.white, c.white, borderColor: c.grey_2),
                            height: 50,
                            width: Screen.width(context) / 3,
                            padding: EdgeInsets.all(5),
                            child: Center(
                                child: getData == "back"
                                    ? Image.asset(
                                        "assets/images/backspace.png",
                                        fit: BoxFit.contain,
                                        height: 20,
                                        width: 40,
                                      )
                                    : UIHelper.titleTextStyle(getData, c.black, 16, true, true)),
                          ))
              ],
            );
          }),
        ));
  }
}
