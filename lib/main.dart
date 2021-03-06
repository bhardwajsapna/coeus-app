import 'dart:io';

import 'package:coeus_v1/appState/loginState.dart';
import 'package:coeus_v1/pages/app.page.dart';
import 'package:coeus_v1/utils/storageUtils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './pages/login.page.dart';
//below library is required for setting screen orientation
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  /*
  14 Nov 21 
  sreeni - set this preferred orientation to portrait
   */
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]).then((_) {
    return runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginStateProvider>(
            create: (context) => LoginStateProvider()),
      ],
      child: MaterialApp(
        title: 'COEUS App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: OpenApp(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
