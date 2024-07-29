// import 'package:fl_quiz_app/models/question_model.dart';
// import 'package:fl_quiz_app/services/api_services.dart';
// import 'package:flutter/material.dart';

// class PlayQuizProvider extends ChangeNotifier {
//   List<QuestionData>? _questionList = [];

//   List<QuestionData>? get questionList => _questionList;

//   void getQuestions(String quizId, BuildContext context) async {
//     _questionList?.clear();
//     _questionList = await ApiServices.fetchQuestionList(
//         quizId: quizId, context: context);
//     notifyListeners();
//   }
// }


import 'dart:math';
import 'package:fl_quiz_app/models/question_model.dart';
import 'package:fl_quiz_app/models/quizz_item.dart';
import 'package:fl_quiz_app/models/security_questions_model.dart';
import 'package:fl_quiz_app/services/api_services.dart';
//import 'package:fl_quiz_app/utils/globals.dart';
import 'package:flutter/material.dart';

class PlayQuizProvider extends ChangeNotifier {
  final List<QuizItem> _quizItems = [];
  //String? _completionMessage;

  List<QuizItem> get quizItems => _quizItems;
  //String? get completionMessage => _completionMessage;

  Future<void> getQuestions(String quizId,String? userId, BuildContext context) async {
    try {
      _quizItems.clear();
      //_completionMessage = null;

      List<QuestionData> questions = await ApiServices.fetchQuestionList(
        quizId: quizId,
        userId: userId,
        context: context,
      );
      if (questions.isEmpty) {
        print('No questions found for quizId: $quizId');
        return;
      }


      SecurityQuestionData randomSecurityQuestion = await _fetchRandomSecurityQuestion(context);
      questions.shuffle();
      _quizItems.addAll(questions.map((question) => QuizItem.fromQuestionData(question)).toList());
      int securityQuestionPosition = min(5, _quizItems.length); 
      _quizItems.insert(securityQuestionPosition, QuizItem.fromSecurityQuestionData(randomSecurityQuestion));
      notifyListeners();
    } catch (e) {
      print('Error fetching questions: $e');
    }
  }
  Future<SecurityQuestionData> _fetchRandomSecurityQuestion(BuildContext context) async {
    List<SecurityQuestionData> questions = await ApiServices.fetchSecurityQuestions(context: context);
    return questions[Random().nextInt(questions.length)];
  }
}

