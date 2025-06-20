import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_26/bottomnavigationscreen/Homepage.dart';

import 'package:flutter_svg/flutter_svg.dart';

class Splashscreen extends StatelessWidget {
  const Splashscreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Homepage()),
      );
    });

    return Scaffold(
      body: Center(child: SvgPicture.asset("assets/Group 115.svg")),
    );
  }
}
