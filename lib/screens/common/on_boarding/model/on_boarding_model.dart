class OnBoardingModel {
  List<Data>? data;
  String? message;
  bool? status;

  OnBoardingModel({this.data, this.message, this.status});

  OnBoardingModel.fromJson(Map<dynamic, dynamic> json) {
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
  String? image;

  Data({this.id, this.title, this.desc, this.image});

  Data.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    title = json['title'];
    desc = json['desc'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['desc'] = this.desc;
    data['image'] = this.image;
    return data;
  }
}
