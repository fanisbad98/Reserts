import 'package:firebase_core/firebase_core.dart';
import 'package:fl_quiz_app/helper/my_navigator_observer.dart';
import 'package:fl_quiz_app/pages/auth/login_page.dart';
import 'package:fl_quiz_app/pages/no_connection/no_connection_page.dart';
import 'package:fl_quiz_app/providers/leader_board_provider.dart';
import 'package:fl_quiz_app/providers/navigate_count_provider.dart';
import 'package:fl_quiz_app/providers/profile_provider.dart';
import 'package:fl_quiz_app/providers/wallet_provider.dart';
import 'package:fl_quiz_app/utils/globals.dart' as global;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'bottom_navigation.dart';
import 'pages/auth/otp_verification.dart';
import 'pages/auth/register_page.dart';
import 'pages/home/categories/categories_page.dart';
import 'pages/home/play_quiz/play_quiz_page.dart';
import 'pages/home/quiz_result/quiz_result_page.dart';
import 'pages/home/top_10_player/top_10_player_page.dart';
import 'pages/home/campuses/campuses_page.dart';
import 'pages/on_boarding_page/on_boarding_page.dart';
import 'pages/profile/edit_profile/edit_profile_page.dart';
import 'pages/profile/help_and_support/help_and_support_page.dart';
import 'pages/profile/privacy_policy/privacy_policy_page.dart';
import 'pages/profile/refer_friends/refer_friends_page.dart';
import 'pages/profile/rules_of_quiz/rules_of_quiz_page.dart';
import 'pages/profile/terms_of_use/terms_of_use_page.dart';
import 'pages/wallet/withdraw_method/withdraw_method.dart';
import 'providers/ads_provider.dart';
import 'providers/helper_provider.dart';
import 'providers/internet_provider.dart';
import 'providers/play_quiz_provider.dart';
import 'providers/withdraw_method_provider.dart';
import 'splash_page.dart';
import 'utils/constant.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fl_quiz_app/pages/home/success_donation_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();
  MobileAds.instance.initialize();
  Stripe.publishableKey = "pk_test_51PaCBWRqJUJdr2cCGPMKhTdAReTBJvvo5Gq2gZZot32ttuRoYNLb2XuuBag6cnBqeJsuW4xYvOaotLddoML2kjY900IpuIbCb0";
    await Stripe.instance.applySettings();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  global.isAdsEnabled = prefs.getBool("isAdsEnabled");
  global.initScreen = prefs.getInt("initScreen");
  global.isLoggedIn = prefs.getBool("isLoggedIn");
  global.token = prefs.getString('token');
  global.userName = prefs.getString('userName');
  global.userId = prefs.getString('userId');
  global.profilePic = prefs.getString('profilePic');
  global.totalPoints = prefs.getInt("totalPoints");
  global.mobileNo = prefs.getString("mobileNo");
  global.email = prefs.getString("email");
  global.referralCode = prefs.getString("referralCode");
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => LeaderBoardProvider()),
      ChangeNotifierProvider(create: (_) => PlayQuizProvider()),
      ChangeNotifierProvider(create: (_) => WithdrawMethodProvider()),
      ChangeNotifierProvider(create: (_) => InternetProvider()),
      ChangeNotifierProvider(create: (_) => AdsProvider()),
      ChangeNotifierProvider(create: (_) => HelperProvider()),
      ChangeNotifierProvider(create: (_) => WalletProvider()),
      ChangeNotifierProvider(create: (_) => ProfileProvider()),
      Provider(create: (_) => NavigateCountProvider()),
    ],
    child: Phoenix(child: const MyApp()),
  ));
}

class MyApp extends StatefulWidget {


  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  HelperProvider? helperProvider;

  @override
  void initState() {
    super.initState();
    helperProvider = Provider.of<HelperProvider>(context, listen: false);
    global.isAdShow
        ? Provider.of<AdsProvider>(context, listen: false)
            .createNavigateInterstitialAd()
        : null;
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<InternetProvider>(
      builder: (context, InternetProvider ip, child) => Sizer(
        builder: (BuildContext context, Orientation orientation,
            DeviceType deviceType) {
          return AnnotatedRegion(
            value: const SystemUiOverlayStyle(
                statusBarBrightness: Brightness.dark),
            child: MaterialApp(
              localizationsDelegates: const [],
              navigatorObservers: [
                MyNavigatorObserver(
                  adsProvider: Provider.of<AdsProvider>(context, listen: false),
                  helperProvider:
                      Provider.of<HelperProvider>(context, listen: false),
                )
              ],
              debugShowCheckedModeBanner: false,
              title: appName,
              theme: ThemeData(
                  appBarTheme: const AppBarTheme(
                      backgroundColor: primaryColor, elevation: 0),
                  primarySwatch: Colors.deepPurple,
                  scaffoldBackgroundColor: scaffoldColor),
              initialRoute: '/SplashPage',
              onGenerateRoute: (settings) {
                dynamic argument = settings.arguments;
                switch (settings.name) {
                  case '/SplashPage':
                    return PageTransition(
                        isIos: true,
                        child: const SplashPage(),
                        type: PageTransitionType.rightToLeft);
                  case '/NoConnectionPage':
                    return PageTransition(
                        isIos: true,
                        child: const NoConnectionPage(),
                        type: PageTransitionType.rightToLeft);
                  case '/OnBoardingPage':
                    return PageTransition(
                        isIos: true,
                        child: const OnBoardingPage(),
                        type: PageTransitionType.rightToLeft);
                  case '/LoginPage':
                    return PageTransition(
                        isIos: true,
                        child: const LoginPage(),
                        type: PageTransitionType.rightToLeft);
                  case '/RegisterPage':
                    return PageTransition(
                        isIos: true,
                        child: RegisterPage(
                          mobileNo: argument[0],
                          countryCode: argument[1],
                        ),
                        type: PageTransitionType.rightToLeft);
                  case '/OtpVerification':
                    return PageTransition(
                        isIos: true,
                        child: OtpVerification(
                          verificationId: argument[0],
                          phoneNo: argument[1],
                          name: argument[2],
                          email: argument[3],
                          referCode: argument[4],
                          countryCode: argument[5],
                        ),
                        type: PageTransitionType.rightToLeft);
//*BottomNavigation
                  case '/BottomNavigation':
                    return PageTransition(
                        isIos: true,
                        child: const BottomNavigation(),
                        type: PageTransitionType.rightToLeft);
                  case '/CategoriesPage':
                    return PageTransition(
                        isIos: true,
                        child: const CategoriesPage(),
                        type: PageTransitionType.rightToLeft);
                  case '/Top10PlayerPage':
                    return PageTransition(
                        isIos: true,
                        child: const Top10PlayerPage(),
                        type: PageTransitionType.rightToLeft);
                  case '/WithdrawMethod':
                    return PageTransition(
                        isIos: true,
                        child: WithdrawMethod(
                            points: argument[0], amount: argument[1]),
                        type: PageTransitionType.rightToLeft);
                  case '/PlayQuizPage':
                    return PageTransition(
                        isIos: true,
                        child: PlayQuizPage(
                          quizId: argument[0],
                          categorie: argument[1],
                        ),
                        type: PageTransitionType.rightToLeft);
                  case '/DonationSuccessPage':
                    return PageTransition(
                        isIos: true,
                        child: DonationSuccessPage(
                          selectedCategory:  argument[0],
                          amountDonated: argument[1],
                          pointsToAdd: argument[2],
                        ),
                        type: PageTransitionType.rightToLeft);
                  case '/QuizResultPage':
                    return PageTransition(
                        isIos: true,
                        child: QuizResultPage(
                          quizType: argument[0],
                          answersGiven: argument[1],
                          totalQuestion: argument[2],
                        ),
                        type: PageTransitionType.rightToLeft);
                  case '/EditProfilePage':
                    return PageTransition(
                        isIos: true,
                        child: const EditProfilePage(),
                        type: PageTransitionType.rightToLeft);
                  case '/ReferFriendsPage':
                    return PageTransition(
                        isIos: true,
                        child: const ReferFriendsPage(),
                        type: PageTransitionType.rightToLeft);
                  case '/RulesOfQuizPage':
                    return PageTransition(
                        isIos: true,
                        child: const RulesOfQuizPage(),
                        type: PageTransitionType.rightToLeft);
                  case '/TermsOfUsePage':
                    return PageTransition(
                        isIos: true,
                        child: const TermsOfUsePage(),
                        type: PageTransitionType.rightToLeft);
                  case '/PrivacyPolicyPage':
                    return PageTransition(
                        isIos: true,
                        child: const PrivacyPolicyPage(),
                        type: PageTransitionType.rightToLeft);
                  case '/HelpAndSupportPage':
                    return PageTransition(
                        isIos: true,
                        child: const HelpAndSupportPage(),
                        type: PageTransitionType.rightToLeft);
                  case '/CampusesPage':
                    return PageTransition(
                      isIos: true,
                      child: const CampusesPage(),
                      type: PageTransitionType.rightToLeft);
                }
                return null;
              },
            ),
          );
        },
      ),
    );
  }
}