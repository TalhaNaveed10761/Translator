import 'dart:io'; 
import 'package:flutter/material.dart';
import 'package:flutter_application_26/CustomWidgets/Customlisttile.dart';
import 'package:flutter_application_26/History/DataBaseHelper.dart';
import 'package:flutter_application_26/Interstitialad.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final FlutterTts flutterTts = FlutterTts();
  double speechRate = 1.0;
  int selectedSpeed = 1;

  void _showSpeedDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color(0xFFF7F7F7),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<int>(
                  title: Text(
                    "Normal",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF455A64)),
                  ),
                  value: 1,
                  groupValue: selectedSpeed,
                  onChanged: (value) {
                    setState(() {
                      selectedSpeed = value!;

                      speechRate = 1.0;

                      flutterTts.setSpeechRate(speechRate);
                    });
                    Navigator.pop(context);
                  },
                ),
                RadioListTile<int>(
                  title: Text(
                    "Slow",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF455A64)),
                  ),
                  value: 2,
                  groupValue: selectedSpeed,
                  onChanged: (value) {
                    setState(() {
                      selectedSpeed = value!;
                      speechRate = 0.7;
                      flutterTts.setSpeechRate(speechRate);
                    });
                    Navigator.pop(context);
                  },
                ),
                RadioListTile<int>(
                  title: Text(
                    "Slower",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF455A64)),
                  ),
                  value: 3,
                  groupValue: selectedSpeed,
                  onChanged: (value) {
                    setState(() {
                      selectedSpeed = value!;
                      speechRate = 0.5;
                      flutterTts.setSpeechRate(speechRate);
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  final String privacyPolicyUrl = 'https://www.example.com/privacy-policy';
  final String appLink =
      'https://play.google.com/store/apps/details?id=com.example.myapp';

  @override
  Widget build(BuildContext context) {
    final InterstitialAdController adController =
        Get.put(InterstitialAdController());
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    String platformSpecificLink = Platform.isAndroid
        ? appLink
        : 'https://apps.apple.com/us/app/example-app/id1234567890';

    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.grey[100],
          elevation: 0,
          centerTitle: false,
          title: const Text(
            "Setting",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: Color(0xFF4F4F4F),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            children: [
              Container(
                  height: height * 0.35,
                  width: width * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Color(0xFFDCDCDC),
                    ),
                  ),
                  child: Column(
                    children: [
                      Customlisttile(
                          onTap: () {
                            _showSpeedDialog();
                            adController.onButtonClick();
                          },
                          image: "assets/Speaker.svg",
                          title: "Speed",
                          subtitle: "Adjust the Speed of voice"),
                      Customlisttile(
                          onTap: () async {
                            adController.onButtonClick();
                            bool? clearHistory = await showDialog<bool>(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    'Are you Sure you want to clear history',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  actions: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          height: height * 0.08,
                                          width: width * 0.3,
                                          decoration: BoxDecoration(
                                              color: Color(0xFFBEC5BB),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(false);
                                            },
                                            child: Text(
                                              'No',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: height * 0.08,
                                          width: width * 0.3,
                                          decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  Color(0xFF74CABB),
                                                  Color(0xFF26A69A),
                                                ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: TextButton(
                                            onPressed: () async {
                                              await DatabaseHelperHistory
                                                  .clearHistory();
                                              Navigator.of(context).pop(true);
                                            },
                                            child: Text(
                                              'Yes',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                );
                              },
                            );

                            if (clearHistory == true) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.grey[700],
                                  content: Text('Search history deleted.'),
                                ),
                              );
                              setState(() {});
                            }
                          },
                          image: "assets/Del.svg",
                          title: "Clear History",
                          subtitle: "Clear All the Search History"),
                      Customlisttile(
                          onTap: () {
                            adController.onButtonClick();
                          },
                          image: "assets/Colors.svg",
                          title: "Theme",
                          subtitle: "Light mode and dark mode"),
                    ],
                  )),
              SizedBox(
                height: height * 0.02,
              ),
              Container(
                height: height * 0.23,
                width: width * 0.9,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Color(0xFFDCDCDC),
                    )),
                child: Column(
                  children: [
                    Customlisttile(
                        onTap: () async {
                          adController.onButtonClick();

                          if (await canLaunch(privacyPolicyUrl)) {
                            await launch(privacyPolicyUrl);
                          } else {
                            throw 'Could not launch $privacyPolicyUrl';
                          }
                        },
                        image: "assets/Privacy.svg",
                        title: "Privacy Policy",
                        subtitle: "Check Privacy policy of our App"),
                    Customlisttile(
                        onTap: () {
                          adController.onButtonClick();

                          if (Platform.isAndroid) {
                            Share.share(appLink);
                          } else if (Platform.isIOS) {
                            Share.share(platformSpecificLink);
                          }
                        },
                        image: "assets/Share.svg",
                        title: "Share App",
                        subtitle: "Share this App to others"),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
