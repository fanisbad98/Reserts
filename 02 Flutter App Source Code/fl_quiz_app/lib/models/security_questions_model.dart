class SecurityQuestionResponse {
  SecurityQuestionResponse({
    required this.result,
    required this.statusCode,
    required this.msg,
    required this.data,
  });

  int result;
  int statusCode;
  String msg;
  List<SecurityQuestionData> data;

  factory SecurityQuestionResponse.fromJson(Map<String, dynamic> json) {
    final result = json["result"] ?? 0;
    final statusCode = json["statusCode"] ?? 0;
    final msg = json["msg"] ?? "";
    final jsonData = json["data"] as List<dynamic>?;

    List<SecurityQuestionData> data = [];
    if (jsonData != null) {
      data = jsonData.map((x) => SecurityQuestionData.fromJson(x)).toList();
    }

    return SecurityQuestionResponse(
      result: result,
      statusCode: statusCode,
      msg: msg,
      data: data,
    );
  }
}

class SecurityQuestionData {
  SecurityQuestionData({
    required this.question,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
    required this.correctAnswer,
  });


  String question;
  String optionA;
  String optionB;
  String optionC;
  String optionD;
  String correctAnswer;

  factory SecurityQuestionData.fromJson(Map<String, dynamic> json) =>
      SecurityQuestionData(
        question: json["question"] ?? "",
        optionA: json["optionA"] ?? "",
        optionB: json["optionB"] ?? "",
        optionC: json["optionC"] ?? "",
        optionD: json["optionD"] ?? "",
        correctAnswer: json["correctAnswer"] ?? "",
      );
}
