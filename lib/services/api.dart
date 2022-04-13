import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:coeus_v1/utils/const.dart' as globalAccess;

Future<http.Response> createUserAPIService(requestParams) async {
  print(requestParams);
  print(jsonEncode(requestParams));
  String url_add = globalAccess.Constants.apiurl;
  if (globalAccess.Constants.gotoServer) {
    final response =
        await http.post(Uri.parse('http://$url_add:5000/userRegistration'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(requestParams));
    print("final json is this" + response.body);

    return response;
  } else {
    Fluttertoast.showToast(
        msg: "web service disabled",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        fontSize: 16.0);
    return (http.Response(
        jsonEncode(
            {"id": "61eda919dc0561cc199604b8", "result": "dummy response"}),
        200));
  }
}

Future<http.Response> updateProfileAPIService(requestParams) async {
  print(requestParams);
  String url = globalAccess.Constants.apiurl;
  if (globalAccess.Constants.gotoServer) {
    final response = await http.post(
        Uri.parse('http://$url:5000/updateUserProfile?userId=' +
            globalAccess.Constants.userId),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestParams));
    print(response.body);
    return response;
  } else {
    return (http.Response('Hello, world!', 200));
  }
}

Future<http.Response> updateEmergencyContactAPIService(requestParams) async {
  print(requestParams);
  String url = globalAccess.Constants.apiurl;
  if (globalAccess.Constants.gotoServer) {
    final response = await http.post(
        Uri.parse('http://$url:5000/updateEmergencyContact?userId=' +
            globalAccess.Constants.userId),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestParams));
    print(response.body);
    return response;
  } else {
    return (http.Response('Hello, world!', 200));
  }
}

Future<http.Response> updateCaregiverDetailsAPIService(requestParams) async {
  print(requestParams);
  String url = globalAccess.Constants.apiurl;
  if (globalAccess.Constants.gotoServer) {
    final response = await http.post(
        Uri.parse('http://$url:5000/updateCaregiverDetails?userId=' +
            globalAccess.Constants.userId),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestParams));
    print(response.body);
    return response;
  } else {
    return (http.Response('Hello, world!', 200));
  }
}

Future<http.Response> updateAdvancedSettingsAPIService(requestParams) async {
  print(requestParams);
  String url = globalAccess.Constants.apiurl;
  if (globalAccess.Constants.gotoServer) {
    final response = await http.post(
        Uri.parse('http://$url:5000/updateSamplingRateSettings?deviceId=' +
            globalAccess.Constants.deviceId),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestParams));
    print(response.body);
    return response;
  } else {
    return (http.Response('Hello, world!', 200));
  }
}

Future<http.Response> updateUserSampleReadingsAPIService(requestParams) async {
  print(requestParams);
  String url = globalAccess.Constants.apiurl;
  if (globalAccess.Constants.gotoServer) {
    final response = await http.post(
        Uri.parse('http://$url:5000/updateUserSampleReadings?userId=' +
            globalAccess.Constants.userId),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestParams));
    print(response.body);
    return response;
  } else {
    return (http.Response('server not updated', 200));
  }
}
