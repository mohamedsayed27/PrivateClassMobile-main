class CategoriesModel {
  List<Dataaa>? data;
  String? message;
  bool? status;

  CategoriesModel({this.data, this.message, this.status});

  CategoriesModel.fromJson(Map<dynamic, dynamic> json) {
    if (json['data'] != null) {
      data = <Dataaa>[];
      json['data'].forEach((v) {
        data!.add(new Dataaa.fromJson(v));
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

class Dataaa {
  int? id;
  String? name;

  Dataaa({this.id, this.name});

  Dataaa.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
