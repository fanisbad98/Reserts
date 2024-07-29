import 'dart:io';
import 'package:fl_quiz_app/pages/home/campuses/campuses_page.dart';
import 'package:fl_quiz_app/pages/no_connection/no_connection_page.dart';
import 'package:fl_quiz_app/providers/ads_provider.dart';
import 'package:fl_quiz_app/providers/helper_provider.dart';
import 'package:fl_quiz_app/providers/internet_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:fl_quiz_app/utils/globals.dart' as global;
import 'pages/home/home_page.dart';
import 'pages/leaderboard/leaderboard_page.dart';
import 'pages/profile/profile_page.dart';
import 'pages/wallet/wallet_page.dart';
import 'utils/constant.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

final List<Widget> _widgetOptions = <Widget>[
  const HomePage(),
  const CampusesPage(),
  const LeaderboardPage(),
  const WalletPage(),
  const ProfilePage(),
];


class _BottomNavigationState extends State<BottomNavigation> {
  DateTime? currentBackPressTime;

  @override
  void initState() {
    super.initState();
    Provider.of<InternetProvider>(context, listen: false)
        .checkRealtimeConnection();
    global.isAdShow
        ? Provider.of<AdsProvider>(context, listen: false).createBannerAd()
        : null;
    global.isAdShow
        ? Provider.of<AdsProvider>(context, listen: false)
            .createInterstitialAd()
        : null;
  }

  @override
  Widget build(BuildContext context) {
  if (global.isAdsEnabled == true) {
    int navigateCounter = Provider.of<HelperProvider>(context).navigateCounter;
    int adCount = global.adCount; 
    if (adCount != 0 && navigateCounter % adCount == 0) {
      try {
        Provider.of<AdsProvider>(context).showInterstitialAd();
      } catch (e) {
        print('Caught IntegerDivisionByZero exception: $e');
      }
    }
  }
  return WillPopScope(
      onWillPop: () async {
        bool backStatus = onWillPop();
        if (backStatus) {
          exit(0);
        }
        return false;
      },
      child: Consumer3<InternetProvider, AdsProvider, HelperProvider>(
        builder: (context, ip, adsProvider, helper, child) => ip.status ==
                'Offline'
            ? const NoConnectionPage()
            : Scaffold(
                bottomSheet:
                    adsProvider.bannerAd == null || helper.selectedIndex == 1
                        ? const SizedBox()
                        : SizedBox(
                            height: 56,
                            child: AdWidget(ad: adsProvider.bannerAd!)),
                bottomNavigationBar: Theme(
                  data: Theme.of(context)
                      .copyWith(canvasColor: color5E, splashColor: transparent),
                  child: BottomNavigationBar(
                    elevation: 20,
                    items: [
                      BottomNavigationBarItem(
                          icon: Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: SizedBox(
                              height: 3.h,
                              child: Image.asset(bn1,
                                  color: helper.selectedIndex == 0
                                      ? colorE2
                                      : white),
                            ),
                          ),
                          label: 'Home'),
                      BottomNavigationBarItem(
                          icon: Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: SizedBox(
                              height: 3.h,
                              child: Image.asset(bn4,
                              color: helper.selectedIndex == 1
                                      ? colorE2
                                      : white),
                            ),
                          ),
                          label: 'Campuses'),
                      BottomNavigationBarItem(
                          icon: Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: SizedBox(
                              height: 3.h,
                              child: Image.asset(bn2,
                                  color: helper.selectedIndex == 2
                                      ? colorE2
                                      : white),
                            ),
                          ),
                          label: 'Contributors'),
                      BottomNavigationBarItem(
                          icon: Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: SizedBox(
                              height: 3.h,
                              child: Image.asset(bn3,
                                  color: helper.selectedIndex == 3
                                      ? colorE2
                                      : white),
                            ),
                          ),
                          label: 'Wallet'),
                      BottomNavigationBarItem(
                          icon: Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: SizedBox(
                              height: 3.h,
                              child: Image.asset(profileIcon,
                                  color: helper.selectedIndex == 4
                                      ? colorE2
                                      : white),
                            ),
                          ),
                          label: 'Profile'),
                    ],
                    onTap: (int index) {
                      helper.onBottomNavTap(index);
                      helper.incrementNavigateCount();
                    },
                    currentIndex: helper.selectedIndex,
                    selectedItemColor: primaryColor,
                    unselectedItemColor: colorC3,
                    showUnselectedLabels: true,
                    unselectedLabelStyle: whiteBold14,
                    type: BottomNavigationBarType.fixed,
                  ),
                ),
                body: _widgetOptions.elementAt(helper.selectedIndex),
              ),
      ),
    );
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
