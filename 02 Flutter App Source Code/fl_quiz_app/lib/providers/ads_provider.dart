import 'package:fl_quiz_app/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:fl_quiz_app/utils/globals.dart' as global;
import '../services/ad_mob_service.dart';

class AdsProvider extends ChangeNotifier {
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  BannerAd? get bannerAd => _bannerAd;
  InterstitialAd? get interstitialAd => _interstitialAd;
  RewardedAd? get rewardedAd => _rewardedAd;

  void createNavigateInterstitialAd() {
    global.isAdsEnabled!
        ? InterstitialAd.load(
            adUnitId: AdMobService.interstitialAdUnitId!,
            request: const AdRequest(),
            adLoadCallback: InterstitialAdLoadCallback(
              onAdLoaded: (ad) => _interstitialAd = ad,
              onAdFailedToLoad: (error) => _interstitialAd = null,
            ))
        : null;
  }

  void showNavigateInterstitialAd() {
    if (global.isAdsEnabled!) {
      if (_interstitialAd != null) {
        _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (ad) {
            ad.dispose();
            createInterstitialAd();
          },
          onAdFailedToShowFullScreenContent: (ad, error) {
            ad.dispose();
            createInterstitialAd();
          },
        );
        _interstitialAd!.show();
        _interstitialAd = null;
      }
    }
  }

  void createBannerAd() {
    if (global.isAdsEnabled!) {
      _bannerAd = BannerAd(
          size: AdSize.fullBanner,
          adUnitId: AdMobService.bannerAdUnitId!,
          listener: AdMobService.bannerAdListener,
          request: const AdRequest())
        ..load();
    }
  }

  //for quiz result page
  void createInterstitialAd() {
    if (global.isAdsEnabled!) {
      InterstitialAd.load(
          adUnitId: AdMobService.interstitialAdUnitId!,
          request: const AdRequest(),
          adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (ad) => _interstitialAd = ad,
            onAdFailedToLoad: (error) => _interstitialAd = null,
          ));
    }
  }

  void createRewardedAd() {
    if (global.isAdsEnabled!) {
      RewardedAd.load(
          adUnitId: AdMobService.rewardedAdUnitId!,
          request: const AdRequest(),
          rewardedAdLoadCallback: RewardedAdLoadCallback(
            onAdLoaded: (ad) {
              _rewardedAd = ad;
              notifyListeners();
            },
            onAdFailedToLoad: (error) {
              _rewardedAd = null;
              notifyListeners();
            },
          ));
    }
  }

  void showInterstitialAd() {
    if (global.isAdsEnabled!) {
      if (_interstitialAd != null) {
        _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (ad) {
            ad.dispose();
            createInterstitialAd();
          },
          onAdFailedToShowFullScreenContent: (ad, error) {
            ad.dispose();
            createInterstitialAd();
          },
        );
        _interstitialAd!.show();
        _interstitialAd = null;
      }
    }
  }

  void showQuizInterstitialAd() {
    if (global.isAdsEnabled!) {
      if (_interstitialAd != null) {
        _interstitialAd!.fullScreenContentCallback =
            FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          createInterstitialAd();
        }, onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          createInterstitialAd();
        });
        _interstitialAd!.show();
        _interstitialAd = null;
      }
    }
  }

  void showRewardedAd() {
    if (global.isAdsEnabled!) {
      if (_rewardedAd != null) {
        _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (ad) {
            ad.dispose();
          },
          onAdFailedToShowFullScreenContent: (ad, error) {
            ad.dispose();
          },
        );
        _rewardedAd!.show(
          onUserEarnedReward: (ad, reward) {},
        );
        _rewardedAd = null;
      }
    }
  }

  Future<void> pointsForRewardedAd(BuildContext context) async {
    if (global.isAdsEnabled!) {
      if (_rewardedAd != null) {
        _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (ad) {
            ad.dispose();
            createRewardedAd();
          },
          onAdFailedToShowFullScreenContent: (ad, error) {
            ad.dispose();
            createRewardedAd();
          },
        );
        _rewardedAd!.show(
          onUserEarnedReward: (ad, reward) {
            ApiServices.addPointsByVideoAd(context);
          },
        );
        _rewardedAd = null;
      }
    }
  }
}
