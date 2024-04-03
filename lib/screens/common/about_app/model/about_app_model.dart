class AboutAppModel {
  Data? data;
  String? message;
  bool? status;

  AboutAppModel({this.data, this.message, this.status});

  AboutAppModel.fromJson(Map<dynamic, dynamic> json) {
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
  String? vision;
  String? msg;
  String? goal;

  Data({this.vision, this.msg, this.goal});

  Data.fromJson(Map<String, dynamic> json) {
    vision = json['vision'];
    msg = json['msg'];
    goal = json['goal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vision'] = this.vision;
    data['msg'] = this.msg;
    data['goal'] = this.goal;
    return data;
  }
}
