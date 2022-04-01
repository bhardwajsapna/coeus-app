import 'package:coeus_v1/appState/loginState.dart';
import 'package:coeus_v1/pages/dashboard.page.dart';
import 'package:coeus_v1/pages/login.page.dart';
import 'package:coeus_v1/pages/newuser.page.dart';
import 'package:coeus_v1/utils/dashboard_secure_storage.dart';
import 'package:coeus_v1/widget/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OpenApp extends StatefulWidget {
  const OpenApp({Key? key}) : super(key: key);

  @override
  _OpenAppState createState() => _OpenAppState();
}

class _OpenAppState extends State<OpenApp> {
  @override
  void initState() {
    super.initState();
    init();
  }

  static Future init() async {
    DashboardSecureStorage.setBattery(50);
    DashboardSecureStorage.setFootsteps(3123);
    DashboardSecureStorage.setSleep(7.5);
    DashboardSecureStorage.setHeartRate(73);
    DashboardSecureStorage.setSpO2(98);
    DashboardSecureStorage.setTemperature(98.2);
    // AdvancedSettingsSecureStorage.setSamplingCommunication("Only BLE");
    // AdvancedSettingsSecureStorage.setSamplingECG("256");
    // AdvancedSettingsSecureStorage.setSamplingTemperature("256");
    // AdvancedSettingsSecureStorage.setSamplingSpO2("256");
    // AdvancedSettingsSecureStorage.setSamplingActivity("256");
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginStateProvider>(builder: (context, data, child) {
      print(data.appState);

      if (data.appState == AppState.LOGIN_FAILURE) {
        //if (true) {
        return Scaffold(
          body: Container(
            alignment: Alignment.center,
            // decoration: BoxDecoration(
            //   gradient: LinearGradient(
            //       begin: Alignment.topRight,
            //       end: Alignment.bottomLeft,
            //       colors: [Constants.white, Constants.lightBlue]),
            // ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                    width: 350,
                    height: 350,
                    image: AssetImage('assets/icons/coeuslogo_elipse.png')),
                Button(
                  nextNavigation: LoginPage(
                    action: 'Login',
                  ),
                  title: "Login",
                ),
                Button(
                  nextNavigation: NewUser(),
                  title: "Signup",
                )
              ],
            ),
          ),
        );
      } else if (data.appState == AppState.LOGIN_SUCCESS) {
        return Dashboard();
      }
      return Center(child: CircularProgressIndicator());
    });
  }
}
