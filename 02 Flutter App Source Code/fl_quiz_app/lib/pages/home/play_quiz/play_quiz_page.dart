import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:fl_quiz_app/models/quizz_item.dart';
import 'package:fl_quiz_app/providers/play_quiz_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:fl_quiz_app/utils/globals.dart' as global;
import '../../../helper/ui_helper.dart';
import '../../../providers/ads_provider.dart';
import '../../../utils/constant.dart';
import '../../../utils/widgets.dart';
import 'package:fl_quiz_app/services/api_services.dart';

class PlayQuizPage extends StatefulWidget {
  final String quizId;
  final String categorie;

  const PlayQuizPage({
    Key? key,
    required this.quizId,
    required this.categorie,
  }) : super(key: key);

  @override
  State<PlayQuizPage> createState() => _PlayQuizPageState();
}

class _PlayQuizPageState extends State<PlayQuizPage> {
  bool _isHintUsed = false;
  String? _selectedAnswer;
  int _pageIndex = 0;
  int _answeredQuestions = 0;
  final _pageController = PageController();
  bool _showCompletedText = false;

  @override
  void initState() {
    super.initState();
    // fetchQuizProgress();
    Provider.of<PlayQuizProvider>(context, listen: false)
        .getQuestions(widget.quizId, global.userId, context);



        Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _showCompletedText = true;
      });
    });
  }


  // void fetchQuizProgress() async {
  //   try {
  //     var progress = await ApiServices.getQuizProgress(global.userId, widget.quizId, context);

  //     setState(() {
  //       _pageIndex = progress['currentQuestionIndex'] ?? 0;
  //       _answeredQuestions = progress['answeredQuestions'] ?? 0;
  //     });
  //     _pageController.animateToPage(_pageIndex, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    
  //   } catch (error) {
  //     print('Error fetching quiz progress: $error');

  //   }
  // }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void saveUserAnswer(
      String categoryId, String? questionId, String selectedAnswer) {
    if (questionId != null) {
      String userId = global.userId ?? '';
      ApiServices.saveUserAnswer(
          categoryId, questionId, selectedAnswer, userId, context);
      _questionsAnswered();
    } else {
      print('Error: Question ID is null');
    }
  }

  void _handleNextTap() {
    setState(() {
      _selectedAnswer = null;
      _pageIndex++;
    });
  }
  void _questionsAnswered(){
    setState(() {
      _answeredQuestions++;
    });
  }

  void _handleFinishTap(BuildContext context) {
  PlayQuizProvider playQuizProvider =
      Provider.of<PlayQuizProvider>(context, listen: false);
  List<QuizItem>? quizItems = playQuizProvider.quizItems;


  Navigator.popUntil(context, (route) => route.isFirst);
  Navigator.pushReplacementNamed(context, '/QuizResultPage', arguments: [
    widget.categorie,
    _answeredQuestions, 
    quizItems.length,

  ]);
}


  void _handleSeeVideo() {
    AdsProvider adsProvider = Provider.of<AdsProvider>(context , listen: false);
    adsProvider.showInterstitialAd();
    ApiServices.addPointsPerQuestion(points: global.pointsPerQuestion, context: context);
  }

  void _handleContinue() {
    print('Continue');
    _handleNextTap();
  }

  void _handleStopHere() {
    print('Stop here');
    _handleFinishTap(context);
  }

  int getNonSecurityQuestionsAnswered(List<QuizItem> quizItems) {
    return quizItems.where((item) => item.type != QuizItemType.securityQuestion).length;
  }

  @override
  Widget build(BuildContext context) {
    PlayQuizProvider playQuizProvider = Provider.of<PlayQuizProvider>(context);
    List<QuizItem>? quizItems = playQuizProvider.quizItems;

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: appBarMethod(context),
        body: quizItems.isEmpty
            ? SafeArea(
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_showCompletedText)
                    Text(
                      'You have completed this Research!',
                      style: colorC3SemiBold16,
                    )
                  ],
                )),
              )
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    ExpandablePageView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _pageController,
                      onPageChanged: (value) {
                        if (global.isAdShow) {
                          if ((value + 1) % 3 == 0) {
                            Provider.of<AdsProvider>(context, listen: false)
                                .showQuizInterstitialAd();
                          }
                        }
                        setState(() => _pageIndex = value);
                        _isHintUsed = false;
                      },
                      itemCount: quizItems.length,
                      itemBuilder: (context, index) {
                        int lastIndex = quizItems.length - 1;
                        return PrimaryContainer(
                          alignment: Alignment.topCenter,
                          margin: const EdgeInsets.all(20),
                          padding:
                              const EdgeInsets.all(20).copyWith(bottom: 40),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Question', style: blackBold18),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 11, vertical: 25),
                                child: Text(
                                  quizItems[_pageIndex].question,
                                  style: blackSemiBold18,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Column(
                                children:
                                    List.generate(4, (optionIndex) {
                                  String option = '';
                                  switch (optionIndex) {
                                    case 0:
                                      option = quizItems[_pageIndex].optionA;
                                      break;
                                    case 1:
                                      option = quizItems[_pageIndex].optionB;
                                      break;
                                    case 2:
                                      option = quizItems[_pageIndex].optionC;
                                      break;
                                    case 3:
                                      option = quizItems[_pageIndex].optionD;
                                      break;
                                  }
                                  return GestureDetector(
                                    onTap: () {
                                      if (_selectedAnswer == null) {
                                        setState(() {
                                          _selectedAnswer = option;
                                        });
                                        //ApiServices.saveQuizProgress(widget.quizId, global.userId, , , _isCompleted, context);
                                        if (quizItems[_pageIndex].type != QuizItemType.securityQuestion) {
                                          saveUserAnswer(
                                            widget.categorie,
                                            quizItems[_pageIndex].question,
                                            option,
                                          );
                                          ApiServices.addPointsPerQuestion(points: global.pointsPerQuestion, context: context);
                                        } else {
                                          print('Security Question: User answer not saved and no points are given');
                                        }
                                      }
                                      if (quizItems[_pageIndex].type == QuizItemType.securityQuestion){
                                        if(option == quizItems[_pageIndex].correctAnswer){
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Answered security question correctly.'),
                                            duration: Duration(seconds: 2),
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:
                                           Text('Answered security question wrongly.'),
                                           duration: Duration(seconds: 2),
                                           ),
                                          );
                                          Navigator.pop(context);
                                        }
                                      }
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 20),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14, horizontal: 16),
                                      decoration: BoxDecoration(
                                        color: _selectedAnswer ==
                                                option
                                            ? selectedAnswerColor
                                            : colorEE,
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 6,
                                            color: _selectedAnswer ==
                                                    option
                                                ? selectedAnswerColor
                                                    .withOpacity(0.25)
                                                : colorB7.withOpacity(1),
                                          ),
                                        ],
                                        borderRadius: borderRadius10,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(option,
                                                style: option ==
                                                        _selectedAnswer
                                                    ? whiteBold16
                                                    : blackSemiBold16),
                                          ),
                                          Icon(
                                            option ==
                                                    _selectedAnswer
                                                ? Icons.chevron_left_rounded
                                                : null,
                                            color: option ==
                                                    _selectedAnswer
                                                ? Colors.white
                                                : null,
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              ),
                              heightSpace20,
                              if (_selectedAnswer != null)
                                Column(
                                  children: [
                                    ElevatedButton(
        onPressed: () {
          if (_pageIndex != lastIndex) {
            _handleContinue();
          } else {
            _handleFinishTap(context);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor, 
          padding: const EdgeInsets.symmetric(vertical: 13),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: SizedBox(
          width: double.infinity, 
          child: Center(
            child: Text(
              _pageIndex != lastIndex ? 'Continue' : 'Finish',
              style: whiteBold16
            ),
          ),
        ),
      ),
      const SizedBox(height: 10),
      ElevatedButton(
        onPressed: _handleSeeVideo,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor, 
          padding: const EdgeInsets.symmetric(vertical: 13),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: SizedBox(
          width: double.infinity, 
          child: Center(
            child: Text(
              'See video for double rewards',
              style: whiteBold16,
            ),
          ),
        ),
      ),     
      const SizedBox(height: 10),
      ElevatedButton(
        onPressed: _handleStopHere,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor, 
          padding: const EdgeInsets.symmetric(vertical: 13),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: SizedBox(
          width: double.infinity, 
          child: Center(
            child: Text(
              'Stop here',
              style: whiteBold16
            ),
          ),
        ),
      ),
    ],
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                    global.hint5050 &&
                            global.totalPoints! >= global.hintPoints
                        ? _selectedAnswer != null || _isHintUsed == true
                            ? const SizedBox()
                            : Center(
                                child: GestureDetector(
                                onTap: () async {
                                  bool? hintResult =
                                      await UiHelper.showHintDialog(context);
                                  if (hintResult == true) {
                                    setState(() {
                                      _isHintUsed = true;
                                    });
                                  }
                                },
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 19),
                                    decoration: BoxDecoration(
                                      boxShadow: [primaryButtonShadow4],
                                      borderRadius: BorderRadius.circular(20),
                                      color: const Color(0xffE2E0F4),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('Use Hint / ${global.hintPoints}',
                                            style: textColorBold16),
                                        widthSpace5,
                                        Image.asset(
                                          pointsImage,
                                          height: 20,
                                        )
                                      ],
                                    )),
                              ))
                        : const SizedBox(),
                    heightSpace20,
                  ],
                ),
              ),
      ),
    );
  }

  AppBar appBarMethod(BuildContext context) {
  PlayQuizProvider playQuizProvider = Provider.of<PlayQuizProvider>(context);
  List<QuizItem>? quizItems = playQuizProvider.quizItems;

  bool isQuizEmpty = quizItems.isEmpty;

  List<QuizItem> nonSecurityQuestions = [];
  int questionListLength = 0;
  int nonSecurityQuestionIndex = 0;

  if (!isQuizEmpty) {
    nonSecurityQuestions = quizItems.where((item) => item.type != QuizItemType.securityQuestion).toList();
    questionListLength = nonSecurityQuestions.length;

    for (int i = 0; i <= _pageIndex; i++) {
      if (i < quizItems.length && quizItems[i].type != QuizItemType.securityQuestion) {
        nonSecurityQuestionIndex++;
      }
    }
  }

  return AppBar(
    automaticallyImplyLeading: false,
    toolbarHeight: 155,
    flexibleSpace: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: SizerUtil.height,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(quizBubbleBg),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back, color: white),
                ),
                widthSpace10,
                Text(widget.categorie, style: whiteBold20),
                const Spacer(),
              ],
            ),
            if (isQuizEmpty) ...[
              const SizedBox(height: 20),
            ] else ...[
              Column(
                children: [
                  Text(
                      'Question $nonSecurityQuestionIndex of $questionListLength',
                      style: whiteBold16),
                  heightSpace15,
                  LinearProgressIndicator(
                    value: (nonSecurityQuestionIndex) / questionListLength,
                    backgroundColor: colorD9,
                    valueColor: const AlwaysStoppedAnimation(timerBoxColor),
                  ),
                  heightSpace20,
                  Row(
                    children: [
                      Text(
                          'Research points : ${(global.pointsPerQuestion * questionListLength)}',
                          style: whiteBold16),
                      widthSpace5,
                      Image.asset(pointsImage, height: 20),
                    ],
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    ),
  );
}
}