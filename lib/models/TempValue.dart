import 'dart:convert';

import 'package:flutter/cupertino.dart';

//MonthReading welcomeFromJson(String str) => MonthReading.fromJson(json.decode(str));

MonthReading convertJsonToTemp(String str) =>
    MonthReading.fromJson(json.decode(str));

String convertTempToJson(MonthReading data) => json.encode(data.toJson());

class MonthReading {
  MonthReading({
    required this.tempValues,
  });

  List<DayReading> tempValues;

  factory MonthReading.fromJson(Map<String, dynamic> json) => MonthReading(
        tempValues: List<DayReading>.from(
            json["readValues"].map((x) => DayReading.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "readValues": List<dynamic>.from(tempValues.map((x) => x.toJson())),
      };

  updateJsonTempData(date, time, value) {
    if (date == "") {
      return;
    }
    debugPrint(
        this.tempValues[this.tempValues.length - 1].sampleDate.toString());

    if (this.tempValues[this.tempValues.length - 1].sampleDate == date) {
      this
          .tempValues[this.tempValues.length - 1]
          .samples
          .add(Sample(time: time, temp: value));
    } else {
      DayReading todayReading = new DayReading(
          sampleDate: date, samples: [Sample(time: time, temp: value)]);
      this.tempValues.add(todayReading);
    }
  }
}

class DayReading {
  DayReading({
    required this.sampleDate,
    required this.samples,
  });

  String sampleDate;
  List<Sample> samples;

  factory DayReading.fromJson(Map<String, dynamic> json) => DayReading(
        sampleDate: json["sampleDate"],
        samples:
            List<Sample>.from(json["samples"].map((x) => Sample.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "sampleDate": sampleDate,
        "samples": List<dynamic>.from(samples.map((x) => x.toJson())),
      };
}

class Sample {
  Sample({
    required this.time,
    required this.temp,
  });

  String time;
  int temp;

  factory Sample.fromJson(Map<String, dynamic> json) => Sample(
        time: json["time"],
        temp: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "time": time,
        "value": temp,
      };
}









/* 
 31 aug 21 - changing to make one file for all multiple data values

*/
/*
// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

//Temperature welcomeFromJson(String str) => Temperature.fromJson(json.decode(str));

Temperature convertJsonToTemp(String str) =>
    Temperature.fromJson(json.decode(str));

String welcomeToJson(Temperature data) => json.encode(data.toJson());

class Temperature {
  Temperature({
    required this.tempValues,
  });

  List<TempValue> tempValues;

  factory Temperature.fromJson(Map<String, dynamic> json) => Temperature(
        tempValues: List<TempValue>.from(
            json["tempValues"].map((x) => TempValue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "tempValues": List<dynamic>.from(tempValues.map((x) => x.toJson())),
      };
}

class TempValue {
  TempValue({
    required this.sampleDate,
    required this.samples,
  });

  String sampleDate;
  List<Sample> samples;

  factory TempValue.fromJson(Map<String, dynamic> json) => TempValue(
        sampleDate: json["sampleDate"],
        samples:
            List<Sample>.from(json["samples"].map((x) => Sample.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "sampleDate": sampleDate,
        "samples": List<dynamic>.from(samples.map((x) => x.toJson())),
      };
}

class Sample {
  Sample({
    required this.time,
    required this.temp,
  });

  String time;
  int temp;

  factory Sample.fromJson(Map<String, dynamic> json) => Sample(
        time: json["time"],
        temp: json["temp"],
      );

  Map<String, dynamic> toJson() => {
        "time": time,
        "temp": temp,
      };
}
*/