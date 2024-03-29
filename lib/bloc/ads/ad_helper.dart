import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {
  Future<InitializationStatus> initialized;
  AdHelper({required this.initialized});
  String get bannerAdUnitId {
    if (Platform.isAndroid) {
      String testAdId = "ca-app-pub-3940256099942544/6300978111";
      String prodAdId = "ca-app-pub-7439240901787604/5744305798";
      return kReleaseMode ? prodAdId : testAdId;
    } else if (Platform.isIOS) {
      String testAdId = "ca-app-pub-3940256099942544/6300978111";
      String prodAdId = "ca-app-pub-7439240901787604/6795820554";
      return kReleaseMode ? prodAdId : testAdId;
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return '<YOUR_ANDROID_INTERSTITIAL_AD_UNIT_ID>';
    } else if (Platform.isIOS) {
      return '<YOUR_IOS_INTERSTITIAL_AD_UNIT_ID>';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      String testAdId = "ca-app-pub-3940256099942544/5224354917";
      String prodAdId = "ca-app-pub-7439240901787604/6865815778";

      return kReleaseMode ? prodAdId : testAdId;
    } else if (Platform.isIOS) {
      String testAdId = "ca-app-pub-3940256099942544/1712485313";
      String prodAdId = "ca-app-pub-7439240901787604/1840869165";

      return kReleaseMode ? prodAdId : testAdId;
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  final BannerAdListener listener = BannerAdListener(
    // Called when an ad is successfully received.
    onAdLoaded: (Ad ad) => debugPrint('Ad loaded.'),
    // Called when an ad request failed.
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      // Dispose the ad here to free resources.
      ad.dispose();
      debugPrint('Ad failed to load: $error');
    },
    // Called when an ad opens an overlay that covers the screen.
    onAdOpened: (Ad ad) => debugPrint('Ad opened.'),
    // Called when an ad removes an overlay that covers the screen.
    onAdClosed: (Ad ad) => debugPrint('Ad closed.'),
    // Called when an impression occurs on the ad.
    onAdImpression: (Ad ad) => debugPrint('Ad impression.'),
  );
}
