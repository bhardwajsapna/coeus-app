//import 'dart:convert';
//import 'dart:ffi';
//import 'dart:io';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:coeus_v1/models/sensorsData.dart';
import 'package:path_provider/path_provider.dart';

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

  static updateLocal(List<dynamic> processedData) async {
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
}
