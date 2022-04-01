import 'dart:collection';
import 'dart:io';

import 'package:coeus_v1/models/BioValues.dart';
import 'package:coeus_v1/models/TempValue.dart';
import 'package:coeus_v1/utils/const.dart';
import 'package:coeus_v1/widget/SimpleBarChart.dart';
import 'package:coeus_v1/widget/button.dart';
import 'package:coeus_v1/widget/textLogin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/services.dart' show rootBundle;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';

import '../widget/StackedLineChart.dart';

class Detailed_Card extends StatefulWidget {
  final String title;
  Detailed_Card({
    required this.title,
  });
  @override
  _Detailed_CardState createState() => _Detailed_CardState();
}

class _Detailed_CardState extends State<Detailed_Card> {
  MonthReading? chartData;

  ChartSeriesController? _chartSeriesController;

  late List<Sensor> listdata;
  late Map<int, List<Sensor>> listMap = HashMap();
  int count = 0;
  String key = 'samples';
  List<int>? key_data;
  Timer? timer;
  List<charts.Series<Sensor, int>> seriesList = [];
  bool isfirstLoading = true;
  int ndays = 7;
  int minY = 0;
  int maxY = 0;
  String baseDir = "";
  Future loadDataFromJson() async {}

  Future loadSensorData(int days) async {
/*add on 27 mar while moving file from asset to directory
*/
    Directory? directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationSupportDirectory();

    baseDir = "${directory!.path}"; //"assets"; //${directory!.path}";

    /*
    22 aug - check the button which has called this page. Accordingly the file will be called.
    should graph show 1 day or 1 month.?  
    */
    final String jsonString = await getJsonFromAssets();

    debugPrint("Data is " + jsonString);

    chartData = convertJsonToTemp(jsonString);

    //setState(() {
    seriesList.add(new charts.Series<Sensor, int>(
      id: 'Temprature',
      colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      domainFn: (Sensor temp, _) => temp.point,
      measureFn: (Sensor temp, _) => temp.value,
      data: get_data(days),
    ));
    seriesList.add(new charts.Series<Sensor, int>(
      id: 'Temprature',
      colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
      domainFn: (Sensor temp, _) => temp.point,
      measureFn: (Sensor temp, _) => temp.value,
      data: get_dataMin(days),
    ));
    //  });
  }

  Future<String> getJsonFromAssets() async {
    String fileName = "";
    switch (widget.title) {
      case "Temperature":
        fileName = baseDir + '/tempRecords.json';
        break;
      case "SpO2":
        fileName = baseDir + '/spo2Records.json';
        break;
      case "Heart Rate":
        fileName = baseDir + '/bpmRecords.json';
        break;
      case "ECG":
        fileName = baseDir + '/tempRecords.json';
        break;
      case "Footsteps":
      case "Sleep":
        fileName = baseDir + '/stepsSleepRecords.json';
        break;

      default:
        fileName = baseDir + '/tempRecords.json';
    }
    File jsonFile = new File(fileName);
    // 27 mar - reading file data from dir
    debugPrint(fileName);
    //   debugPrint(jsonFile.readAsStringSync());
    //   return jsonFile.readAsStringSync();
//   readin file data from assets
    return (await jsonFile.readAsString());

    //return await rootBundle.loadString(fileName);
  }

  dynamic render_chart(int ndays) async {
   Directory? directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationSupportDirectory();

    //baseDir = "assets";
    baseDir = "${directory!.path}";
    
    if (true) {
      //(isfirstLoading) {
      String fileName = "";
      switch (widget.title) {
        case "Temperature":
          fileName = baseDir + '/tempRecords.json';
          minY = 25;
          maxY = 50;
          break;
        case "SpO2":
          fileName = baseDir + '/spo2Records.json';
          minY = 50;
          maxY = 100;

          break;
        case "Heart Rate":
          fileName = baseDir + '/bpmRecords.json';
          minY = 50;
          maxY = 140;

          break;
        case "ECG":
          fileName = baseDir + '/tempRecords.json';
          break;
        default:
          fileName = baseDir + '/tempRecords.json';
      }
      
     // String jsonData = await rootBundle.loadString(fileName);
      
      // 27 mar - reading file data from dir
      debugPrint(fileName + " n days =" + ndays.toString());
      File jsonFile = new File(fileName);
      //   readin file data from file struct
      String jsonData = await jsonFile.readAsString();

      // setState(() {
      chartData = convertJsonToTemp(jsonData);
      isfirstLoading = false;
      // });
    }
    
   // setState(() {
    seriesList = [];
    seriesList.add(new charts.Series<Sensor, int>(
      id: 'LineGraph',
      colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      domainFn: (Sensor temp, _) => temp.point,
      measureFn: (Sensor temp, _) => temp.value,
      data: get_data(ndays),
    ));
    seriesList.add(new charts.Series<Sensor, int>(
      id: 'LineGraph',
      colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
      domainFn: (Sensor temp, _) => temp.point,
      measureFn: (Sensor temp, _) => temp.value,
      data: get_dataMin(ndays),
    ));
    // });
    return seriesList;
  }

  @override
  void initState() {
    super.initState();
    // loadDataFromJson();
    loadSensorData(7);
  }

  List<Sensor> get_data(int days) {
    List<Sensor> l = [];
    debugPrint("in get_data");
/*
1.  user has given ndays.
2.  file may have less or more data than days given.
3.  check the quantity of data available in chartdata ( it contains max data from file)
4.  provide the max data graph depending on availability and ndays 
    ie.
    if we have 3 days of data and user asked for 7 days or 15 days or 30 days 
        provide for 3 days.
    if we have enough data as asked then provide what ever has been asked for.

    if there is no data then provide appropriate msg to user.
5.  this has to be done for both max and min reading of data
6.  Graph should display the data as provided here.
*/

    var startIndex = 0;
    var endIndex = 0;
    var chartDataLen = chartData!.tempValues.length;
    debugPrint("chart data len" + chartDataLen.toString());
    if (chartDataLen >= days) {
      startIndex = chartDataLen - days;
      endIndex = chartDataLen;
    } else {
      startIndex = 0;
      endIndex = chartDataLen;
    }
    for (int i = startIndex; i < endIndex; i++) {
      final data = chartData!.tempValues[i];

      int max = 0;
      debugPrint("data samples" + data.samples.length.toString());
      if (data.samples != null && data.samples.isNotEmpty) {
        data.samples.sort((a, b) => a.temp.compareTo(b.temp));
        max = data.samples.last.temp;
      }
      l.add(Sensor(value: max, point: i - startIndex + 1));

      debugPrint(l.length.toString() +
          (i - startIndex + 1).toString() +
          " is the length of max debug");
    }

    // changes made for fixing the graph min an max bug - 22 oct 21
    /*  for (int i = math.max(0, chartData!.tempValues.length - days);
        i < chartData!.tempValues.length;
        i++) {
      final data = chartData!.tempValues[i];
      int max = 0;
      if (data.samples != null && data.samples.isNotEmpty) {
        data.samples.sort((a, b) => a.temp.compareTo(b.temp));
        max = data.samples.last.temp;
      }

      l.add(Sensor(value: max, point: 30 - i));
      print(l.length);
    }*/
    return l;
  }

  List<Sensor> get_dataMin(int days) {
    List<Sensor> l = [];
    debugPrint("in get data min");
    var startIndex = 0;
    var endIndex = 0;
    var chartDataLen = chartData!.tempValues.length;
    if (chartDataLen >= days) {
      startIndex = chartDataLen - days;
      endIndex = chartDataLen;
    } else {
      startIndex = 0;
      endIndex = chartDataLen;
    }

    for (int i = startIndex; i < endIndex; i++) {
      final data = chartData!.tempValues[i];
      int min = 0;
      if (data.samples != null && data.samples.isNotEmpty) {
        data.samples.sort((a, b) => a.temp.compareTo(b.temp));
        min = data.samples.first.temp;
      }

      l.add(Sensor(value: min, point: i - startIndex + 1));
      debugPrint(l.length.toString() +
          (i - startIndex + 1).toString() +
          " is min data return");
    }
/*
    for (int i = math.max(0, chartData!.tempValues.length - days);
        i < chartData!.tempValues.length;
        i++) {
      final data = chartData!.tempValues[i];
      int min = 0;
      if (data.samples != null && data.samples.isNotEmpty) {
        data.samples.sort((a, b) => a.temp.compareTo(b.temp));
        min = data.samples.first.temp;
      }
      l.add(Sensor(value: min, point: 30 - i));
      print(l.length);
    }
    */
    return l;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        SizedBox(
          height: 50,
        ),
        TextWrapper(textstr: widget.title, font: 28),
        TextWrapper(textstr: ndays.toString() + " days details", font: 22),
        Container(
          // height: MediaQuery.of(context).size.height / 3,
          child: FutureBuilder(
              future: render_chart(ndays),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: StackedLineChart(
                        seriesList,
                        animate: false,
                        minY: this.minY,
                        maxY: this.maxY,
                        ndays: ndays,
                      ));
                } else {
                  return Card(
                      elevation: 5.0,
                      child: Container(
                        height: 100,
                        width: 400,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text('Retriving JSON data...',
                                  style: TextStyle(fontSize: 20.0)),
                              Container(
                                height: 40,
                                width: 40,
                                child: CircularProgressIndicator(
                                  semanticsLabel: 'Retriving JSON data',
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.blueAccent),
                                  backgroundColor: Colors.grey[300],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ));
                }
              }),
        ),
        /*
            ns on 08 aug 21
            these buttons were added so that the content of the graph can be changed as per user request
            update the graph
            */

        /*
            1 , 7 15 => title , no ofdays
            1 day by default for title , 1
            */
        Button(
          onTapFunction: () => {
            setState(() {
              ndays = 7;
            })
          },
          title: "7 Days",
          width: MediaQuery.of(context).size.width,
          baseColor: Color(0xffeff3d0),
        ),
        Button(
          onTapFunction: () => {
            setState(() {
              ndays = 15;
            })
          },
          title: "15 Days",
          width: MediaQuery.of(context).size.width,
          baseColor: Color(0xffd6eeee),
        ),
        Button(
          onTapFunction: () => {
            setState(() {
              ndays = 30;
            })
          },
          title: "1 Month",
          width: MediaQuery.of(context).size.width,
          baseColor: Color(0xffdde3f3),
        ),
        Button(
          onTapFunction: () => {Navigator.pop(context)},
          title: "Done",
          width: MediaQuery.of(context).size.width,
          baseColor: Constants.dull_blue_gray,
        )
      ],
    ));
  }
}

class Sensor {
  int value;
  int point;

  Sensor({required this.value, required this.point});
}
