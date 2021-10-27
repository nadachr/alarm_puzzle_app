import 'dart:convert';

import 'package:alarm_puzzle/utilities/my_constant.dart';
import 'package:alarm_puzzle/utilities/my_theme.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final storage = new FlutterSecureStorage();

  TimeOfDay? timeSelect;
  String? timeShow;
  String? timeSet;

  String? getTime() {
    if (timeSelect == null) {
      return null;
    } else {
      final hours = timeSelect!.hour.toString().padLeft(2, '0');
      final minutes = timeSelect!.minute.toString().padLeft(2, '0');
      return '$hours:$minutes';
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  init() {
    storage.read(key: 'time').then((value) => setState(() => timeShow = value));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: MyColors.primary,
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    color: MyColors.primary,
                    height: constraints.maxHeight,
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/logo.png',
                              width: 120,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(height: 10),
                            Container(
                              alignment: Alignment.topLeft,
                              padding: EdgeInsets.only(left: 40),
                              child: Text(
                                "เวลาปลุก :",
                                style: GoogleFonts.chakraPetch(
                                  fontSize: 30,
                                  color: MyColors.secondary,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 10,
                              ),
                              width: constraints.maxWidth,
                              height: constraints.maxHeight * 0.2,
                              decoration: BoxDecoration(
                                color: MyColors.black.withOpacity(0.4),
                                border: Border.all(
                                  color: MyColors.secondary,
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                timeShow == null ? '--:--' : timeShow!,
                                style: GoogleFonts.chakraPetch(
                                  fontSize: 90,
                                  color: MyColors.white,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 4,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 30),
                              child: Divider(
                                color: MyColors.grey,
                                thickness: 1,
                              ),
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              padding: EdgeInsets.only(left: 40),
                              child: Text(
                                "ตั้งค่า :",
                                style: GoogleFonts.chakraPetch(
                                  fontSize: 30,
                                  color: MyColors.secondary,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () => pickTime(context),
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: 40,
                                  vertical: 15,
                                ),
                                padding: EdgeInsets.only(left: 20),
                                width: constraints.maxWidth,
                                height: 65,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: MyColors.secondary,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  getTime() == null
                                      ? 'ตั้งเวลาปลุก'
                                      : getTime()!,
                                  style: GoogleFonts.chakraPetch(
                                    color: MyColors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 25,
                                    letterSpacing: 4,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 15),
                              padding: const EdgeInsets.symmetric(
                                vertical: 3.0,
                                horizontal: 15.0,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: getTime() != null
                                    ? MyColors.secondary
                                    : MyColors.grey,
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(10, 10),
                                    blurRadius: 10,
                                    spreadRadius: -5,
                                    color: MyColors.grey.withOpacity(0.4),
                                  ),
                                ],
                              ),
                              child: TextButton(
                                child: Text(
                                  'SAVE',
                                  style: GoogleFonts.chakraPetch(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 3,
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                  primary: MyColors.primary,
                                  backgroundColor: Colors.transparent,
                                ),
                                onPressed: getTime() != null
                                    ? () {
                                        _onSuccess(getTime()!);
                                      }
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future pickTime(BuildContext context) async {
    final initialTime = TimeOfDay(hour: 0, minute: 0);
    final newTime = await showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.input,
      initialTime: timeSelect ?? initialTime,
      builder: (context, childWidget) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: childWidget!,
        );
      },
    );

    if (newTime == null) return;

    setState(() => timeSelect = newTime);
  }

  Future<Null> setTime(String time) async {
    String apiUrl = '${MyConstant.domain}/alarm_puzzle_app_api/setTime.php';

    Dio().post(apiUrl, data: {'time': time}).then((res) async {
      var body = json.decode(res.data);
      if (body['msg'] == 'success') {
        await storage.write(key: 'time', value: body['time_set']);
        setState(() {
          timeShow = body['time_set'];
        });
      }
    });
  }

  _onSuccess(String time) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "แก้ไขเวลาปลุก",
            style: GoogleFonts.chakraPetch(
              color: MyColors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            "ต้องการเปลี่ยนเวลาปลุกเป็น $time น. หรือไม่?",
            style: GoogleFonts.chakraPetch(
              color: MyColors.black,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'ตกลง',
                style: GoogleFonts.chakraPetch(
                  color: MyColors.success,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                setState(() {
                  timeSet = getTime();
                  timeSelect = null;
                });
                setTime(time);
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text(
                'ยกเลิก',
                style: GoogleFonts.chakraPetch(
                  color: MyColors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
