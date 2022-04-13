//import 'dart:convert';
//import 'dart:ffi';
//import 'dart:io';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:coeus_v1/models/MonthReadingOnceADay.dart';
import 'package:coeus_v1/models/TempValue.dart';
import 'package:coeus_v1/models/sensorsData.dart';
import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

import 'dashboard_secure_storage.dart';

class Data_utils {
  static int byte8toInt(List<int> givenList) {
    //print("Step 1");
    final bytes = Uint8List.fromList(givenList);
    // print("Step 2");
    final byteData = ByteData.sublistView(bytes);
    //print("Step 3");
    // print(byteData.toString());
    return byteData.getUint64(0);
  }

  static int byte4toInt(List<int> givenList) {
    final bytes = Uint8List.fromList(givenList);
    final byteData = ByteData.sublistView(bytes);
    return byteData.getUint32(0); //.getInt32(0);
  }

  static int byte2toInt(List<int> givenList) {
    final bytes = Uint8List.fromList(givenList);
    final byteData = ByteData.sublistView(bytes);
    return byteData.getUint16(0);
  }

  static List rawToProcessed(List<dynamic> rawData) {
    List rowData = [];
    List sensorProcessedData = [];

    for (var value in rawData) {
      rowData = [];

      print("first value" + value.toString());

      var epochTime =
          Data_utils.byte8toInt(value.sublist(0, 8).reversed.toList());

      // print("raw time is" + epochTime.toString());

      DateTime asperread =
          new DateTime.fromMillisecondsSinceEpoch(epochTime * 1000);

      rowData.add(epochTime * 1000);

      //print("converted time is" + asperread.toString());
      //print("sample no" +
      //   Data_utils.byte4toInt(value.sublist(8, 12).reversed.toList())
      //     .toString());
      //4 byte data set
      rowData.add(byte4toInt(value.sublist(8, 12).reversed.toList()));
      rowData.add(byte4toInt(value.sublist(12, 16).reversed.toList()));
      rowData.add(byte4toInt(value.sublist(16, 20).reversed.toList()));
      rowData.add(byte4toInt(value.sublist(20, 24).reversed.toList()));
      rowData.add(byte4toInt(value.sublist(24, 28).reversed.toList()));
      rowData.add(byte4toInt(value.sublist(28, 32).reversed.toList()));
      rowData.add(byte4toInt(value.sublist(32, 36).reversed.toList()));

      //2 byte data set
      rowData.add(byte2toInt(value.sublist(36, 38).reversed.toList()));
      rowData.add(byte2toInt(value.sublist(38, 40).reversed.toList()));
      rowData.add(byte2toInt(value.sublist(40, 42).reversed.toList()));
      rowData.add(byte2toInt(value.sublist(42, 44).reversed.toList()));

      //1 byte data
      rowData.add(value.sublist(44, 45)[0]);
      rowData.add(value.sublist(45, 46)[0]);
      rowData.add(value.sublist(46, 47)[0]);
      rowData.add(value.sublist(47, 48)[0]);
      rowData.add(value.sublist(48, 49)[0]);
      rowData.add(value.sublist(49, 50)[0]);
      rowData.add(value.sublist(50, 51)[0]);

      print("row data : " + rowData.toString());
      sensorProcessedData.add(rowData);
    }
    return (sensorProcessedData);
  }

  static updateLocalJsonForGraph() async {
    String baseDir = "";
    Directory? directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationSupportDirectory();

    baseDir = "${directory!.path}";
    String givenDate = await DashboardSecureStorage.getLastUpdate();
    String givenTime = (givenDate.split(" "))[1];
    givenDate = (givenDate.split(" "))[0];

    /*
    temperature json update
    */
    String fileName = baseDir + '/tempRecords.json';

    File jsonFile = new File(fileName);
    String jsonData = await jsonFile.readAsString();

    var tempData = convertJsonToTemp(jsonData);

    debugPrint(
        tempData.tempValues.length.toString() + " is the length in temp start");

    var tempValue = await DashboardSecureStorage.getTemperature();

    debugPrint("sample at start" + tempData.tempValues.last.samples.toString());

    tempData.updateJsonTempData(givenDate, givenTime, tempValue.toInt());

    debugPrint(
        tempData.tempValues.length.toString() + " is the length in temp now");

    var updateJson = convertTempToJson(tempData);

    debugPrint("sample at last" + tempData.tempValues.last.samples.toString());
    await jsonFile.writeAsString(updateJson.toString());
    /*
    BPM json update
    */

    fileName = baseDir + '/bpmRecords.json';

    jsonFile = new File(fileName);
    jsonData = await jsonFile.readAsString();

    tempData = convertJsonToTemp(jsonData);

    debugPrint(
        tempData.tempValues.length.toString() + " is the length in bpm start");

    var bpmValue = await DashboardSecureStorage.getHeartRate();

    debugPrint("sample at start" + tempData.tempValues.last.samples.toString());

    tempData.updateJsonTempData(givenDate, givenTime, bpmValue);

    debugPrint(
        tempData.tempValues.length.toString() + " is the length in bpm now");

    updateJson = convertTempToJson(tempData);

    debugPrint("sample at last" + tempData.tempValues.last.samples.toString());
    await jsonFile.writeAsString(updateJson.toString());

    /*
    spo2 json update
    */

    fileName = baseDir + '/spo2Records.json';

    jsonFile = new File(fileName);
    jsonData = await jsonFile.readAsString();

    tempData = convertJsonToTemp(jsonData);

    debugPrint(
        tempData.tempValues.length.toString() + " is the length in spo2 start");

    var spo2Value = await DashboardSecureStorage.getSpO2();

    debugPrint("sample at start" + tempData.tempValues.last.samples.toString());

    tempData.updateJsonTempData(givenDate, givenTime, spo2Value);

    debugPrint(
        tempData.tempValues.length.toString() + " is the length in spo2 now");

    updateJson = convertTempToJson(tempData);

    debugPrint("sample at last" + tempData.tempValues.last.samples.toString());
    await jsonFile.writeAsString(updateJson.toString());

// 07 apr 22 now we need to update the steps and sleeping hrs of the day.
    String fileNameSS = baseDir + '/stepsSleepRecords.json';

    File jsonFileSS = new File(fileNameSS);
    String jsonDataSS = await jsonFileSS.readAsString();

    var ssData = convertJsonToMonthReadingOnceADay(jsonDataSS);

    var sleepValue = await DashboardSecureStorage.getSleep();
    var stepsValue = await DashboardSecureStorage.getFootsteps();
    ssData.updateJsonDayData(givenDate, [stepsValue, sleepValue.toString()]);

    var updateJsonss = convertMonthReadingOnceADayToJson(ssData);

    debugPrint("last steps and sleep data" +
        (ssData.dayValues.last).sleepHrs.toString());
    await jsonFileSS.writeAsString(updateJsonss.toString());
  }

  static saveDataLocally(List<dynamic> processedData) async {
    Directory? directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationSupportDirectory();
    print("dir path" + directory.toString());

    String filePath = "${directory!.path}/" +
        DateTime.now().toIso8601String().substring(0, 16) +
        ".json";

    File file = File(filePath);

    processedData //convert list data  to json
        .map(
          (sensorsData) => (SensorsData(sensorsData)).toJson(),
        )
        .toList();

    file.writeAsStringSync(json.encode(processedData));

    //  await file.writeAsString(jsonEncode(value));

    //  var fileName = 'assets/tempRecords.json';
    //  var tempFile = File(filePath);

    // if ((await File(filePath).exists())) {
    // } else {}

    //  final String jsonString = await file.readAsString();
    //  print("data in json file is ");
    //  print(jsonString);

    // await rootBundle.loadString(fileName);

    // var fileData = (jsonString);
  }

  static updateLocalJson(var givenDT) async {
    var fileName = 'assets/tempRecords.json';
    var givenDate = givenDT.toString().split(" ")[0];
    var givenTime = givenDT.toString().split(" ")[1];

    var tempFile = File(fileName);

    String jsonData = await rootBundle.loadString(fileName);
    debugPrint("------------");
    debugPrint(givenDT);
    // debugPrint(jsonData);
    // setState(() {
    var tempData = convertJsonToTemp(jsonData);
    debugPrint(tempData.tempValues[tempData.tempValues.length - 1].sampleDate);
    debugPrint(givenDate + " ----> " + givenTime);
    if (tempData.tempValues[tempData.tempValues.length - 1].sampleDate ==
        givenDate) {
      debugPrint("date present so add sample");
    } else {
      debugPrint("add date and then sample");
      var tempValue = await DashboardSecureStorage.getTemperature();

      tempData.updateJsonTempData(givenDate, givenTime, tempValue.toInt());

      var updateJson = convertTempToJson(tempData);

      await tempFile.writeAsString(updateJson.toString());
    }

    Fluttertoast.showToast(msg: tempData.tempValues.toString());
  }

  static dataFromFile() async {
    debugPrint("reached updateJson");
    String filepath = 'assets/sensor_data_log.csv';
    final input = await rootBundle.loadString(filepath);
    debugPrint(input + "is the input");
    var csvlst = [];
    csvlst = CsvToListConverter().convert(input);
    debugPrint(" the csvlst");
    return (csvlst);
  }
}
