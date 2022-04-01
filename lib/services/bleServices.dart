import 'dart:convert';
import 'package:coeus_v1/utils/Data_utils.dart';
import 'package:coeus_v1/utils/advanced_settings_secure_storage.dart';
import 'package:coeus_v1/utils/const.dart';
import 'package:coeus_v1/utils/scroller_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

/*
*
*   Below are the BLE write functions 
*
*/

//base functions - as write is given in only characteristic 100 so this is coded accordingly
writeBLE_String_Data_service_100(String data, String characteristic_given) {
  debugPrint("come to write" + Constants.bleDevice.id);
  if (Constants.bleDevice != null) {
    String full_char = Constants.characteristic_format_100;

    full_char = full_char.replaceAll('XXX', characteristic_given);

    debugPrint(
        "writing to " + Constants.service_100 + " character " + full_char);
    final characteristic = QualifiedCharacteristic(
        serviceId: Uuid.parse(Constants.service_100),
        characteristicId: Uuid.parse(full_char),
        deviceId: Constants.bleDevice!.id);

    Constants.flutterReactiveBle.writeCharacteristicWithResponse(characteristic,
        value: utf8.encode(data));
  }
}

writeBLE_List_Data_service_100(List<int> data, String characteristic_given) {
  debugPrint("come to write" + Constants.bleDevice.id);
  if (Constants.bleDevice != null) {
    String full_char = Constants.characteristic_format_100;

    full_char = full_char.replaceAll('XXX', characteristic_given);

    debugPrint(
        "writing to " + Constants.service_100 + " character " + full_char);
    final characteristic = QualifiedCharacteristic(
        serviceId: Uuid.parse(Constants.service_100),
        characteristicId: Uuid.parse(full_char),
        deviceId: Constants.bleDevice!.id);

    Constants.flutterReactiveBle
        .writeCharacteristicWithResponse(characteristic, value: data);
  }
}

//user functions in application
//this is called when the app gets connected to device and also button press in test app
writeISTEpochTime() {
  DateTime now = DateTime.now();
  String time_now =
      (((now.millisecondsSinceEpoch + now.timeZoneOffset.inMilliseconds) /
              1000))
          .toStringAsFixed(0);
  print("time_now:" + time_now);
  writeBLE_String_Data_service_100(time_now, '112');
}

// this is called when the user press the "sync" button on the dash board
initiateBLEData(String characteristic_given) {
  writeBLE_List_Data_service_100([1], characteristic_given);
}

// this is called when the user press the "sync" button on the dash board
deactivateBLEData(String characteristic_given) {
  writeBLE_List_Data_service_100([0], characteristic_given);
}

/*
*
*   Below are the BLE read functions 
*
*/
Future<List<int>> readBLEData(
    String service_given, String characteristic_given) async {
  var service_to_search;
  String full_char;

  if (service_given.contains("200")) {
    service_to_search = Constants.service_200;
    full_char = Constants.characteristic_format_200;
  } else {
    service_to_search = Constants.service_100;
    full_char = Constants.characteristic_format_100;
  }

  full_char = full_char.replaceAll('XXX', characteristic_given);
  debugPrint(service_to_search + " || " + full_char);
  final characteristic = QualifiedCharacteristic(
      serviceId: Uuid.parse(service_to_search),
      characteristicId: Uuid.parse(full_char),
      deviceId: Constants.bleDevice!.id);
  final response =
      await Constants.flutterReactiveBle.readCharacteristic(characteristic);

  // // this is for reading the writen value...

  // debugPrint("temp val == " + response.toString());
  return response;
}

//22 mar 22 - for reading the battery charge
readBatteryCharge() {
  final value = readBLEData("100", Constants.character113);

  return (value);
}

readSensorsData(characteristic_given) async {
  // data is provided in service 200 and characteristic 201
  // data transfer is initiated by setting 1 to characteristic 110 of service 100

  int flagDataRead = 1;
  var sensorData = [];
  var rowData = [];
  // standby break for while
  int sizeSensorData = 0;
  print("here........");
  while (sizeSensorData < 50) {
    // above has to be replaced the flag data of 110
    //(flagDataRead == 1) {

    var value = await readBLEData("200", "201");
    // this has to be done after seregation of data so done later
    sensorData.add(value);
/*    For testing purpose
*/

/*    print("first value" + value.toString());

    var epochTime =
        Data_utils.byte8toInt(value.sublist(0, 8).reversed.toList());

    print("raw time is" + epochTime.toString());

    DateTime asperread =
        new DateTime.fromMillisecondsSinceEpoch(epochTime * 1000);

    rowData = [];
    rowData.add(epochTime * 1000);

    print("converted time is" + asperread.toString());
    //print("sample no" +
    //   Data_utils.byte4toInt(value.sublist(8, 12).reversed.toList())
    //     .toString());
    //4 byte data set
    rowData.add(Data_utils.byte4toInt(value.sublist(8, 12).reversed.toList()));
    rowData.add(Data_utils.byte4toInt(value.sublist(12, 16).reversed.toList()));
    rowData.add(Data_utils.byte4toInt(value.sublist(16, 20).reversed.toList()));
    rowData.add(Data_utils.byte4toInt(value.sublist(20, 24).reversed.toList()));
    rowData.add(Data_utils.byte4toInt(value.sublist(24, 28).reversed.toList()));
    rowData.add(Data_utils.byte4toInt(value.sublist(28, 32).reversed.toList()));
    rowData.add(Data_utils.byte4toInt(value.sublist(32, 36).reversed.toList()));

    //2 byte data set
    rowData.add(Data_utils.byte2toInt(value.sublist(36, 38).reversed.toList()));
    rowData.add(Data_utils.byte2toInt(value.sublist(38, 40).reversed.toList()));
    rowData.add(Data_utils.byte2toInt(value.sublist(40, 42).reversed.toList()));
    rowData.add(Data_utils.byte2toInt(value.sublist(42, 44).reversed.toList()));

    //1 byte data
    rowData.add(value.sublist(44));
    rowData.add(value.sublist(45));
    rowData.add(value.sublist(46));
    rowData.add(value.sublist(47));
    rowData.add(value.sublist(48));
    rowData.add(value.sublist(49));
    rowData.add(value.sublist(50));
    sensorData.add(rowData);
*/
    // print("temperature is " +
    //   Data_utils.byte2toInt(value.sublist(40, 42).reversed.toList())
    //     .toString());

/* for testing purpose - end
*/
    debugPrint("201 data" + value.toString());
    debugPrint("rowdata : " + rowData.toString());
    /* readBLEData("100", "110").then((value) {
      debugPrint("101 data" + value.toString());

      flagDataRead = int.parse(value);
    });
*/

    // Here the logic needs to be changed - as time will be different, time should be disgarded
    // for comparision.
    /* debugPrint("sizesensor data" + sizeSensorData.toString());
    if (sizeSensorData > 3) {
      if (sensorData[sizeSensorData] == sensorData[sizeSensorData - 1] &&
          sensorData[sizeSensorData - 1] == sensorData[sizeSensorData - 2]) {
        flagDataRead = 2;
      }
    }
*/
    sizeSensorData = sizeSensorData + 1;
  }
  return (sensorData);
}

/*
*
*   Below are the BLE notification functions 
*
*/
listenBLEData(String characteristic_given) {
  /* var service_to_search;

  String full_char;
  if (controllerServiceRead.text.contains("200")) {
    service_to_search = Constants.service_200;
    full_char = Constants.characteristic_format_200;
  } else {
    service_to_search = Constants.service_100;
    full_char = Constants.characteristic_format_100;
  }

  final characteristic = QualifiedCharacteristic(
      serviceId: serviceUuid,
      characteristicId: characteristicUuid,
      deviceId: foundDeviceId);
  flutterReactiveBle.subscribeToCharacteristic(characteristic).listen((data) {
    // code to handle incoming data
  }, onError: (dynamic error) {
    // code to handle errors
  });

  Constants.bleDevice.discoverServices().then((services) {
    services.forEach((service) async {
      var serviceDispName = service.uuid.toString();
      print("print:servicename" + serviceDispName);

      var service_to_search;

      String full_char;
      if (controllerServiceRead.text.contains("200")) {
        service_to_search = Constants.service_200;
        full_char = Constants.characteristic_format_200;
      } else {
        service_to_search = Constants.service_100;
        full_char = Constants.characteristic_format_100;
      }

      if (service.uuid.toString() == service_to_search) {
        print("found service...");
        //String full_char = Constants.characteristic_format;
        full_char = full_char.replaceAll('XXX', characteristic_given);
        debugPrint("print:fullchal" + full_char);
        var characteristics = service.characteristics;
        for (BluetoothCharacteristic c in characteristics) {
          print("print:char:" + c.uuid.toString());
          if (c.uuid.toString() == full_char) {
            // // this is for reading the writen value...
            var count = 0;
            //await Constants.bleDevice.requestMtu(100);
            await c.setNotifyValue(true);
            c.value.listen((value) {
              // do something with new value
              debugPrint("notified val = " + "$value");
              setState(() {
                sensorData = value.toString();
              });
            });
          }
        }
      }
    });
  });*/
}
