class TeacherProfileModel {
  Data? data;
  String? message;
  bool? status;

  TeacherProfileModel({this.data, this.message, this.status});

  TeacherProfileModel.fromJson(Map<dynamic, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? photo;
  String? jobTitle;
  int? numSubscribes;
  int? numCourses;
  String? createdAt;
  List<Courses>? courses;

  Data(
      {this.id,
        this.name,
        this.photo,
        this.jobTitle,
        this.numSubscribes,
        this.numCourses,
        this.createdAt,
        this.courses});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    photo = json['photo'];
    jobTitle = json['job_title'];
    numSubscribes = json['num_subscribes'];
    numCourses = json['num_courses'];
    createdAt = json['created_at'];
    if (json['courses'] != null) {
      courses = <Courses>[];
      json['courses'].forEach((v) {
        courses!.add(Courses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['photo'] = this.photo;
    data['job_title'] = this.jobTitle;
    data['num_subscribes'] = this.numSubscribes;
    data['num_courses'] = this.numCourses;
    data['created_at'] = this.createdAt;
    if (this.courses != null) {
      data['courses'] = this.courses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Courses {
  int? id;
  String? photo;
  String? name;
  String? details;
  String? price;
  dynamic duration;
  bool? isFavorite;
  dynamic isInstallment;

  Courses(
      {this.id,
        this.photo,
        this.name,
        this.details,
        this.price,
        this.duration,
        this.isInstallment,
        this.isFavorite});

  Courses.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    photo = json['photo'];
    name = json['name'];
    details = json['details'];
    price = json['price'];
    duration = json['duration'];
    isFavorite = json['is_favorite'];
    isInstallment = json['isInstallment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['photo'] = this.photo;
    data['name'] = this.name;
    data['details'] = this.details;
    data['price'] = this.price;
    data['duration'] = this.duration;
    data['is_favorite'] = this.isFavorite;
    data['isInstallment'] = this.isInstallment;
    return data;
  }
}
