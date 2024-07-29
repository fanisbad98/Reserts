import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

//Application name
String appName = 'Reserts';
//OneSignal app_id
String oneSignalAppID = "60830851-4026-4e4b-9056-394333f06c15";
int myAndroidVersion = 1;
int myIosVersion = 1;

//Colors
const Color primaryColor = Color(0xff171617);
const Color color5E = Color(0xff689caa);
const Color colorC3 = Color(0xff83ccdf);
const Color amber = Colors.amber;
const Color black = Color(0xff3C3C3C);
const Color white = Colors.white;
const Color transparent = Colors.transparent;
const Color scaffoldColor = Color(0xff507580);
const Color pointsColor = Color(0xffE99634);
const Color timerBoxColor = Color(0xff507580);
const Color colorE2 = Color(0xff2f474e);
const Color textColor = Color(0xff2f474e);
const Color profileBgColor = Color(0xff83ccdf);
const Color colorCC = Color(0xffCCC9EB);
const Color color0 = Color(0xff507580);
const Color selectedAnswerColor = Color(0xff83ccdf);
const Color colorEE = Color(0xffEEEEF0);
const Color colorDB = Color(0xffDBD1FB);
const Color colorDA = Color(0xffDADADA);
const Color colorD9 = Color(0xffD9D9D9);
const Color color94 = Color(0xff949494);
const Color colorB4 = Color(0xffB4B4B4);
const Color colorB7 = Color(0xffB7B7B7);
const Color appRed = Color(0xffF23138);
const Color appGreen = Color(0xff2EBD5D);
const Color colorForShadow = Color(0xff000000);

//Others
BorderRadius borderRadius5 = BorderRadius.circular(5);
BorderRadius borderRadius10 = BorderRadius.circular(10);
BoxShadow color00Shadow =
    BoxShadow(blurRadius: 6, color: colorForShadow.withOpacity(.25));
BoxShadow primaryButtonShadow6 =
    BoxShadow(blurRadius: 6, color: primaryColor.withOpacity(.25));
BoxShadow primaryButtonShadow4 =
    BoxShadow(blurRadius: 4, color: primaryColor.withOpacity(.25));

//SizedBox
const SizedBox heightSpace2 = SizedBox(height: 2);
const SizedBox heightSpace3 = SizedBox(height: 3);
const SizedBox heightSpace4 = SizedBox(height: 4);
const SizedBox heightSpace5 = SizedBox(height: 5);
const SizedBox heightSpace6 = SizedBox(height: 6);
const SizedBox heightSpace7 = SizedBox(height: 7);
const SizedBox heightSpace8 = SizedBox(height: 8);
const SizedBox heightSpace10 = SizedBox(height: 10);
const SizedBox heightSpace12 = SizedBox(height: 12);
const SizedBox heightSpace13 = SizedBox(height: 13);
const SizedBox heightSpace15 = SizedBox(height: 15);
const SizedBox heightSpace18 = SizedBox(height: 18);
const SizedBox heightSpace20 = SizedBox(height: 20);
const SizedBox heightSpace22 = SizedBox(height: 22);
const SizedBox heightSpace25 = SizedBox(height: 25);
const SizedBox heightSpace30 = SizedBox(height: 30);
const SizedBox heightSpace35 = SizedBox(height: 35);
const SizedBox heightSpace40 = SizedBox(height: 40);
const SizedBox heightSpace45 = SizedBox(height: 45);
const SizedBox heightSpace50 = SizedBox(height: 50);
const SizedBox heightSpace55 = SizedBox(height: 55);
const SizedBox heightSpace60 = SizedBox(height: 60);
const SizedBox heightSpace70 = SizedBox(height: 70);
const SizedBox heightSpace80 = SizedBox(height: 80);
const SizedBox heightSpace100 = SizedBox(height: 100);
const SizedBox heightSpace125 = SizedBox(height: 125);

const SizedBox widthSpace2 = SizedBox(width: 2);
const SizedBox widthSpace3 = SizedBox(width: 3);
const SizedBox widthSpace5 = SizedBox(width: 5);
const SizedBox widthSpace6 = SizedBox(width: 6);
const SizedBox widthSpace7 = SizedBox(width: 7);
const SizedBox widthSpace8 = SizedBox(width: 8);
const SizedBox widthSpace10 = SizedBox(width: 10);
const SizedBox widthSpace12 = SizedBox(width: 12);
const SizedBox widthSpace15 = SizedBox(width: 15);
const SizedBox widthSpace20 = SizedBox(width: 20);
const SizedBox widthSpace25 = SizedBox(width: 25);
const SizedBox widthSpace30 = SizedBox(width: 30);
const SizedBox widthSpace35 = SizedBox(width: 35);
const SizedBox widthSpace40 = SizedBox(width: 40);
const SizedBox widthSpace45 = SizedBox(width: 45);
const SizedBox widthSpace50 = SizedBox(width: 50);

//Images
const String imagePath = 'assets/images/';
const String onBoardBubbleBG = '${imagePath}onBoardBubbleBG.png';
const String authBubbleBG = '${imagePath}authBubbleBG.png';
const String homeBubbleBg = '${imagePath}homeBubbleBg.png';
const String logo = '${imagePath}Reserts.png';
const String onBoardImage1 = '${imagePath}onBoardImage1.png';
const String onBoardImage2 = '${imagePath}onBoardImage2.png';
const String onBoardImage3 = '${imagePath}onBoardImage3.png';
const String authHeaderImage = '${imagePath}authHeaderImage.png';
const String profileIcon = '${imagePath}profileIcon.png';
const String callIcon = '${imagePath}callIcon.png';
const String emailIcon = '${imagePath}emailIcon.png';
const String otpHeaderImage = '${imagePath}otpHeaderImage.png';
const String bn1 = '${imagePath}bn1.png';
const String bn2 = '${imagePath}bn2.png';
const String bn3 = '${imagePath}bn3.png';
const String bn4 = '${imagePath}bn4.png';
const String trophy = '${imagePath}trophy.png';
const String pointsImage = '${imagePath}pointsImage.png';
const String quizBubbleBg = '${imagePath}quizBubbleBg.png';
const String hintHeader = '${imagePath}hintHeader.png';
const String resultBg = '${imagePath}resultBg.png';
const String resultMedalTag = '${imagePath}resultMedalTag.png';
const String hintIcon = '${imagePath}hintIcon.png';
const String leaderboardBubbleBg = '${imagePath}leaderboardBubbleBg.png';
const String crown = '${imagePath}crown.png';
const String equalTo = '${imagePath}equalTo.png';
const String successIcon = '${imagePath}successIcon.png';
const String editProfileIcon = '${imagePath}editProfileIcon.png';
const String blueCamera = '${imagePath}blueCamera.png';
const String greenGallery = '${imagePath}greenGallery.png';
const String redBin = '${imagePath}redBin.png';
const String profileItem1 = '${imagePath}profileItem1.png';
const String profileItem2 = '${imagePath}profileItem2.png';
const String profileItem3 = '${imagePath}profileItem3.png';
const String profileItem4 = '${imagePath}profileItem4.png';
const String profileItem5 = '${imagePath}profileItem5.png';
const String profileItem6 = '${imagePath}profileItem6.png';
const String profileItem7 = '${imagePath}profileItem7.png';
const String referMain = '${imagePath}referMain.png';
const String copyIcon = '${imagePath}copyIcon.png';
const String shareVia1 = '${imagePath}shareVia1.png';
const String shareVia2 = '${imagePath}shareVia2.png';
const String shareVia3 = '${imagePath}shareVia3.png';
const String helpSupportMain = '${imagePath}helpSupportMain.png';
const String refer = '${imagePath}refer.png';
const String withdrawIcon = '${imagePath}withdrawIcon.png';
const String cameraIcon = '${imagePath}cameraIcon.png';
const String noConnection = '${imagePath}noConnection.gif';
const String test = '${imagePath}test.gif';
const String update = '${imagePath}update.gif';


/*
10 = 8.5
12 = 9.2
13 = 9.5
14 = 9.7
15 = 10.8
16 = 11.2
17 = 13
18 = 12.6
20 = 14
22 = 15.5
24 = 16.8
25 = 17.5
28 = 19.4
30 = 22.2
 */
//Text-Styles
TextStyle blackBold22=
    TextStyle(color: black, fontFamily: 'B', fontSize: 15.5.sp);
TextStyle colorE2Bold16= 
    TextStyle(color: colorE2, fontFamily: 'B', fontSize:11.2.sp );
TextStyle colorE2SemiBold16 = 
    TextStyle(color: colorE2, fontFamily: 'SB', fontSize:11.2.sp );
TextStyle primarySemiBold16 = 
    TextStyle(color: primaryColor, fontFamily: 'SB', fontSize:11.2.sp );
TextStyle colorCCBold18 = 
    TextStyle(color: colorCC, fontFamily: 'B' , fontSize: 12.6.sp);
TextStyle whiteBold22 =
    TextStyle(color: white, fontFamily: 'B', fontSize: 15.5.sp);
TextStyle textColorBold24 =
    TextStyle(color: textColor, fontFamily: 'B', fontSize: 16.8.sp);
TextStyle colorE2Bold28 =
    TextStyle(color: colorE2, fontFamily: 'B', fontSize: 19.4.sp);
TextStyle kadwaRegular22 =
    TextStyle(color: primaryColor, fontFamily: 'KR', fontSize: 15.5.sp);
TextStyle whiteBold18 =
    TextStyle(color: white, fontFamily: 'B', fontSize: 12.6.sp);
TextStyle textColorBold18 =
    TextStyle(color: textColor, fontFamily: 'B', fontSize: 12.6.sp);
TextStyle textColorBold20 =
    TextStyle(color: textColor, fontFamily: 'B', fontSize: 14.sp);
TextStyle textColorBold16 =
    TextStyle(color: textColor, fontFamily: 'B', fontSize: 11.2.sp);
TextStyle blackBold18 =
    TextStyle(color: black, fontFamily: 'B', fontSize: 12.6.sp);
TextStyle blackSemiBold18 =
    TextStyle(color: black, fontFamily: 'SB', fontSize: 12.6.sp);
TextStyle colorC3SemiBold14 = 
    TextStyle(color: colorC3, fontFamily: 'SB', fontSize: 9.7.sp);
TextStyle colorC3SemiBold16 =
    TextStyle(color: colorC3, fontFamily: 'SB', fontSize: 11.2.sp);
TextStyle colorC3SemiBold18 =
    TextStyle(color: colorC3, fontFamily: 'SB', fontSize: 12.6.sp);
TextStyle color0SemiBold18 =
    TextStyle(color: color0, fontFamily: 'SB', fontSize: 12.6.sp);
 TextStyle color0SemiBold16 =
    TextStyle(color: color0, fontFamily: 'SB', fontSize: 11.2.sp);   
TextStyle color94SemiBold18 =
    TextStyle(color: color94, fontFamily: 'SB', fontSize: 12.6.sp);
TextStyle pointsColorBold18 =
    TextStyle(color: pointsColor, fontFamily: 'B', fontSize: 12.6.sp);
TextStyle whiteBold20 =
    TextStyle(color: white, fontFamily: 'B', fontSize: 14.sp);
TextStyle colorC3Bold20 =
    TextStyle(color: colorC3, fontFamily: 'B', fontSize: 14.sp);
TextStyle whiteExtraBold22 =
    TextStyle(color: white, fontFamily: 'EB', fontSize: 16.sp);
TextStyle whiteSemiBold14 =
    TextStyle(color: white, fontFamily: 'SB', fontSize: 9.7.sp);
TextStyle blackSemiBold14 =
    TextStyle(color: black, fontFamily: 'SB', fontSize: 9.7.sp);
TextStyle textColorSemiBold14 =
    TextStyle(color: textColor, fontFamily: 'SB', fontSize: 9.7.sp);
TextStyle whiteBold14 =
    TextStyle(color: white, fontFamily: 'B', fontSize: 9.7.sp);
TextStyle whiteBold16 =
    TextStyle(color: white, fontFamily: 'B', fontSize: 11.2.sp);
TextStyle textColorBold14 =
    TextStyle(color: textColor, fontFamily: 'B', fontSize: 9.7.sp);
TextStyle colorE2SemiBold14 =
    TextStyle(color: colorE2, fontFamily: 'SB', fontSize: 9.7.sp);
TextStyle colorE2SemiBold18 =
    TextStyle(color: colorE2, fontFamily: 'SB', fontSize: 12.6.sp);
TextStyle colorE2Bold18 =
    TextStyle(color: colorE2, fontFamily: 'B', fontSize: 12.6.sp);
TextStyle colorE2Bold20 =
    TextStyle(color: colorE2, fontFamily: 'B', fontSize: 14.sp);
TextStyle blackSemiBold16 =
    TextStyle(color: black, fontFamily: 'SB', fontSize: 11.2.sp);
TextStyle blackBold16 =
    TextStyle(color: black, fontFamily: 'B', fontSize: 11.2.sp);
TextStyle whiteSemiBold16 =
    TextStyle(color: white, fontFamily: 'SB', fontSize: 11.2.sp);
TextStyle primaryBold16 =
    TextStyle(color: primaryColor, fontFamily: 'B', fontSize: 11.2.sp);
TextStyle color5ESemiBold16 =
    TextStyle(color: color5E, fontFamily: 'SB', fontSize: 11.2.sp);
    TextStyle color5ESemiBold20 =
    TextStyle(color: color5E, fontFamily: 'SB', fontSize: 14.0.sp);
    TextStyle color5ESemiBold18 =
    TextStyle(color: color5E, fontFamily: 'SB', fontSize: 12.6.sp);
TextStyle colorB4Bold16 =
    TextStyle(color: colorB4, fontFamily: 'B', fontSize: 11.2.sp);
TextStyle blackSemiBold20 =
    TextStyle(color: black, fontFamily: 'SB', fontSize: 14.sp);
TextStyle blackBold20 =
    TextStyle(color: black, fontFamily: 'B', fontSize: 14.sp);
TextStyle blackSemiBold22 =
    TextStyle(color: black, fontFamily: 'SB', fontSize: 15.5.sp);
TextStyle colorC3SemiBold25 =
    TextStyle(color: colorC3, fontFamily: 'SB', fontSize: 17.5.sp);
TextStyle color94SemiBold16 =
    TextStyle(color: color94, fontFamily: 'SB', fontSize: 11.2.sp);
TextStyle textColorSemiBold16 =
    TextStyle(color: textColor, fontFamily: 'SB', fontSize: 11.2.sp);
TextStyle colorCCSemiBold15 =
    TextStyle(color: colorCC, fontFamily: 'SB', fontSize: 10.8.sp);
TextStyle colorCCSemiBold16 =
    TextStyle(color: colorCC, fontFamily: 'SB', fontSize: 11.2.sp);
TextStyle color94SemiBold15 =
    TextStyle(color: color94, fontFamily: 'SB', fontSize: 10.8.sp);
TextStyle color94Bold15 =
    TextStyle(color: color94, fontFamily: 'B', fontSize: 10.8.sp);
TextStyle textColorBold15 =
    TextStyle(color: textColor, fontFamily: 'B', fontSize: 10.8.sp);
TextStyle primaryBold15 =
    TextStyle(color: primaryColor, fontFamily: 'B', fontSize: 10.8.sp);
TextStyle color94SemiBold14 =
    TextStyle(color: color94, fontFamily: 'SB', fontSize: 9.7.sp);
TextStyle primarySemiBold14 =
    TextStyle(color: primaryColor, fontFamily: 'SB', fontSize: 9.7.sp);
TextStyle colorDAExtraBold14 =
    TextStyle(color: colorDA, fontFamily: 'EB', fontSize: 9.7.sp);
TextStyle whiteExtraBold14 =
    TextStyle(color: white, fontFamily: 'EB', fontSize: 9.7.sp);
