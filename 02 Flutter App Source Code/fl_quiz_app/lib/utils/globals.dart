//Shared_Prefs variables
int?
    initScreen; //if it's null after splashPage its show onboard otherwise direct loginpage
bool? isLoggedIn;
// bool? isSubscribed; //check isSubscribed or not//!removed by Satyambhai
String? token = ''; //token will initialize when user try to login or register
bool? isAdsEnabled; //for remove ads while authentication
String? userName = 'user'; //save user_name
String? userId = ''; //save user_id
String? userCampus = ''; 
String? profilePic; //save profile_pic
int? totalPoints = 0; //save total_points
String? mobileNo = ''; //save user_mobile_number
String? email = ''; //save user_email
String? referralCode = '';
//temporary variables
String tempQuizId = '';
String appName = 'Reserts';
String stripeSecretKey = 'sk_test_51PaCBWRqJUJdr2cCN85NQF5RW250oc2ijCALNpvXt8FmoJ6cM8ouqlEuEcdl9bwTcfPBE7hykN4UMM5LaACSdcsA003sminVKr';
//String tempQuizLvl = '';

//App-Settings variables
bool androidUpdatePopup = false;
bool iOSUpdatePopup = false;
bool androidForceUpdate = false;
bool iOSForceUpdate = false;
String currencySymbol = "\$";
int conversionRate = 1;
bool isAdShow = false;
String androidAdMobAppId = "";
String androidAdMobBannerId = "";
String androidAdMobInterstitialAdId = "";
String androidAdMobRewardedVideoAdId = "";
String iOSAdMobAppId = "";
String iOSAdMobBannerId = "";
String iOSAdMobInterstitialAdId = "8";
String iOSAdMobRewardedVideoAdId = "";
int pointsPerQuestion = 2;
int androidAppVersionCode = 1;
int iOSAppVersionCode = 1;
String androidAppLink = "test";
String bannerImage = "public/dist/img/banner/banner-1677747593728-history.jpg";// den pairnei swsta to banner image xreiazete allagi ston kodika
String iOSAppLink = "test";
bool isMinusGrading = true;
int minusGradPoints = 1;
String referralCodePrefix = "QUZY"; //!not used
int referralPoints = 100;
int welcomePoints = 50;
bool hint5050 = true;
int timePerQuestion = 7;
// String oneSignalAppID = "68737542-c42e-4b07-9c5c-9380f1a5fe36";
String userPlaceholder = "public/dist/img/profilePic/defaultProfilePic.png";
int minWithdrawAmount = 5;
String referalText = ""; //!not used
bool isRewardedVideoAdsShow = false;
bool isVideoAdsShow = true;
String updateAppMessage = "";
int adCount = 10;
int rewardedVideoPoint = 10;
int hintPoints = 2;
String exitQuizMessage = "Are You Sure you want to Quit Quiz?";

