class MyProfileResponse {
  int result;
  int statusCode;
  String msg;
  MyProfileData data;

  MyProfileResponse({
    required this.result,
    required this.statusCode,
    required this.msg,
    required this.data,
  });

  factory MyProfileResponse.fromJson(Map<String, dynamic> json) =>
      MyProfileResponse(
        result: json["result"],
        statusCode: json["statusCode"],
        msg: json["msg"],
        data: MyProfileData.fromJson(json["data"]),
      );
}

class MyProfileData {
  String name;
  String email;
  String mobile;
  String profilePic;
  bool isSubscribed;
  int totalPoints;
  String referralCode;
  String? campus;

  MyProfileData({
    required this.name,
    required this.email,
    required this.mobile,
    required this.profilePic,
    required this.isSubscribed,
    required this.totalPoints,
    required this.referralCode,
    this.campus,
  });

  factory MyProfileData.fromJson(Map<String, dynamic> json) => MyProfileData(
        name: json["name"],
        email: json["email"],
        mobile: json["mobile"],
        profilePic: json["profilePic"],
        isSubscribed: json["isSubscribed"],
        totalPoints: json["totalPoints"],
        referralCode: json["referralCode"],
        campus: json["campus"],
      );
}
