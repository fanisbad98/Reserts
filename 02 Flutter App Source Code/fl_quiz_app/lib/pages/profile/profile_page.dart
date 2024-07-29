import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fl_quiz_app/providers/profile_provider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../helper/shimmer.dart';
import '../../helper/ui_helper.dart';
import '../../utils/api_constant.dart';
import '../../utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:fl_quiz_app/utils/globals.dart' as global;
import '../../utils/widgets.dart';
import 'edit_profile/edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<void> openStoreViaPlatform() async {
    Uri url = Uri.parse(
        Platform.isAndroid ? global.androidAppLink : global.iOSAppLink);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    List profileItems = [
      {
        'icon': profileItem1,
        'title': 'Refer friends',
        'navigate': 'ReferFriendsPage',
      },
      {
        'icon': profileItem2,
        'title': 'Rules of quiz',
        'navigate': 'RulesOfQuizPage',
      },
      {
        'icon': profileItem3,
        'title': 'Privacy policy ',
        'navigate': 'PrivacyPolicyPage',
      },
      {
        'icon': profileItem4,
        'title': 'Terms of Use',
        'navigate': 'TermsOfUsePage',
      },
      {
        'icon': profileItem5,
        'title': 'Rate us',
        'navigate': '',
      },
      {
        'icon': profileItem6,
        'title': 'Help and support',
        'navigate': 'HelpAndSupportPage',
      },
      {
        'icon': profileItem7,
        'title': 'Logout',
        'navigate': '',
      },
    ];
    return Scaffold(
      appBar: appBar(),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          userDetail(),
          ListView.builder(
            padding: const EdgeInsets.all(20).copyWith(top: 0, bottom: 56),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: profileItems.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              dynamic item = profileItems[index];
              int lastIndex = profileItems.length - 1;
              return ListTile(
                onTap: index == lastIndex
                    ? () {
                        UiHelper.showLogoutDialog(context);
                      }
                    : index == 4
                        ? () {
                            openStoreViaPlatform();
                          }
                        : () {
                            Navigator.pushNamed(
                                context, '/${item['navigate']}');
                          },
                contentPadding: EdgeInsets.zero,
                leading: Image.asset(
                  item['icon'],
                  height: 2.7.h,
                ),
                title: Transform.translate(
                  offset: const Offset(-10, 0),
                  child: Text(item['title'],
                      style: TextStyle(
                          color: index == lastIndex
                              ? white
                              : white,
                          fontFamily: 'SB',
                          fontSize: 12.6.sp)),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Padding userDetail() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Consumer<ProfileProvider>(
            builder: (context, profileProvider, child) => SizedBox(
              height: 77,
              width: 77,
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: profileProvider.file != null
                      ? '${ApiConstants.url}${profileProvider.file}'
                      : '${ApiConstants.url}${global.profilePic}',
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Shimmer(
                    child: ShimmerLoading(
                      child: CircleAvatar(
                        radius: 24,
                        backgroundColor: black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          widthSpace15,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(global.userName.toString(), style: whiteBold18),
              heightSpace5,
              Text(global.mobileNo.toString(), style: colorC3SemiBold14),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              /*  var result = await */ Navigator.push(
                  context,
                  PageTransition(
                      isIos: true,
                      child: const EditProfilePage(),
                      type: PageTransitionType.rightToLeft));
              // if (result == true) {
              //   Future.delayed(const Duration(seconds: 1))
              //       .then((value) => setState(() {}));
              // }
            },
            child: Image.asset(
              editProfileIcon,
              height: 24,
            ),
          )
        ],
      ),
    );
  }

  PreferredSize appBar() {
    return const PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: PrimaryAppBar(
          title: 'Profile',
          withBackArrow: false,
        ));
  }
}
