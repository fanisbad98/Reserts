import 'package:fl_quiz_app/helper/shimmer.dart';
import 'package:fl_quiz_app/models/top_user_model.dart';
import 'package:fl_quiz_app/providers/leader_board_provider.dart';
import 'package:fl_quiz_app/services/api_services.dart';
import 'package:fl_quiz_app/utils/api_constant.dart';
import 'package:provider/provider.dart';
import 'package:fl_quiz_app/utils/globals.dart' as global;
import '../../utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../utils/widgets.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({Key? key}) : super(key: key);

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

List<TopUserData> topUserData = [];
LeaderBoardProvider? leaderBoardProvider;
List<TopUserData> currentUser = [];
int? currentUserIndex;

class _LeaderboardPageState extends State<LeaderboardPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    leaderBoardProvider =
        Provider.of<LeaderBoardProvider>(context, listen: false);
    leaderBoardProvider!.checkWetherAppbarCollapsed(_scrollController);
    fetchTopUsers();
  }

  void fetchTopUsers() async {
    asignCurrentUser();
    topUserData = await ApiServices.fetchTopUsers(context);
    if (topUserData.length >= 3) {
      leaderBoardProvider!.getTopThreeUser(
        top1: topUserData[0].name,
        top1Point: topUserData[0].totalPoints,
        top1ProfilePic: topUserData[0].profilePic,
        top2: topUserData[1].name,
        top2Point: topUserData[1].totalPoints,
        top2ProfilePic: topUserData[1].profilePic,
        top3: topUserData[2].name,
        top3Point: topUserData[2].totalPoints,
        top3ProfilePic: topUserData[2].profilePic,
      );
    }
  }

  void asignCurrentUser() {
    currentUser =
        topUserData.where((element) => element.id == global.userId).toList();
    currentUserIndex =
        topUserData.indexWhere((element) => element.id == global.userId);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: currentUser.isNotEmpty ? bottomSheetHeader() : null,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        controller: _scrollController,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 20),
            sliver: SliverAppBar(
              automaticallyImplyLeading: false,
              expandedHeight: 40.h,
              pinned: true,
              snap: false,
              floating: false,
              centerTitle: false,
              title:  Text('Contributors', style: whiteBold20),
              flexibleSpace: Consumer<LeaderBoardProvider>(
                builder:
                    (context, LeaderBoardProvider leaderBoardProvider, child) =>
                        Container(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  alignment: Alignment.bottomCenter,
                  height: SizerUtil.height,
                  width: SizerUtil.height,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                              leaderBoardProvider.isAppBarCollapsed
                                  ? homeBubbleBg
                                  : leaderboardBubbleBg),
                          fit: BoxFit.cover)),
                  child: leaderBoardProvider.isAppBarCollapsed
                      ? null
                      : topUserData.length >= 3
                          ? Consumer<LeaderBoardProvider>(
                              builder: (context,
                                      LeaderBoardProvider leaderBoardProvider,
                                      child) =>
                                  Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  secRank(leaderBoardProvider),
                                  firstRank(leaderBoardProvider),
                                  thirdRank(leaderBoardProvider)
                                ],
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(top: 50),
                              child: Center(
                                  child: Text(
                                'No data available',
                                style: whiteBold18,
                              )),
                            ),
                ),
              ),
            ),
          ),
          Consumer<LeaderBoardProvider>(
            builder: (context, leaderBoardProvider, child) => FutureBuilder(
              future: ApiServices.fetchTopUsers(context),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  List<TopUserData> topUserData = snapshot.data;
                  return SliverList(
                      delegate: SliverChildBuilderDelegate(
                          addAutomaticKeepAlives: true,
                          childCount: topUserData.length, (context, index) {
                    return PrimaryContainer(
                      padding: const EdgeInsets.all(10),
                      margin: currentUser.isNotEmpty
                          ? index == topUserData.length - 1
                              ? const EdgeInsets.symmetric(horizontal: 20)
                                  .copyWith(bottom: 100)
                              : const EdgeInsets.symmetric(horizontal: 20)
                                  .copyWith(bottom: 20)
                          : index == topUserData.length - 1
                              ? const EdgeInsets.symmetric(horizontal: 20)
                                  .copyWith(bottom: 20)
                              : const EdgeInsets.symmetric(horizontal: 20)
                                  .copyWith(bottom: 20),
                      color: colorC3,
                      child: Row(
                        children: [
                          Text('${index + 1}'.toString().padLeft(2, '0'),
                              style: textColorBold18),
                          widthSpace15,
                          CircleAvatar(
                            backgroundColor: profileBgColor,
                            backgroundImage: NetworkImage(
                                '${ApiConstants.url}${topUserData[index].profilePic}'),
                          ),
                          widthSpace10,
                          Text(topUserData[index].name, style: blackSemiBold16),
                          const Spacer(),
                          Text(topUserData[index].totalPoints.toString(),
                              style: whiteBold18),
                          widthSpace5,
                          Image.asset(pointsImage, height: 20)
                        ],
                      ),
                    );
                  }));
                } else {
                  return SliverList(
                      delegate: SliverChildBuilderDelegate(
                          addAutomaticKeepAlives: true,
                          childCount: 5, (context, index) {
                    return Shimmer(
                      child: ShimmerLoading(
                        child: Container(
                            height: 55,
                            decoration: BoxDecoration(
                                color: black,
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.all(25),
                            margin: index == topUserData.length - 1
                                ? const EdgeInsets.symmetric(horizontal: 20)
                                    .copyWith(bottom: 20)
                                : const EdgeInsets.symmetric(horizontal: 20)
                                    .copyWith(bottom: 20)),
                      ),
                    );
                  }));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Container bottomSheetHeader() {
    return Container(
      decoration: BoxDecoration(
        color: scaffoldColor,
        boxShadow: [color00Shadow],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [primaryButtonShadow6],
            ),
            child: Row(
              children: [
                Text(
                    currentUserIndex != null
                        ? '${currentUserIndex! + 1}'.padLeft(2, '0')
                        : '',
                    style: whiteBold18),
                widthSpace15,
                CircleAvatar(
                  backgroundColor: profileBgColor,
                  backgroundImage: NetworkImage(
                      '${ApiConstants.url}${currentUser[0].profilePic}'),
                ),
                widthSpace10,
                Text(currentUser[0].name, style: whiteSemiBold16),
                const Spacer(),
                Text(currentUser[0].totalPoints.toString(),
                    style: whiteBold18),
                widthSpace5,
                Image.asset(pointsImage, height: 20)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Column firstRank(LeaderBoardProvider leaderBoardProvider) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          crown,
          height: 3.3.h,
        ),
        Container(
            height: 54,
            width: 54,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              border:
                  Border.all(color: const Color.fromARGB(255, 189, 186, 198)),
              color: transparent,
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              backgroundColor: const Color(0xffCCC1F0),
              backgroundImage: NetworkImage(
                  '${ApiConstants.url}${leaderBoardProvider.topOneProfilePic}'),
            )),
        heightSpace5,
        Text(leaderBoardProvider.topOne, style: whiteBold14),
        heightSpace5,
        Container(
          height: 23.h,
          width: 100.w / 4.5,
          color: const Color(0xff8E82F8),
          child: Column(
            children: [
              const Text(
                '1',
                style: TextStyle(fontSize: 70, color: white, fontFamily: 'B'),
              ),
              heightSpace10,
              Text(
                leaderBoardProvider.topOnePoint.toString(),
                style: const TextStyle(
                    fontSize: 20, color: colorC3, fontFamily: 'B'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Column secRank(LeaderBoardProvider leaderBoardProvider) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            height: 54,
            width: 54,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xffCCC1F0)),
              color: transparent,
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              backgroundColor: const Color(0xffCCC1F0),
              backgroundImage: NetworkImage(
                  '${ApiConstants.url}${leaderBoardProvider.topSecProfilePic}'),
            )),
        heightSpace5,
        Text(leaderBoardProvider.topSec, style: whiteBold14),
        heightSpace5,
        Container(
          height: 17.h,
          width: 100.w / 4.5,
          color: const Color(0xff7A6CEE),
          child: Column(
            children: [
              const Text(
                '2',
                style: TextStyle(fontSize: 70, color: white, fontFamily: 'B'),
              ),
              Text(
                leaderBoardProvider.topSecPoint.toString(),
                style: const TextStyle(
                    fontSize: 20, color: colorC3, fontFamily: 'B'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Column thirdRank(LeaderBoardProvider leaderBoardProvider) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            height: 54,
            width: 54,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xffCCC1F0)),
              color: transparent,
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              backgroundColor: const Color(0xffCCC1F0),
              backgroundImage: NetworkImage(
                  '${ApiConstants.url}${leaderBoardProvider.topThirdProfilePic}'),
            )),
        heightSpace5,
        Text(leaderBoardProvider.topThird, style: whiteBold14),
        heightSpace5,
        Container(
          height: 17.h,
          width: 100.w / 4.5,
          color: const Color(0xff7A6CEE),
          child: Column(
            children: [
              const Text(
                '3',
                style: TextStyle(fontSize: 70, color: white, fontFamily: 'B'),
              ),
              Text(
                leaderBoardProvider.topThirdPoint.toString(),
                style: const TextStyle(
                    fontSize: 20, color: colorC3, fontFamily: 'B'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
