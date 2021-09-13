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
      // home: QueryList(),
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
    String apiUrl = '${MyConstant.domain}/api/getTimeAlarm.php';
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

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: FutureBuilder(
  //       future: getTimeAlarm(),
  //       builder: (BuildContext context, AsyncSnapshot snapshot) {
  //         if (snapshot.hasData) {
  //           print(snapshot.data);

  //           var body = json.decode(snapshot.data.data);
  //           bool isAlert = false;

  //           if (body['alarm'] == '0') {
  //             isAlert = true;
  //           }

  //           if (isAlert) {
  // Future.delayed(
  //   Duration.zero,
  //   () => MyDialog().onAlert(
  //     context,
  //     title: "ตื่นได้แล้วอั้ยต้าวดื้อ!",
  //     content:
  //         "นาฬิกาปลุกดังไม่ไหว >< เล่นเกมเพื่อปิดเสียงนาฬิกาปลุก!",
  //   ),
  // );
  // return Center(
  //   child: screens[1],
  // );
  //           } else {
  //             return Center(
  //               child: screens[0],
  //             );
  //           }
  //         }
  //         return Center(
  //           child: screens[0],
  //         );
  //       },
  //     ),
  //     // bottomNavigationBar: BottomNavigationBar(
  //     //   currentIndex: currentIndex,
  //     //   onTap: (index) => setState(() => currentIndex = index),
  //     //   backgroundColor: MyColors.primary,
  //     //   selectedItemColor: MyColors.secondary,
  //     //   unselectedItemColor: MyColors.grey,
  //     //   iconSize: 40,
  //     //   items: [
  //     //     BottomNavigationBarItem(
  //     //       icon: Icon(Icons.home),
  //     //       label: 'Home',
  //     //       backgroundColor: MyColors.secondary,
  //     //     ),
  //     //     BottomNavigationBarItem(
  //     //       icon: Icon(Icons.videogame_asset),
  //     //       label: 'Game',
  //     //       backgroundColor: MyColors.secondary,
  //     //     ),
  //     //   ],
  //     // ),
  //   );
  // }
}
