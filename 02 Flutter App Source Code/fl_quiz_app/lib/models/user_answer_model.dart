class UserAnswer {
  final String? questionId;
  final String selectedAnswer;
  final String userId;
  final String categoryId;
  final String lvl;

  UserAnswer({
    required this.questionId,
    required this.selectedAnswer,
    required this.userId,
    required this.categoryId,
    required this.lvl,
  });

  Map<String, dynamic> toJson() {
    return {
      'categoryId' : categoryId,
      'lvl': lvl,
      'questionId': questionId,
      'selectedAnswer': selectedAnswer,
      'userId': userId,
    };
  }
}