import 'dart:convert';
import 'dart:io';

import 'package:coeus_v1/components/summary_card.dart';
import 'package:coeus_v1/models/TempValue.dart';
import 'package:coeus_v1/services/api.dart';

import 'package:coeus_v1/services/bleServices.dart';
import 'package:coeus_v1/utils/Data_utils.dart';
import 'package:coeus_v1/utils/const.dart';
import 'package:coeus_v1/utils/dashboard_secure_storage.dart';
import 'package:coeus_v1/utils/user_secure_storage.dart';

import 'package:coeus_v1/widget/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/services.dart' show rootBundle;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

// this csv can be removed for production.
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int batteryValue = 0;
  int footsteps = 0;
  double sleep = 0;
  int heartrate = 0;
  double temperature = 0;
  int spo2 = 0;
  String username = "User";
  String lastSampleDT = "November-04,2021  02:30 AM";
  var sensorData = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  updateUIandSecuredStorage(_listData) async {
// 03 feb for testing from csv data provided by sriharsha on 02 feb
// if data has to be read from file and displayed on the screen then this has to be uncommented
// if data  to be taken from the sensor and displayed on the screen then comment this portion till
// _listData

// 02 par now we have declared boolean to def the flow

    /*   debugPrint("reached updateJson");
    String filepath = 'assets/sensor_data_log.csv';
    final input = await rootBundle.loadString(filepath);

    List<List<dynamic>> _listData = CsvToListConverter().convert(input);
*/
//--------------------------------------------------
    // debugPrint(_listData.toString());
    num temp1 = 0;
    num hr = 0;
    num spo = 0;
    num sampleTime = 0;
    late DateTime sampleDate;
    String fileDate = "";
    String fileTime = "";
    _listData.forEach((element) {
      temp1 = temp1 + (element[11] * 0.005); // on 22 mar 22

      hr = hr + element[12];
      spo = spo + element[16];

      //(int.tryParse(element[11]) ?? 0);
      // temp = temp + double.parse(element[12]);
    });

    temp1 = temp1 / _listData.length;
    hr = hr / _listData.length;
    spo = spo / _listData.length;
    sampleTime = _listData[_listData.length - 1][0];

    setState(() {
      this.heartrate = hr.toInt();
      this.spo2 = spo.toInt();
      // 22 mar 22 - rounded the temp as this was giving the floating number
      // below line for deg celcius
      this.temperature = (temp1.round()).toDouble();
      // now converting to deg fahrenheit
      this.temperature =
          (((this.temperature * (9 / 5)) + 32).round()).toDouble();

//24 mar 22 - removing the multiplication factor 1000 as
      DateTime now = DateTime.now();
      sampleDate = DateTime.fromMillisecondsSinceEpoch(sampleTime.toInt() -
          int.parse(now.timeZoneOffset.inMilliseconds.toString())); // * 1000);

      // debugPrint(sampleDate.toString() + " sample date");
      fileDate = DateFormat('dd-MM-yyyy').format(sampleDate);
      //debugPrint(fileDate.toString() + "file date");

      fileTime = DateFormat('HH:mm:SS').format(sampleDate);
      //20 feb 22 - this is to update the refresh button.
      this.lastSampleDT = fileDate.toString() + " " + fileTime.toString();
    });

    // 23 mar 22 - update local storage so that same can be used while app is opened next time
    // same can also be used updating the json files for each of the parameter.
    await DashboardSecureStorage.setHeartRate(this.heartrate);
    await DashboardSecureStorage.setSpO2(this.spo2);
    await DashboardSecureStorage.setTemperature(this.temperature);
    await DashboardSecureStorage.setLastUpdate(sampleDate);
  }

  Future init() async {
    username = await UserSecureStorage.getFirstName() ?? "User";
    batteryValue = await DashboardSecureStorage.getBattery();
    footsteps = await DashboardSecureStorage.getFootsteps();
    sleep = await DashboardSecureStorage.getSleep();
    heartrate = await DashboardSecureStorage.getHeartRate();
    spo2 = await DashboardSecureStorage.getSpO2();
    temperature = await DashboardSecureStorage.getTemperature();
    lastSampleDT = await DashboardSecureStorage.getLastUpdate();

    setState(() {
      this.batteryValue = batteryValue;
      this.footsteps = footsteps;
      this.sleep = sleep;
      this.heartrate = heartrate;
      this.spo2 = spo2;
      this.temperature = temperature;
      this.username = username;
      this.lastSampleDT = lastSampleDT;
    });

    debugPrint("every time or one time");
  }

  callAPI() {
    print("we are here ");
    debugPrint("yaarr");

    var url = "http://192.168.0.107:5000/userRegistration";
    Map jsonMap = {
      "firstName": "ss",
      "secondName": "ss",
      "DOB": {"date": "1995-02-20T18:30:00Z"},
      "mobileNo": "2121212121",
      "emergencyContact": {
        "firstName": "Shiva",
        "lastName": "kailash",
        "contactNumber": "1111111",
        "emailId": "sLs@kilasa.com"
      },
      "emailId": "sLs@kilasa.com",
      "gender": "Male",
      "password": "123",
      "doctorId": "123",
      "caretakerId": "333",
      "deviceId": "coeus_v1_777",
      "activeUser": true,
      "recordList": [
        {
          "creationDT": "26 Apr 95",
          "fullDT": "30 Apr 95",
          "recordName": "sree_r1"
        },
        {"creationDT": "30 Apr 95", "fullDT": "0", "recordName": "sree_r2"}
      ]
    };
    apiRequest(url, jsonMap);
  }

  Future<String> apiRequest(String url, Map jsonMap) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(jsonMap)));
    HttpClientResponse response = await request.close();
    // todo - you should check the response.statusCode
    String reply = await response.transform(utf8.decoder).join();
    httpClient.close();
    print(reply);
    return reply;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 15.0),
                child: Text(
                  "Hello, " + username,
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
              // SummaryCard(
              //     image: AssetImage('assets/icons/Battery_25.png'),
              //     value: "",
              //     unit: "",
              //     title: batteryValue.toString() + "%",
              //     color: Constants.transparent),
              // CircularPercentIndicator(
              //   radius: 60.0,
              //   lineWidth: 5.0,
              //   //21 oct 21
              //   percent: batteryValue / 100,
              //   center: new Text(batteryValue.toString()),
              //   progressColor: Colors.green,
              // )
            ],
          ),
          Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SummaryCard(
                        image: AssetImage('assets/icons/steps.png'),
                        title: "Footsteps",
                        value: this.footsteps.toString(),
                        unit: "steps",
                        color: Constants.musturd),
                    SizedBox(width: 10),
                    SummaryCard(
                        image: AssetImage('assets/icons/sleep.png'),
                        title: "Sleep",
                        value: this.sleep.toString(),
                        unit: "hours",
                        color: Constants.dull_light_purple),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SummaryCard(
                        image: AssetImage('assets/icons/heartbeat.png'),
                        title: "Heart Rate",
                        value: this.heartrate.toString(),
                        unit: "bpm",
                        color: Constants.dull_blue_gray),
                    SizedBox(width: 10),
                    SummaryCard(
                        image: AssetImage('assets/icons/oxygen_.png'),
                        title: "SpO2",
                        value: this.spo2.toString(),
                        unit: "%",
                        color: Constants.gray),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SummaryCard(
                        image: AssetImage('assets/icons/temperature.png'),
                        title: "Temperature",
                        value: this.temperature.toString(),
                        unit: "˚F",
                        color: Constants.greendull),
                    SizedBox(width: 10),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.15,
                      padding: EdgeInsets.all(15.0),
                      width: ((MediaQuery.of(context).size.width -
                              (Constants.paddingSide * 2 +
                                  Constants.paddingSide / 2)) /
                          2),
                      decoration: new BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        shape: BoxShape.rectangle,
                        color: Constants.dull_move,
                      ),
                      child: InkWell(
                        onTap: () async {
                          Fluttertoast.showToast(
                            msg: "Battery Charge clicked",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                          var tempBattery =
                              await readBLEData("100", Constants.character113);
                          // readBatteryCharge();
                          setState(() {
                            this.batteryValue = tempBattery[0];
                          });
                          Fluttertoast.showToast(
                            msg: "Battery Charge " +
                                tempBattery.toString() +
                                "***",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Battery",
                              style: TextStyle(
                                fontSize: 22,
                                color: Constants.textDark,
                                // fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            LinearPercentIndicator(
                              width: MediaQuery.of(context).size.width / 3,
                              animation: true,
                              lineHeight: 20.0,
                              animationDuration: 2500,
                              percent: batteryValue / 100,
                              center: Text(""),
                              linearStrokeCap: LinearStrokeCap.roundAll,
                              progressColor: Colors.brown.shade300,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "$batteryValue%",
                              style: TextStyle(
                                fontSize: 24,
                                color: Constants.textDark,
                                // fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                /*  Row(
                  children: [
                    Button(
                      onTapFunction: callAPI,
                      title: "API Check",
                    )
                  ],
                ),*/
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          Container(
            child: InkWell(
              onTap: () async {
                /*to read from file and update on the screen enable only the updatejson(sensordata)
                and comment the if statement
                */
                //  updateJson(sensorData);
                //  Data_utils.updateLocalJson(this.lastSampleDT);
//------------------------------------------------------------
                if (Constants.isdataFromFile) {
                  var temp = await Data_utils.dataFromFile() as List;
                  sensorData = temp;
                  debugPrint(
                      sensorData.toString() + " here we get the file data");
                  debugPrint("data read completed");
                } else {
                  if (Constants.bleDevice != null) {
                    // this above async and below await will ensure that intiateBLEdata function called and finished
                    // and then readsensordata will be called.
                    await initiateBLEData('110');
                    Fluttertoast.showToast(
                        msg: "data transfer initiated at 110");
                    Fluttertoast.showToast(msg: "ready for data reception");
                    sensorData = await readSensorsData('201');

                    //process data
                    print(sensorData.toString());
                    print("above the read data from sensor");

                    //processing
                    sensorData = Data_utils.rawToProcessed(sensorData);
                  } else {
                    Fluttertoast.showToast(
                        msg: "Kindly connect the App with Device",
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                }
                //update UI first
                updateUIandSecuredStorage(sensorData);
                // update the local files
                print("before updastelocaljsonforgraph");
                Data_utils.updateLocalJsonForGraph();
                print("after updastelocaljsonforgraph");
                // save data in local storage with date and time stamp
                print("before savedatalocally");
                Data_utils.saveDataLocally(sensorData);
                print("after savedatalocally");
                // update server with summary
                /* 09 apr 22
                There are 2 ways to update the server
                1.  send the complete sensor data to server
                2.  Send summary (dashboard data) to server
                in option 1:
                    data is huge. This would take sometime depending on network bandwidth.
                    Once server receives data it needs to read and 
                    extract information from the data received. 
                    ONLY after this user dashboard gets updated.
                in option 2:
                 send the summary data to server immediately so that server gets update.
                 In this there are 2 calls - one for sending summary to server and second is sending data
                 once server receives summary - user dashboard gets updated.
                 after server receives sensor data - data may be analysed.
                */
                var requestParams = {
                  "HR": this.heartrate,
                  "SPO2": this.spo2,
                  "Temperature": this.temperature,
                  "BatteryCharge": this.batteryValue,
                  "Sleep": this.sleep,
                  "Footsteps": this.footsteps,
                  "Lastupdate": this.lastSampleDT,
                };
                late Future<http.Response> response;
                print("before updateUserSampleReadingsAPIService");
                response = updateUserSampleReadingsAPIService(requestParams);
                print("after updateUserSampleReadingsAPIService");
                // upload the data to server

                //SensorsData(sensorsData)).toJson();

                Fluttertoast.showToast(msg: "data reception completed");
                Fluttertoast.showToast(msg: sensorData.toString());
              },
              child: Container(
                padding: EdgeInsets.all(15.0),
                width: MediaQuery.of(context).size.width * 0.95,
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  shape: BoxShape.rectangle,
                  color: Constants.dull_light_blue,
                ),
                child: Column(
                  children: [
                    Text(
                      "Refresh Data",
                      style: TextStyle(
                        fontSize: 22,
                        color: Constants.textDark,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Image(
                        width: 40,
                        height: 40,
                        image: AssetImage('assets/icons/sync.png')),
                    Text(
                      lastSampleDT,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Constants.textDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static List<charts.Series<OrdinalSales, String>> _createSampleData() {
    final desktopSalesData = [
      new OrdinalSales('2014', 5),
      new OrdinalSales('2015', 25),
      new OrdinalSales('2016', 100),
      new OrdinalSales('2017', 75),
    ];

    final tableSalesData = [
      new OrdinalSales('2014', 25),
      new OrdinalSales('2015', 50),
      new OrdinalSales('2016', 10),
      new OrdinalSales('2017', 20),
    ];

    final mobileSalesData = [
      new OrdinalSales('2014', 10),
      new OrdinalSales('2015', 15),
      new OrdinalSales('2016', 50),
      new OrdinalSales('2017', 45),
    ];

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Desktop',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: desktopSalesData,
      ),
      new charts.Series<OrdinalSales, String>(
        id: 'Tablet',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: tableSalesData,
      ),
      new charts.Series<OrdinalSales, String>(
        id: 'Mobile',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: mobileSalesData,
      ),
    ];
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}
