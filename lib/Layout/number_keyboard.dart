// ignore_for_file: use_build_context_synchronously, file_names, unused_field, prefer_typing_uninitialized_variables

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
  State<CustomNumberBoard> createState() => _CustomNumberBoardState();
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
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        // margin: const EdgeInsets.only(top: 15),
        height: 270,
        child: ResponsiveGridList(
          listViewBuilderOptions: ListViewBuilderOptions(physics: const NeverScrollableScrollPhysics()),
          // horizontalGridMargin: 5,
          // verticalGridMargin: 5,
          minItemWidth: Screen.width(context) / 4,
          children: List.generate(numbers.length, (index) {
            String getData = numbers[index];
            return Column(
              children: [
                getData == "E"
                    ? SizedBox(
                        height: 40,
                        width: Screen.width(context) / 3,
                      )
                    : ElevatedButton(
                        onPressed: () {
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
                        style: ElevatedButton.styleFrom(
                          foregroundColor: c.blue_new_very_very_light,
                          backgroundColor: c.white, // Text color
                          elevation: 4, // Shadow elevation
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // Rounded corners
                            side: BorderSide(color: c.grey_2), // Border color
                          ),
                        ),
                        child: Container(
                          height: 40,
                          width: Screen.width(context) / 3,
                          padding: const EdgeInsets.all(5),
                          child: Center(
                            child: getData == "back"
                                ? Image.asset(
                                    "assets/images/backspace.png",
                                    fit: BoxFit.contain,
                                    height: 20,
                                    width: 40,
                                  )
                                : UIHelper.titleTextStyle(getData, c.black, 16, true, true),
                          ),
                        ),
                      )
              ],
            );
          }),
        ));
  }
}
