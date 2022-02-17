import 'dart:typed_data';

import 'package:coeus_v1/models/SpO2Values.dart';
import 'package:coeus_v1/services/api.dart';
import 'package:coeus_v1/services/bleServices.dart';
import 'package:coeus_v1/utils/advanced_settings_secure_storage.dart';
import 'package:coeus_v1/utils/const.dart';
import 'package:coeus_v1/widget/dropdown.dart';
import 'package:coeus_v1/widget/scroller.dart';
import 'package:flutter/material.dart';
import 'package:coeus_v1/widget/button.dart';
import 'package:coeus_v1/widget/textLogin.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:coeus_v1/utils/const.dart' as globalAccess;

class AdvancedSettingsProfilePage extends StatefulWidget {
  @override
  _AdvancedSettingsProfilePageState createState() =>
      _AdvancedSettingsProfilePageState();
}

class _AdvancedSettingsProfilePageState
    extends State<AdvancedSettingsProfilePage> {
  final ScrollController _scrollController = new ScrollController();

  List<String> monitor_after_every = [];
  List<String> communication_list = ["Only BLE", "Only Mobile", "Both"];
  List<String> samplingrate_list = ["off", "128", "256", "512"];

  var map_communication_list_index = {};
  var map_samplingrate_list_value = {};
  var map_monitorafter_list_value = {};

  int selected_index_comunication = 0;
  int selected_index_SpO2 = 0;
  int selected_index_ecg = 0;
  int selected_index_temp = 0;
  int selected_index_activity = 0;
  int selected_index_monitor_after = 0;

  bool mounted = false;

/*
23 aug 21 - sreeni
*/
  late Future<http.Response> response;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //init();
    for (int i = 0; i < communication_list.length; i++) {
      map_communication_list_index[communication_list[i]] = i;
    }
    for (int i = 0; i < 24; i++) {
      if (i == 0) {
        monitor_after_every.add((i + 1).toString() + " hour");
      } else {
        monitor_after_every.add((i + 1).toString() + " hours");
      }

      map_monitorafter_list_value[(i + 1).toString()] = i;
    }
    print(monitor_after_every);
    map_samplingrate_list_value['off'] = 0;
    map_samplingrate_list_value['128'] = 128;
    map_samplingrate_list_value['256'] = 256;
    map_samplingrate_list_value['512'] = 512;
/*
    FlutterBlue.instance.connectedDevices.then((value) async {
      List<BluetoothDevice> list = await value.toList();
      for (BluetoothDevice r in list) {
        if (r.name.contains('COEUS')) {
          //
          services = await r.discoverServices();
        }
      }
    });
    */
  }

  void write_to_device() {
    debugPrint("inside updating");

// communication mode characteristic = 107
    writeBLE_List_Data_service_100(
        [this.selected_index_comunication + 1], Constants.character107);

    writeBLE_List_Data_service_100(
        [this.selected_index_monitor_after], Constants.character106);

    /*  Uint16List char108data = Uint16List.fromList([
      map_samplingrate_list_value[
          this.samplingrate_list[this.selected_index_SpO2]],
      map_samplingrate_list_value[
          this.samplingrate_list[this.selected_index_ecg]],
      map_samplingrate_list_value[
          this.samplingrate_list[this.selected_index_temp]],
      map_samplingrate_list_value[
          this.samplingrate_list[this.selected_index_activity]]
    ]);
    var buffer = char108data.buffer;
    var bufferdata = new ByteData.view(buffer);
*/
    List<int> char108data = [
      map_samplingrate_list_value[
          this.samplingrate_list[this.selected_index_SpO2]],
      map_samplingrate_list_value[
          this.samplingrate_list[this.selected_index_ecg]],
      map_samplingrate_list_value[
          this.samplingrate_list[this.selected_index_temp]],
      map_samplingrate_list_value[
          this.samplingrate_list[this.selected_index_activity]]
    ];
    writeBLE_List_Data_service_100(char108data, Constants.character108);

    debugPrint((char108data).toString() + "are the sampling rates");

    // Uint16List.bytesPerElement
    /*
    services.forEach((service) async {
      if (service.uuid.toString() == globalAccess.Constants.service_100) {
        print("found service...");
        Fluttertoast.showToast(
            msg: "Inside uuid service - to be written",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);

        var characteristics = service.characteristics;
        for (BluetoothCharacteristic c in characteristics) {
          if (c.uuid.toString() == Constants.character108) {
            print("--------------------------------------");
            print(c);
            String spo2 = samplingrate_list[this.selected_index_SpO2];
            if (spo2 == 'off') {
              spo2 = "0";
            }
            int spo2_int = int.parse(spo2);
            String ecg = samplingrate_list[this.selected_index_ecg];
            if (ecg == 'off') {
              ecg = "0";
            }
            int ecg_int = int.parse(ecg);
            String temperature = samplingrate_list[this.selected_index_temp];
            if (temperature == 'off') {
              temperature = "0";
            }
            int temperature_int = int.parse(temperature);

            String accel = samplingrate_list[this.selected_index_activity];
            if (accel == 'off') {
              accel = "0";
            }
            int accel_int = int.parse(accel);

            // Uint16List temp = Uint16List.fromList(
            //    [spo2_int, ecg_int, temperature_int, accel_int]);

            var temp = spo2 + ecg + temperature + accel;

            Fluttertoast.showToast(
                msg: "values to be written" + "${temp}",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);

            var writeval = [134, 135, 136, 137, 138, 139, 140, 141];
            var writeResult = await c.write(writeval);

            Fluttertoast.showToast(
                msg: "$writeResult",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);

            if (writeResult) {
              Fluttertoast.showToast(
                  msg: "written successfully",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
          }
        }
      }
    });
    */
  }

  int getIndexFromList(list, val) {
    print("hi...");
    print(list.indexOf(val));
    return list.indexOf(val);
  }

  Future<http.Response> updateAdvancedSettingsService() async {
    print(this.selected_index_comunication);
    print(this.communication_list[this.selected_index_comunication]);
    var requestParams = {
      'monitorAfterEvery': map_monitorafter_list_value[
          this.monitor_after_every[this.selected_index_monitor_after]],
      'communicationChannel': map_communication_list_index[
          this.communication_list[this.selected_index_comunication]],
      'samplingRateInfo': <String, int>{
        "heartRate": map_samplingrate_list_value[
            this.samplingrate_list[this.selected_index_ecg]],
        "spo2": map_samplingrate_list_value[
            this.samplingrate_list[this.selected_index_SpO2]],
        "temperature": map_samplingrate_list_value[
            this.samplingrate_list[this.selected_index_temp]],
        "activity": map_samplingrate_list_value[
            this.samplingrate_list[this.selected_index_activity]]
      }
    };
    print(requestParams);
    response = updateAdvancedSettingsAPIService(requestParams);
    return response;
  }

  void onSubmit() async {
    // this has to be done after server commits. for testing this is done here now.

/*
17 aug 21
this is to test and implement the API
*/
    updateAdvancedSettingsService().then((response) {
      if (response.statusCode == 200) {
        write_to_device(); //commented by sapna  //uncommneted by sreeni

        AdvancedSettingsSecureStorage.setMonitorAfter(
            this.monitor_after_every[this.selected_index_monitor_after]);
        AdvancedSettingsSecureStorage.setSamplingCommunication(
            this.communication_list[this.selected_index_comunication]);
        AdvancedSettingsSecureStorage.setSamplingSpO2(
            this.samplingrate_list[this.selected_index_SpO2]);
        AdvancedSettingsSecureStorage.setSamplingECG(
            this.samplingrate_list[this.selected_index_ecg]);
        AdvancedSettingsSecureStorage.setSamplingTemperature(
            this.samplingrate_list[this.selected_index_temp]);
        AdvancedSettingsSecureStorage.setSamplingActivity(
            this.samplingrate_list[this.selected_index_activity]);

        Fluttertoast.showToast(
            msg: "Successfully done.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.of(context).pop();
      } else {
        Fluttertoast.showToast(
            msg: "Some error occured. Please try later.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }

  Future<String> getIndex() async {
    if (!mounted) {
      print("HIIII");
      final monitorafter =
          await AdvancedSettingsSecureStorage.getMonitorAfter() ??
              monitor_after_every[0];
      final communication =
          await AdvancedSettingsSecureStorage.getSamplingCommunication() ??
              communication_list[0];
      final spo2 = await AdvancedSettingsSecureStorage.getSamplingSpO2() ??
          samplingrate_list[0];
      final ecg = await AdvancedSettingsSecureStorage.getSamplingECG() ??
          samplingrate_list[0];
      final temp =
          await AdvancedSettingsSecureStorage.getSamplingTemperature() ??
              samplingrate_list[0];
      final activity =
          await AdvancedSettingsSecureStorage.getSamplingActivity() ??
              samplingrate_list[0];

      setState(() {
        this.selected_index_monitor_after =
            getIndexFromList(monitor_after_every, monitorafter);
        this.selected_index_comunication =
            getIndexFromList(communication_list, communication);

        this.selected_index_SpO2 = getIndexFromList(samplingrate_list, spo2);

        this.selected_index_ecg = getIndexFromList(samplingrate_list, ecg);

        this.selected_index_temp = getIndexFromList(samplingrate_list, temp);

        this.selected_index_activity =
            getIndexFromList(samplingrate_list, activity);
      });
      mounted = true;
      return "true";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    double __height = MediaQuery.of(context).size.height * 0.12;
    return Scaffold(
      body: ListView(children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          // decoration: BoxDecoration(
          //   gradient: LinearGradient(
          //       begin: Alignment.topRight,
          //       end: Alignment.bottomLeft,
          //       colors: [Constants.white, Constants.lightBlue]),
          // ),
          child: Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TextWrapper(
                    textstr: "Advanced Settings",
                    font: 32,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: SingleChildScrollView(
                      child: FutureBuilder(
                        future: getIndex(),
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    child: SizedBox(
                                      height: __height,
                                      child: CustomPickerPage(
                                          font: 22,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          title: "Monitor after every:",
                                          values: monitor_after_every,
                                          selectedIndex:
                                              this.selected_index_monitor_after,
                                          onChangedValue: (index) => setState(() =>
                                              this.selected_index_monitor_after =
                                                  index)),
                                    ),
                                  ),
                                  Container(
                                    child: SizedBox(
                                      height: __height,
                                      child: CustomPickerPage(
                                          font: 22,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          title: "Communicate via:",
                                          values: communication_list,
                                          selectedIndex:
                                              this.selected_index_comunication,
                                          onChangedValue: (index) => setState(() =>
                                              this.selected_index_comunication =
                                                  index)),
                                    ),
                                  ),
                                  Container(
                                    child: SizedBox(
                                      height: __height,
                                      child: CustomPickerPage(
                                          font: 22,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          title: "SpO2 (Hz):",
                                          values: samplingrate_list,
                                          selectedIndex:
                                              this.selected_index_SpO2,
                                          onChangedValue: (index) => setState(
                                              () => this.selected_index_SpO2 =
                                                  index)),
                                    ),
                                  ),
                                  Container(
                                    child: SizedBox(
                                      height: __height,
                                      child: CustomPickerPage(
                                          font: 22,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          title: "HeartRate (Hz):",
                                          values: samplingrate_list,
                                          selectedIndex:
                                              this.selected_index_ecg,
                                          onChangedValue: (index) => setState(
                                              () => this.selected_index_ecg =
                                                  index)),
                                    ),
                                  ),
                                  Container(
                                    child: SizedBox(
                                      height: __height,
                                      child: CustomPickerPage(
                                          font: 22,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          title: "Temperature (Hz):",
                                          values: samplingrate_list,
                                          selectedIndex:
                                              this.selected_index_temp,
                                          onChangedValue: (index) => setState(
                                              () => this.selected_index_temp =
                                                  index)),
                                    ),
                                  ),
                                  Container(
                                    child: SizedBox(
                                      height: __height,
                                      child: CustomPickerPage(
                                          font: 22,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          title: "Activity (Hz):",
                                          values: samplingrate_list,
                                          selectedIndex:
                                              this.selected_index_activity,
                                          onChangedValue: (index) => setState(
                                              () =>
                                                  this.selected_index_activity =
                                                      index)),
                                    ),
                                  )
                                ]);
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ),
                  ),
                  Button(
                    title: "OK",
                    nextNavigation: null,
                    onTapFunction: onSubmit,
                    width: MediaQuery.of(context).size.width,
                    baseColor: Constants.lightgreendull,
                  ),
                ]),
          ),
        ),
      ]),
    );
  }
}
