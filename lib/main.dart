import 'package:chat_app/config/firebase.dart';
import 'package:chat_app/screens/main_menu.dart';
import 'package:chat_app/screens/slider_screen.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:chat_app/screens/test1.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(new MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.pumpingHeart
    ..loadingStyle = EasyLoadingStyle.light
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
  // ..customAnimation = CustomAnimation();
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _MyApp createState() => new _MyApp();
}

class _MyApp extends State<MyApp> {
  Service service = Service();
  Widget currentPage = IntroSliderPage();
  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        theme: new ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        // home: Test(),
        builder: EasyLoading.init(),
        home: currentPage);
  }

  void checkLogin() async {
    String token = await service.getToken();

    if (token != null) {
      setState(() {
        currentPage = MainMenu(
          isReg: true,
        );
      });
    }
  }
}
