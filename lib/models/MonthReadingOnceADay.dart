import 'dart:convert';

MonthReadingOnceADay convertJsonToMonthReadingOnceADay(String str) =>
    MonthReadingOnceADay.fromJson(json.decode(str));

String convertMonthReadingOnceADayToJson(MonthReadingOnceADay data) =>
    json.encode(data.toJson());

class MonthReadingOnceADay {
  MonthReadingOnceADay({required this.dayValues});

  List<DayValues> dayValues;

  factory MonthReadingOnceADay.fromJson(Map<String, dynamic> json) =>
      MonthReadingOnceADay(
          dayValues: List<DayValues>.from(
              json["dayValues"].map((x) => DayValues.fromJson(x))));

  Map<String, dynamic> toJson() => {
        "dayValues": List<dynamic>.from(dayValues.map((e) => e.toJson())),
      };

  updateJsonDayData(date, value) {
    if (date == "") {
      return;
    }
/*
data value for the day is expected and not delta - was discussed with sriharsh.
Therefore we are doing the direct assignment and not adding the steps.
*/
    if (this.dayValues[this.dayValues.length - 1].sampleDate == date) {
      this.dayValues[this.dayValues.length - 1].stepsCount = value[0];
      this.dayValues[this.dayValues.length - 1].sleepHrs = value[1];
    } else {
      DayValues todayValues = new DayValues(
          sampleDate: date, stepsCount: value[0], sleepHrs: value[1]);
      this.dayValues.add(todayValues);
      if (this.dayValues.length > 30) {
        this.dayValues.removeAt(0);
      }
    }
  }
}

class DayValues {
  String sampleDate;
  int stepsCount;
  String sleepHrs;

  DayValues(
      {required this.sampleDate,
      required this.stepsCount,
      required this.sleepHrs});

  factory DayValues.fromJson(Map<String, dynamic> json) => DayValues(
      sampleDate: json['sampleDate'],
      stepsCount: json['stepsCount'],
      sleepHrs: json['sleepHrs']);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sampleDate'] = this.sampleDate;
    data['stepsCount'] = this.stepsCount;
    data['sleepHrs'] = this.sleepHrs;
    return data;
  }
}
