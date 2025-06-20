import 'dart:io';  
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_application_26/bottomnavigationscreen/Favourite.dart';
import 'package:flutter_application_26/bottomnavigationscreen/History.dart';
import 'package:flutter_application_26/bottomnavigationscreen/Setting.dart';
import 'package:flutter_application_26/bottomnavigationscreen/Translator.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;
  BannerAd? _bannerAd;
  bool _isBannerLoaded = false;

  static final List<Widget> _pages = <Widget>[
    const Translator(),
    const Favourite(),
    const History(),
    const Setting(),
  ];

  @override
  void initState() {
    super.initState();
    _initializeBannerAd();
  }

  void _initializeBannerAd() {
    String adUnitId;

    
    if (Platform.isAndroid) {
      adUnitId = 'ca-app-pub-3940256099942544/6300978111'; 
    } else if (Platform.isIOS) {
      adUnitId = 'ca-app-pub-3940256099942544/2934735716'; 
    } else {
      adUnitId = 'ca-app-pub-3940256099942544/6300978111'; 
    }

    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: adUnitId,  
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isBannerLoaded = true;
          });
          print("✅ Banner Ad Loaded");
        },
        onAdFailedToLoad: (ad, error) {
          print("❌ Failed to load banner ad: ${error.message}");
          ad.dispose(); 
        },
      ),
      request: const AdRequest(),
    )..load();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    _bannerAd?.dispose(); 
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: _pages[_selectedIndex],  
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
         
          if (_isBannerLoaded)
            SizedBox(
              height: _bannerAd!.size.height.toDouble(),
              width: _bannerAd!.size.width.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),
          SizedBox(
            height: height * 0.03,  
          ),
         
          BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: const Color(0xFF43BAA2),
            unselectedItemColor: const Color(0xFF455A64),
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.translate, size: 20),
                label: 'Translator',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border, size: 20),
                label: 'Favourite',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history, size: 20),
                label: 'History',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings, size: 20),
                label: 'Settings',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
