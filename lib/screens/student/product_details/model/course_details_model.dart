class CourseDetailsModel {
  Data? data;
  String? message;
  bool? status;

  CourseDetailsModel({this.data, this.message, this.status});

  CourseDetailsModel.fromJson(Map<dynamic, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
  String? price;
  String? photo;
  String? details;
  Teacher? teacher;
  bool? isFavorite;
  bool? isInstallment;

  Data(
      {this.id,
      this.name,
      this.price,
      this.photo,
      this.details,
      this.teacher,
      this.isInstallment,
      this.isFavorite});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    photo = json['photo'];
    details = json['details'];
    isInstallment = json['isInstallment'];
    teacher =
        json['teacher'] != null ? new Teacher.fromJson(json['teacher']) : null;
    isFavorite = json['is_favorite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['photo'] = this.photo;
    data['details'] = this.details;
    data['is_favorite'] = this.isFavorite;
    data['isInstallment'] = this.isInstallment;
    if (this.teacher != null) {
      data['teacher'] = this.teacher!.toJson();
    }
    return data;
  }
}

class Teacher {
  int? id;
  String? name;
  String? photo;
  String? email;
  dynamic pio;
  String? jobTitle;

  Teacher({this.id, this.name, this.email,this.photo, this.pio, this.jobTitle});

  Teacher.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    photo = json['photo'];
    pio = json['pio'];
    jobTitle = json['job_title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['photo'] = this.photo;
    data['pio'] = this.pio;
    data['job_title'] = this.jobTitle;
    return data;
  }
}
