import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_quiz_app/pages/no_connection/no_connection_page.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:fl_quiz_app/utils/globals.dart' as global;
import '../../helper/ui_helper.dart';
import '../../providers/auth_handler.dart';
import '../../providers/internet_provider.dart';
import '../../utils/constant.dart';
import '../../utils/widgets.dart';

class OtpVerification extends StatefulWidget {
  final String verificationId;
  final String phoneNo;
  final String? name;
  final String? email;
  final String? referCode;
  final String? countryCode;
  const OtpVerification(
      {Key? key,
      required this.verificationId,
      required this.phoneNo,
      this.name,
      this.email,
      this.referCode,
      this.countryCode})
      : super(key: key);

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

final defaultPinTheme = PinTheme(
  width: 4.5.h,
  height: 4.5.h,
  textStyle: TextStyle(fontSize: 13.5.sp, color: primaryColor, fontFamily: 'R'),
  decoration: BoxDecoration(
      color: white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          blurRadius: 4,
          offset: const Offset(0, 0),
          color: colorForShadow.withOpacity(.25),
        ),
      ]),
  margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
);

final focusedPinTheme = defaultPinTheme.copyDecorationWith(
    color: white,
    borderRadius: BorderRadius.circular(10),
    boxShadow: [
      BoxShadow(
        blurRadius: 4,
        offset: const Offset(0, 0),
        color: colorForShadow.withOpacity(.25),
      )
    ]);

final submittedPinTheme = defaultPinTheme.copyWith(
  decoration: defaultPinTheme.decoration?.copyWith(
      color: white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: primaryColor),
      boxShadow: [
        BoxShadow(
          blurRadius: 4,
          offset: const Offset(0, 0),
          color: colorForShadow.withOpacity(.25),
        )
      ]),
);

class _OtpVerificationState extends State<OtpVerification> {
  bool isCountdownCompleted = false;
  final CountdownController _countdownController =
      CountdownController(autoStart: true);
  final _otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<InternetProvider>(context, listen: false)
        .checkRealtimeConnection();
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> verifyOtp() async {
    String otp = _otpController.text.trim();
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId, smsCode: otp);
    if (widget.name == null) {
      forRegistered(credential);
    } else {
      forUnregistered(credential);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InternetProvider>(
      builder: (context, InternetProvider ip, child) => ip.status == "Offline"
          ? const NoConnectionPage()
          : Scaffold(
              body: ListView(
                padding: EdgeInsets.zero,
                physics: const BouncingScrollPhysics(),
                children: [
                  Container(
                    height: 41.h,
                    width: 100.w,
                    decoration: const BoxDecoration(
                        color: primaryColor,
                        image: DecorationImage(
                            image: AssetImage(authBubbleBG),
                            fit: BoxFit.cover)),
                    child: SafeArea(
                        child: Column(
                      children: [
                        heightSpace5,
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: const Icon(Icons.arrow_back,
                                      color: white))
                            ],
                          ),
                        ),
                        Transform.translate(
                          offset: const Offset(0, -12.5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Otp verification', style: whiteExtraBold22),
                              heightSpace5,
                              Text(
                                'Welcome to $appName. Please verify your mobile number',
                                style: colorCCSemiBold15,
                                textAlign: TextAlign.center,
                              ),
                              heightSpace25,
                              Image.asset(otpHeaderImage, height: 150),
                            ],
                          ),
                        ),
                      ],
                    )),
                  ),
                  ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(20).copyWith(top: 48),
                    children: [
                      Text(
                        'Confirmation code has been send to your\nmobile no ${widget.countryCode}(${widget.phoneNo})',
                        style: color94SemiBold14,
                        textAlign: TextAlign.center,
                      ),
                      heightSpace35,
                      Pinput(
                          controller: _otpController,
                          length: 6,
                          defaultPinTheme: defaultPinTheme,
                          focusedPinTheme: focusedPinTheme,
                          submittedPinTheme: submittedPinTheme,
                          pinputAutovalidateMode:
                              PinputAutovalidateMode.onSubmit,
                          showCursor: true,
                          onCompleted: (pin) {}),
                      heightSpace40,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsetsDirectional.symmetric(
                                vertical: 5, horizontal: 27.5),
                            decoration: BoxDecoration(
                              borderRadius: borderRadius10,
                              color: const Color(0xffDCE0E5),
                            ),
                            child: Countdown(
                              controller: _countdownController,
                              onFinished: () {
                                isCountdownCompleted = true;
                                setState(() {});
                              },
                              seconds: 60,
                              build: (BuildContext context, double time) =>
                                  Text(
                                '00.${time.toStringAsFixed(0).padLeft(2, '0')}',
                                style: primarySemiBold14,
                              ),
                              interval: const Duration(milliseconds: 100),
                            ),
                          ),
                        ],
                      ),
                      heightSpace25,
                      PrimaryButton(
                        text: 'Verify',
                        onTap: () {
                          UiHelper.showLoadingDialog(context, 'Please wait');
                          verifyOtp();
                        },
                      ),
                      heightSpace15,
                      isCountdownCompleted
                          ? Center(
                              child: GestureDetector(
                                  onTap: () {
                                    setState(() {});
                                    isCountdownCompleted = false;
                                    resendOTP().then((value) =>
                                        _countdownController.restart());
                                  },
                                  child: Text('Resend', style: primaryBold15)))
                          : const SizedBox()
                    ],
                  )
                ],
              ),
            ),
    );
  }

  Future<void> resendOTP() async {
    String phoneNumber = '${widget.countryCode}${widget.phoneNo}';
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        codeSent: (verificationId, forceResendingToken) {},
        verificationCompleted: (phoneAuthCredential) {},
        verificationFailed: (error) {
          log(error.code.toString());
        },
        codeAutoRetrievalTimeout: (verificationId) {},
        timeout: const Duration(seconds: 60));
  }

  void forUnregistered(PhoneAuthCredential credential) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCredential.user != null) {
        if (!mounted) return;
        AuthHandler.register(
            name: widget.name,
            email: widget.email,
            number: widget.phoneNo,
            referCode: widget.referCode,
            context: context,
            countryCode: widget.countryCode);
      }
    } on FirebaseAuthException catch (ex) {
      if (ex.code == 'invalid-verification-code') {
        // OTP verification failed
        Navigator.pop(context);
        UiHelper.showSnackBar(context: context, message: 'Invalid otp');
      } else {
        log(ex.code.toString());
      }
    }
  }

  void forRegistered(PhoneAuthCredential credential) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCredential.user != null) {
        if (!mounted) return;

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('isLoggedIn', true);
        global.isLoggedIn = prefs.getBool("isLoggedIn");
        prefs.setBool('isAdsEnabled', true);
        global.isAdsEnabled = prefs.getBool("isAdsEnabled");
        if (!mounted) return;
        //!enabled notification only for logged in user
        await OneSignal.shared.setExternalUserId(global.userId!);
        if (!mounted) return;
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacementNamed(context, '/BottomNavigation');
      }
    } on FirebaseAuthException catch (ex) {
      if (ex.code == 'invalid-verification-code') {
        // OTP verification failed
        Navigator.pop(context);
        UiHelper.showSnackBar(context: context, message: 'Invalid otp');
      } else {
        log(ex.code.toString());
      }
    }
  }
}
