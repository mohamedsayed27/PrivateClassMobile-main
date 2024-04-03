class LiveCourseModel {
  LiveCourseModel({
    required this.data,
    required this.message,
    required this.status,
  });

  List<Data> data;
  String message;
  bool status;

  factory LiveCourseModel.fromJson(Map<dynamic, dynamic>? json) =>
      LiveCourseModel(
        data: json!['data'] != null
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
    required this.teacherName,
    required this.timeStart,
    required this.dateLive,
    this.details,
    required this.dateLiveFormat,
    required this.timeStartFormat,
    required this.note,
    required this.photo,
  });

  int id;
  String name;
  String teacherName;
  String timeStart;
  String dateLive;
  String dateLiveFormat;
  String timeStartFormat;
  dynamic details;
  String note;
  String photo;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        teacherName: json["name_teacher"],
        timeStart: json["time_start"],
        dateLive: json["date_live"],
        dateLiveFormat: json['date_live_format'],
        timeStartFormat: json['time_start_format'],
        details: json["details"],
        note: json["note"] ?? "",
        photo: json["photo"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "name_teacher": teacherName,
        "time_start": timeStart,
        "date_live": dateLive,
        "date_live_format": dateLiveFormat,
        "time_start_format": timeStartFormat,
        "details": details,
        "note": note,
        "photo": photo,
      };
}
