class OneOfFacultyModel {
  OneOfFacultyModel({
    required this.data,
    required this.message,
    required this.status,
  });

  List<Data> data;
  String message;
  bool status;

  factory OneOfFacultyModel.fromJson(Map<dynamic, dynamic>? json) =>
      OneOfFacultyModel(
        data: json!["data"] != null
            ? List<Data>.from(json["data"].map((item) => Data.fromJson(item)))
            : [],
        message: json["message"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
        "status": status,
      };
}

class Data {
  Data({
    required this.id,
    required this.photo,
    required this.name,
    required this.details,
    required this.price,
    required this.duration,
    required this.isFavorite,
    required this.isInstallment,
  });

  int id;
  String photo;
  String name;
  String details;
  String price;
  dynamic duration;
  bool isFavorite;
  bool isInstallment;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        photo: json["photo"],
        name: json["name"],
        details: json["details"],
        price: json["price"],
        duration: json["duration"],
        isInstallment: json["isInstallment"],
        isFavorite: json["is_favorite"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "photo": photo,
        "name": name,
        "details": details,
        "price": price,
        "duration": duration,
        "is_favorite": isFavorite,
        "isInstallment": isInstallment,
      };
}
