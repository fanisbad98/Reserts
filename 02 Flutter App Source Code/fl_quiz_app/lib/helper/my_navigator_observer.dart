import 'package:fl_quiz_app/providers/ads_provider.dart';
import 'package:fl_quiz_app/providers/helper_provider.dart';
import 'package:flutter/material.dart';
import 'package:fl_quiz_app/utils/globals.dart' as global;

class MyNavigatorObserver extends NavigatorObserver {
  HelperProvider helperProvider;
  AdsProvider adsProvider;
  MyNavigatorObserver(
      {Key? key, required this.helperProvider, required this.adsProvider});

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    showNavigationAdsByCount();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    showNavigationAdsByCount();
  }

  void showNavigationAdsByCount() {
    helperProvider.incrementNavigateCount();
    if (global.isAdsEnabled == true) {
      if (global.isAdShow) {
        if (helperProvider.navigateCounter % global.adCount == 0) {
          adsProvider.showNavigateInterstitialAd();
        }
      }
    }
  }
}
