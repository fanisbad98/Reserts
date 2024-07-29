class AddPointsResponse {
  AddPointsResponse({
    required this.result,
    required this.statusCode,
    required this.msg,
    required this.data,
  });

  int result;
  int statusCode;
  String msg;
  AddPointsData data;

  factory AddPointsResponse.fromJson(Map<String, dynamic> json) =>
      AddPointsResponse(
        result: json["result"],
        statusCode: json["statusCode"],
        msg: json["msg"],
        data: AddPointsData.fromJson(json["data"]),
      );
}

class AddPointsData {
  AddPointsData({
    required this.id,
    required this.totalPoints,
  });

  String id;
  int totalPoints;

  factory AddPointsData.fromJson(Map<String, dynamic> json) => AddPointsData(
        id: json["_id"],
        totalPoints: json["totalPoints"],
      );
}
