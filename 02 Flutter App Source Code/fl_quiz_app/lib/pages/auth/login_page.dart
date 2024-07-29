import 'package:fl_quiz_app/pages/no_connection/no_connection_page.dart';
import 'package:fl_quiz_app/providers/auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../../helper/ui_helper.dart';
import '../../providers/internet_provider.dart';
import '../../utils/constant.dart';
import '../../utils/widgets.dart';
import 'package:fl_quiz_app/utils/globals.dart' as global;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? countryCode = '+91';
  final _numberController = TextEditingController();

  @override
  void initState() {
    Provider.of<InternetProvider>(context, listen: false)
        .checkRealtimeConnection();
    introOnlyForFirstTime();
    super.initState();
  }

  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
  }

  void introOnlyForFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("initScreen", 1);
    global.initScreen = prefs.getInt("initScreen");
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InternetProvider>(
      builder: (context, InternetProvider ip, child) => ip.status == 'Offline'
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
                        heightSpace15,
                        Text('Login', style: whiteExtraBold22),
                        heightSpace5,
                        Text(
                          'Welcome to $appName. Please login',
                          style: colorCCSemiBold15,
                          textAlign: TextAlign.center,
                        ),
                        heightSpace25,
                        Image.asset(authHeaderImage, height: 150),
                      ],
                    )),
                  ),
                  ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(20).copyWith(top: 30),
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      Text('Enter your mobile number', style: whiteBold18),
                      heightSpace5,
                      Text('Login with mobile number',
                          style: color5ESemiBold16),
                      heightSpace40,
                      Text('Mobile number', style: primaryBold15),
                      heightSpace8,
                      Container(
                        padding: const EdgeInsets.all(1.5).copyWith(left: 15),
                        decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [color00Shadow]),
                        child: InternationalPhoneNumberInput(
                          textFieldController: _numberController,
                          cursorColor: primaryColor,
                          onInputChanged: (PhoneNumber number) {
                            countryCode = number.dialCode;
                          },
                          selectorConfig: const SelectorConfig(
                              showFlags: true,
                              trailingSpace: false,
                              selectorType: PhoneInputSelectorType.DIALOG),
                          ignoreBlank: false,
                          initialValue: PhoneNumber(isoCode: 'IN'),
                          autoValidateMode: AutovalidateMode.disabled,
                          selectorTextStyle: blackSemiBold16,
                          formatInput: true,
                          textStyle: color94SemiBold15,
                          onFieldSubmitted: (value) {},
                          keyboardType: TextInputType.number,
                          inputBorder: InputBorder.none,
                          inputDecoration: InputDecoration(
                            isDense: true,
                            hintText: 'Enter your mobile number',
                            hintStyle: color94SemiBold15,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      heightSpace6,
                      Text(
                        '*We  are sending OTP for verification',
                        style: TextStyle(
                            color: const Color(0xffE03232),
                            fontFamily: 'SB',
                            fontSize: 10.8.sp),
                      ),
                      heightSpace60,
                      PrimaryButton(
                        text: 'Login',
                        onTap: () => validationProgress(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  void validationProgress() {
    String number =
        _numberController.text.trim().replaceAll(RegExp(r"\s+\b|\b\s"), "");
    RegExp regExp = RegExp(r'^(?:[+0][1-9])?[0-9]{10,12}$');
    if (regExp.hasMatch(number)) {
      // mobile number is valid
      UiHelper.showLoadingDialog(context, 'Please wait');
      AuthHandler.login(
          number: number, context: context, countryCode: countryCode);
    } else if (_numberController.text.trim().isEmpty) {
      //text_field is empty
      UiHelper.showSnackBar(
          context: context, message: 'Please enter your mobile number');
    } else {
      // mobile number is not valid
      UiHelper.showSnackBar(
          context: context, message: 'Please enter valid mobile number');
    }
  }
}
