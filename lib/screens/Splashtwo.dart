import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_26/bottomnavigationscreen/Homepage.dart';




import 'package:flutter_svg/svg.dart';





class Splashtwo extends StatelessWidget {
  const Splashtwo({super.key});

  @override
  Widget build(BuildContext context) {

   
    // final height=MediaQuery.of(context).size.height;
    // final width=MediaQuery.of(context).size.height;
     Timer(const Duration(seconds: 5), () {
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Homepage()),
      );
    
    });
   
    return Scaffold(
      
      backgroundColor:const Color(0xFF43BAA2) ,
      body: Center(child: SvgPicture.asset("assets/icon.svg")),
    );
  }
}