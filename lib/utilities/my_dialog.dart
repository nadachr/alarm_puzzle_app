import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'my_theme.dart';

class MyDialog {
  Future<Null> showProgressDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => WillPopScope(
        child: Center(child: CircularProgressIndicator()),
        onWillPop: () async {
          return false;
        },
      ),
    );
  }

  Future<Null> onAlert(BuildContext context, {String? title, String? content}) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    title ?? "Title",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.chakraPetch(
                      color: MyColors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                  height: 200,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    content ?? "Content",
                    style: GoogleFonts.chakraPetch(
                      color: MyColors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
