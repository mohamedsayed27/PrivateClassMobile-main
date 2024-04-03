class CourseCouponModel {
  CourseCouponModel({
    required this.data,
    required this.message,
    required this.status,
  });

  Data data;
  String message;
  bool status;

  factory CourseCouponModel.fromJson(Map<dynamic, dynamic>? json) =>
      CourseCouponModel(
        data: Data.fromJson(json!["data"]),
        message: json["message"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
    "message": message,
    "status": status,
  };
}

class Data {
  Data({
    required this.total,
  });

  dynamic total;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    total: json["priceAfterCoupon"],
  );

  Map<String, dynamic> toJson() => {
    "total": total,
  };
}
