import 'dart:io'; 
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class ReusableNativeAd extends StatefulWidget {
  final String? adUnitId; 
  final double height;
  final double width;

  const ReusableNativeAd({
    super.key,
    this.adUnitId,
    this.height = 100.0,
    this.width = 200.0,
  });

  @override
  _ReusableNativeAdState createState() => _ReusableNativeAdState();
}

class _ReusableNativeAdState extends State<ReusableNativeAd> {
  NativeAd? _nativeAd;
  bool _nativeAdIsLoaded = false;

  @override
  void initState() {
    super.initState();
    loadAd();
  }

  void loadAd() {
   
    String adUnitId = widget.adUnitId ??
        (Platform.isAndroid
            ? 'ca-app-pub-3940256099942544/2247696110' 
            : 'ca-app-pub-3940256099942544/3986624511'); 

    _nativeAd = NativeAd(
      adUnitId: adUnitId,
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          debugPrint('NativeAd loaded.');
          setState(() {
            _nativeAdIsLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('NativeAd failed to load: $error');
          ad.dispose();
        },
      ),
      request: const AdRequest(),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.small,
        mainBackgroundColor: Color(0xFFF5F5F5),
        cornerRadius: 16.0,
        callToActionTextStyle: NativeTemplateTextStyle(
          textColor: Colors.white,
          backgroundColor: Color(0xFF26A69A),
          style: NativeTemplateFontStyle.monospace,
          size: 16.0,
        ),
        primaryTextStyle: NativeTemplateTextStyle(
          textColor: Color(0xFF202328),
          style: NativeTemplateFontStyle.italic,
          size: 16.0,
        ),
        secondaryTextStyle: NativeTemplateTextStyle(
          textColor: Color(0xFF26A69A),
          backgroundColor: Colors.black,
          style: NativeTemplateFontStyle.bold,
          size: 16.0,
        ),
        tertiaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.brown,
          backgroundColor: Colors.amber,
          style: NativeTemplateFontStyle.normal,
          size: 16.0,
        ),
      ),
    )..load();
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   
    return _nativeAdIsLoaded
        ? SizedBox(
            height: widget.height,
            width: widget.width,
            child: AdWidget(ad: _nativeAd!),
          )
        : SizedBox();
}
}
