import 'package:coeus_v1/components/summary_card.dart';
import 'package:coeus_v1/pages/discovery_page_updated.dart';
import 'package:coeus_v1/pages/home.page.dart';
import 'package:coeus_v1/pages/profile.page.dart';
import 'package:coeus_v1/utils/const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

int _index = 0;

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  @override
  Widget build(BuildContext context) {
    Widget child = Container();

    switch (_index) {
      case 2:
        child = ProfilePage();
        break;

      case 0:
        child = HomePage();
        break;

      case 1:
        child = DiscoveryBluetoothDevice();
    }

    return Scaffold(
      appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("Coeus"),
          backgroundColor: Colors.blueAccent),
      body: SingleChildScrollView(child: child),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (int index) => setState(() => _index = index),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            /*
06 aug 21
ns - changed colur from transperent to light blue 
*/
            backgroundColor: Colors.lightBlue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.watch),
            label: 'Connect Device',
            /*
06 aug 21
ns - changed colur from transperent to light blue 
*/
            backgroundColor: Colors.lightBlue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
            backgroundColor: Colors.lightBlue,
          ),
        ],
        selectedItemColor: Colors.black,
      ),
    );
  }
}
