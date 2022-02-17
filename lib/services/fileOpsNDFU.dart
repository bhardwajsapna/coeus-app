import 'dart:io';

import 'package:coeus_v1/utils/const.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nordic_dfu/flutter_nordic_dfu.dart';
import 'package:path_provider/path_provider.dart';

Future downloadFile() async {
  try {
    Dio dio = Dio();
    String savePath = "";
    String fileName =
        Constants.fileUrl.substring(Constants.fileUrl.lastIndexOf("/") + 1);

    debugPrint("filename = " + fileName);

    savePath = await getFilePath(fileName);
    debugPrint("save path" + savePath);
    await dio.download(Constants.fileUrl, savePath,
        onReceiveProgress: (rec, total) {
      debugPrint("rec and total" + rec.toString() + " " + total.toString());
    });
    return (savePath);
  } catch (e) {
    print(e.toString());
  }
  return ("");
}

Future<String> getFilePath(uniqueFileName) async {
  String path = '';

  Directory dir = await getApplicationDocumentsDirectory();

  path = '${dir.path}/$uniqueFileName';

  return path;
}

Future<void> doDfu(String deviceId) async {
  // stopScan();
  //dfuRunning = true;
  try {
    // deviceId,
    debugPrint("started uploading");
    var s = await FlutterNordicDfu.startDfu(
      'FB:36:25:8F:DC:4D',
      'assets/dfu_application_0d.zip',
      fileInAsset: true,
      forceDfu: true,
      enableUnsafeExperimentalButtonlessServiceInSecureDfu: true,
      progressListener:
          DefaultDfuProgressListenerAdapter(onProgressChangedHandle: (
        deviceAddress,
        percent,
        speed,
        avgSpeed,
        currentPart,
        partsTotal,
      ) {
        print('deviceAddress: $deviceAddress, percent: $percent');
        debugPrint('deviceAddress: $deviceAddress, percent: $percent');
      }),
    );
    print(s);
    debugPrint(s);
    // dfuRunning = false;
  } catch (e) {
    // dfuRunning = false;
    print(e.toString());
  }
}
