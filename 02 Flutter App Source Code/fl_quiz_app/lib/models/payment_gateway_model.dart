class PaymentGatewayResponse {
  PaymentGatewayResponse({
    this.result,
    this.statusCode,
    this.msg,
    this.data,
  });

  int? result;
  int? statusCode;
  String? msg;
  List<PaymentGatewayData>? data;

  factory PaymentGatewayResponse.fromJson(Map<String, dynamic> json) =>
      PaymentGatewayResponse(
        result: json["result"],
        statusCode: json["statusCode"],
        msg: json["msg"],
        data: json["data"] == null
            ? []
            : List<PaymentGatewayData>.from(
                json["data"]!.map((x) => PaymentGatewayData.fromJson(x))),
      );
}

class PaymentGatewayData {
  PaymentGatewayData({
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

  factory PaymentGatewayData.fromJson(Map<String, dynamic> json) =>
      PaymentGatewayData(
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
