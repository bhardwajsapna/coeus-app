//https://github.com/JohannesMilke/secure_storage_example/blob/master/lib/utils/user_secure_storage.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DeviceInfoSecureStorage {
  static final _storage = FlutterSecureStorage();

  static const _keySerialNumber = 'serialnumber';
  static const _keyFirmwareVersion = 'firmwareversion';
  static const _keyLastUpdated = 'lastupdated';
  static const _keyMACAddress = 'maccaddress';

  static Future setSerialNumber(String val) async {
    print("inuserseecure SerialNumber:" + val);
    await _storage.write(key: _keySerialNumber, value: val);
  }

  static Future<String?> getSerialNumber() async {
    String? temp = await _storage.read(key: _keySerialNumber);
    print("outuserseecure SerialNumber:" + temp!);
    return temp;
  }

  static Future setFirmwareVersion(String val) async {
    print("inuserseecure FirmwareVersion:" + val);
    await _storage.write(key: _keyFirmwareVersion, value: val);
  }

  static Future<String?> getFirmwareVersion() async {
    String? temp = await _storage.read(key: _keyFirmwareVersion);
    print("outuserseecure FirmwareVersion:" + temp!);
    return temp;
  }

  static Future setLastUpdated(DateTime val) async {
    final temp = val.toIso8601String();
    print("in user secure LastUpdated:" + temp);
    await _storage.write(key: _keyLastUpdated, value: temp);
  }

  static Future<DateTime?> getLastUpdated() async {
    String? temp = await _storage.read(key: _keyLastUpdated);
    print("out use secure LastUpdated:" + temp!);
    if (temp == null) {
      return null;
    } else {
      return DateTime.tryParse(temp);
    }
  }

  static Future setMACAddress(String val) async {
    print("inuserseecure MACAddress:" + val);
    await _storage.write(key: _keyMACAddress, value: val);
  }

  static Future<String?> getMACAddress() async {
    String? temp = await _storage.read(key: _keyMACAddress);
    print("outuserseecure MACAddress:" + temp!);
    return temp;
  }
}
