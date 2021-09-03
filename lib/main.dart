import 'package:alarm_puzzle/pages/home_page.dart';
import 'package:alarm_puzzle/pages/game_page.dart';
import 'package:alarm_puzzle/utilities/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  int currentIndex = 0;
  final screens = [
    HomeScreen(),
    GameScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: screens[currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        backgroundColor: MyColors.primary,
        selectedItemColor: MyColors.secondary,
        unselectedItemColor: MyColors.grey,
        iconSize: 40,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: MyColors.secondary,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.videogame_asset),
            label: 'Game',
            backgroundColor: MyColors.secondary,
          ),
        ],
      ),
    );
  }
}
