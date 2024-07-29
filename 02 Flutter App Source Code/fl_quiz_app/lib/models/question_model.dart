class QuestionResponse {
  QuestionResponse({
    required this.result,
    required this.statusCode,
    this.msg,
    required this.data,
  });

  int result;
  int statusCode;
  String? msg;
  List<QuestionData> data;

  factory QuestionResponse.fromJson(Map<String, dynamic> json) =>
      QuestionResponse(
        result: json["result"],
        statusCode: json["statusCode"],
        msg: json["msg"],
        data: json["data"] != null 
          ? List<QuestionData>.from(
              json["data"].map((x) => QuestionData.fromJson(x)))
          : [],
      );
}

class QuestionData {
  QuestionData({
    required this.question,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
  });

  String question;
  String optionA;
  String optionB;
  String optionC;
  String optionD;

  factory QuestionData.fromJson(Map<String, dynamic> json) => QuestionData(
        question: json["question"],
        optionA: json["optionA"],
        optionB: json["optionB"],
        optionC: json["optionC"],
        optionD: json["optionD"],
      );
}
