class LoginModel {
  Data? data;
  String? message;
  bool? status;

  LoginModel({this.data, this.message, this.status});

  LoginModel.fromJson(Map<dynamic, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
    status = json['status'];
  }

}

class Data {
  EmailUser? user;
  String? token;

  Data({this.user, this.token});

  Data.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new EmailUser.fromJson(json['user']) : null;
    token = json['token'];
  }

}

class EmailUser {
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
  String? user;
  int? notificationCount;
  int? cartCount;

  EmailUser(
      {this.id,
        this.name,
        this.phone,
        this.phoneKey,
        this.email,
        this.stage,
        this.stageId,
        this.cartCount,
        this.subjectId,
        this.subject,
        this.pio,
        this.photo,
        this.user,
        this.isNotifiy,
        this.role,
        this.notificationCount});

  EmailUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    phoneKey = json['phone_key'];
    email = json['email'];
    stage = json['stage'];
    stageId = json['stage_id'];
    subjectId = json['subject_id'];
    subject = json['subject'];
    cartCount = json['cart_count'];
    pio = json['pio'];
    photo = json['photo'];
    user = json['user'];
    isNotifiy = json['is_notifiy'];
    role = json['role'];
    notificationCount = json['notification_count'];
  }

}
