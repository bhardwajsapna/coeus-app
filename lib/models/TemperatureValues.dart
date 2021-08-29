// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Temperature welcomeFromJson(String str) =>
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