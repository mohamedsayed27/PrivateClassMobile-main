class StoreSearchModel {
  StoreSearchModel({
    required this.data,
    required this.message,
    required this.status,
  });

  List<Data>? data;
  String message;
  bool status;

  factory StoreSearchModel.fromJson(Map<dynamic, dynamic>? json) =>
      StoreSearchModel(
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
    required this.isInstallment,
    required this.numHours,
  });

  int id;
  String name;
  String price;
  String photo;
  String details;
  List<Category> categories;
  Teacher teacher;
  int numSubscribe;
  bool isFavorite;
  bool isInstallment;
  int numVideos;
  dynamic numHours;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"]!,
        price: json["price"],
        photo: json["photo"],
        details: json["details"]!,
        categories: List<Category>.from(
            json["categories"].map((x) => Category.fromJson(x))),
        teacher: Teacher.fromJson(json["teacher"]),
        numSubscribe: json["num_subscribe"],
        isFavorite: json["is_favorite"],
        numVideos: json["num_videos"],
        numHours: json["num_hours"],
       isInstallment: json["isInstallment"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "photo": photo,
        "details": details,
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
        "teacher": teacher.toJson(),
        "num_subscribe": numSubscribe,
        "is_favorite": isFavorite,
        "num_videos": numVideos,
        "num_hours": numHours,
        "isInstallment": isInstallment,
      };
}

class Category {
  Category({
    required this.id,
    required this.name,
    required this.timeVideos,
    required this.videos,
  });

  int id;
  String name;
  dynamic timeVideos;
  List<Video> videos;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        timeVideos: json["time_videos"],
        videos: List<Video>.from(json["videos"].map((x) => Video.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "time_videos": timeVideos,
        "videos": List<dynamic>.from(videos.map((x) => x.toJson())),
      };
}

class Video {
  Video({
    required this.id,
    required this.name,
    required this.video,
    required this.timeVideo,
    required this.free,
  });

  int id;
  String name;
  String video;
  String timeVideo;
  bool free;

  factory Video.fromJson(Map<String, dynamic> json) => Video(
        id: json["id"],
        name: json["name"],
        video: json["video"],
        timeVideo: json["time_video"],
        free: json["free"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "video": video,
        "time_video": timeVideo,
        "free": free,
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
  String? pio;
  String jobTitle;

  factory Teacher.fromJson(Map<String, dynamic> json) => Teacher(
        id: json["id"],
        name: json["name"]!,
        photo: json["photo"],
        pio: json["pio"],
        jobTitle: json["job_title"]!,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "photo": photo,
        "pio": pio,
        "job_title": jobTitle,
      };
}
