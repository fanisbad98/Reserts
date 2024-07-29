class FeatureCategoriesResponse {
  FeatureCategoriesResponse({
    required this.result,
    required this.statusCode,
    required this.msg,
    required this.data,
  });

  int result;
  int statusCode;
  String msg;
  List<FeatureCategoriesData> data;

  factory FeatureCategoriesResponse.fromJson(Map<String, dynamic> json) =>
      FeatureCategoriesResponse(
        result: json["result"],
        statusCode: json["statusCode"],
        msg: json["msg"],
        data: List<FeatureCategoriesData>.from(
            json["data"].map((x) => FeatureCategoriesData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "statusCode": statusCode,
        "msg": msg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class FeatureCategoriesData {
  FeatureCategoriesData({
    required this.id,
    required this.name,
    required this.image,
  });

  String id;
  String name;
  String image;

  factory FeatureCategoriesData.fromJson(Map<String, dynamic> json) =>
      FeatureCategoriesData(
        id: json["_id"],
        name: json["name"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "image": image,
      };
}
