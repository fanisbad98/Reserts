import 'package:dotted_border/dotted_border.dart';
import 'package:fl_quiz_app/pages/no_connection/no_connection_page.dart';
import 'package:fl_quiz_app/providers/internet_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:fl_quiz_app/utils/globals.dart' as global;
import '../../../utils/constant.dart';
import '../../../utils/widgets.dart';

class ReferFriendsPage extends StatelessWidget {
  const ReferFriendsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<InternetProvider>(context, listen: false)
        .checkRealtimeConnection();
    return Consumer(
      builder: (BuildContext context, InternetProvider ip, Widget? child) =>
          ip.status == 'Offline'
              ? const NoConnectionPage()
              : Scaffold(
                  appBar: appBar(),
                  body: ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    children: [
                      Image.asset(
                        referMain,
                        height: 22.h,
                      ),
                      heightSpace40,
                      Column(
                        children: [
                          Text('Refer and earn', style: whiteBold20),
                          heightSpace5,
                          Text.rich(
                            TextSpan(
                                text: 'Refer a friend and get ',
                                style: colorC3SemiBold14,
                                children: [
                                  TextSpan(
                                      text: '${global.referralPoints} coins',
                                      style: colorC3SemiBold14),
                                  TextSpan(
                                      text:
                                          '\nfor each person registered with your code',
                                      style: colorC3SemiBold14),
                                ]),
                            textAlign: TextAlign.center,
                          ),
                          heightSpace40,
                          Container(
                            decoration: BoxDecoration(
                              color: white,
                              borderRadius: borderRadius10,
                            ),
                            child: DottedBorder(
                              color: primaryColor,
                              dashPattern: const [3, 3],
                              radius: const Radius.circular(10),
                              borderType: BorderType.RRect,
                              padding: const EdgeInsets.all(14),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text.rich(TextSpan(
                                      text: 'Your referal code : ',
                                      style: textColorSemiBold14,
                                      children: [
                                        TextSpan(
                                            text: global.referralCode,
                                            style: textColorBold15)
                                      ])),
                                  GestureDetector(
                                      onTap: () {
                                        Clipboard.setData(ClipboardData(
                                            text: global.referralCode!));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                duration:
                                                    const Duration(seconds: 2),
                                                backgroundColor: primaryColor,
                                                content: Text(
                                                  'Referral code copied to clipboard',
                                                  style: whiteSemiBold14,
                                                )));
                                      },
                                      child: Image.asset(copyIcon, height: 24))
                                ],
                              ),
                            ),
                          ),
                          heightSpace40,
                          Text('Share via', style: whiteBold18),
                          heightSpace5,
                          IconButton(
                            icon: Icon(
                              Icons.share_rounded,
                              color: primaryColor,
                              size: 3.0.h,
                            ),
                            onPressed: () => shareMessage(),
                          )
                        ],
                      )
                    ],
                  ),
                ),
    );
  }

  PreferredSize appBar() {
    return const PreferredSize(
      preferredSize: Size.fromHeight(56),
      child: PrimaryAppBar(title: 'Refer friends'),
    );
  }

  void shareMessage() {
    var message =
        "Install Our App Now\n\nFor Android : ${global.androidAppLink}\n\nFor Ios : ${global.iOSAppLink}\n\nUse Referral Code: ${global.referalText}";

    Share.share(message, subject: "Share this awesome app with your friends");
  }
}
