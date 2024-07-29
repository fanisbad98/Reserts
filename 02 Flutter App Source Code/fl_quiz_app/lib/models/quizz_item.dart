import 'package:fl_quiz_app/models/question_model.dart';
import 'package:fl_quiz_app/models/security_questions_model.dart';

enum QuizItemType {
  question,
  securityQuestion,
}

class QuizItem {
  final String question;
  final String optionA;
  final String optionB;
  final String optionC;
  final String optionD;
  final String? correctAnswer;
  final QuizItemType type;


  QuizItem({
    required this.question,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
    required this.correctAnswer,
    required this.type,
  });

   factory QuizItem.fromQuestionData(QuestionData questionData) {
    return QuizItem(
      question: questionData.question,
      optionA: questionData.optionA,
      optionB: questionData.optionB,
      optionC: questionData.optionC,
      optionD: questionData.optionD,
      correctAnswer: null,
      type: QuizItemType.question,
    );
  }

  factory QuizItem.fromSecurityQuestionData(SecurityQuestionData securityQuestionData) {
    return QuizItem(
      question: securityQuestionData.question,
      optionA: securityQuestionData.optionA,
      optionB: securityQuestionData.optionB,
      optionC: securityQuestionData.optionC,
      optionD: securityQuestionData.optionD,
      correctAnswer: securityQuestionData.correctAnswer,
      type: QuizItemType.securityQuestion,
    );
  }
}
