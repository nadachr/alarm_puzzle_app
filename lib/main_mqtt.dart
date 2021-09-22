
import 'package:alarm_puzzle/pages/home_page.dart';
import 'package:alarm_puzzle/pages/game_page.dart';
import 'package:alarm_puzzle/utilities/my_dialog.dart';
import 'package:alarm_puzzle/utilities/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

////// Code เก่า -> ใช้ MQTT

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

MqttServerClient? client;

class _MainScreenState extends State<MainScreen> {
  bool _connectState = false;

  mqttConnect() async {
    client = new MqttServerClient('192.168.137.1', 'clientIdentifier1');
    client!.keepAlivePeriod = 60;
    client!.autoReconnect = true;
    client!.onConnected = onConnected;
    client!.onDisconnected = onDisconnected;

    try {
      await client!.connect();
    } on NoConnectionException catch (e) {
      print('Disconnected :' + e.toString());
    }
  }

  Stream<List<MqttReceivedMessage<MqttMessage>>>? mqttSubscribe(
      String topic, bool state) {
    if (state) {
      client!.subscribe(topic, MqttQos.exactlyOnce);
      return client!.updates;
    } else {
      return null;
    }
  }

  void onConnected() {
    print('Connect.');
    setState(() {
      _connectState = true;
    });
  }

  void onDisconnected() {
    print('Disconnect.');
    _connectState = false;
  }

  @override
  void initState() {
    super.initState();
    mqttConnect();
  }

  int currentIndex = 0;
  final screens = [
    HomeScreen(),
    GameScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: _connectState ? mqttSubscribe('alarm', _connectState) : null,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List<MqttReceivedMessage<MqttMessage>> mqttReceiveMessage =
                snapshot.data;

            MqttPublishMessage recMess =
                mqttReceiveMessage[0].payload as MqttPublishMessage;
            String payload = MqttPublishPayload.bytesToStringAsString(
                recMess.payload.message);

            print(payload);

            bool isAlert = false;

            if (payload == "0") {
              isAlert = true;
            }

            if (isAlert) {
              Future.delayed(
                Duration.zero,
                () => MyDialog().onAlert(
                  context,
                  title: "ตื่นได้แล้วอั้ยต้าวดื้อ!",
                  content:
                      "นาฬิกาปลุกดังไม่ไหว >< เล่นเกมเพื่อปิดเสียงนาฬิกาปลุก!",
                ),
              );
              return Center(
                child: screens[1],
              );
            } else {
              return Center(
                child: screens[0],
              );
            }
          }
          return Center(
            child: screens[0],
          );
        },
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: currentIndex,
      //   onTap: (index) => setState(() => currentIndex = index),
      //   backgroundColor: MyColors.primary,
      //   selectedItemColor: MyColors.secondary,
      //   unselectedItemColor: MyColors.grey,
      //   iconSize: 40,
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //       backgroundColor: MyColors.secondary,
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.videogame_asset),
      //       label: 'Game',
      //       backgroundColor: MyColors.secondary,
      //     ),
      //   ],
      // ),
    );
  }
}
