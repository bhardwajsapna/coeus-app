import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:coeus_v1/services/fileOpsNDFU.dart';
import 'package:coeus_v1/utils/Data_utils.dart';
import 'package:coeus_v1/utils/const.dart';
import 'package:coeus_v1/widget/inputEmail.dart';
import 'package:coeus_v1/widget/scroller.dart';
import 'package:flutter/material.dart';
import 'package:coeus_v1/widget/button.dart';
import 'package:coeus_v1/widget/textLogin.dart';

import 'package:coeus_v1/services/bleServices.dart';

final key = new GlobalKey<CustomPickerPageState>();

class SchedulingProfilePage extends StatefulWidget {
  @override
  _SchedulingProfilePageState createState() => _SchedulingProfilePageState();
}

class _SchedulingProfilePageState extends State<SchedulingProfilePage> {
  final ScrollController _scrollController = new ScrollController();
  final controllerCharacteristicRead = TextEditingController();
  final controllerServiceRead = TextEditingController();
  final controllerCharacteristicWrite = TextEditingController();
  late CustomPickerPage custom_picker;
  final elements = [1, 2, 3, 4, 5, 6];
  int selected_index = 3;

  bool downloading = true;
  String downloadingStr = "No data";

  String sensorData = "";
  var lstSensorData = [];
  @override
  Widget build(BuildContext context) {
    var currentState = key.currentState;
    List<String> elements_str = elements.map((e) => e.toString()).toList();
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height - 50,
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //       begin: Alignment.topRight,
        //       end: Alignment.bottomLeft,
        //       colors: [Constants.white, Constants.lightBlue]),
        // ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
              ),
              InputField(
                title: "baseservice 100/200",
                font: 22,
                isPassword: false,
                controller: controllerServiceRead,
                onChanged: (val) {
                  print("value changed:" + val);
                },
                validator: (String? value) {},
              ),
              InputField(
                title: "char",
                font: 22,
                isPassword: false,
                controller: controllerCharacteristicRead,
                onChanged: (val) {
                  print("value changed:" + val);
                },
                validator: (String? value) {},
              ),
              Button(
                title: "Try Read",
                onTapFunction: () {
                  readBLEData(controllerServiceRead.text,
                          controllerCharacteristicRead.text)
                      .then((value) => {
                            setState(() {
                              sensorData = value.toString();
                            })
                          });
                },
                width: MediaQuery.of(context).size.width,
                baseColor: Constants.lightgreendull,
              ),
              /* Button(
                title: "Try Notify",
                onTapFunction: () =>
                    {listenBLEData(controllerCharacteristicRead.text)},
                width: MediaQuery.of(context).size.width,
                baseColor: Constants.lightgreendull,
              ),*/
              TextWrapper(
                textstr: "Data Read:{$sensorData}",
                font: 18,
              ),
              InputField(
                title: "write something",
                font: 22,
                isPassword: false,
                controller: controllerCharacteristicWrite,
                onChanged: (val) {
                  print("value changed:" + val);
                },
                validator: (String? value) {},
              ),
              Button(
                title: "Try Write",
                onTapFunction: () =>
                    //{}
                    {
                  writeBLE_String_Data_service_100(
                      controllerCharacteristicWrite.text,
                      controllerCharacteristicRead.text)
                },
                width: MediaQuery.of(context).size.width,
                baseColor: Constants.lightgreendull,
              ),
              Button(
                title: "Write Date",
                onTapFunction: () {
                  DateTime now = DateTime.now();
                  print(now);

                  print((now.timeZoneOffset.inMilliseconds));
                  String time_now = (((now.millisecondsSinceEpoch +
                              now.timeZoneOffset.inMilliseconds) /
                          1000))
                      .toStringAsFixed(0);
                  print("time_now:" + time_now);
                  writeBLE_String_Data_service_100(time_now, '112');
                },
                width: MediaQuery.of(context).size.width,
                baseColor: Constants.lightgreendull,
              ),
              Button(
                title: "Initiate Sensor Read",
                onTapFunction: () => {initiateBLEData('110')},
                width: MediaQuery.of(context).size.width,
                baseColor: Constants.lightgreendull,
              ),
              Button(
                title: "Read Packet",
                onTapFunction: () => {lstSensorData = readSensorsData('201')},
                width: MediaQuery.of(context).size.width,
                baseColor: Constants.lightgreendull,
              ),
              Button(
                title: "Terminate Sensor Read",
                onTapFunction: () => {deactivateBLEData('110')},
                width: MediaQuery.of(context).size.width,
                baseColor: Constants.lightgreendull,
              ),
              Button(
                title: " 8 byte to int",
                onTapFunction: () {
                  List<int> tempdata1 = [
                    175,
                    60,
                    158,
                    98,
                    0,
                    0,
                    0,
                    0,
                    0,
                    11,
                    0
                  ];

                  int temp64 = Data_utils.byte8toInt(
                      tempdata1.sublist(0, 8).reversed.toList());
                  DateTime asperread =
                      new DateTime.fromMillisecondsSinceEpoch(temp64 * 1000);
                  print("temp 64 =" +
                      temp64.toString() +
                      "  " +
                      asperread.toString());
                },
                width: MediaQuery.of(context).size.width,
                baseColor: Constants.lightgreendull,
              ),
              Button(
                title: "Download latest Firmware",
                onTapFunction: () async {
                  await downloadFile().then((savePath) {
                    setState(() {
                      if (savePath.toString().length > 1) {
                        downloading = false;
                        downloadingStr = "Completed";
                        debugPrint("saved path =" + savePath);
                        debugPrint("download " + downloadingStr);
                        File binFile = new File(savePath);
                        final bytes = binFile.readAsBytesSync().lengthInBytes;
                        debugPrint("size of file is = " + bytes.toString());
                      } else {
                        debugPrint(
                            "File is not downloaded and / or incomplete");
                      }
                    });
                  });
                },
                width: MediaQuery.of(context).size.width,
                baseColor: Constants.lightgreendull,
              ),
              Button(
                title: "Upload to Device",
                onTapFunction: () async {
                  await doDfu("1"); //result.device.id.id);
                },
                width: MediaQuery.of(context).size.width,
                baseColor: Constants.lightgreendull,
              )
            ],
          ),
        ),
      ),
    );
  }
}
