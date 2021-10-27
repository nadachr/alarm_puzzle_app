import 'dart:async';
import 'dart:convert';

import 'package:alarm_puzzle/pages/home_page.dart';
import 'package:alarm_puzzle/pages/game_page.dart';
import 'package:alarm_puzzle/utilities/my_constant.dart';
import 'package:alarm_puzzle/utilities/my_dialog.dart';
import 'package:alarm_puzzle/utilities/my_theme.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alarm Puzzle',
      theme: ThemeData(
        primaryColor: MyColors.primary,
        secondaryHeaderColor: MyColors.secondary,
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 2), (Timer t) => getTimeAlarm());
  }

  int currentIndex = 0;
  final screens = [
    HomeScreen(),
    GameScreen(),
  ];

  Future<Null>? getTimeAlarm() async {
    String apiUrl =
        '${MyConstant.domain}/alarm_puzzle_app_api/getTimeAlarm.php';
    Response response = await Dio().get(apiUrl);
    print(response.data);
    var body = json.decode(response.data);
    if (body['alarm'] == '0') {
      setState(() {
        currentIndex = 1;
      });
    } else {
      setState(() {
        currentIndex = 0;
      });
    }
  }

  bool alert = true;

  @override
  Widget build(BuildContext context) {
    if (currentIndex == 1 && alert) {
      alert = false;
      Future.delayed(
        Duration.zero,
        () => MyDialog().onAlert(
          context,
          title: "ตื่นได้แล้วอั้ยต้าวดื้อ!",
          content: "นาฬิกาปลุกดังไม่ไหว >< เล่นเกมเพื่อปิดเสียงนาฬิกาปลุก!",
        ),
      );
    } else if (currentIndex == 0) {
      alert = true;
    }
    return Scaffold(
      body: Center(
        child: screens[currentIndex],
      ),
    );
  }
}
