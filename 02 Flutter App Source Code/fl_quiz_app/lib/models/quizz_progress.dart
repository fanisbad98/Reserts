// class QuizProgress {
//   String userId;
//   String quizId;
//   int currentQuestionIndex;
//   int answeredQuestions;

//   QuizProgress({
//     required this.userId,
//     required this.quizId,
//     this.currentQuestionIndex = 0,
//     this.answeredQuestions = 0,
//   });

//   factory QuizProgress.fromJson(Map<String, dynamic> json) {
//     return QuizProgress(
//       userId: json['userId'] ?? '',
//       quizId: json['quizId'] ?? '',
//       currentQuestionIndex: json['currentQuestionIndex'] ?? 0,
//       answeredQuestions: json['answeredQuestions'] ?? 0, 
//     );
//   }


//   Map<String, dynamic> toMap() {
//     return {
//       'userId': userId,
//       'quizId': quizId,
//       'currentQuestionIndex': currentQuestionIndex,
//       'answeredQuestions' : answeredQuestions,
//     };
//   }
// }
