import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_26/History/DataBaseHelper.dart';
import 'package:flutter_application_26/History/HistoryItem.dart';
import 'package:flutter_application_26/Interstitialad.dart';
import 'package:flutter_application_26/bottomnavigationscreen/FavouriteItem.dart';
import 'package:flutter_application_26/database/DatabaseHelper.dart';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';

import 'package:share_plus/share_plus.dart';

class SHowscreen extends StatefulWidget {
  final String originalText;
  final String translatedText;
  final String fromLanguage;
  final String toLanguage;
  final String? fromFlag;
  final String? toFlag;

  const SHowscreen({
    super.key,
    required this.originalText,
    required this.translatedText,
    required this.fromLanguage,
    required this.toLanguage,
    this.fromFlag,
    this.toFlag,
  });

  @override
  State<SHowscreen> createState() => _SHowscreenState();
}

class _SHowscreenState extends State<SHowscreen> {
  final InterstitialAdController adController =
      Get.put(InterstitialAdController());
  bool isFavorite = false;
  bool isCopied = false;
  late FlutterTts flutterTts;
  bool isSpeakingOriginal = false;
  bool isSpeakingTranslated = false;
  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    insertToHistory();
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  void speakOriginal(String text, String languageCode) async {
    await flutterTts.setLanguage(languageCode);
    if (isSpeakingOriginal) {
      await flutterTts.stop();
    } else {
      await flutterTts.speak(text);
    }

    setState(() {
      isSpeakingOriginal = !isSpeakingOriginal;

      if (isSpeakingOriginal) {
        isSpeakingTranslated = false;
      }
    });
  }

  void speakTranslated(String text, String languageCode) async {
    await flutterTts.setLanguage(languageCode);
    if (isSpeakingTranslated) {
      await flutterTts.stop();
    } else {
      await flutterTts.speak(text);
    }

    setState(() {
      isSpeakingTranslated = !isSpeakingTranslated;

      if (isSpeakingTranslated) {
        isSpeakingOriginal = false;
      }
    });
  }

  void insertToHistory() async {
    await DatabaseHelperHistory.insertHistory(HistoryItem(
      originalText: widget.originalText,
      translatedText: widget.translatedText,
      fromLanguage: widget.fromLanguage,
      toLanguage: widget.toLanguage,
      fromFlag: widget.fromFlag,
      toFlag: widget.toFlag,
    ));
  }

  void toggleFavorite() async {
    setState(() {
      isFavorite = !isFavorite;
    });

    if (isFavorite) {
      await DatabaseHelper.insertFavorite(FavoriteItem(
        originalText: widget.originalText,
        translatedText: widget.translatedText,
        fromLanguage: widget.fromLanguage,
        toLanguage: widget.toLanguage,
        fromFlag: widget.fromFlag,
        toFlag: widget.toFlag,
      ));
    } else {
      await DatabaseHelper.deleteFavorite(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: height * 0.08,
                width: width * 0.9,
                decoration: (BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: const Color(0xFFD5D5D5)))),
                child: Row(
                  children: [
                    Container(
                      height: height * 0.08,
                      width: width * 0.3,
                      decoration: BoxDecoration(
                        color: const Color(0xFF5AA587),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.fromFlag != null)
                            Image.network(widget.fromFlag!,
                                height: 20, width: 20),
                          SizedBox(
                            width: width * 0.02,
                          ),
                          Text(
                            widget.fromLanguage,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: width * 0.15,
                    ),
                    Image.asset("assets/Arrow.png"),
                    SizedBox(
                      width: width * 0.04,
                    ),
                    Container(
                      height: height * 0.08,
                      width: width * 0.3,
                      decoration: BoxDecoration(
                        // color: const Color(0xFF5AA587),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.toFlag != null)
                            Image.network(widget.toFlag!,
                                height: 20, width: 20),
                          SizedBox(
                            width: width * 0.02,
                          ),
                          Text(
                            widget.toLanguage,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF525D4D),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.05,
              ),
              Container(
                height: height * 0.28,
                width: width * 0.9,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFD5D5D5))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Text(" ${widget.originalText}",
                              style: const TextStyle(fontSize: 16)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () {
                          speakOriginal(
                        
                              widget.originalText, widget.fromLanguage);
                        },
                        child: Icon(
                          isSpeakingOriginal
                              ? Icons.volume_up
                              : Icons.volume_off,
                          color: Color(0xFF242424),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              Container(
                height: height * 0.22,
                width: width * 0.9,
                decoration: (BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFD5D5D5)))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Text(" ${widget.translatedText}",
                              style: const TextStyle(fontSize: 16)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              speakTranslated(
                                  widget.translatedText, widget.toLanguage);
                            },
                            child: Icon(
                              isSpeakingTranslated
                                  ? Icons.volume_up
                                  : Icons.volume_off,
                              color: Color(0xFF242424),
                            ),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  adController.onButtonClick();
                                  Share.share(widget.translatedText);
                                },
                                child: Container(
                                  child: const Icon(
                                    Icons.share,
                                    color: Color(0xFF455A64),
                                    size: 17,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: width * 0.04,
                              ),
                              GestureDetector(
                                onTap: () {
                                  adController.onButtonClick();
                                  Clipboard.setData(ClipboardData(
                                          text: widget.translatedText))
                                      .then((_) {
                                    setState(() {
                                      isCopied = true;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Copied: ',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: Color(0xFF455A64),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );

                                    Future.delayed(const Duration(seconds: 2),
                                        () {
                                      setState(() {
                                        isCopied = false;
                                      });
                                    });
                                  });
                                },
                                child: Container(
                                  child: Icon(
                                    Icons.copy,
                                    color: isCopied
                                        ? const Color(0xFF455A64)
                                        : const Color(0xFF455A64),
                                    size: 17,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: width * 0.04,
                              ),
                              GestureDetector(
                                onTap: () {
                                  adController.onButtonClick();
                                  toggleFavorite();
                                },
                                child: Container(
                                  child: Icon(
                                    isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_outline,
                                    color: const Color(0xFF455A64),
                                    size: 17,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: width * 0.04,
                              ),
                              InkWell(
                                  onTap: () {},
                                  child: Container(
                                      child:
                                          Image.asset("assets/Maskgroup.png"))),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
