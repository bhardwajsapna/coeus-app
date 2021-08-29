import 'dart:collection';

import 'package:coeus_v1/models/BioValues.dart';
import 'package:coeus_v1/models/TemperatureValues.dart';
import 'package:coeus_v1/widget/StackedBarChart.dart';
import 'package:coeus_v1/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/services.dart' show rootBundle;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';

class Detailed_Card extends StatefulWidget {
  @override
  _Detailed_CardState createState() => _Detailed_CardState();
}

class _Detailed_CardState extends State<Detailed_Card> {
  Temperature? chartData;
  ChartSeriesController? _chartSeriesController;
  late List<Temprature> listdata;
  late Map<int, List<Temprature>> listMap = HashMap();
  int count = 0;
  String key = 'samples';
  List<int>? key_data;
  Timer? timer;
  List<charts.Series<Temprature, String>> seriesList = [];

  Future loadSalesData() async {
    /*
    22 aug - check the button which has called this page. Accordingly the file will be called.
    should graph show 1 day or 1 month.?  
    */
    final String jsonString = await getJsonFromAssets();
    chartData = welcomeFromJson(jsonString);
    // listdata = get_data(key);
    for (int i = 0; i < chartData!.tempValues.length; i++) {
      listMap.putIfAbsent(i, () => get_data(i));
    }

    //count = listdata.length;

    // seriesList = [
    //   new charts.Series<Temprature, String>(
    //     id: 'Temprature',
    //     domainFn: (Temprature sales, _) => sales.time,
    //     measureFn: (Temprature sales, _) => sales.temperature,
    //     data: listdata,
    // )
    // ];

    for (int i = 0; i < chartData!.tempValues.length; i++) {
      seriesList.add(new charts.Series<Temprature, String>(
        id: 'Temprature',
        domainFn: (Temprature sales, _) => sales.time,
        measureFn: (Temprature sales, _) => sales.temperature,
        data: listMap[i]!.toList(),
      ));
    }

    //key_data = chartData!.tempValues![key].sampleDate;
    //timer = Timer.periodic(const Duration(milliseconds: 10), addChartData);
  }

  Future<String> getJsonFromAssets() async {
// this is new code
    return await rootBundle.loadString('assets/tempRecords.json');
// this is old code
    return await rootBundle.loadString('assets/data.json');
  }

  @override
  void initState() {
    super.initState();
    loadSalesData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  // void addChartData(Timer timer) {
  //   setState(() {
  //     data!.removeAt(0);
  //     data!.add(Point(
  //         timestamp: count.toString(), value: key_data!.elementAt(count)));
  //     count = count + 1;
  //   });
  // }

  List<Temprature> get_data(int key) {
    final data = chartData!.tempValues[key];

    List<Temprature> l = [];
    for (int i = 0; i < data.samples.length; i++) {
      l.add(Temprature(
          temperature: data.samples[i].temp, time: data.samples[i].time));
    }
    print(l.length);
    return l;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Data Chart'),
        ),
        body: Column(
          children: [
            Container(
              height: 300,
              child: FutureBuilder(
                  future: getJsonFromAssets(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return SizedBox(
                          height: 400.0,
                          child: StackedBarChart(seriesList, animate: false));
                      // return SfCartesianChart(
                      //     primaryXAxis: CategoryAxis(),
                      //     // Chart title
                      //     title: ChartTitle(text: 'Data plotting'),
                      //     series: <ChartSeries<Point, String>>[
                      //       LineSeries<Point, String>(
                      //         onRendererCreated:
                      //             (ChartSeriesController controller) {
                      //           _chartSeriesController = controller;
                      //         },
                      //         dataSource: data!,
                      //         xValueMapper: (Point p, _) => p.timestamp,
                      //         yValueMapper: (Point p, _) => p.value,
                      //       )
                      //     ]);
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
                        ),
                      );
                    }
                  }),
            ),
            /*
            ns on 08 aug 21
            these buttons were added so that the content of the graph can be changed as per user request
            update the graph
            */
            Button(
              onTapFunction: () => {Navigator.pop(context)},
              title: "1 Day",
              // width: 40,
              width: MediaQuery.of(context).size.width,
            ),
            Button(
              onTapFunction: () => {Navigator.pop(context)},
              title: "7 Days",
              //width: 25, // this has tobe dne approrrri
              width: MediaQuery.of(context).size.width,
            ),
            /* Button(
              onTapFunction: () => {Navigator.pop(context)},
              title: "15 Day",
              width: MediaQuery.of(context).size.width,
            ),
            */
            Button(
              onTapFunction: () => {Navigator.pop(context)},
              title: "1 Month",
              width: MediaQuery.of(context).size.width,
            ),
            /* Button(
              onTapFunction: () => {Navigator.pop(context)},
              title: "OK",
              width: MediaQuery.of(context).size.width,
            )
            */
          ],
        ));
  }
}

class Temprature {
  int temperature;
  String time;

  Temprature({required this.temperature, required this.time});
}
