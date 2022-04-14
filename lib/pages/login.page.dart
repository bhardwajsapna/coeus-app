import 'dart:convert';

import 'package:coeus_v1/services/api.dart';
import 'package:coeus_v1/utils/dashboard_secure_storage.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:coeus_v1/widget/button.dart';
import 'package:coeus_v1/widget/first.dart';
import 'package:coeus_v1/widget/inputEmail.dart';
import 'package:coeus_v1/widget/textLogin.dart';

import 'dashboard.page.dart';
import 'package:coeus_v1/utils/const.dart';
import 'package:coeus_v1/utils/user_secure_storage.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  String action = "";
  LoginPage({required this.action});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final controllerUserName = TextEditingController();
  final controllerPassword = TextEditingController();
  String? uname;
  String? password;
  static const validSymbols = "!\"#\$%&'()*+,-./:;<=>?@[\\]^_`{|}~";
  bool isPassLong = false;
  bool isPassNumber = false;
  bool isPassSymbol = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    print("=----widget-action----" + widget.action);
    if (widget.action == 'logout') {
      await UserSecureStorage.logOut();
    } else {
      String? password = await UserSecureStorage.getPassword() ?? 'admin';
      String? uname = await UserSecureStorage.getEmailId() ?? 'admin';
      setState(() {
        this.uname = uname;
        this.password = password;
        print("uname:" + this.uname!);
      });
    }
  }

  bool passIsValid(String value) {
    String pattern =
        '^(?=.*?[a-zA-Z])(?=.*?[0-9])(?=.*?[$validSymbols]).{5,}\$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  bool passHaveNumber(String value) {
    String pattern = r'^(?=.*?[0-9]).{1,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  bool passHaveSymbol(String value) {
    String pattern = '^(?=.*?[$validSymbols]).{1,}\$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  void onLoginSubmit() async {
    if (_formKey.currentState!.validate()) {
      bool isvalid = false;
      // check from internal storage
      if (this.uname == controllerUserName.text) {
        if (this.password == controllerPassword.text) {
          isvalid = true;
          print("success");
        } else {
          isvalid = false;
        }
      } else {
        isvalid = false;
      }
      // check from server
      if (isvalid == false) {
        var requestParams = {
          "userName": controllerUserName.text,
          "password": controllerPassword.text
        };
        http.Response response;
        response = await appLogin(requestParams);
        print(response.body.toString());
        var decodedJson = jsonDecode(response.body);
        print(decodedJson);
        print(decodedJson["result"]);
        if (decodedJson["result"] == "success") {
          isvalid = true;
          await UserSecureStorage.setFirstName(decodedJson["firstName"]);
          await UserSecureStorage.setUserID(decodedJson["userId"]);
          await UserSecureStorage.setPassword(controllerPassword.text);
          await UserSecureStorage.setEmailId(controllerUserName.text);

          print(await UserSecureStorage.getFirstName());

          //14 apr 22 - so that dash board display dummy reading
          await DashboardSecureStorage.setBattery(50);
          await DashboardSecureStorage.setFootsteps(3123);
          await DashboardSecureStorage.setSleep(7.5);
          await DashboardSecureStorage.setHeartRate(73);
          await DashboardSecureStorage.setSpO2(98);
          await DashboardSecureStorage.setTemperature(98.2);
          var lastDT = DateTime.now();
          print("last dt" + lastDT.toString());
          await DashboardSecureStorage.setLastUpdate(lastDT);
        }
      }
      if (isvalid) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Dashboard()));
      } else {
        controllerUserName.text = "";
        controllerPassword.text = "";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      alignment: Alignment.center,
      // decoration: BoxDecoration(
      //   gradient: LinearGradient(
      //       begin: Alignment.topRight,
      //       end: Alignment.bottomLeft,
      //       colors: [Constants.white, Constants.lightBlue]),
      // ),
      child: Container(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              //SizedBox(height: 10),
              Image(
                  width: 250,
                  height: 250,
                  image: AssetImage('assets/icons/coeuslogo_elipse.png')),
              //      TextWrapper(textstr: "Coeus", font: 34),
              InputField(
                title: "Email-id",
                font: 24,
                isPassword: false,
                controller: controllerUserName,
                validator: (email) {
                  return EmailValidator.validate(email!)
                      ? null
                      : "Invalid email address";
                },
              ),
              InputField(
                title: "Password",
                font: 24,
                isPassword: true,
                controller: controllerPassword,
                onChanged: (val) {
                  setState(() {
                    controllerPassword.text.length > 5
                        ? isPassLong = true
                        : isPassLong = false;
                    passHaveNumber(controllerPassword.text)
                        ? isPassNumber = true
                        : isPassNumber = false;
                    passHaveSymbol(controllerPassword.text)
                        ? isPassSymbol = true
                        : isPassSymbol = false;
                  });
                },
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return 'Please enter password';
                  }
/*
23 oct 21 - sreeni
i dont think this check is required here.
*/
                  /*       if (!passIsValid(controllerPassword.text)) {
                    return 'Password must be at least 5 characters long and consist of letters, numbers and symbols';
                  }
                  */
                },
              ),
              Button(
                title: "Login",
                onTapFunction: onLoginSubmit,
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
