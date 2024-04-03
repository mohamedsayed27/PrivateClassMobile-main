class AddToCartModel {
  AddToCartModel({
    this.data,
    required this.message,
    required this.status,
  });

  dynamic data;
  String message;
  bool status;

  factory AddToCartModel.fromJson(Map<dynamic, dynamic> json) => AddToCartModel(
        data: json["data"],
        message: json["message"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": data,
        "message": message,
        "status": status,
      };
}
