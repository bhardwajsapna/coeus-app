import 'package:coeus_v1/services/bleServices.dart';
import 'package:coeus_v1/utils/const.dart';
import 'package:coeus_v1/utils/dashboard_secure_storage.dart';
import 'package:coeus_v1/widget/bluetoohSearch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_blue/flutter_blue.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:location_permissions/location_permissions.dart';
import 'dart:async';
import 'dart:io' show Platform;

class DiscoveryBluetoothDevice extends StatefulWidget {
  _DiscoveryBluetoothDevice createState() => _DiscoveryBluetoothDevice();
}

class _DiscoveryBluetoothDevice extends State<DiscoveryBluetoothDevice> {
//  FlutterBlue flutterBlue = FlutterBlue.instance;
//  List<ScanResult> list = [];
  List<DiscoveredDevice> list = [];
//-------------------------------
  bool _foundDeviceWaitingToConnect = false;
  bool _scanStarted = false;
  bool _connected = false;
  late DiscoveredDevice _coeusDevice;
  final flutterReactiveBle = FlutterReactiveBle();
// Bluetooth related variables
  late StreamSubscription<DiscoveredDevice> _scanStream;
  late QualifiedCharacteristic _rxCharacteristic;
// These are the UUIDs of your device
  final Uuid serviceUuid = Uuid.parse(Constants.service_100);
  final Uuid characteristicUuid = Uuid.parse(Constants.character101);

  void _startScan() async {
    debugPrint("start scaning");
// Platform permissions handling stuff
    bool permGranted = false;
    setState(() {
      _scanStarted = true;
    });
    PermissionStatus permission;
    if (Platform.isAndroid) {
      permission = await LocationPermissions().requestPermissions();
      if (permission == PermissionStatus.granted) permGranted = true;
    } else if (Platform.isIOS) {
      permGranted = true;
    }
// Main scanning logic happens here ⤵️
    if (permGranted) {
      list = [];
      _scanStream =
          flutterReactiveBle.scanForDevices(withServices: []).listen((device) {
        // Change this string to what you defined in Zephyr
        // if (device.name == 'UBIQUE') {
        //      debugPrint(list.length.toString() + " is the length");
        setState(() {
          _coeusDevice = device;
          _foundDeviceWaitingToConnect = true;
          var deviceFound = false;
          list.forEach((element) {
            if (element.id == device.id) {
              deviceFound = true;
            }
          });

          if (!deviceFound) {
            list.add(device);
            //    debugPrint(list.first.toString() + "list content");
          }
        });
        // }

        //       debugPrint(device.id + "," + device.name + " is the present list");
      });
    }
  }

  void _connectToDevice(device) {
    // We're done scanning, we can cancel it
    _scanStream.cancel();
    // Let's listen to our connection so we can make updates on a state change
    Stream<ConnectionStateUpdate> _currentConnectionStream = flutterReactiveBle
        .connectToAdvertisingDevice(
            id: device.id,
            prescanDuration: const Duration(seconds: 1),
            withServices: []);
    _currentConnectionStream.listen((event) {
      debugPrint(event.connectionState.toString() + "is the connect state");
      switch (event.connectionState) {
        // We're connected and good to go!
        case DeviceConnectionState.connected:
          {
            _rxCharacteristic = QualifiedCharacteristic(
                serviceId: serviceUuid,
                characteristicId: characteristicUuid,
                deviceId: event.deviceId);
            setState(() {
              _foundDeviceWaitingToConnect = false;
              _connected = true;
            });
            break;
          }
        // Can add various state state updates on disconnect
        case DeviceConnectionState.disconnected:
          {
            break;
          }
        default:
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startScan();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (BuildContext context, index) {
          DiscoveredDevice device = list[index];
          //final device = result.device;
          final address = device.id;
          return BluetoothDeviceListEntry(
            device: device,
            rssi: device.rssi,
            onTap: () async {
              Fluttertoast.showToast(
                  msg: "Tapped for connection",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
              print("in tap...");
              _connectToDevice(device);

              if (_connected != null) {
                print("checking for name...");

                Fluttertoast.showToast(
                  msg: "connected" + device.name + "***",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
                // 16 jan 22
                // this has to be set back for final version
                //if (device.name.contains(Constants.deviceName))
                {
                  // only if the device name contains device name then go ahead
                  Constants.bleDevice = device;
                  // once connected transmit time
                  writeISTEpochTime();

                  Fluttertoast.showToast(
                    msg: "device initiated " + device.name + "***",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );

                  var tempBatteryValue = readBatteryCharge();

                  await DashboardSecureStorage.setBattery(tempBatteryValue[0]);
                  Fluttertoast.showToast(
                    msg: "Battery Charge " + tempBatteryValue + "***",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                }
              }
            },
            onLongPress: () async {
              try {
                if (_connected != null) {
//this has to be done for disconnected

                  //device..disconnect();
                  print("alisa-disconnected...  to do");
                }
              } catch (ex) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Error occured while bonding'),
                      content: Text("${ex.toString()}"),
                      actions: <Widget>[
                        new TextButton(
                          child: new Text("Close"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            },
          );
        },
      ),
    );
  }
}
