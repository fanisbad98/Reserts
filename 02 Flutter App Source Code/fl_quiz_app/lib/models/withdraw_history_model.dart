class WithdrawHistoryResponse {
  WithdrawHistoryResponse({
    this.result,
    this.statusCode,
    this.msg,
    this.data,
  });

  int? result;
  int? statusCode;
  String? msg;
  List<WithdrawHistoryData>? data;

  factory WithdrawHistoryResponse.fromJson(Map<String, dynamic> json) =>
      WithdrawHistoryResponse(
        result: json["result"],
        statusCode: json["statusCode"],
        msg: json["msg"],
        data: json["data"] == null
            ? []
            : List<WithdrawHistoryData>.from(
                json["data"]!.map((x) => WithdrawHistoryData.fromJson(x))),
      );
}

class WithdrawHistoryData {
  WithdrawHistoryData({
    this.id,
    this.userId,
    this.reqStatus,
    this.amount,
    this.points,
    this.paymentMethod,
    this.paymentVia,
    this.createdAt,
    this.updatedAt,
  });

  String? id;
  String? userId;
  String? reqStatus;
  double? amount;
  int? points;
  PaymentMethod? paymentMethod;
  String? paymentVia;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory WithdrawHistoryData.fromJson(Map<String, dynamic> json) =>
      WithdrawHistoryData(
        id: json["_id"],
        userId: json["userId"],
        reqStatus: json["reqStatus"],
        amount: json["amount"]?.toDouble(),
        points: json["points"],
        paymentMethod: json["paymentMethod"] == null
            ? null
            : PaymentMethod.fromJson(json["paymentMethod"]),
        paymentVia: json["paymentVia"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );
}

class PaymentMethod {
  PaymentMethod({
    this.id,
    this.name,
    this.image,
    this.inputField,
    this.inputPlaceholder,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  String? id;
  String? name;
  String? image;
  String? inputField;
  String? inputPlaceholder;
  bool? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
        id: json["_id"],
        name: json["name"],
        image: json["image"],
        inputField: json["inputField"],
        inputPlaceholder: json["inputPlaceholder"],
        isActive: json["isActive"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );
}
