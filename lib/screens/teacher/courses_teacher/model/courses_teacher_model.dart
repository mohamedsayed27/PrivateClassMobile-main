class CoursesTeacherModel {
  List<Data>? data;
  String? message;
  bool? status;

  CoursesTeacherModel({this.data, this.message, this.status});

  CoursesTeacherModel.fromJson(Map<dynamic, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class Data {
  int? id;
  String? photo;
  String? name;
  String? details;
  String? price;
  dynamic duration;
  bool? isFavorite;

  Data(
      {this.id,
        this.photo,
        this.name,
        this.details,
        this.price,
        this.duration,
        this.isFavorite});

  Data.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    photo = json['photo'];
    name = json['name'];
    details = json['details'];
    price = json['price'];
    duration = json['duration'];
    isFavorite = json['is_favorite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['photo'] = this.photo;
    data['name'] = this.name;
    data['details'] = this.details;
    data['price'] = this.price;
    data['duration'] = this.duration;
    data['is_favorite'] = this.isFavorite;
    return data;
  }
}
