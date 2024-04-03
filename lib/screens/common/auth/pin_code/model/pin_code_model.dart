class PinCodeModel {
  Data? data;
  String? message;
  bool? status;

  PinCodeModel({this.data, this.message, this.status});

  PinCodeModel.fromJson(Map<dynamic, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
    status = json['status'];
  }

}

class Data {
  User? user;
  String? token;

  Data({this.user, this.token});

  Data.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    token = json['token'];
  }

}

class User {
  int? id;
  String? name;
  String? phone;
  String? phoneKey;
  String? email;
  String? stage;
  int? stageId;
  int? subjectId;
  String? subject;
  String? pio;
  String? photo;
  bool? isNotifiy;
  String? role;
  int? notificationCount;
  int? cartCount;

  User(
      {this.id,
        this.name,
        this.phone,
        this.phoneKey,
        this.email,
        this.stage,
        this.cartCount,
        this.stageId,
        this.subjectId,
        this.subject,
        this.pio,
        this.photo,
        this.isNotifiy,
        this.role,
        this.notificationCount});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    phoneKey = json['phone_key'];
    email = json['email'];
    stage = json['stage'];
    stageId = json['stage_id'];
    subjectId = json['subject_id'];
    subject = json['subject'];
    pio = json['pio'];
    cartCount = json['cart_count'];
    photo = json['photo'];
    isNotifiy = json['is_notifiy'];
    role = json['role'];
    notificationCount = json['notification_count'];
  }

}
