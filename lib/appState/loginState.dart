import 'dart:io';

import 'package:coeus_v1/utils/storageUtils.dart';
import 'package:coeus_v1/utils/user_secure_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

enum AppState { LOGIN_INITIAL, LOGIN_SUCCESS, LOGIN_FAILURE }

class LoginStateProvider extends ChangeNotifier {
  AppState _appState = AppState.LOGIN_INITIAL;

  LoginStateProvider() {
    checkAutoLogin();
  }

  Future checkAutoLogin() async {
    try {
      String? userName = await UserSecureStorage.getEmailId();

      String? passWord = await UserSecureStorage.getPassword();
      await userLogin(userName!, passWord!);
      print('>>>>>>>>>' + userName);

      /*
      09 feb 22 - sreeni - for moving files from assets to internal storate.\
      why here ? as this runs only once and checking once is good enough so this is better place 
      */

      // Retrieve "External Storage Directory" for Android and "NSApplicationSupportDirectory" for iOS
      Directory? directory = Platform.isAndroid
          ? await getExternalStorageDirectory()
          : await getApplicationSupportDirectory();

      print("dir path" + directory.toString());
      // String fileName = "tempRecords.json";
      String savePath = "${directory!.path}/tempRecords.json";

      print("directory work done  " + savePath);
      if (!(await File(savePath).exists())) {
        print("file check done");

        // Create a new file. You can create any kind of file like txt, doc , json etc.
        File file = await File("${directory!.path}/tempRecords.json").create();

        print("file created");
// Users can load any kind of files like txt, doc or json files as well
        String assetContent =
            await rootBundle.loadString('assets/tempRecords.json');
        print("file content" + assetContent);
        await file.writeAsString(assetContent);
        print("write to new file");
        if ((await File("${directory!.path}/tempRecords.json").exists())) {
          print("file copied");
        } else {
          print("file not copied");
        }
      } else {
        print("file already exist");
        // await File("${directory!.path}/tempRecords.json").delete();
      }
    } catch (e) {
      _appState = AppState.LOGIN_FAILURE;
      notifyListeners();
    }
  }

  Future userLogin(String userName, String password) async {
    try {
      await StorageUtil.setUserName(userName);
      await StorageUtil.setPassword(password);
      _appState = AppState.LOGIN_SUCCESS;
      notifyListeners();
    } catch (e) {
      _appState = AppState.LOGIN_FAILURE;
      notifyListeners();
    }
  }

  Future userLogout() async {
    print("deleteing user...");
    await StorageUtil.clear();
    _appState = AppState.LOGIN_SUCCESS;
    notifyListeners();
  }

  AppState get appState => _appState;
}
