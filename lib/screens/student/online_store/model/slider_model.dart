class CartSliderModel {
  List<Data>? data;
  String? message;
  bool? status;

  CartSliderModel({this.data, this.message, this.status});

  CartSliderModel.fromJson(Map<dynamic, dynamic> json) {
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
  String? title;
  String? desc;
  String? photo;
  String? link;
  int? course_id;
  String? type;

  Data({this.id, this.title, this.desc, this.photo, this.link, this.course_id, this.type});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    desc = json['desc'];
    photo = json['photo'];
    link = json['link'];
    course_id = json['course_id'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['desc'] = this.desc;
    data['photo'] = this.photo;
    data['link'] = this.link;
    data['course_id'] = this.course_id;
    data['type'] = this.type;
    return data;
  }
}
