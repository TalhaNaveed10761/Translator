import 'package:flutter/material.dart';
import 'package:flutter_application_26/Ads/ReusableNativeAd.dart';
import 'package:flutter_application_26/Interstitialad.dart';

import 'package:flutter_application_26/bottomnavigationscreen/Homepage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Dotscreen extends StatefulWidget {
  const Dotscreen({super.key});

  @override
  State<Dotscreen> createState() => _DotscreenState();
}

class _DotscreenState extends State<Dotscreen> {
  final InterstitialAdController adController =
      Get.put(InterstitialAdController());

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final controller = PageController();
    // int currentPage = 0;

    return Scaffold(
      backgroundColor: const Color(0xFF43BAA2),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: controller,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(child: SvgPicture.asset("assets/Frame.svg")),
                    SizedBox(height: height * 0.07),
                    const Text(
                      "Express Yourself Freely We'll",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      "break down language barriers",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      "together",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: height * 0.03),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Container(
                          height: height * 0.06,
                          width: width * 0.15,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: IconButton(
                            onPressed: () {
                              adController.onButtonClick();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Homepage(),
                                  ));
                            },
                            icon: Icon(
                              Icons.arrow_right_alt_outlined,
                              size: 25,
                            ),
                            color: Color(0xFF43BAA2),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.07,
                    ),
                    ReusableNativeAd(
                     // adUnitId: 'ca-app-pub-3940256099942544/2247696110',
                      height: height * 0.15,
                      width: width,
                    ),
                  ],
                ),
                Scaffold(
                  appBar: AppBar(
                    backgroundColor: Color(0xFF43BAA2),
                    elevation: 0,
                    leading: const Icon(Icons.arrow_back),
                  ),
                  backgroundColor: Color(0xFF43BAA2),
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/Layer 2.svg"),
                      SizedBox(height: height * 0.1),
                      const Text(
                        "Explore the essence of words,",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF455A64),
                        ),
                      ),
                      const Text(
                        "right at your fingertips",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF455A64),
                        ),
                      ),
                      SizedBox(height: height * 0.03),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Container(
                            height: height * 0.06,
                            width: width * 0.15,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: IconButton(
                              onPressed: () {
                                adController.onButtonClick();
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Homepage(),
                                    ));
                              },
                              icon: Icon(
                                Icons.arrow_right_alt_outlined,
                                size: 25,
                              ),
                              color: Color(0xFF43BAA2),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Scaffold(
                  appBar: AppBar(
                    backgroundColor: Color(0xFF43BAA2),
                    elevation: 0,
                    leading: const Icon(Icons.arrow_back),
                  ),
                  backgroundColor: Color(0xFF43BAA2),
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/Frame2.svg"),
                      SizedBox(height: height * 0.1),
                      const Text(
                        "Your words deserve to ",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF455A64),
                        ),
                      ),
                      const Text(
                        "shine let us bring them to life",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF455A64),
                        ),
                      ),
                      const Text(
                        "in every language",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF455A64)),
                      ),
                      SizedBox(height: height * 0.03),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: InkWell(
                            onTap: () {
                              adController.onButtonClick();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Homepage(),
                                  ));
                            },
                            child: Container(
                              height: height * 0.06,
                              width: width * 0.3,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Text(
                                  "Get Started",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFF43BAA2),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.07,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: SmoothPageIndicator(
              controller: controller,
              count: 3,
              effect: ExpandingDotsEffect(
                dotColor: Colors.white,
                activeDotColor: Color(0xFF455A64),
                dotHeight: 10.0,
                dotWidth: 10.0,
                spacing: 16.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
