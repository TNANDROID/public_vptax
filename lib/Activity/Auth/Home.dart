// import 'dart:io';

// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:form_builder_validators/form_builder_validators.dart';
// import 'package:public_tax/Layout/ui_helper.dart';
// import 'package:public_tax/Model/startup_model.dart';
// import 'package:public_tax/Resources/StringsKey.dart';
// import 'package:public_tax/Services/Preferenceservices.dart';
// import 'package:public_tax/Services/locator.dart';
// import 'package:public_tax/Utils/utils.dart';
// import 'package:stacked/stacked.dart';
// import 'package:public_tax/Resources/ColorsValue.dart' as c;
// import 'package:public_tax/Resources/ImagePath.dart' as imagePath;

// class Home extends StatefulWidget {
//   Home({Key? key}) : super(key: key);

//   @override
//   _HomeState createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
//   PreferenceService preferencesService = locator<PreferenceService>();
//   Utils utils = Utils();

//   //Variables session
//   bool houseListFlag = false;
//   List villageItems = [];
//   List habitationItems = [];
//   List streetItems = [];
//   List houseList = [];
//   String selectedDistrict = "";
//   String selectedBlock = "";
//   String selectedVillage = "";
//   String selectedHabitation = "";
//   String selectedStreet = "";
//   bool searchEnabled = false;
//   Iterable filteredHouse = [];
//   TextEditingController _searchController = TextEditingController();

//   //Dropdown Input Field Widget
//   Widget addInputField(int index, String title, String inputHint,
//       String fieldName, String errorText, StartUpViewModel model) {
//     List dropList = [];
//     String keyCode = "";
//     String titleText = "";
//     String titleTextTamil = "";

//     if (index == 0) {
//       dropList = model.districtList;
//       keyCode = "$key_dcode";
//       titleText = "$key_dname";
//       titleTextTamil = "$key_dname_ta";
//     } else if (index == 1) {
//       dropList = model.selectedBlockList;
//       keyCode = "$key_bcode";
//       titleText = "$key_bname";
//       titleTextTamil = "$key_bname_ta";
//     } else if (index == 2) {
//       dropList = villageItems.toList();
//       keyCode = "$key_pvcode";
//       titleText = "$key_pvname";
//       titleTextTamil = "$key_pvname_ta";
//     } else if (index == 3) {
//       dropList = habitationItems.toList();
//       keyCode = "$key_habitation_code";
//       titleText = "$key_habitation_name";
//       titleTextTamil = "$key_habitation_name_ta";
//     } else if (index == 4) {
//       dropList = streetItems.toList();
//       keyCode = "$key_street_code";
//       titleText = "$key_street_name";
//       titleTextTamil = "$key_street_name_ta";
//     } else {
//       print("End.....");
//     }
//     return Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Expanded(
//             flex: 1,
//             child: Container(
//               child: Text(
//                 title.tr().toString() + " : ",
//                 style: TextStyle(fontSize: 12, color: c.grey_8),
//               ),
//             ),
//           ),
//           Expanded(
//               flex: 3,
//               child: FormBuilderDropdown(
//                 decoration: InputDecoration(
//                   contentPadding: EdgeInsets.only(left: 10),
//                   hintText: inputHint.tr().toString(),
//                   hintStyle: TextStyle(fontSize: 12),
//                   //filled: true,
//                   fillColor: Colors.white,
//                   enabledBorder:
//                       UIHelper.getInputBorder(1, borderColor: c.grey_6),
//                   focusedBorder:
//                       UIHelper.getInputBorder(1, borderColor: c.grey_6),
//                   focusedErrorBorder:
//                       UIHelper.getInputBorder(1, borderColor: Colors.red),
//                   errorBorder:
//                       UIHelper.getInputBorder(1, borderColor: Colors.red),
//                 ),
//                 name: fieldName,
//                 initialValue: index == 0
//                     ? selectedDistrict
//                     : index == 1
//                         ? selectedBlock
//                         : index == 2
//                             ? selectedVillage
//                             : index == 3
//                                 ? selectedHabitation
//                                 : selectedStreet,
//                 onTap: () async {
//                   if (index == 0) {
//                     selectedDistrict = "";
//                     selectedBlock = "";
//                     selectedVillage = "";
//                     selectedHabitation = "";
//                     selectedStreet = "";
//                     model.selectedBlockList.clear();
//                   } else if (index == 1) {
//                     selectedBlock = "";
//                     selectedVillage = "";
//                     selectedHabitation = "";
//                     selectedStreet = "";
//                   } else if (index == 2) {
//                     selectedVillage = "";
//                     selectedHabitation = "";
//                     selectedStreet = "";
//                   } else if (index == 3) {
//                     selectedHabitation = "";
//                     selectedStreet = "";
//                   } else if (index == 4) {
//                     selectedStreet = "";
//                   } else {
//                     print("End of the Statement......");
//                   }
//                   setState(() {});
//                 },
//                 iconSize: 28,
//                 autovalidateMode: AutovalidateMode.onUserInteraction,
//                 validator: title != ""
//                     ? FormBuilderValidators.compose([
//                         FormBuilderValidators.required(
//                             errorText: errorText.tr().toString()),
//                       ])
//                     : null,
//                 items: dropList
//                     .map((item) => DropdownMenuItem(
//                           value: item[keyCode],
//                           child: Text(
//                             preferencesService.selectedLanguage == "en"
//                                 ? item[titleText].toString()
//                                 : item[titleTextTamil].toString(),
//                             style: const TextStyle(
//                               fontSize: 12,
//                             ),
//                           ),
//                         ))
//                     .toList(),
//                 onChanged: (value) async {
//                   if (index == 0) {
//                     selectedDistrict = value.toString();
//                     model.selectedBlockList.clear();
//                     await model.loadUIBlock(value.toString());
//                   } else if (index == 1) {
//                     selectedBlock = value.toString();
//                     //  loadUIVillage(value.toString());
//                     habitationItems.clear();
//                     streetItems.clear();
//                     houseList.clear();
//                   } else if (index == 2) {
//                     selectedVillage = value.toString();
//                     //  loadUIHabitaion(value.toString());
//                     streetItems = [];
//                     houseList = [];
//                   } else if (index == 3) {
//                     selectedHabitation = value.toString();
//                     // loadUIStreet(value.toString());
//                     houseList = [];
//                   } else if (index == 4) {
//                     selectedStreet = value.toString();
//                     //  loadWorkList(value.toString());
//                   } else {
//                     print("End of the Statement......");
//                   }
//                   setState(() {});
//                 },
//               ))
//         ]);
//   }

// //Form of control Widget
//   Widget formControls(BuildContext context, StartUpViewModel model) {
//     return FormBuilder(
//       key: _formKey,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           addInputField(0, "district", "selectDistrict", "districtName",
//               "please_enter_district", model),
//           UIHelper.verticalSpaceSmall,
//           Visibility(
//             visible: model.selectedBlockList.length > 0 ? true : false,
//             child: addInputField(1, "block", "selectBlock", "blockName",
//                 "please_enter_block", model),
//           ),
//           UIHelper.verticalSpaceSmall,
//           Visibility(
//             visible: villageItems.length > 0 ? true : false,
//             child: addInputField(2, "village", "select_village", "villageName",
//                 "please_enter_village", model),
//           ),
//           UIHelper.verticalSpaceSmall,
//           Visibility(
//             visible: habitationItems.length > 0 ? true : false,
//             child: addInputField(3, "habitation", "select_habitation",
//                 "habitationName", "please_enter_habitation", model),
//           ),
//           UIHelper.verticalSpaceSmall,
//           Visibility(
//             visible: streetItems.length > 0 ? true : false,
//             child: addInputField(4, "street", "select_street", "streetName",
//                 "please_enter_street", model),
//           ),
//           UIHelper.verticalSpaceSmall,
//         ],
//       ),
//     );
//   }

//   void handleClick(String value) {
//     switch (value) {
//       case 'Tamil':
//         preferencesService.selectedLanguage = "ta";
//         context.setLocale(Locale('ta', 'IN'));

//         break;
//       case 'English':
//         preferencesService.selectedLanguage = "en";
//         context.setLocale(Locale('en', 'US'));
//         break;
//     }
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     Future<bool> showExitPopup() async {
//       return await showDialog(
//             //show confirm dialogue
//             //the return value will be from "Yes" or "No" options
//             context: context,
//             builder: (context) => AlertDialog(
//               title: Text('exit_app'.tr().toString()),
//               content: Text('do_you_want_to_exit_an_app'.tr().toString()),
//               actions: [
//                 ElevatedButton(
//                   onPressed: () => Navigator.of(context).pop(false),
//                   //return false when click on "NO"
//                   child: Text('no'.tr().toString()),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     if (Platform.isAndroid) {
//                       SystemNavigator.pop();
//                     } else if (Platform.isIOS) {
//                       exit(0);
//                     }
//                   },
//                   //return true when click on "Yes"
//                   child: Text('yes'.tr().toString()),
//                 ),
//               ],
//             ),
//           ) ??
//           false; //if showDialouge had returned null, then return false
//     }

//     return WillPopScope(
//         onWillPop: showExitPopup,
//         child: Scaffold(
//           appBar: AppBar(
//             backgroundColor: c.colorPrimary,
//             centerTitle: true,
//             elevation: 2,
//             automaticallyImplyLeading: false,
//             title: Center(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Container(
//                     transform: Matrix4.translationValues(-15.0, 0.0, 0.0),
//                     alignment: Alignment.centerLeft,
//                     child: PopupMenuButton<String>(
//                       onSelected: handleClick,
//                       itemBuilder: (BuildContext context) {
//                         return {'Tamil', 'English'}.map((String choice) {
//                           return PopupMenuItem<String>(
//                             value: choice,
//                             child: Text(choice),
//                           );
//                         }).toList();
//                       },
//                     ),
//                   ),
//                   Expanded(
//                     child: Container(
//                       alignment: Alignment.center,
//                       child: Text(
//                         'house_list_heading'.tr().toString(),
//                         style: TextStyle(fontSize: 15),
//                       ),
//                     ),
//                   ),
//                   Container(
//                     alignment: Alignment.centerRight,
//                     child: GestureDetector(
//                         child: Image.asset(
//                           imagePath.logout,
//                           color: c.white,
//                           fit: BoxFit.contain,
//                           height: 25,
//                           width: 25,
//                         ),
//                         onTap: () async {
//                           logout();
//                         }),
//                   )
//                 ],
//               ),
//             ),
//           ),
//           body: ViewModelBuilder<StartUpViewModel>.reactive(
//               // ignore: deprecated_member_use
//               onModelReady: (model) async {
//                 model.getDistrictList();
//                 model.getBlockList();
//               },
//               builder: (context, model, child) {
//                 return model.isBusy
//                     ? Center(
//                         child: SpinKitFadingCircle(
//                         color: c.primary_text_color2,
//                         duration: const Duration(seconds: 1, milliseconds: 500),
//                         size: 50,
//                       ))
//                     : SafeArea(
//                         top: true,
//                         child: Column(
//                           children: [
//                             Stack(children: [
//                               Container(
//                                 child: Image.asset(
//                                   imagePath.house_bg,
//                                   fit: BoxFit.fitWidth,
//                                   width: MediaQuery.of(context).size.width,
//                                   height: 200,
//                                 ),
//                               ),
//                               Neumorphic(
//                                 margin: EdgeInsets.only(
//                                     top: 170, left: 30, right: 30, bottom: 20),
//                                 style: NeumorphicStyle(
//                                   depth: -5,
//                                   color: c.white,
//                                 ),
//                                 child: Container(
//                                   padding: EdgeInsets.fromLTRB(25, 5, 20, 2),
//                                   color: c.white,
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     children: [
//                                       UIHelper.verticalSpaceSmall,
//                                       formControls(context, model),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ]),
//                             Column(children: [
//                               Visibility(
//                                 visible: houseListFlag,
//                                 child: Container(
//                                     width: MediaQuery.of(context).size.width,
//                                     child: Padding(
//                                       padding: EdgeInsets.symmetric(
//                                           vertical: 5, horizontal: 5),
//                                       child: Text(
//                                         'house_list'.tr().toString(),
//                                         textAlign: TextAlign.center,
//                                         style: TextStyle(
//                                             fontSize: 16,
//                                             color: c.primary_text_color2,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     )),
//                               ),
//                               Visibility(
//                                 visible: houseListFlag,
//                                 child: Container(
//                                     alignment: Alignment.centerLeft,
//                                     margin: EdgeInsets.symmetric(
//                                         vertical: 5, horizontal: 10),
//                                     height: 35,
//                                     child: Padding(
//                                       padding: EdgeInsets.symmetric(
//                                           vertical: 0, horizontal: 5),
//                                       child: TextField(
//                                         controller: _searchController,
//                                         onChanged: (value) {
//                                           // onSearchQueryChanged(value);
//                                         },
//                                         decoration: InputDecoration(
//                                           border: InputBorder.none,
//                                           hintText: 'search'.tr().toString(),
//                                           hintStyle: TextStyle(fontSize: 13),
//                                           contentPadding: EdgeInsets.only(
//                                               top: 4,
//                                               bottom: 10,
//                                               left: 10,
//                                               right: 0),
//                                           filled: true,
//                                           fillColor: c.grey_2,
//                                           suffixIcon: Container(
//                                               decoration: BoxDecoration(
//                                                   border: Border.all(
//                                                     color: c.colorPrimary,
//                                                   ),
//                                                   color: c.colorPrimary,
//                                                   borderRadius:
//                                                       BorderRadius.only(
//                                                           topLeft: Radius
//                                                               .circular(5),
//                                                           topRight:
//                                                               Radius.circular(
//                                                                   5),
//                                                           bottomLeft:
//                                                               Radius.circular(
//                                                                   5),
//                                                           bottomRight:
//                                                               Radius.circular(
//                                                                   5))),
//                                               child: InkWell(
//                                                 onTap: () {},
//                                                 child: Icon(
//                                                   Icons.search,
//                                                   color: c.white,
//                                                   size: 22,
//                                                 ),
//                                               )),
//                                           enabledBorder: OutlineInputBorder(
//                                               borderSide: BorderSide(
//                                                   width: 0.2, color: c.grey_2),
//                                               borderRadius: BorderRadius.only(
//                                                   topLeft: Radius.circular(10),
//                                                   topRight: Radius.circular(10),
//                                                   bottomLeft:
//                                                       Radius.circular(10),
//                                                   bottomRight:
//                                                       Radius.circular(10))),
//                                         ),
//                                       ),
//                                     )),
//                               ),
//                               Visibility(
//                                 visible: houseListFlag,
//                                 child: Container(
//                                     margin: EdgeInsets.symmetric(
//                                         vertical: 0, horizontal: 10),
//                                     child: AnimationLimiter(
//                                       child: ListView.builder(
//                                         physics: NeverScrollableScrollPhysics(),
//                                         shrinkWrap: true,
//                                         itemCount: searchEnabled
//                                             ? filteredHouse.length
//                                             : houseList.length,
//                                         // itemCount: houseList == null ? 0 : houseList.length,
//                                         itemBuilder:
//                                             (BuildContext context, int index) {
//                                           final item = searchEnabled
//                                               ? filteredHouse.elementAt(index)
//                                               : houseList[index];
//                                           return AnimationConfiguration
//                                               .staggeredList(
//                                             position: index,
//                                             duration: const Duration(
//                                                 milliseconds: 800),
//                                             child: SlideAnimation(
//                                               horizontalOffset: 200.0,
//                                               child: FlipAnimation(
//                                                 child: InkWell(
//                                                   onTap: () {
//                                                     Navigator.push(
//                                                         context,
//                                                         MaterialPageRoute(
//                                                             builder: (context) =>
//                                                                 HouseDetails()));
//                                                   },
//                                                   child: Container(
//                                                     /*width: 350,
//                                                       height: 150,*/
//                                                     margin:
//                                                         EdgeInsets.symmetric(
//                                                             horizontal: 0,
//                                                             vertical: 10),
//                                                     child: Neumorphic(
//                                                       style:
//                                                           const NeumorphicStyle(
//                                                               lightSource:
//                                                                   LightSource
//                                                                       .topRight,
//                                                               depth: -5,
//                                                               color:
//                                                                   Colors.white),
//                                                       child: Row(
//                                                         children: [
//                                                           Container(
//                                                               width: 150,
//                                                               height: 150,
//                                                               decoration: BoxDecoration(
//                                                                   color: c
//                                                                       .colorAccent4,
//                                                                   borderRadius: BorderRadius.only(
//                                                                       topLeft:
//                                                                           Radius.circular(
//                                                                               0),
//                                                                       topRight:
//                                                                           Radius.circular(
//                                                                               155),
//                                                                       bottomRight:
//                                                                           Radius.circular(
//                                                                               15),
//                                                                       bottomLeft:
//                                                                           Radius.circular(
//                                                                               0))),
//                                                               child: Padding(
//                                                                 padding: EdgeInsets
//                                                                     .only(
//                                                                         right:
//                                                                             10),
//                                                                 child: Column(
//                                                                   mainAxisAlignment:
//                                                                       MainAxisAlignment
//                                                                           .center,
//                                                                   children: [
//                                                                     Image.asset(
//                                                                       imagePath
//                                                                           .house_1,
//                                                                       width: 30,
//                                                                       height:
//                                                                           30,
//                                                                       fit: BoxFit
//                                                                           .cover,
//                                                                     ),
//                                                                     Padding(
//                                                                         padding:
//                                                                             EdgeInsets.all(
//                                                                                 7),
//                                                                         child:
//                                                                             Column(
//                                                                           crossAxisAlignment:
//                                                                               CrossAxisAlignment.center,
//                                                                           children: [
//                                                                             Text(
//                                                                               'door_number'.tr().toString(),
//                                                                               style: TextStyle(
//                                                                                 fontSize: 11,
//                                                                                 fontWeight: FontWeight.normal,
//                                                                                 color: Colors.white,
//                                                                               ),
//                                                                             ),
//                                                                             Text(
//                                                                               "${item[key_door_number].toString()}",
//                                                                               style: TextStyle(
//                                                                                 fontSize: 15,
//                                                                                 fontWeight: FontWeight.bold,
//                                                                                 color: Colors.white,
//                                                                               ),
//                                                                             ),
//                                                                           ],
//                                                                         ))
//                                                                   ],
//                                                                 ),
//                                                               )),
//                                                           Container(
//                                                             child: Padding(
//                                                               padding: EdgeInsets
//                                                                   .only(
//                                                                       top: 20),
//                                                               child: Column(
//                                                                 crossAxisAlignment:
//                                                                     CrossAxisAlignment
//                                                                         .start,
//                                                                 children: [
//                                                                   Container(
//                                                                       child:
//                                                                           Padding(
//                                                                     padding: EdgeInsets.only(
//                                                                         top: 10,
//                                                                         left:
//                                                                             10,
//                                                                         right:
//                                                                             10,
//                                                                         bottom:
//                                                                             10),
//                                                                     child:
//                                                                         Column(
//                                                                       crossAxisAlignment:
//                                                                           CrossAxisAlignment
//                                                                               .start,
//                                                                       children: [
//                                                                         Text(
//                                                                           'owner_name'
//                                                                               .tr()
//                                                                               .toString(),
//                                                                           style:
//                                                                               TextStyle(
//                                                                             fontSize:
//                                                                                 12,
//                                                                             fontWeight:
//                                                                                 FontWeight.normal,
//                                                                             color:
//                                                                                 c.grey_9,
//                                                                           ),
//                                                                         ),
//                                                                         SizedBox(
//                                                                             height:
//                                                                                 5),
//                                                                         Text(
//                                                                           preferencesService.selectedLanguage == "en"
//                                                                               ? utils.splitStringByLength("${item[key_owner_name]}", 10)
//                                                                               : utils.splitStringByLength("${item[key_owner_name_ta]}", 10),
//                                                                           style:
//                                                                               TextStyle(
//                                                                             fontSize:
//                                                                                 13,
//                                                                             fontWeight:
//                                                                                 FontWeight.bold,
//                                                                             color:
//                                                                                 c.grey_10,
//                                                                           ),
//                                                                         ),
//                                                                       ],
//                                                                     ),
//                                                                   )),
//                                                                   Container(
//                                                                     child:
//                                                                         Padding(
//                                                                       padding: EdgeInsets.only(
//                                                                           top:
//                                                                               10,
//                                                                           left:
//                                                                               10,
//                                                                           right:
//                                                                               10,
//                                                                           bottom:
//                                                                               10),
//                                                                       child:
//                                                                           Column(
//                                                                         crossAxisAlignment:
//                                                                             CrossAxisAlignment.start,
//                                                                         children: [
//                                                                           Text(
//                                                                             'father_husband_name'.tr().toString(),
//                                                                             style:
//                                                                                 TextStyle(
//                                                                               fontSize: 12,
//                                                                               fontWeight: FontWeight.normal,
//                                                                               color: Colors.black,
//                                                                             ),
//                                                                           ),
//                                                                           SizedBox(
//                                                                               height: 5),
//                                                                           Text(
//                                                                             preferencesService.selectedLanguage == "en"
//                                                                                 ? utils.splitStringByLength("${item[key_father_husband_name]}", 16)
//                                                                                 : utils.splitStringByLength("${item[key_father_husband_name_ta]}", 16),
//                                                                             style:
//                                                                                 TextStyle(
//                                                                               fontSize: 13,
//                                                                               fontWeight: FontWeight.bold,
//                                                                               color: c.grey_10,
//                                                                             ),
//                                                                           ),
//                                                                         ],
//                                                                       ),
//                                                                     ),
//                                                                   ),
//                                                                 ],
//                                                               ),
//                                                             ),
//                                                           )
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           );
//                                         },
//                                       ),
//                                     )),
//                               )
//                             ])
//                           ],
//                         ));
//               },
//               viewModelBuilder: () => StartUpViewModel()),
//         ));
//   }

//   void logout() async {
//     await preferencesService.cleanAllPreferences();

//     customAlertWithOkCancel(context, "W", 'logout'.tr().toString());
//   }

//   Future<void> customAlertWithOkCancel(
//       BuildContext context, String type, String msg) async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false, // user must tap button!
//       builder: (BuildContext context) {
//         return WillPopScope(
//           onWillPop: () async => false,
//           child: Center(
//             child: Container(
//               decoration: BoxDecoration(
//                   color: c.white,
//                   borderRadius: BorderRadius.circular(15),
//                   boxShadow: const [
//                     BoxShadow(
//                       color: Colors.grey,
//                       offset: Offset(0.0, 1.0), //(x,y)
//                       blurRadius: 5.0,
//                     ),
//                   ]),
//               width: 300,
//               height: 300,
//               child: Column(
//                 children: [
//                   Container(
//                     height: 100,
//                     decoration: BoxDecoration(
//                         color: type == "W"
//                             ? c.yellow_new
//                             : type == "S"
//                                 ? c.green_new
//                                 : c.red_new,
//                         borderRadius: const BorderRadius.only(
//                             topLeft: Radius.circular(15),
//                             topRight: Radius.circular(15))),
//                     child: Center(
//                       child: Image.asset(
//                         type == "W"
//                             ? imagePath.warning
//                             : type == "S"
//                                 ? imagePath.success
//                                 : imagePath.error,
//                         height: type == "W" ? 60 : 100,
//                         width: type == "W" ? 60 : 100,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                   Container(
//                     decoration: BoxDecoration(
//                         color: c.white,
//                         borderRadius: const BorderRadius.only(
//                             bottomLeft: Radius.circular(15),
//                             bottomRight: Radius.circular(15))),
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Column(
//                         children: [
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           Text(
//                             msg,
//                             style: TextStyle(
//                                 decoration: TextDecoration.none,
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: 15,
//                                 color: c.black),
//                             textAlign: TextAlign.center,
//                           ),
//                           const SizedBox(
//                             height: 35,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Visibility(
//                                 visible:
//                                     type == "S" || type == "E" ? true : false,
//                                 child: ElevatedButton(
//                                   style: ButtonStyle(
//                                       backgroundColor:
//                                           MaterialStateProperty.all<Color>(
//                                               c.primary_text_color2),
//                                       shape: MaterialStateProperty.all<
//                                               RoundedRectangleBorder>(
//                                           RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(15),
//                                       ))),
//                                   onPressed: () {
//                                     Navigator.pop(context, true);
//                                   },
//                                   child: Text(
//                                     'ok'.tr().toString(),
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.w800,
//                                         fontSize: 15,
//                                         color: c.white),
//                                   ),
//                                 ),
//                               ),
//                               Visibility(
//                                 visible: type == "W" ? true : false,
//                                 child: SizedBox(
//                                   width: 90,
//                                   child: ElevatedButton(
//                                     style: ButtonStyle(
//                                         backgroundColor:
//                                             MaterialStateProperty.all<Color>(
//                                                 c.green_new),
//                                         shape: MaterialStateProperty.all<
//                                                 RoundedRectangleBorder>(
//                                             RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(15),
//                                         ))),
//                                     onPressed: () {
//                                       Navigator.pop(context, true);
//                                       Navigator.pushReplacement(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (context) => Login()));
//                                     },
//                                     child: Text(
//                                       'ok'.tr().toString(),
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.w600,
//                                           fontSize: 12,
//                                           color: c.white),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Visibility(
//                                   visible: type == "W" ? true : false,
//                                   child: const SizedBox(
//                                     width: 50,
//                                   )),
//                               Visibility(
//                                 visible: type == "W" ? true : false,
//                                 child: SizedBox(
//                                   width: 95,
//                                   child: ElevatedButton(
//                                     style: ButtonStyle(
//                                         backgroundColor:
//                                             MaterialStateProperty.all<Color>(
//                                                 c.red_new),
//                                         shape: MaterialStateProperty.all<
//                                                 RoundedRectangleBorder>(
//                                             RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(15),
//                                         ))),
//                                     onPressed: () {
//                                       Navigator.pop(context, false);
//                                     },
//                                     child: Text(
//                                       'cancel'.tr().toString(),
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.w500,
//                                           fontSize: 12,
//                                           color: c.white),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
