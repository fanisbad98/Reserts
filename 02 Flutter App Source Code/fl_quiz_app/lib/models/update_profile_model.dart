class UpdateProfileResponse {
  UpdateProfileResponse({
    this.result,
    this.statusCode,
    this.msg,
    this.data,
  });

  int? result;
  int? statusCode;
  String? msg;
  UpdateProfileData? data;

  factory UpdateProfileResponse.fromJson(Map<String, dynamic> json) =>
      UpdateProfileResponse(
        result: json["result"],
        statusCode: json["statusCode"],
        msg: json["msg"],
        data: json["data"] == null ? null : UpdateProfileData.fromJson(json["data"]),
      );
}

class UpdateProfileData {
  UpdateProfileData({
    this.id,
    this.name,
    this.profilePic,
  });

  String? id;
  String? name;
  String? profilePic;

  factory UpdateProfileData.fromJson(Map<String, dynamic> json) => UpdateProfileData(
        id: json["_id"],
        name: json["name"],
        profilePic: json["profilePic"],
      );
}
