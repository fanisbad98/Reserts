import 'package:fl_quiz_app/pages/no_connection/no_connection_page.dart';
import 'package:fl_quiz_app/providers/auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../helper/ui_helper.dart';
import '../../providers/internet_provider.dart';
import '../../utils/constant.dart';
import '../../utils/widgets.dart';
import 'package:fl_quiz_app/utils/globals.dart' as global;

class RegisterPage extends StatefulWidget {
  final String mobileNo;
  final String countryCode;
  const RegisterPage(
      {Key? key, required this.mobileNo, required this.countryCode})
      : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  final _emailController = TextEditingController();
  final _referController = TextEditingController();

  @override
  void initState() {
    Provider.of<InternetProvider>(context, listen: false)
        .checkRealtimeConnection();
    _numberController.text = widget.mobileNo;
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    _emailController.dispose();
    _referController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InternetProvider>(
      builder: (context, InternetProvider ip, child) => ip.status == "Offline"
          ? const NoConnectionPage()
          : Scaffold(
              body: ListView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.zero,
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
                            children: [
                              Text('Register', style: whiteExtraBold22),
                              heightSpace5,
                              Text(
                                  'Welcome to $appName. Please create your account',
                                  style: colorCCSemiBold15),
                              heightSpace25,
                              Image.asset(authHeaderImage, height: 150),
                            ],
                          ),
                        ),
                      ],
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20).copyWith(top: 30),
                    child: Column(
                      children: [
                        PrimaryTextField(
                          header: 'Name',
                          controller: _nameController,
                          prefixIcon: profileIcon,
                          hintText: 'Enter your name',
                        ),
                        heightSpace20,
                        PrimaryTextField(
                          header: 'Mobile number',
                          enabled: false,
                          controller: _numberController,
                          prefixIcon: callIcon,
                          hintText: 'Enter your mobile number',
                          keyboardType: TextInputType.number,
                        ),
                        heightSpace20,
                        PrimaryTextField(
                          header: 'Email address',
                          controller: _emailController,
                          prefixIcon: emailIcon,
                          hintText: 'Enter your email address',
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.done,
                        ),
                        heightSpace20,
                        PrimaryTextField(
                          header: 'Refferal code',
                          controller: _referController,
                          prefixIcon: refer,
                          suffixIcon: Tooltip(
                            padding: const EdgeInsets.all(10),
                            triggerMode: TooltipTriggerMode.tap,
                            showDuration: const Duration(seconds: 5),
                            decoration:
                                BoxDecoration(borderRadius: borderRadius10),
                            message:
                                'Enter refferal code and u will\nget ${global.welcomePoints} point as reward',
                            textStyle: color94SemiBold14,
                            textAlign: TextAlign.center,
                            child: Icon(
                              Icons.info_outline,
                              color: color94,
                              size: 2.25.h,
                            ),
                          ),
                          hintText: 'Enter refferal code',
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.done,
                        ),
                        heightSpace60,
                        PrimaryButton(
                            text: 'Register',
                            onTap: () {
                              String name = _nameController.text.trim();
                              String email = _emailController.text.trim();
                              if (name.isNotEmpty && email.isNotEmpty) {
                                validationProgress();
                              } else if (name.isEmpty) {
                                UiHelper.showSnackBar(
                                    context: context,
                                    message: 'Please enter your name');
                              } else if (email.isEmpty) {
                                UiHelper.showSnackBar(
                                    context: context,
                                    message: 'Please enter your email');
                              }
                            }),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }

  void validationProgress() {
    String email = _emailController.text.trim();
    RegExp regExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (regExp.hasMatch(email)) {
      UiHelper.showLoadingDialog(context, 'Please wait');
      AuthHandler.sendOTP(
        number: widget.mobileNo,
        context: context,
        countryCode: widget.countryCode,
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        referCode: _referController.text.trim(),
      );
    } else {
      //email is not valid
      UiHelper.showSnackBar(
          context: context, message: 'Please enter valid email');
    }
  }
}
