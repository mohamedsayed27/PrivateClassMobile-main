class CurrentCoursesModel {
  List<CurrentData>? data;
  String? message;
  bool? status;

  CurrentCoursesModel({this.data, this.message, this.status});

  CurrentCoursesModel.fromJson(Map<dynamic, dynamic> json) {
    if (json['data'] != null) {
      data = <CurrentData>[];
      json['data'].forEach((v) {
        data!.add(CurrentData.fromJson(v));
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
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class CurrentData {
  int? id;
  String? name;
  String? photo;
  double? progress;
  int? countVideos;

  CurrentData(
      {this.id, this.name, this.photo, this.progress, this.countVideos});

  CurrentData.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    name = json['name'];
    photo = json['photo'];
    progress = json['progress'].toDouble();
    countVideos = json['count_videos'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['photo'] = this.photo;
    data['progress'] = this.progress;
    data['count_videos'] = this.countVideos;
    return data;
  }
}
