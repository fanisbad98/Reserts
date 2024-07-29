import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fl_quiz_app/models/my_profile_model.dart';
import 'package:fl_quiz_app/utils/api_constant.dart';
import 'package:fl_quiz_app/utils/constant.dart';
import 'package:fl_quiz_app/utils/globals.dart' as global;
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'helper/ui_helper.dart';
import 'models/app_settings_model.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  MyProfileResponse? myProfileResponse;
  DateTime? currentBackPressTime;
  @override
  void initState() {
    super.initState();
    checkAppVersion();

    asignOneSignal();
  }

  Future<void> fetchAppSettings() async {
    AppSettingResponse? appSettingResponce;
    try {
      Response response = await Dio().get(ApiConstants.appSettings);
      if (response.statusCode == 200) {
        appSettingResponce = AppSettingResponse.fromJson(response.data);
        asignGlobalVariables(appSettingResponce);
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectionTimeout) {
        await UiHelper.showRestartAppDialog(context);
      } else {
        log('fetchAppSetting:${e.message}');
      }
    }
  }

  void asignOneSignal() {
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    OneSignal.shared.setAppId(oneSignalAppID);

    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      log("OneSignal Permission Accepted:$accepted");
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool backStatus = onWillPop();
        if (backStatus) {
          exit(0);
        }
        return false;
      },
      child: Scaffold(
        body: Container(
          height: 100.h,
          width: 100.w,
          decoration: const BoxDecoration(
              color: primaryColor,
              image: DecorationImage(
                  image: AssetImage(onBoardBubbleBG), fit: BoxFit.cover)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                logo,
                scale: 3.5,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void asignGlobalVariables(AppSettingResponse appSettingResponce) {
    AppSettingData asd = appSettingResponce.data;
    global.updateAppMessage = asd.updateAppMessage;
    global.androidUpdatePopup = asd.androidUpdatePopup;
    global.iOSUpdatePopup = asd.iOsUpdatePopup;
    global.androidForceUpdate = asd.androidForceUpdate;
    global.iOSForceUpdate = asd.iOsForceUpdate;
    global.currencySymbol = asd.currencySymbol;
    global.conversionRate = asd.conversionRate;
    global.isAdShow = asd.isAdShow;
    global.androidAdMobAppId = asd.androidAdMobAppId;
    global.androidAdMobBannerId = asd.androidAdMobBannerId;
    global.androidAdMobInterstitialAdId = asd.androidAdMobInterstitialAdId;
    global.androidAdMobRewardedVideoAdId = asd.androidAdMobRewardedVideoAdId;
    global.iOSAdMobAppId = asd.iOsAdMobAppId;
    global.iOSAdMobBannerId = asd.iOsAdMobBannerId;
    global.iOSAdMobInterstitialAdId = asd.iOsAdMobInterstitialAdId;
    global.iOSAdMobRewardedVideoAdId = asd.iOsAdMobRewardedVideoAdId;
    global.pointsPerQuestion = asd.pointsPerQuestion;
    global.androidAppVersionCode = asd.androidAppVersionCode;
    global.iOSAppVersionCode = asd.iOsAppVersionCode;
    global.bannerImage = asd.bannerImage;
    global.androidAppLink = asd.androidAppLink;
    global.iOSAppLink = asd.iOsAppLink;
    global.isMinusGrading = asd.isMinusGrading;
    global.minusGradPoints = asd.minusGradPoints;
    global.referralCodePrefix = asd.referralCodePrefix;
    global.referralPoints = asd.referralPoints;
    global.welcomePoints = asd.welcomePoints;
    global.hint5050 = asd.hint5050;
    global.timePerQuestion = asd.timePerQuestion;
    // global.oneSignalAppID = asd.oneSignalAppId;
    global.userPlaceholder = asd.userPlaceholder;
    global.minWithdrawAmount = asd.minWithdrawAmount;
    global.referalText = asd.referalText;
    global.isRewardedVideoAdsShow = asd.isRewardedVideoAdsShow;
    global.isVideoAdsShow = asd.isVideoAdsShow;
    global.adCount = asd.adCount;
    global.rewardedVideoPoint = asd.rewardedVideoPoint;
    global.hintPoints = asd.hintPoints;
    global.exitQuizMessage = asd.exitQuizMessage;
  }

  void regularRoute() {
    Future.delayed(const Duration(seconds: 3))
        .then((value) => Navigator.pushReplacementNamed(
            context,
            global.initScreen == null
                ? '/OnBoardingPage'
                : global.isLoggedIn == null
                    ? '/LoginPage'
                    : '/BottomNavigation'));
  }

  void checkAppVersion() async {
    // PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // String version = packageInfo.version;
    await fetchAppSettings();

    if (!mounted) return;
    if (Platform.isIOS) {
      if (global.iOSUpdatePopup) {
        if (myIosVersion < global.iOSAppVersionCode) {
          bool? result = await UiHelper.showUpdateDialog(context);
          if (result == true) {
            launchAppStore();
            if (!mounted) return;
            Navigator.pushReplacementNamed(context, '/SplashPage');
          } else if (result == false) {
            regularRoute();
          }
        } else {
          regularRoute();
        }
      } else {
        regularRoute();
      }
    } else {
      if (global.androidUpdatePopup) {
        if (myAndroidVersion < global.androidAppVersionCode) {
          bool? result = await UiHelper.showUpdateDialog(context);
          if (result == true) {
            launchPlayStore();
            if (!mounted) return;
            Navigator.pushReplacementNamed(context, '/SplashPage');
          } else if (result == false) {
            regularRoute();
          }
        } else {
          regularRoute();
        }
      } else {
        regularRoute();
      }
    }
  }

  Future<void> launchAppStore() async {
    if (await canLaunchUrl(Uri.parse(global.iOSAppLink))) {
      await launchUrl(Uri.parse(global.iOSAppLink));
    } else {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/SplashPage');
      throw 'Could not launch AppStore URL';
    }
  }

  Future<void> launchPlayStore() async {
    if (await canLaunchUrl(Uri.parse(global.androidAppLink))) {
      await launchUrl(Uri.parse(global.androidAppLink));
    } else {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/SplashPage');
      throw 'Could not launch PlayStore URL';
    }
  }

  onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: primaryColor,
        content: Text('Press back again to exit', style: whiteSemiBold14),
        duration: const Duration(seconds: 1),
      ));
      return false;
    } else {
      return true;
    }
  }
}
