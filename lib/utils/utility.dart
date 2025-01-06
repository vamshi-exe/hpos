import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Utility {
  static Future pushToNext(BuildContext context, dynamic page) {
    return Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => page),
    );
  }
}
