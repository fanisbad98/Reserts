import mongoose from "mongoose";
import db from "./dbConnection.js";

const settingSchema = new mongoose.Schema(
  {
    androidAppLink: { type: String, default: "" },
    iOSAppLink: { type: String, default: "" },
    androidAppVersionCode: { type: Number, default: 1 },
    iOSAppVersionCode: { type: Number, default: 1 },
    androidUpdatePopup: { type: Boolean, default: false },
    iOSUpdatePopup: { type: Boolean, default: false },
    androidForceUpdate: { type: Boolean, default: false },
    iOSForceUpdate: { type: Boolean, default: false },
    isMinusGrading: { type: Boolean, default: false },
    hint5050: { type: Boolean, default: false },
    hintPoints: { type: Number, default: 0 },
    exitQuizMessage: { type: String, default: "" },
    minusGradPoints: { type: Number, default: 0 },
    referralCodePrefix: { type: String, default: "QUZY" },
    welcomePoints: { type: Number, default: 0 },
    referralPoints: { type: Number, default: 0 },
    timePerQuestion: { type: Number, default: 5 },
    oneSignalAppID: { type: String, default: "" },
    oneSignalSecretKey: { type: String, default: "" },
    userPlaceholder: {
      type: String,
      default: "/public/dist/img/profilePic/defaultProfilePic.png",
    },
    privacyPolicy: { type: String, default: "" },
    termsOfUse: { type: String, default: "" },
    currencySymbol: { type: String, default: "$" },
    conversionRate: { type: Number, default: 0 },
    pointsPerQuestion: { type: Number, default: 1 },
    bannerImage: {
      type: String,
      default: "/public/dist/img/banner/banner.png",
    },
    isAdShow: { type: Boolean, default: false },
    isVideoAdsShow: { type: Boolean, default: false },
    isRewardedVideoAdsShow: { type: Boolean, default: false },
    rewardedVideoPoint: { type: Number, default: 0 },
    adCount: { type: Number, default: 0 },
    androidAdMobAppId: { type: String, default: "" },
    androidAdMobBannerId: { type: String, default: "" },
    androidAdMobInterstitialAdId: { type: String, default: "" },
    androidAdMobRewardedVideoAdId: { type: String, default: "" },
    iOSAdMobAppId: { type: String, default: "" },
    iOSAdMobBannerId: { type: String, default: "" },
    iOSAdMobInterstitialAdId: { type: String, default: "" },
    iOSAdMobRewardedVideoAdId: { type: String, default: "" },
    referalText: { type: String, default: "" },
    minWithdrawAmount: { type: Number, default: 1 },
    ruleOfQuiz: { type: String, default: "" },
    updateAppMessage: { type: String, default: "" },
    appName: { type: String, default: "Quiz & Earn" },
    appIcon: { type: String, default: "/public/dist/img/appIcon.png" },
    copyrightYear: { type: String, default: "2023" },
    appHost: { type: String, default: "AdminLTE.io" },
  },
  { timestamps: true }
);

const SettingModel = db.model("setting", settingSchema);

export { SettingModel };
