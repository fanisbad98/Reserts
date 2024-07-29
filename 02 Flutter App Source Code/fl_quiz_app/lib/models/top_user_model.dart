/* class TopUserResponse {
  TopUserResponse({
    required this.result,
    required this.statusCode,
    required this.msg,
    required this.data,
  });

  int result;
  int statusCode;
  String msg;
  List<TopUserData> data;

  factory TopUserResponse.fromJson(Map<String, dynamic> json) =>
      TopUserResponse(
        result: json["result"],
        statusCode: json["statusCode"],
        msg: json["msg"],
        data: List<TopUserData>.from(
            json["data"].map((x) => TopUserData.fromJson(x))),
      );
}

class TopUserData {
  TopUserData({
    required this.id,
    required this.totalPoints,
    required this.name,
  });

  String id;
  int totalPoints;
  String name;

  factory TopUserData.fromJson(Map<String, dynamic> json) => TopUserData(
        id: json["_id"],
        totalPoints: json["totalPoints"],
        name: json["name"],
      );
}
 */

// To parse this JSON data, do
//
//     final topUserResponse = topUserResponseFromJson(jsonString);



class TopUserResponse {
    TopUserResponse({
        required this.result,
        required this.statusCode,
        required this.msg,
        required this.data,
    });

    int result;
    int statusCode;
    String msg;
    List<TopUserData> data;

    factory TopUserResponse.fromJson(Map<String, dynamic> json) => TopUserResponse(
        result: json["result"],
        statusCode: json["statusCode"],
        msg: json["msg"],
        data: List<TopUserData>.from(json["data"].map((x) => TopUserData.fromJson(x))),
    );


}

class TopUserData {
    TopUserData({
        required this.id,
        required this.totalPoints,
        required this.name,
        required this.profilePic,
    });

    String id;
    int totalPoints;
    String name;
    String profilePic;

    factory TopUserData.fromJson(Map<String, dynamic> json) => TopUserData(
        id: json["_id"],
        totalPoints: json["totalPoints"],
        name: json["name"],
        profilePic: json["profilePic"],
    );

    // Map<String, dynamic> toJson() => {
    //     "_id": id,
    //     "totalPoints": totalPoints,
    //     "name": name,
    //     "profilePic": profilePicValues.reverse[profilePic],
    // };
}

// enum ProfilePic { PUBLIC_DIST_IMG_PROFILE_PIC_DEFAULT_PROFILE_PIC_PNG }

// final profilePicValues = EnumValues({
//     "public/dist/img/profilePic/defaultProfilePic.png": ProfilePic.PUBLIC_DIST_IMG_PROFILE_PIC_DEFAULT_PROFILE_PIC_PNG
// });

// class EnumValues<T> {
//     Map<String, T> map;
//     late Map<T, String> reverseMap;

//     EnumValues(this.map);

//     Map<T, String> get reverse {
//         reverseMap = map.map((k, v) => MapEntry(v, k));
//         return reverseMap;
//     }
// }
