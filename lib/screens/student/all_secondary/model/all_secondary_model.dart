class AllSecondaryModel {
  AllSecondaryModel({
    required this.data,
    required this.message,
    required this.status,
  });

  List<Data> data;
  String message;
  bool status;

  factory AllSecondaryModel.fromJson(Map<dynamic, dynamic> json) =>
      AllSecondaryModel(
        data: json['data'] != null
            ? List<Data>.from(json["data"].map((x) => Data.fromJson(x)))
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
    required this.name,
    required this.courses,
  });

  int id;
  String name;
  List<Course> courses;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        courses: json["courses"] != null
            ? List<Course>.from(json["courses"].map((x) => Course.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "courses": List<dynamic>.from(courses.map((x) => x.toJson())),
      };
}

class Course {
  Course({
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
  dynamic isFavorite;
  dynamic isInstallment;

  factory Course.fromJson(Map<String, dynamic> json) => Course(
        id: json["id"],
        photo: json["photo"],
        name: json["name"],
        details: json["details"],
        price: json["price"],
        duration: json["duration"],
        isFavorite: json["is_favorite"],
    isInstallment: json["isInstallment"],
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
