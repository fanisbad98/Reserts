class AppSettingResponse {
  AppSettingResponse({
    required this.result,
    required this.statusCode,
    required this.msg,
    required this.data,
  });

  int result;
  int statusCode;
  String msg;
  AppSettingData data;

  factory AppSettingResponse.fromJson(Map<String, dynamic> json) =>
      AppSettingResponse(
        result: json["result"],
        statusCode: json["statusCode"],
        msg: json["msg"],
        data: AppSettingData.fromJson(json["data"]),
      );
}

class AppSettingData {
  AppSettingData({
    required this.androidUpdatePopup,
    required this.iOsUpdatePopup,
    required this.androidForceUpdate,
    required this.iOsForceUpdate,
    required this.currencySymbol,
    required this.conversionRate,
    required this.isAdShow,
    required this.androidAdMobAppId,
    required this.androidAdMobBannerId,
    required this.androidAdMobInterstitialAdId,
    required this.androidAdMobRewardedVideoAdId,
    required this.iOsAdMobAppId,
    required this.iOsAdMobBannerId,
    required this.iOsAdMobInterstitialAdId,
    required this.iOsAdMobRewardedVideoAdId,
    required this.pointsPerQuestion,
    required this.androidAppVersionCode,
    required this.iOsAppVersionCode,
    required this.bannerImage,
    required this.androidAppLink,
    required this.iOsAppLink,
    required this.isMinusGrading,
    required this.minusGradPoints,
    required this.referralCodePrefix,
    required this.referralPoints,
    required this.welcomePoints,
    required this.hint5050,
    required this.timePerQuestion,
    required this.oneSignalAppId,
    required this.userPlaceholder,
    required this.minWithdrawAmount,
    required this.referalText,
    required this.isRewardedVideoAdsShow,
    required this.isVideoAdsShow,
    required this.updateAppMessage,
    required this.adCount,
    required this.rewardedVideoPoint,
    required this.hintPoints,
    required this.exitQuizMessage,
  });

  bool androidUpdatePopup;
  bool iOsUpdatePopup;
  bool androidForceUpdate;
  bool iOsForceUpdate;
  String currencySymbol;
  int conversionRate;
  bool isAdShow;
  String androidAdMobAppId;
  String androidAdMobBannerId;
  String androidAdMobInterstitialAdId;
  String androidAdMobRewardedVideoAdId;
  String iOsAdMobAppId;
  String iOsAdMobBannerId;
  String iOsAdMobInterstitialAdId;
  String iOsAdMobRewardedVideoAdId;
  int pointsPerQuestion;
  int androidAppVersionCode;
  int iOsAppVersionCode;
  String bannerImage;
  String androidAppLink;
  String iOsAppLink;
  bool isMinusGrading;
  int minusGradPoints;
  String referralCodePrefix;
  int referralPoints;
  int welcomePoints;
  bool hint5050;
  int timePerQuestion;
  String oneSignalAppId;
  String userPlaceholder;
  int minWithdrawAmount;
  String referalText;
  bool isRewardedVideoAdsShow;
  bool isVideoAdsShow;
  String updateAppMessage;
  int adCount;
  int rewardedVideoPoint;
  int hintPoints;
  String exitQuizMessage;

  factory AppSettingData.fromJson(Map<String, dynamic> json) => AppSettingData(
        androidUpdatePopup: json["androidUpdatePopup"],
        iOsUpdatePopup: json["iOSUpdatePopup"],
        androidForceUpdate: json["androidForceUpdate"],
        iOsForceUpdate: json["iOSForceUpdate"],
        currencySymbol: json["currencySymbol"],
        conversionRate: json["conversionRate"],
        isAdShow: json["isAdShow"],
        androidAdMobAppId: json["androidAdMobAppId"],
        androidAdMobBannerId: json["androidAdMobBannerId"],
        androidAdMobInterstitialAdId: json["androidAdMobInterstitialAdId"],
        androidAdMobRewardedVideoAdId: json["androidAdMobRewardedVideoAdId"],
        iOsAdMobAppId: json["iOSAdMobAppId"],
        iOsAdMobBannerId: json["iOSAdMobBannerId"],
        iOsAdMobInterstitialAdId: json["iOSAdMobInterstitialAdId"],
        iOsAdMobRewardedVideoAdId: json["iOSAdMobRewardedVideoAdId"],
        pointsPerQuestion: json["pointsPerQuestion"],
        androidAppVersionCode: json["androidAppVersionCode"],
        iOsAppVersionCode: json["iOSAppVersionCode"],
        bannerImage: json["bannerImage"],
        androidAppLink: json["androidAppLink"],
        iOsAppLink: json["iOSAppLink"],
        isMinusGrading: json["isMinusGrading"],
        minusGradPoints: json["minusGradPoints"],
        referralCodePrefix: json["referralCodePrefix"],
        referralPoints: json["referralPoints"],
        welcomePoints: json["welcomePoints"],
        hint5050: json["hint5050"],
        timePerQuestion: json["timePerQuestion"],
        oneSignalAppId: json["oneSignalAppID"],
        userPlaceholder: json["userPlaceholder"],
        minWithdrawAmount: json["minWithdrawAmount"],
        referalText: json["referalText"],
        isRewardedVideoAdsShow: json["isRewardedVideoAdsShow"],
        isVideoAdsShow: json["isVideoAdsShow"],
        updateAppMessage: json["updateAppMessage"],
        adCount: json["adCount"],
        rewardedVideoPoint: json["rewardedVideoPoint"],
        hintPoints: json["hintPoints"],
        exitQuizMessage: json["exitQuizMessage"],
      );
}
