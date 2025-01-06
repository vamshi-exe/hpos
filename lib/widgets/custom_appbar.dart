import 'package:employee_app/screens/auth/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.settings, color: Colors.black),
        onPressed: () {
          // Handle settings press
        },
      ),
      title: Text(
        "Subject Details",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.logout, color: Colors.red),
          onPressed: () {
            // Handle logout press
            Navigator.push(
                context,
                CupertinoDialogRoute(
                    builder: (context) => LoginScreen(), context: context));
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
