import 'package:alarm_puzzle/pages/game_page.dart';
import 'package:alarm_puzzle/utilities/my_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TimeOfDay? time;
  String? times;
  String? hh;
  String? mm;
  List<String?> hhmm = [];

  String? getTime() {
    if (time == null) {
      return null;
    } else {
      final hours = time!.hour.toString().padLeft(2, '0');
      final minutes = time!.minute.toString().padLeft(2, '0');

      return '$hours:$minutes';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        color: MyColors.primary,
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
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
                              times == null ? "07:00" : times!,
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
                                // color: MyColors.black.withOpacity(0.4),
                                border: Border.all(
                                  color: MyColors.secondary,
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                getTime() == null ? 'เวลาปลุก' : getTime()!,
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
                              color: MyColors.secondary,
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
                              onPressed: () {
                                if (getTime() != null) {
                                  setState(() {
                                    times = getTime();
                                    hhmm = times!.split(':');
                                    hh = hhmm[0];
                                    mm = hhmm[1];
                                    time = null;
                                  });
                                }
                              },
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
                            ),
                          ),
                        ],
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
    final initialTime = TimeOfDay(hour: 7, minute: 0);
    final newTime = await showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.input,
      initialTime: time ?? initialTime,
      builder: (context, childWidget) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: childWidget!,
        );
      },
    );

    if (newTime == null) return;

    setState(() => time = newTime);
  }
}
