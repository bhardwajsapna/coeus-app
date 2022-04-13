//https://github.com/JohannesMilke/secure_storage_example/blob/master/lib/utils/user_secure_storage.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

class DashboardSecureStorage {
  static final _storage = FlutterSecureStorage();

  static const _keyBattery = 'battery';
  static const _keyFootsteps = 'footsteps';
  static const _keySleep = 'sleep';
  static const _keyHeartRate = 'heartrate';
  static const _keySpO2 = 'spo2';
  static const _keyTemperature = 'temperature';
  static const _keyECG = 'ECG';
  static const _keyLastUpdate = 'lastupdate';

  static Future setLastUpdate(DateTime lastDT) async {
    await _storage.write(key: _keyLastUpdate, value: lastDT.toString());
    print("in last update:" + lastDT.toString());
  }

  static Future getLastUpdate() async {
    String? lastDT = await _storage.read(key: _keyLastUpdate);
    print("out last update:" + lastDT!);

    return (DateFormat('dd-MM-yyyy HH-mm-ss').format(DateTime.parse(lastDT)))
        .toString();
  }

  static Future setBattery(int battery) async {
    await _storage.write(key: _keyBattery, value: battery.toString());
    print("in battery:" + battery.toString());
  }

  static Future<int> getBattery() async {
    String? temp = await _storage.read(key: _keyBattery);
    print("out battery:" + temp!);
    return int.parse(temp);
  }

  static Future setFootsteps(int footsteps) async {
    await _storage.write(key: _keyFootsteps, value: footsteps.toString());
    print("in footsteps:" + footsteps.toString());
  }

  static Future<int> getFootsteps() async {
    String? temp = await _storage.read(key: _keyFootsteps);
    print("out footsteps:" + temp!);
    return int.parse(temp);
  }

  static Future setSleep(double sleep) async {
    await _storage.write(key: _keySleep, value: sleep.toString());
    print("in sleep:" + sleep.toString());
  }

  static Future<double> getSleep() async {
    String? temp = await _storage.read(key: _keySleep);
    print("out sleep:" + temp!);
    return double.parse(temp);
  }

  static Future setHeartRate(int heartrate) async {
    await _storage.write(key: _keyHeartRate, value: heartrate.toString());
    print("in heartrate:" + heartrate.toString());
  }

  static Future<int> getHeartRate() async {
    String? temp = await _storage.read(key: _keyHeartRate);
    print("out heartrate:" + temp!);
    return int.parse(temp);
  }

  static Future setSpO2(int spo2) async {
    await _storage.write(key: _keySpO2, value: spo2.toString());
    print("in spo2:" + spo2.toString());
  }

  static Future<int> getSpO2() async {
    String? temp = await _storage.read(key: _keySpO2);
    print("out spo2:" + temp!);
    return int.parse(temp);
  }

  static Future setTemperature(double temperature) async {
    await _storage.write(key: _keyTemperature, value: temperature.toString());
    print("in temperature:" + temperature.toString());
  }

  static Future<double> getTemperature() async {
    String? temp = await _storage.read(key: _keyTemperature);
    print("out temperature:" + temp!);
    return double.parse(temp);
  }
}
