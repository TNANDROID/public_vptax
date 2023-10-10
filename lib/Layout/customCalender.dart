// ignore_for_file: use_build_context_synchronously, file_names, unused_field, must_be_immutable, non_constant_identifier_names

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:public_vptax/Resources/ColorsValue.dart' as c;
import 'package:public_vptax/Services/Preferenceservices.dart';
import 'package:public_vptax/Services/locator.dart';
import 'package:public_vptax/Utils/ContentInfo.dart';
import 'package:public_vptax/Utils/utils.dart';

class CustomCalenderView extends StatefulWidget {
  final onCompleted;
  CustomCalenderView({super.key, required this.onCompleted});
  @override
  State<CustomCalenderView> createState() => _CustomCalenderViewState();
}

class _CustomCalenderViewState extends State<CustomCalenderView> {
  PreferenceService preferencesService = locator<PreferenceService>();
  Utils utils = Utils();
  DateTime? selectedFromDate;
  DateTime? selectedToDate;
  List<DateTime> selectedfromDateRange = [];
  List<DateTime> selectedtoDateRange = [];
  int calendarSelectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: MediaQuery.of(context).size.height < 700
            ? const EdgeInsets.all(10)
            : EdgeInsets.only(left: 15, right: 15, top: MediaQuery.of(context).size.height / 6, bottom: MediaQuery.of(context).size.height / 6),
        child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  calendarSelectedIndex = 0;
                                });
                              },
                              child: Container(
                                width: 150,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'from_date'.tr().toString(),
                                    style: TextStyle(
                                      color: calendarSelectedIndex == 0 ? Colors.black : Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(width: calendarSelectedIndex == 0 ? 2.0 : 1.0, color: calendarSelectedIndex == 0 ? c.primary_text_color2 : Colors.white))),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                if (selectedFromDate != null) {
                                  setState(() {
                                    calendarSelectedIndex = 1;
                                  });
                                } else {
                                  utils.showAlert(context, ContentType.warning, "select_from_date".tr().toString());
                                }
                              },
                              child: Container(
                                width: 150,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'to_date'.tr().toString(),
                                    style: TextStyle(
                                      color: calendarSelectedIndex == 1 ? Colors.black : Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(width: calendarSelectedIndex == 0 ? 2.0 : 1.0, color: calendarSelectedIndex == 1 ? c.primary_text_color2 : Colors.white))),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  calendarSelectedIndex == 0
                      ? calendarWidget(context, 0, selectedFromDate ?? DateTime.now(), setState)
                      : AnimatedContainer(
                          duration: const Duration(seconds: 1, milliseconds: 500),
                          child: Center(child: calendarWidget(context, 1, selectedFromDate ?? DateTime.now(), setState)),
                        ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              calendarSelectedIndex = 0;
                              selectedFromDate = null;
                              selectedToDate = null;
                              selectedfromDateRange.clear();
                              selectedtoDateRange.clear();
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                            ),
                            child: Padding(
                                padding: const EdgeInsets.only(top: 2, bottom: 2),
                                child: Text(
                                  "cancel".tr().toString(),
                                  style: TextStyle(
                                    color: c.colorPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () {
                              if (selectedToDate != null && selectedFromDate != null) {
                                widget.onCompleted({"fromDate": selectedFromDate, "toDate": selectedToDate});
                                calendarSelectedIndex = 0;
                                selectedfromDateRange.clear();
                                selectedtoDateRange.clear();
                                selectedFromDate = null;
                                selectedToDate = null;
                                Navigator.of(context).pop();
                              } else {
                                if (selectedFromDate == null) {
                                  utils.showAlert(context, ContentType.warning, 'select_from_date'.tr().toString());
                                } else if (selectedToDate == null) {
                                  utils.showAlert(context, ContentType.warning, 'select_to_date'.tr().toString());
                                } else {
                                  print("Something Went Wrong....");
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                            ),
                            child: Padding(
                                padding: const EdgeInsets.only(top: 2, bottom: 2),
                                child: Text(
                                  "ok".tr().toString(),
                                  style: TextStyle(
                                    color: c.colorPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ));
  }

  Widget calendarWidget(BuildContext context, int index, DateTime initialDate, setState) {
    return CalendarDatePicker2(
      config: CalendarDatePicker2Config(
        firstDate: index == 0 ? DateTime(2000) : initialDate,
        lastDate: DateTime.now(),
        currentDate: initialDate,
        selectedDayHighlightColor: c.colorAccent,
        weekdayLabels: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
        weekdayLabelTextStyle: const TextStyle(color: Color(0xFF07b3a5), fontWeight: FontWeight.bold, fontSize: 10),
        firstDayOfWeek: 1,
        controlsHeight: 50,
        controlsTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
        dayTextStyle: const TextStyle(
          fontSize: 10,
          color: Color(0xFF252b34),
          fontWeight: FontWeight.bold,
        ),
        disabledDayTextStyle: const TextStyle(color: Colors.grey, fontSize: 10),
      ),
      value: index == 0 ? selectedfromDateRange : selectedtoDateRange,
      onValueChanged: (value) async {
        if (index == 0) {
          selectedfromDateRange.clear();
          selectedfromDateRange.add(value[0]!);
          selectedFromDate = value[0];
          if (selectedFromDate != null) {
            selectedToDate = null;
            selectedtoDateRange.clear();
          }
          calendarSelectedIndex = 1;
          setState(() {});
        } else {
          selectedToDate = value[0];
          selectedtoDateRange.clear();
          selectedtoDateRange.add(value[0]!);
        }
      },
      displayedMonthDate: index == 0 ? initialDate : selectedToDate ?? DateTime.now(),
    );
  }
}
