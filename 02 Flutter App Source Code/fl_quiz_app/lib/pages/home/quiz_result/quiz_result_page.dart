import 'package:fl_quiz_app/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:fl_quiz_app/providers/ads_provider.dart';
import 'package:fl_quiz_app/utils/api_constant.dart';
import 'package:fl_quiz_app/utils/constant.dart';
import 'package:fl_quiz_app/utils/globals.dart' as global;

class QuizResultPage extends StatefulWidget {
  final String quizType;
  final int answersGiven;
  final int totalQuestion;


  const QuizResultPage({
    Key? key,
    required this.quizType,
    required this.totalQuestion,
    required this.answersGiven,
  }) : super(key: key);

  @override
  State<QuizResultPage> createState() => _QuizResultPageState();
}

class _QuizResultPageState extends State<QuizResultPage> {
  bool _doubleRewardsPressed = false; 

  @override
  void initState() {
    super.initState();

    global.isAdShow
        ? global.isVideoAdsShow
            ? Provider.of<AdsProvider>(context, listen: false)
                .createRewardedAd()
            : Provider.of<AdsProvider>(context, listen: false)
                .createInterstitialAd()
        : null;
    // if (global.isMinusGrading) {
    //   ApiServices.addPointsByResult(
    //       answersGiven: widget.answersGiven,
    //       context: context);
    // } else {
    //   ApiServices.addPointsByResult(
    //       answersGiven: widget.answersGiven,
    //       context: context);
    // }
  }

  String withMinusGradeMsg() {
    var calPercentage =
        (widget.totalQuestion * global.pointsPerQuestion) * 0.5;
    var earnedPoints = (global.pointsPerQuestion * widget.answersGiven);
    if (earnedPoints == 0) {
      return 'OOPS!!!';
    } else if (earnedPoints > calPercentage) {
      return 'Excellent'; 
    } else {
      return 'More answers, better rewards';
    }
  }

  String withoutMinusGradeMsg() {
    var calPercentage =
        (widget.totalQuestion * global.pointsPerQuestion) * 0.5;
    var earnedPoints = (global.pointsPerQuestion * widget.answersGiven);
    if (earnedPoints > calPercentage) {
      return 'Excellent';
    } else {
      return 'More answers,better rewards'; 
    }
  }

  void _doubleRewards() {
    setState(() {
      _doubleRewardsPressed = true;
    });

    Provider.of<AdsProvider>(context, listen: false).showRewardedAd();
    ApiServices.addPointsByResult(
      answersGiven: widget.answersGiven,
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    //var minute = (widget.totalTime / 60).truncate().toString().padLeft(2, '0');
    //var second = (widget.totalTime % 60).toStringAsFixed(0).padLeft(2, '0');
    final List resultItem = [
      '${widget.answersGiven} Questions Answered',
      //'$minute : $second',
    ];

    return Scaffold(
      backgroundColor: color0,
      body: Container(
        height: SizerUtil.height,
        width: SizerUtil.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(resultBg),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.only(top: 80),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(resultMedalTag, height: 215),
                    Positioned(
                      top: 30,
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50.5,
                            backgroundColor: colorC3,
                            backgroundImage: NetworkImage(
                              '${ApiConstants.url}${global.profilePic}',
                            ),
                          ),
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              const SizedBox(width: 5),
                              Image.asset(pointsImage, height: 25),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 25),
                Text(
                  global.isMinusGrading
                      ? withMinusGradeMsg()
                      : withoutMinusGradeMsg(),
                  style: colorC3SemiBold18,
                ),
                const SizedBox(height: 5),
                Text(
                  'You have successfully completed',
                  style: colorE2SemiBold16,
                ),
                const SizedBox(height: 2),
                Text(
                  '${widget.quizType} quiz',
                  style: whiteBold18,
                ),
                const SizedBox(height: 25),
                Text(
                  'Total ${widget.totalQuestion -1} question',
                  style: colorE2Bold16,
                ),
                const SizedBox(height: 35),
                GridView.builder(
                  padding: const EdgeInsets.all(20),
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: resultItem.length,
                  shrinkWrap: true,
                  gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 7.5,
                  ),
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: colorC3,
                        borderRadius: borderRadius10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          index == 0
                              ? const Icon(
                                  Icons.article_rounded,
                                  color: colorE2,
                                )
                              : index == 1
                                  ? const Icon(
                                      Icons.access_time_rounded,
                                      color: colorE2,
                                    )
                                  : const SizedBox(),
                          const SizedBox(width: 15),
                          Text(resultItem[index], style: whiteBold18),
                        ],
                      ),
                    );
                  },
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: Column(
                    children: [
                      _doubleRewardsPressed
                          ? const SizedBox() 
                          : ElevatedButton(
                              onPressed: _doubleRewards,
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(colorEE),
                                foregroundColor:
                                    MaterialStateProperty.all(color5E),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: const BorderSide(color: color5E),
                                  ),
                                ),
                                padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 5),
                                ),
                              ),
                              child: const Text(
                                'Watch Ad for Double Rewards',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                      const SizedBox(height: 15),
                      GestureDetector(
                        onTap: () {                     
                          Navigator.popUntil(context, (route) => route.isFirst);
                          Navigator.pushReplacementNamed(
                            context,
                            '/BottomNavigation',
                          );
                          Navigator.pushNamed(
                            context,
                            '/PlayQuizPage',
                            arguments: [
                              global.tempQuizId,
                              widget.quizType,
                            ],
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 60, vertical: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: transparent),
                            color: primaryColor,
                            borderRadius: borderRadius10,
                          ),
                          child: Text('Play Again', style: whiteBold16),
                        ),
                      ),
                      const SizedBox(height: 15),
                      GestureDetector(
                        onTap: () => Navigator.pushReplacementNamed(
                          context,
                          '/BottomNavigation',
                        ),
                        child: Text('Back to home', style: whiteBold16),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
