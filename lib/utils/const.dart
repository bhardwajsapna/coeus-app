import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class Constants {
  // Name
  static String appName = "Rhinestone";
  static String apiurl = "192.168.0.107"; //71.49"; //0.103"; //173.49";

  // Material Design Color
  static Color lightPrimary = Color(0xFFFFDAC1);
  static Color lightAccent = Color(0xFFFFDAC1);
  static Color lightBackground = Color(0xFFFFDAC1);

  static Color darkPrimary = Colors.black;
  static Color darkAccent = Color(0xFF3B72FF);
  static Color darkBackground = Colors.black;

  static Color grey = Color(0xff707070);
  static Color textPrimary = Color(0xFF486581);
  static Color textDark = Color(0xFF102A43);

  static Color backgroundColor = Color(0xFFF5F5F7);

  // Green
  static Color darkGreen = Color(0xFF3ABD6F);
  static Color lightGreen = Color(0xFFE2F0CB);

  // Yellow
  static Color darkYellow = Color(0xFF3ABD6F);
  static Color lightYellow = Color(0xFFFFDA7A);

  // Blue
  static Color darkBlue = Color(0xFF60A3D9);
  static Color lightBlue = Color(0xFFACE7FF);

  // Orange
  static Color darkOrange = Color(0xFFFFB74D);
  static Color transparent = Color(0x00FFB700);
  static Color white = Color(0xFFFFFFFF);

  static Color musturd = Color(0xffdec68a);
  static Color gray = Color(0xffd3cbc5);
  static Color greendull = Color(0xffcbdec0);
  static Color lightgreendull = Color(0xffd8e8cf);
  static Color dull_move = Color(0xffe7c5b1);
  static Color dull_light_purple = Color(0xffc6cae3);
  static Color dull_blue_gray = Color(0xffa4bbc9);
  static Color dull_light_blue = Color(0xff9ed2e8);

/* 16 jan 22
 this is done while doing ble services */
  static FlutterReactiveBle flutterReactiveBle = FlutterReactiveBle();
  static bool gotoServer = false;
  static String fileUrl = "http://192.168.173.49:5000/file/App_update.bin";
/*
28 Nov 21
ss
List of services for BLE communication
*/ // 18 dec 21 - changed during blore integration work
  static String service_200 = "97fe1000-9e89-00ec-2371-2a2ea5b4d546";
  static String service_100 = "97fe0000-9e89-00ec-2371-2a2ea5b4d546";
  // "97fe6ff7-9e89-40ec-a371-2a2ea5b4d546"; // "97fe0100-9e89-00ec-2371-2a2ea5b4d546";
  static String characteristic_format_100 =
      "97fe0XXX-9e89-00ec-2371-2a2ea5b4d546";
  static String characteristic_format_200 =
      "97fe0XXX-9e89-00ec-2371-2a2ea5b4d546";
  static String character100 = "97fe0100-9e89-00ec-2371-2a2ea5b4d546";
  static String character101 = "97fe0101-9e89-00ec-2371-2a2ea5b4d546";
  static String character102 = "97fe0102-9e89-00ec-2371-2a2ea5b4d546";
  static String character103 = "97fe0103-9e89-00ec-2371-2a2ea5b4d546";
  //"00000103-0000-1000-8000-00805f9b34fb";
  //"97fe0103-9e89-00ec-2371-2a2ea5b4d546";
  static String character104 = "97fe0104-9e89-00ec-2371-2a2ea5b4d546";
  //"00000104-0000-1000-8000-00805f9b34fb";
  static String character105 = "97fe0105-9e89-00ec-2371-2a2ea5b4d546";
  //"00000105-0000-1000-8000-00805f9b34fb";
  static String character106 = "106"; //"97fe0106-9e89-00ec-2371-2a2ea5b4d546";
  // 16 jan 22 -  discuss with quanti on change of this, as the read and write logic at ble has changed, this would be more apt.
  static String character107 = "107"; // "97fe0107-9e89-00ec-2371-2a2ea5b4d546";
  static String character108 = "108"; //"97fe0108-9e89-00ec-2371-2a2ea5b4d546";
//22 mar 22 - discussed with sriharsha
  static String character113 = "113"; // this is for battery charge reading

  static String character200 = "97fe0200-9e89-40ec-a371-2a2ea5b4d546";
  static String character201 = "97fe0201-9e89-40ec-a371-2a2ea5b4d546";
  static String character202 = "97fe0202-9e89-40ec-a371-2a2ea5b4d546";
  static String character203 = "97fe0203-9e89-40ec-a371-2a2ea5b4d546";
  static String character204 = "97fe0204-9e89-40ec-a371-2a2ea5b4d546";
  static String character205 = "97fe0205-9e89-40ec-a371-2a2ea5b4d546";
  static String character206 = "97fe0206-9e89-40ec-a371-2a2ea5b4d546";
  static String character207 = "97fe0207-9e89-40ec-a371-2a2ea5b4d546";
  static String character208 = "97fe0208-9e89-40ec-a371-2a2ea5b4d546";
  static String character209 = "97fe0209-9e89-40ec-a371-2a2ea5b4d546";
  static String character210 = "97fe0210-9e89-40ec-a371-2a2ea5b4d546";
  static String character211 = "97fe0211-9e89-40ec-a371-2a2ea5b4d546";
  static String character212 = "97fe0212-9e89-40ec-a371-2a2ea5b4d546";
  static String character213 = "00000213-0000-1000-8000-00805f9b34fb";
  static String character214 = "97fe0214-9e89-40ec-a371-2a2ea5b4d546";
  static String character215 = "97fe0215-9e89-40ec-a371-2a2ea5b4d546";
  static String character216 = "97fe0216-9e89-40ec-a371-2a2ea5b4d546";
  static String character217 = "97fe0217-9e89-40ec-a371-2a2ea5b4d546";

  /* 18 dec 21
  during the blore integration
  */
  static String deviceName = "COEUS";
  static String ctsService = "00001800-0000-1000-8000-00805f9b34fb";
  static String ctsCharacteristic = "0000282b-0000-1000-8000-00805f9b34fb";
// for implementation of CTS

/*02 Apr 22 => if data to be read from sensor or from file*/

  static bool isdataFromFile = false;

  static late DiscoveredDevice bleDevice;

  static ThemeData lighTheme(BuildContext context) {
    return ThemeData(
      backgroundColor: lightBackground,
      primaryColor: lightPrimary,
      accentColor: lightAccent,
      cursorColor: lightAccent,
      scaffoldBackgroundColor: lightBackground,
      //textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme),
      appBarTheme: AppBarTheme(
        //textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme),
        iconTheme: IconThemeData(
          color: lightAccent,
        ),
      ),
    );
  }

  static double headerHeight = 228.5;
  static double paddingSide = 10.0;

/*
23 aug 21 - sreeni 

below variables are the global variables which are required to be used for api calls
TODO list
they are to be initialised during login page after successfull login.
These data are saved in secure storage. 
*/
  static String userId = '6253249cee722eb8c2d1b166';
  static String deviceId = '123';
}
