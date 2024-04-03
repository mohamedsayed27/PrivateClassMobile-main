import 'dart:convert';

class CurrentCourseModel {
  CurrentCourseModel({
    required this.data,
    required this.message,
    required this.status,
  });

  List<Data>? data;
  String message;
  bool status;

  factory CurrentCourseModel.fromJson(Map<dynamic, dynamic>? json) =>
      CurrentCourseModel(
        data: json!["data"] != null
            ? List<Data>.from(json["data"].map((item) => Data.fromJson(item)))
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
    required this.photo,
    required this.progress,
    required this.countVideos,
  });

  int id;
  String name;
  String photo;
  double progress;
  int countVideos;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        photo: json["photo"],
        progress: json["progress"].toDouble(),
        countVideos: json["count_videos"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "photo": photo,
        "progress": progress,
        "count_videos": countVideos,
      };
}
