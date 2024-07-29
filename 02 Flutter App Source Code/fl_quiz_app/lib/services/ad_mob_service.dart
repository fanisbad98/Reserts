import 'dart:io';
import 'package:fl_quiz_app/utils/globals.dart' as global;
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {
  static String? get bannerAdUnitId {
    if (Platform.isAndroid) {
      return global.androidAdMobBannerId;
    } else if (Platform.isIOS) {
      return global.iOSAdMobBannerId;
    }
    return null;
  }

  static String? get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return global.androidAdMobInterstitialAdId;
    } else if (Platform.isIOS) {
      return global.iOSAdMobInterstitialAdId;
    }
    return null;
  }

  static String? get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return global.androidAdMobRewardedVideoAdId;
    } else if (Platform.isIOS) {
      return global.iOSAdMobRewardedVideoAdId;
    }
    return null;
  }

  static final BannerAdListener bannerAdListener = BannerAdListener(
    onAdLoaded: (ad) => debugPrint('Add loaded'),
    onAdFailedToLoad: (ad, error) {
      ad.dispose();
      debugPrint('Add failed to load:$error');
    },
    onAdOpened: (ad) => debugPrint('Ad opened'),
    onAdClosed: (ad) => debugPrint('Ad closed'),
  );
}
