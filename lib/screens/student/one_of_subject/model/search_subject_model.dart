class SearchSubjectModel {
  SearchSubjectModel({
    required this.data,
    required this.message,
    required this.status,
  });

  List<Data>? data;
  String message;
  bool status;

  factory SearchSubjectModel.fromJson(Map<dynamic, dynamic>? json) =>
      SearchSubjectModel(
        data: json!['data'] != null
            ? List<Data>.from(json["data"].map((x) => Data.fromJson(x)))
            : [],
        message: json["message"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "message": message,
        "status": status,
      };
}

class Data {
  Data({
    required this.id,
    required this.name,
    required this.price,
    required this.photo,
    required this.details,
    required this.categories,
    required this.teacher,
    required this.numSubscribe,
    required this.isFavorite,
    required this.numVideos,
    required this.numHours,
    required this.isInstallment,
  });

  int id;
  String name;
  String price;
  String photo;
  String details;
  List<dynamic> categories;
  Teacher teacher;
  int numSubscribe;
  bool isFavorite;
  bool isInstallment;
  int numVideos;
  dynamic numHours;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        photo: json["photo"],
        details: json["details"],
        categories: List<dynamic>.from(json["categories"].map((x) => x)),
        teacher: Teacher.fromJson(json["teacher"]),
        numSubscribe: json["num_subscribe"],
        isFavorite: json["is_favorite"],
        isInstallment: json["isInstallment"],
        numVideos: json["num_videos"],
        numHours: json["num_hours"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "photo": photo,
        "details": details,
        "categories": List<dynamic>.from(categories.map((x) => x)),
        "teacher": teacher.toJson(),
        "num_subscribe": numSubscribe,
        "is_favorite": isFavorite,
        "isInstallment": isInstallment,
        "num_videos": numVideos,
        "num_hours": numHours,
      };
}

class Teacher {
  Teacher({
    required this.id,
    required this.name,
    required this.photo,
    this.pio,
    required this.jobTitle,
  });

  int id;
  String name;
  String photo;
  dynamic pio;
  String jobTitle;

  factory Teacher.fromJson(Map<String, dynamic> json) => Teacher(
        id: json["id"],
        name: json["name"],
        photo: json["photo"],
        pio: json["pio"],
        jobTitle: json["job_title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "photo": photo,
        "pio": pio,
        "job_title": jobTitle,
      };
}
