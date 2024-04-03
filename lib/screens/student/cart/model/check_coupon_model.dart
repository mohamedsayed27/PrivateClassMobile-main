class CheckCouponModel {
  CheckCouponModel({
    required this.data,
    required this.message,
    required this.status,
  });

  Data data;
  String message;
  bool status;

  factory CheckCouponModel.fromJson(Map<dynamic, dynamic>? json) =>
      CheckCouponModel(
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
    required this.percent,
  });

  dynamic total;
  int percent;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        total: json["total"],
        percent: json["percent"],
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "percent": percent,
      };
}
