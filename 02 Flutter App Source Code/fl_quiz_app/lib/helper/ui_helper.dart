import 'dart:io';
import 'package:fl_quiz_app/providers/auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:fl_quiz_app/utils/globals.dart' as global;
import '../providers/helper_provider.dart';
import '../services/api_services.dart';
import '../utils/constant.dart';
import '../utils/widgets.dart';
import 'package:flutter_html/flutter_html.dart';

class UiHelper {
  static void showLoadingDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Container(
              width: 100.w,
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(color: primaryColor),
                  heightSpace20,
                  Text(
                    title,
                    style: primaryBold16,
                  ),
                ],
              )),
        ),
      ),
    );
  }

  static Future showQuitQuizDialog(
      {required BuildContext context, required int wrongAnswer}) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: borderRadius10),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              global.exitQuizMessage,
              style: textColorBold18,
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                  'You will loose ${global.minusGradPoints} coins,if you exit',
                  textAlign: TextAlign.center,
                  style: blackSemiBold16),
            ),
            PrimaryButton(
              text: 'Confirm',
              onTap: () {
                Navigator.pop(context, true);
                ApiServices.minusPointsAtQuit(
                    wrongAnswer: wrongAnswer, context: context);
              },
            ),
            heightSpace20,
            GestureDetector(
                onTap: () => Navigator.pop(context, false),
                child: Text('Cancel', style: blackBold18))
          ],
        ),
      ),
    );
  }

  static Future showHintDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: borderRadius10),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(hintHeader, height: 52),
            heightSpace5,
            Text('Use hint', style: textColorBold18),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                  'Using this hint remove two wrong option and you loss ${(global.hintPoints)} coins',
                  textAlign: TextAlign.center,
                  style: blackSemiBold16),
            ),
            PrimaryButton(
              text: 'Use hint',
              onTap: () async {
                Navigator.pop(context, true);
                ApiServices.minusHintPoint(context);
              },
            ),
            heightSpace20,
            GestureDetector(
                onTap: () => Navigator.pop(context, false),
                child: Text('Exit', style: blackBold18))
          ],
        ),
      ),
    );
  }
  
  static Future showRestartAppDialog(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: borderRadius10),
        content: WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Image.asset(hintHeader, height: 52),
              // heightSpace5,
              Text('Opps!', style: textColorBold20),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                    'There are some issue in the app. Please restart app.',
                    textAlign: TextAlign.center,
                    style: blackSemiBold16),
              ),
              PrimaryButton(
                text: 'Restart',
                onTap: () {
                  if (Platform.isAndroid) {
                    Restart.restartApp();
                  } else {
                    Phoenix.rebirth(context);
                  }
                },
              ),
              // heightSpace10,
            ],
          ),
        ),
      ),
    );
  }

  static showWithdrawDialog(BuildContext context, double amount) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: borderRadius10),
        contentPadding: const EdgeInsets.all(20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              successIcon,
              height: 60,
            ),
            Text('Success', style: textColorBold24),
            heightSpace20,
            Text(
              'Congretulation you successfully withdrow amount \$$amount',
              style: color94SemiBold16,
              textAlign: TextAlign.center,
            ),
            heightSpace20,
            GestureDetector(
                onTap: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                  Navigator.pushReplacementNamed(context, '/BottomNavigation');
                },
                child: Text('Back to home', style: textColorSemiBold16))
          ],
        ),
      ),
    );
  }

  static showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: borderRadius10),
        contentPadding: const EdgeInsets.all(20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Logout', style: blackBold20),
            heightSpace20,
            Text('Are you sure you want to logout?', style: blackSemiBold16),
            heightSpace20,
            Row(
                children: List.generate(
              2,
              (index) => Expanded(
                child: PrimaryContainer(
                    onTap: index == 0
                        ? () => Navigator.pop(context)
                        : () async {
                            Provider.of<HelperProvider>(context, listen: false)
                                .resetSelectedIndex();
                            AuthHandler.logOut(context);
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setBool('isAdsEnabled', false);
                            global.isAdsEnabled = prefs.getBool("isAdsEnabled");
                          },
                    boxShadow: index == 0 ? [color00Shadow] : [],
                    color: index == 0 ? white : primaryColor,
                    margin: index == 0
                        ? const EdgeInsets.only(right: 10)
                        : const EdgeInsets.only(left: 10),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    borderRadius: 5,
                    child: Text(
                      index == 0 ? 'Cancel' : 'Logout',
                      style: index == 0 ? blackSemiBold18 : whiteBold18,
                    )),
              ),
            )),
          ],
        ),
      ),
    );
  }


  static Future showUpdateDialog(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        // scrollable: true,
        shape: RoundedRectangleBorder(borderRadius: borderRadius10),
        // content: SingleChildScrollView(child:  Html(
        //     // shrinkWrap: true,
        //     data: global.updateAppMessage,
        //   ),),
        contentPadding: const EdgeInsets.all(20),
        content: Wrap(
          children: [
            Center(
              child: Image(
                image: const AssetImage(update),
                height: 15.h,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 15)
                  .copyWith(top: 0),
              child: Container(
                height: 120.0,
                width: 90.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.grey[100]),
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Html(
                      shrinkWrap: true,
                      data: global.updateAppMessage,
                    ),
                  ],
                ),
              ),
            ),
            PrimaryButton(
              text: 'Update',
              onTap: () => Navigator.pop(context, true),
            ),
            Platform.isIOS
                ? global.iOSForceUpdate
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: GestureDetector(
                            onTap: () => Navigator.pop(context, false),
                            child: Center(
                                child: Text('Later', style: blackBold18))),
                      )
                : global.androidForceUpdate
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: GestureDetector(
                            onTap: () => Navigator.pop(context, false),
                            child: Center(
                                child: Text('Later', style: blackBold18))),
                      ),
          ],
        ),
      ),
    );
  }

  static void showSnackBar(
      {required BuildContext context, required String message, int? duration}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: duration ?? 2),
        backgroundColor: primaryColor,
        content: Text(
          message,
          style: whiteSemiBold14,
        )));
  }
}

