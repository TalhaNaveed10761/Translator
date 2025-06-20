import 'dart:async';
import 'dart:io';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class InterstitialAdController extends GetxController {
  InterstitialAd? _interstitialAd;
  final RxBool isAdLoaded = false.obs;
  final RxBool isAdShowing = false.obs;
  final RxBool hasInternet = false.obs;
  final RxBool canShowAd = false.obs;
  Timer? _cooldownTimer;

  final RxInt adCooldownRemaining = 40.obs; 


  String get adUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/1033173712"; 
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/3986624511"; 
    } else {
      return ""; 
    }
  }

  @override
  void onInit() {
    super.onInit();
    _setupConnectivityListener();
    resetAdCooldown(); 
  }

  void _setupConnectivityListener() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    hasInternet.value = connectivityResult != ConnectivityResult.none;

    Connectivity().onConnectivityChanged.listen((result) {
      hasInternet.value = result != ConnectivityResult.none;

      if (hasInternet.value && !isAdLoaded.value && !isAdShowing.value) {
        _loadAd();
      }
    });

    if (hasInternet.value) {
      _loadAd();
    }
  }

  void resetAdCooldown() {
    _cooldownTimer?.cancel(); 
    adCooldownRemaining.value = 40;
    canShowAd.value = false;

    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (adCooldownRemaining.value > 0) {
        adCooldownRemaining.value--;
      } else {
        canShowAd.value = true;
        timer.cancel(); 
      }
    });
  }

  void _loadAd() {
    if (!hasInternet.value || isAdShowing.value) {
      print("Cannot load ad: No internet or ad is currently showing");
      return;
    }

    InterstitialAd.load(
      adUnitId: adUnitId,  
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          isAdLoaded.value = true;
          print("Interstitial Ad Loaded Successfully");

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              isAdShowing.value = true;
              isAdLoaded.value = false;
              resetAdCooldown();
            },
            onAdDismissedFullScreenContent: (ad) {
              print("Interstitial Ad Dismissed");
              isAdShowing.value = false;
              ad.dispose();
              _loadAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              print("Failed to show Interstitial Ad: $error");
              isAdShowing.value = false;
              ad.dispose();
              _loadAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          _interstitialAd = null;
          isAdLoaded.value = false;
          print("Failed to load Interstitial Ad: $error");
        },
      ),
    );
  }

  void onButtonClick() {
    if (!canShowAd.value) {
      print("Please wait ${adCooldownRemaining.value} seconds before showing next ad");
      return;
    }

    if (!hasInternet.value) {
      print("No internet connection. Cannot show ad.");
      return;
    }

    if (isAdShowing.value) {
      print("Ad is already showing");
      return;
    }

    if (isAdLoaded.value && _interstitialAd != null) {
      _interstitialAd!.show();
    } else {
      print("Interstitial Ad is not loaded, trying to reload...");
      _loadAd();
    }
  }

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    _interstitialAd?.dispose();
    super.dispose();
  }
}
