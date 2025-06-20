import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_26/Interstitialad.dart';
import 'package:flutter_application_26/Translation/TranslateFrom.dart';
import 'package:flutter_application_26/Translation/TranslateTo.dart';
import 'package:flutter_application_26/bottomnavigationscreen/Wordoftheday.dart';
import 'package:flutter_application_26/bottomnavigationscreen/showscreen.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:translator/translator.dart';

class Translator extends StatefulWidget {
  const Translator({super.key});

  @override
  State<Translator> createState() => _TranslatorState();
}

class _TranslatorState extends State<Translator> {
  TextEditingController controller = TextEditingController();
  final GoogleTranslator translator = GoogleTranslator();
  final stt.SpeechToText speech = stt.SpeechToText();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final InterstitialAdController adController =
  Get.put(InterstitialAdController());
  bool isListening = false;
 

  bool isTapped = false;
  String? selectedLanguage = 'Select';
  String? selectedFlag;

  String? toLanguage = 'Select';
  String? toFlag;
  String translatedText = '';
  late BannerAd bannerAd;
  bool isBannerLoaded = false;

  Future<void> _checkMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if (status.isDenied || status.isRestricted) {
      status = await Permission.microphone.request();
    }
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Microphone permission is required to use speech-to-text.'),
        ),
      );
    }
  }

  Future<void> _translate() async {
    if (controller.text.isNotEmpty &&
        selectedLanguage != 'Select' &&
        toLanguage != 'Select') {
      var fromLangCode = selectedLanguage!.substring(0, 2).toLowerCase();
      var toLangCode = toLanguage!.substring(0, 2).toLowerCase();

      if (fromLangCode == toLangCode) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('From and To languages cannot be the same.')),
        );
        return;
      }

      try {
        var translation = await translator.translate(
          controller.text,
          from: fromLangCode,
          to: toLangCode,
        );
        if (mounted) {
          setState(() {
            translatedText = translation.text;
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Translation failed: $e')),
        );
      }
    }
  }

  Future<void> _startListening() async {
    await _checkMicrophonePermission();

    if (await Permission.microphone.isGranted) {
      bool available = await speech.initialize(
        onStatus: (status) => print("Status: $status"),
        onError: (error) => print("Error: $error"),
      );

      if (available) {
        setState(() {
          isListening = true;
          controller.text = "Listening...";
        });

        speech.listen(
          onResult: (result) {
            setState(() {
              if (result.recognizedWords.isNotEmpty) {
                controller.text = result.recognizedWords;
              }
            });
          },
        );

        Future.delayed(const Duration(seconds: 10), () {
          if (isListening && controller.text == "Listening...") {
            setState(() {
              controller.clear();
            });
            _stopListening();
          }
        });
      }
    }
  }

  void _stopListening() {
    setState(() {
      isListening = false;
      if (controller.text == "Listening...") {
        controller.clear();
      }
    });
    speech.stop();
  }

  File? pickedImage;

  final FocusNode focusNode = FocusNode();

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        pickedImage = File(image.path);
      });
      await _extractTextFromImage(image.path);
    }
  }

  Future<void> galleryImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        pickedImage = File(image.path);
      });
      await _extractTextFromImage(image.path);
    }
  }

  Future<void> _extractTextFromImage(String imagePath) async {
    final InputImage inputImage = InputImage.fromFilePath(imagePath);
    final TextRecognizer textRecognizer = TextRecognizer();

    try {
      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);

      String extractedText =
          recognizedText.text.replaceAll(RegExp(r'\s+'), ' ');
      int characterCount = 0;

      for (int i = 0; i < extractedText.length; i++) {
        if (extractedText[i] != ' ' &&
            RegExp(r'[a-zA-Z0-9]').hasMatch(extractedText[i])) {
          characterCount++;
        }
      }

      print('Extracted text: $extractedText');
      print('Character count: $characterCount');

      if (characterCount > 200  ) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Character count exceeds 200 ')),
        );
        return;
      }

      setState(() {
        controller.text = extractedText;
      });

      FocusScope.of(context).requestFocus(focusNode);
    } catch (e) {
      print("Error recognizing text: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to recognize text from the image.')),
      );
    } finally {
      textRecognizer.close();
    }
  }

  void _showImageDialog() {
    if (pickedImage == null) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(pickedImage!),
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.grey[100],
          elevation: 0,
          title: const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 10.0,
            ),
            child: Row(
              children: [
                Text(
                  "Globe",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF455A64),
                  ),
                ),
                Text(
                  "Lingo",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF43BAA2),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Image.asset("assets/Book1.png"),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                  ),
                  child: Container(
                    height: height * 0.08,
                    width: width * 0.9,
                    decoration: (BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: const Color(0xFFD5D5D5)))),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            adController.onButtonClick();
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const TranslateFrom()),
                            );

                            if (result != null &&
                                result is Map<String, String>) {
                              setState(() {
                                selectedLanguage = result['language'];
                                selectedFlag = result['flag'];
                              });
                            }
                          },
                          child: Container(
                            height: height * 0.08,
                            width: width * 0.32,
                            decoration: BoxDecoration(
                              color: const Color(0xFF5AA587),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (selectedFlag != null)
                                  Image.network(selectedFlag!,
                                      height: 20, width: 20),
                                SizedBox(
                                  width: width * 0.02,
                                ),
                                Text(
                                  selectedLanguage!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: width * 0.13,
                        ),
                        Image.asset("assets/Arrow.png"),
                        SizedBox(
                          width: width * 0.04,
                        ),
                        GestureDetector(
                          onTap: () async {
                            adController.onButtonClick();
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const TranslateTo()),
                            );

                            if (result != null &&
                                result is Map<String, String>) {
                              setState(() {
                                toLanguage = result['language'];
                                toFlag = result['flag'];
                              });
                            }
                          },
                          child: Container(
                            height: height * 0.08,
                            width: width * 0.32,
                            decoration: BoxDecoration(
                              // color: Color(0xFF43BAA2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (toFlag != null)
                                  Image.network(toFlag!, height: 20, width: 20),
                                SizedBox(
                                  width: width * 0.02,
                                ),
                                Text(
                                  toLanguage!,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF525D4D)),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                Container(
                  height: height * 0.28,
                  width: width * 0.9,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      double localWidth = constraints.maxWidth;
                      double localHeight = constraints.maxHeight;

                      return Form(
                        key: _formKey,
                        child: Stack(
                          children: [
                            TextFormField(
                              maxLength: 200,
                              cursorColor: Colors.transparent,
                              maxLines: 8,
                              controller: controller,
                              decoration: InputDecoration(
                                hintText: "Start Typing...",
                                hintStyle: TextStyle(
                                  color: Color(0xFFA7A7A7),
                                  fontSize: localWidth * 0.05,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFFD5D5D5)),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFFD5D5D5)),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Please enter text to translate.";
                                }
                                return null;
                              },
                            ),
                            if (pickedImage != null)
                              Positioned(
                                top: localHeight * 0.03,
                                right: localWidth * 0.03,
                                child: GestureDetector(
                                  onTap: _showImageDialog,
                                  child: Image.file(
                                    pickedImage!,
                                    width: localWidth * 0.12,
                                    height: localWidth * 0.12,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: localWidth * 0.01,
                                  vertical: localHeight * 0.05,
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        adController.onButtonClick();
                                        isListening
                                            ? _stopListening()
                                            : _startListening();
                                      },
                                      icon: Icon(isListening
                                          ? Icons.mic
                                          : Icons.mic_off),
                                      color: Color(0xFF525D4D),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        adController.onButtonClick();
                                        _pickImage();
                                      },
                                      icon: Icon(Icons.camera_alt_outlined,
                                          color: Color(0xFF525D4D)),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        adController.onButtonClick();
                                        galleryImage();
                                      },
                                      icon: Icon(Icons.photo_library_outlined,
                                          color: Color(0xFF525D4D)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: localWidth * 0.03,
                                  bottom: localHeight * 0.05,
                                ),
                                child: TextButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      await _translate();
                                      adController.onButtonClick();
                                      if (translatedText.isNotEmpty) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => SHowscreen(
                                              originalText: controller.text,
                                              translatedText: translatedText,
                                              fromLanguage: selectedLanguage!,
                                              toLanguage: toLanguage!,
                                              fromFlag: selectedFlag,
                                              toFlag: toFlag,
                                            ),
                                          ),
                                        ).then((_) => controller.clear());
                                      }
                                    }
                                  },
                                  child: Text(
                                    "Translate",
                                    style: TextStyle(
                                      fontSize: localWidth * 0.05,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF26A69A),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                WordOfTheDay(),
              ],
            ),
          ),
        ));
  }
}
