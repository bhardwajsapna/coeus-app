//https://github.com/JohannesMilke/secure_storage_example/blob/master/lib/utils/user_secure_storage.dart
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AdvancedSettingsSecureStorage {
  static final _storage = FlutterSecureStorage();

  static const _keySamplingCommunication = 'samplingcommunication';
  static const _keySamplingSpO2 = 'samplingspo2';
  static const _keySamplingECG = 'samplingECG';
  static const _keySamplingTemperature = 'samplingtemperature';
  static const _keySamplingActivity = 'samplingactivity';
  static const _keyMonitorAfter = 'monitorafter';

  static Future setMonitorAfter(String val) async {
    print("inuserseecure MonitorAfter:" + val);
    await _storage.write(key: _keyMonitorAfter, value: val);
  }

  static Future<String?> getMonitorAfter() async {
    String? temp = await _storage.read(key: _keyMonitorAfter);
    print("outuserseecure MonitorAfter:" + temp!);
    return temp;
  }

  static Future setSamplingCommunication(String val) async {
    print("inuserseecure SamplingCommunication:" + val);
    await _storage.write(key: _keySamplingCommunication, value: val);
  }

  static Future<String?> getSamplingCommunication() async {
    String? temp = await _storage.read(key: _keySamplingCommunication);
    print("outuserseecure SamplingCommunication:" + temp!);
    return temp;
  }

  static Future setSamplingSpO2(String val) async {
    print("inuserseecure SamplingSpO2:" + val);
    await _storage.write(key: _keySamplingSpO2, value: val);
  }

  static Future<String?> getSamplingSpO2() async {
    String? temp = await _storage.read(key: _keySamplingSpO2);
    print("outuserseecure SamplingSpO2:" + temp!);
    return temp;
  }

  static Future setSamplingECG(String val) async {
    print("inuserseecure SamplingECG :" + val);
    await _storage.write(key: _keySamplingECG, value: val);
  }

  static Future<String?> getSamplingECG() async {
    String? temp = await _storage.read(key: _keySamplingECG);
    print("outuserseecure SamplingECG :" + temp!);
    return temp;
  }

  static Future setSamplingTemperature(String val) async {
    print("inuserseecure SamplingTemperature:" + val);
    await _storage.write(key: _keySamplingTemperature, value: val);
  }

  static Future<String?> getSamplingTemperature() async {
    String? temp = await _storage.read(key: _keySamplingTemperature);
    print("outuserseecure SamplingTemperature:" + temp!);
    return temp;
  }

  static Future setSamplingActivity(String val) async {
    print("inuserseecure SamplingActivity:" + val);
    await _storage.write(key: _keySamplingActivity, value: val);
  }

  static Future<String?> getSamplingActivity() async {
    String? temp = await _storage.read(key: _keySamplingActivity);
    print("outuserseecure SamplingActivity:" + temp!);
    return temp;
  }
}
