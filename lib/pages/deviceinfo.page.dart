import 'dart:convert';

import 'package:coeus_v1/services/bleServices.dart';
import 'package:coeus_v1/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:coeus_v1/widget/button.dart';
import 'package:coeus_v1/widget/textLogin.dart';

import 'package:fluttertoast/fluttertoast.dart';

class DeviceInfoProfilePage extends StatefulWidget {
  @override
  _DeviceInfoProfilePageState createState() => _DeviceInfoProfilePageState();
}

class _DeviceInfoProfilePageState extends State<DeviceInfoProfilePage> {
  final ScrollController _scrollController = new ScrollController();

  String firmware_version = "0.0.0.0";
  String software_version = "0.0.0.0";

  List bledata = [];
  bool isReading = false;
  @override
  void initState() {}

  buttonOK() {
    Navigator.pop(context);
  }

/*
04 nov 21 - done for demonstration of app - sreeni
*/

  displayOnScreen(String msg) {
    debugPrint(msg);
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  readDeviceInfo() {
    // amended on 16 jan with new lib and services
    var tempVal = readBLEData("100", "103");

    displayOnScreen("tempval data is " + tempVal.toString()); //);
    //21 oct 21
    firmware_version = tempVal.toString();
    displayOnScreen('firmware ver :  $firmware_version');

    tempVal = readBLEData("100", "104");

    displayOnScreen("tempval data is " + tempVal.toString()); //);
    //21 oct 21
    software_version = tempVal.toString();
    displayOnScreen('software ver :  $software_version');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        Container(
          height: MediaQuery.of(context).size.height - 50,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                SizedBox(height: 20),
                TextWrapper(textstr: "Coeus v1.0", font: 36),
                SizedBox(height: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextWrapper(textstr: "Serial No: 123-323-679", font: 22),
                    TextWrapper(
                        textstr: "Firmware Version: $firmware_version",
                        font: 22),
                    TextWrapper(
                        textstr: "Software Version: $software_version",
                        font: 22),
                    TextWrapper(
                        textstr: "Last Updated on:  10212021", font: 22),
                    TextWrapper(textstr: "MAC Address: 879-988-357", font: 22),
                  ],
                ),
                /* Button(
                  title: "Demo",
                  nextNavigation: null,
                  onTapFunction: readDeviceInfo,
                  width: MediaQuery.of(context).size.width,
                  baseColor: Constants.dull_move,
                ),
                 Button(
                  title: "Stop Reading",
                  nextNavigation: null,
                  onTapFunction: stopReading,
                  width: MediaQuery.of(context).size.width,
                  baseColor: Constants.dull_move,
                ),*/
                Button(
                  title: "OK",
                  nextNavigation: null,
                  onTapFunction: buttonOK,
                  width: MediaQuery.of(context).size.width,
                  baseColor: Constants.dull_move,
                ),
              ]),
        ),
      ]),
    );
  }
}
