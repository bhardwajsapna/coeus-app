import 'package:coeus_v1/utils/const.dart';
import 'package:coeus_v1/utils/user_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:coeus_v1/widget/button.dart';
import 'package:coeus_v1/widget/inputEmail.dart';
import 'package:coeus_v1/widget/textLogin.dart';
import 'package:coeus_v1/widget/date_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

import 'package:intl/intl.dart';
/*
23 aug 21 - sreeni
*/
import 'package:coeus_v1/services/api.dart';

class PersonalProfilePage extends StatefulWidget {
  Color color;
  PersonalProfilePage(this.color);
  @override
  _PersonalProfilePageState createState() => _PersonalProfilePageState();
}

class _PersonalProfilePageState extends State<PersonalProfilePage> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final ScrollController _scrollController = new ScrollController();
//06 aug 21 - ns
// email cannot be edited and password can be changed
//  final controllerEmailid = TextEditingController();
  final controllerFirstName = TextEditingController();
  final controllerSecondName = TextEditingController();
  final controllerMobileNumber = TextEditingController();
  // ss - 29 sep 21 - removed the password display
  //final controllerPassword = TextEditingController();
  // added this new controller for DOB for get and set - 24 aug 21
  final controllerDob = TextEditingController();
  late DateTime selectedDate = DateTime.now();

/*
23 aug 21 - sreeni
*/
  late Future<http.Response> response;

//30 aug 21 - ns
  bool isNameLong = false;
  bool isSecNameLong = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    //06 aug 21 - ns
// email cannot be edited and password can be changed
//    final emailid = await UserSecureStorage.getEmailId() ?? "";
    final fname = await UserSecureStorage.getFirstName() ?? "";
    final sname = await UserSecureStorage.getSecondName() ?? "";
    final mobilenumber = await UserSecureStorage.getMobileNumber() ?? "";
    final password = await UserSecureStorage.getPassword() ?? "";
    // added this new controller for DOB for get and set - 24 aug 21
    final dob = await UserSecureStorage.getDOB() ?? "";
    final f = new DateFormat('yyyy-MM-dd');

    selectedDate = DateTime.parse(dob.toString());

    setState(() {
      print("personal.profile.page:" + fname);
      //06 aug 21 - ns
// email cannot be edited and password can be changed
//    this.controllerEmailid.text = emailid;
      this.controllerFirstName.text = fname;
      this.controllerSecondName.text = sname;
      this.controllerMobileNumber.text = mobilenumber;
      // ss - 29 sep 21 - removed the password display
      // this.controllerPassword.text = password;
      // added this new controller for DOB for get and set - 24 aug 21
      this.controllerDob.text = dob.toString();
    });
  }

  Future<http.Response> updateProfileService() async {
    var requestParams = {
      "firstName": this.controllerFirstName.text,
      "secondName": this.controllerSecondName.text,
      "mobileNo": this.controllerMobileNumber.text,
      "DOB": this.controllerDob.text,
      // ss - 29 sep 21 - removed the password display
      //  "password": this.controllerPassword.text
    };
    print(requestParams);
    response = updateProfileAPIService(requestParams);
    print(response);
    return response;
  }

  onUpdate() async {
    print("outside val");
    //_key.currentState!.validate()
    if (isNameLong && isSecNameLong) {
      print("inside val");

      await UserSecureStorage.setFirstName(controllerFirstName.text);
      await UserSecureStorage.setSecondName(controllerSecondName.text);
      await UserSecureStorage.setMobileNumber(controllerMobileNumber.text);
      // ss - 29 sep 21 - removed the password display
      //   await UserSecureStorage.setPassword(controllerPassword.text);
      await UserSecureStorage.setDOB(DateTime.tryParse(controllerDob.text));

      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Are you sure you want to update these details?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                updateProfileService();
                Navigator.pop(context, 'OK');
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // 30 aug 21 - if first and second name are not correct
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Data Error'),
          content: const Text(
              'First Name and Second Name should be more than 2 characters.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'OK');
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1940),
            lastDate: DateTime(2022)) // current year and not hardcoding
        .then((pickedDate) => {
              if (pickedDate != null)
                {
                  setState(() {
                    selectedDate = pickedDate;
                  })
                }
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.05),
        TextWrapper(
            textstr: "Personal Info",
            font: MediaQuery.of(context).size.height * 0.05),
        Container(
          height: MediaQuery.of(context).size.height * 0.8,
          // decoration: BoxDecoration(
          // gradient: LinearGradient(
          //     begin: Alignment.topRight,
          //     end: Alignment.bottomLeft,
          //     colors: [Constants.white, widget.color]),
          // color: widget.color),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                InputField(
                  title: "First Name",
                  font: MediaQuery.of(context).size.height * 0.025,
                  isPassword: false,
                  controller: controllerFirstName,
                  onChanged: (val) {
                    setState(() {
                      controllerFirstName.text.length > 2
                          ? isNameLong = true
                          : isNameLong = false;
                    });
                  },
                ),
                InputField(
                  title: "Last Name",
                  font: MediaQuery.of(context).size.height * 0.025,
                  isPassword: false,
                  controller: controllerSecondName,
                  onChanged: (val) {
                    setState(() {
                      controllerSecondName.text.length > 2
                          ? isSecNameLong = true
                          : isSecNameLong = false;
                    });
                  },
                ),
                InputField(
                    title: "Mobile Number",
                    font: MediaQuery.of(context).size.height * 0.025,
                    isPassword: false,
                    controller: controllerMobileNumber,
                    keyboardType: TextInputType.phone),
                // SizedBox(
                //   height: MediaQuery.of(context).size.height * 0.025,
                // ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        selectedDate == null
                            ? 'Select DOB'
                            : (selectedDate.toString().split(" "))[0],
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    TextButton(
                        onPressed: presentDatePicker,
                        child: Text('Choose DoB'),
                        style: TextButton.styleFrom(
                            textStyle: const TextStyle(fontSize: (20)))),
                  ],
                ),

                //     (MediaQuery.of(context).size.height * 0.03).toInt())),
                /* DatePickerWidget(
                  title: "DoB",
                  controller: controllerDob,
                  font: (MediaQuery.of(context).size.height * 0.03).toInt(),
                  // color: widget.color
                ), */
                // SizedBox(
                //   height: MediaQuery.of(context).size.height * 0.025,
                // ),
                /*
                InputField(
                  title: "DOB",
                  font: 20,
                  isPassword: false,
                ),*/
                /*
                as email - id is being used as the primary key 
                user can change there password and not the emailid
                */
                /*
                InputField(
                  title: "Email-id",
                  font: 20,
                  isPassword: false,
                  isEditable: false,
                  controller: controllerEmailid,
                ),*/
                /*  
                 // ss - 29 sep 21 - removed the password display
              InputField(
                  title: "Password",
                  font: 20,
                  isPassword: false,
                  isEditable: false,
                  controller: controllerPassword,
                ),*/
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Button(
                    onTapFunction: () => Navigator.pop(context),
                    nextNavigation: null,
                    title: "Cancel",
                    width: MediaQuery.of(context).size.width / 3,
                    baseColor: widget.color,
                  ),
                  Button(
                    onTapFunction: onUpdate,
                    nextNavigation: null,
                    title: "Update",
                    width: MediaQuery.of(context).size.width / 3,
                    baseColor: widget.color,
                  ),
                ]),
              ]),
        ),
      ]),
    );
  }
}
