import 'dart:developer';
import 'package:fl_quiz_app/helper/ui_helper.dart';
import 'package:fl_quiz_app/services/api_services.dart';
import 'package:fl_quiz_app/utils/globals.dart' as global;
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/api_constant.dart';
import '../utils/constant.dart';

Dio dio = Dio();

Future<void> firebaseAuthentication(
    {required String number,
    required BuildContext context,
    required String countryCode}) async {
  String phoneNumber = '$countryCode$number';

  await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      codeSent: (verificationId, forceResendingToken) {
        Navigator.popAndPushNamed(context, '/OtpVerification', arguments: [
          verificationId,
          number,
          null,
          null,
          null,
          countryCode,
        ]); //!required arguments
      },
      verificationCompleted: (phoneAuthCredential) {},
      verificationFailed: (error) {
        if (error.code == 'too-many-requests') {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              duration: const Duration(seconds: 5),
              backgroundColor: primaryColor,
              content: Text(
                "We're sorry, but you have sent too many requests to us recently,Please try again later.",
                style: whiteSemiBold14,
              )));
        } else if (error.code == 'invalid-phone-number') {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              duration: const Duration(seconds: 5),
              backgroundColor: primaryColor,
              content: Text(
                "We're sorry, but you have entered invalid phone number,Please enter valid phone number",
                style: whiteSemiBold14,
              )));
        } else {
          Navigator.pop(context);
          log(error.code.toString());
        }
      },
      codeAutoRetrievalTimeout: (verificationId) {},
      timeout: const Duration(seconds: 60));
}

class AuthHandler {
  static Future<void> login(
      {required number, required context, required countryCode}) async {
    if (number.isNotEmpty) {
      try {
        Response response =
            await dio.get(ApiConstants.login, data: {"mobile": number});
        if (response.statusCode == 200) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('token', response.data['data']['token']);
          global.token = prefs.getString('token');
          prefs.setString('userId', response.data['data']['_id']);
          global.userId = prefs.getString('userId');
          prefs.setString('userName', response.data['data']['name']);
          global.userName = prefs.getString('userName');
          prefs.setString('profilePic', response.data['data']['profile']);
          // global.userCampus = prefs.getString('campus');
          // prefs.setString('userCampus', response.data['data']['campus']);
          global.profilePic = prefs.getString('profilePic');
          prefs.setInt('totalPoints', response.data['data']['totalPoints']);
          global.totalPoints = prefs.getInt('totalPoints');
          prefs.setString('mobileNo', response.data['data']['mobile']);
          global.mobileNo = prefs.getString('mobileNo');
          prefs.setString('email', response.data['data']['email']);
          global.email = prefs.getString('email');
          prefs.setString(
              'referralCode', response.data['data']['referralCode']);
          global.referralCode = prefs.getString('referralCode');
          firebaseAuthentication(
              number: number, context: context, countryCode: countryCode);
        }
      } on DioError catch (e) {
        Navigator.pop(context);
        log(e.error.toString());
        Navigator.pushNamed(context, '/RegisterPage',
            arguments: [number, countryCode]);
      }
    }
  }

  static Future<void> register(
      {required name,
      required email,
      required number,
      required referCode,
      required context,
      required countryCode,
      //campus
      })async {
    try {
      Response registerResponse = await dio.post(ApiConstants.register, data: {
        "name": name,
        "email": email,
        "mobile": number,
        "referedBy": referCode,
        //"campus" : null
      });
      if (registerResponse.statusCode == 200) {
        log('Register Success');
        try {
          Response loginResponse =
              await dio.get(ApiConstants.login, data: {"mobile": number});
          if (loginResponse.statusCode == 200) {
            log('Login Success');
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('token', loginResponse.data['data']['token']);
            global.token = prefs.getString('token');
            // prefs.setString('userCampus', loginResponse.data['data']['campus']);
            // global.userCampus prefs.getString('userCampus');
            prefs.setString('userId', loginResponse.data['data']['_id']);           
            global.userId = prefs.getString('userId');
            prefs.setString('userName', name);
            global.userName = prefs.getString('userName');
            prefs.setString(
                'profilePic', loginResponse.data['data']['profile']);
            global.profilePic = prefs.getString('profilePic');
            prefs.setInt(
                'totalPoints', loginResponse.data['data']['totalPoints']);
            global.totalPoints = prefs.getInt('totalPoints');
            prefs.setString('mobileNo', loginResponse.data['data']['mobile']);
            global.mobileNo = prefs.getString('mobileNo');
            prefs.setString('email', loginResponse.data['data']['email']);
            global.email = prefs.getString('email');
            prefs.setBool('isLoggedIn', true);
            global.isLoggedIn = prefs.getBool("isLoggedIn");
            prefs.setBool('isAdsEnabled', true);
            global.isAdsEnabled = prefs.getBool("isAdsEnabled");
            //!enabled notification only for logged in user
            await OneSignal.shared.setExternalUserId(global.userId!);
            Navigator.popUntil(context, (route) => route.isFirst);
            Navigator.pushReplacementNamed(context, '/BottomNavigation');
          }
        } on DioError catch (e) {
          log(e.error.toString());
        }
      }
    } on DioError catch (e) {
      log(e.response!.data['err_msg']);
    }
  }

  static Future<void> sendOTP({
    required String number,
    required BuildContext context,
    required String countryCode,
    required String name,
    required String email,
    required String referCode,
  }) async {
    String phoneNumber = '$countryCode$number';
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        codeSent: (verificationId, forceResendingToken) {
          Navigator.popAndPushNamed(context, '/OtpVerification', arguments: [
            verificationId,
            number,
            name,
            email,
            referCode,
            countryCode,
          ]); //!required arguments
        },
        verificationCompleted: (phoneAuthCredential) {},
        verificationFailed: (error) {
          if (error.code == 'too-many-requests') {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: const Duration(seconds: 5),
                backgroundColor: primaryColor,
                content: Text(
                  "We're sorry, but you have sent too many requests to us recently,Please try again later.",
                  style: whiteSemiBold14,
                )));
          } else if (error.code == 'invalid-phone-number') {
            Navigator.pop(context);
            UiHelper.showSnackBar(
                context: context, message: "Please enter valid phone number");
          } else {
            Navigator.pop(context);
            log(error.code.toString());
          }
        },
        codeAutoRetrievalTimeout: (verificationId) {},
        timeout: const Duration(seconds: 60));
  }

  static Future<void> logOut(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('isSubscribed');
    prefs.remove('userId');
    prefs.remove('userName');
    //prefs.remove('userCampus');
    prefs.remove('profilePic');
    prefs.remove('mobileNo');
    prefs.remove('email');
    prefs.remove('isLoggedIn');
    prefs.remove('totalPoints');
    OneSignal.shared.removeExternalUserId();
    await FirebaseAuth.instance.signOut();
    await ApiServices.logOut();
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacementNamed(context, '/LoginPage');
  }
}
