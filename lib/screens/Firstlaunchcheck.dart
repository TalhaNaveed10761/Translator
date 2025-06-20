import 'package:flutter/material.dart';
import 'package:flutter_application_26/screens/Dotscreen.dart';

import 'package:flutter_application_26/screens/Splashtwo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Firstlaunchcheck extends StatefulWidget {
  const Firstlaunchcheck({super.key});

  @override
  State<Firstlaunchcheck> createState() => _FirstlaunchcheckState();
}

class _FirstlaunchcheckState extends State<Firstlaunchcheck> {
  bool _isFirstLaunch = true;

  @override
  void initState() {
    super.initState();
    _checkIfFirstLaunch();
  }

  void _checkIfFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isFirstLaunch = prefs.getBool('isFirstLaunch');

    if (isFirstLaunch == null || isFirstLaunch) {
      setState(() {
        _isFirstLaunch = true;
      });
      prefs.setBool('isFirstLaunch', false);
    } else {
      setState(() {
        _isFirstLaunch = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isFirstLaunch) {
      return Dotscreen();
    } else {
      return Splashtwo();
    }
  }
}

@override
Widget build(BuildContext context) {
  return Scaffold();
}
