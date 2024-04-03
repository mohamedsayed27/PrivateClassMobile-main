class PreviousCoursesModel {
  List<Data>? data;
  String? message;
  bool? status;

  PreviousCoursesModel({this.data, this.message, this.status});

  PreviousCoursesModel.fromJson(Map<dynamic, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    data['status'] = status;
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? photo;
  dynamic progress;
  int? countVideos;

  Data({this.id, this.name, this.photo, this.progress, this.countVideos});

  Data.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    name = json['name'];
    photo = json['photo'];
    progress = json['progress'];
    countVideos = json['count_videos'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['photo'] = photo;
    data['progress'] = progress;
    data['count_videos'] = countVideos;
    return data;
  }
}
