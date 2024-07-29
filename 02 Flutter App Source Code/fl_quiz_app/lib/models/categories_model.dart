//import 'package:fl_quiz_app/utils/constant.dart' as constants;
class AllCategoriesResponse {
  int result;
  int statusCode;
  String msg;
  List<AllCategoriesData> data;

  AllCategoriesResponse({
    required this.result,
    required this.statusCode,
    required this.msg,
    required this.data,
  });

  factory AllCategoriesResponse.fromJson(Map<String, dynamic> json) =>
      AllCategoriesResponse(
        result: json["result"],
        statusCode: json["statusCode"],
        msg: json["msg"],
        data: List<AllCategoriesData>.from(
            json["data"].map((x) => AllCategoriesData.fromJson(x))),
      );
}

class AllCategoriesData {
  String id;
  String name;
  String image;
  int? points;
  //String pointsImage;

  AllCategoriesData({
    required this.id,
    required this.name,
    required this.image,
    required this.points,
    //required this.pointsImage
  });

  factory AllCategoriesData.fromJson(Map<String, dynamic> json) =>
      AllCategoriesData(
        id: json["_id"],
        name: json["name"],
        image: json["image"],
        points: json["points"],
        //pointsImage: constants.pointsImage,
      );
}
