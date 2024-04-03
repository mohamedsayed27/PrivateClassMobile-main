class RegisterModel {
  DataUser? data;
  String? message;
  bool? status;

  RegisterModel({this.data, this.message, this.status});

  RegisterModel.fromJson(Map<dynamic, dynamic> json) {
    data = json['data'] != null ? new DataUser.fromJson(json['data']) : null;
    message = json['message'];
    status = json['status'];
  }

}

class DataUser {
  int? id;
  String? name;
  String? phone;
  String? phoneKey;
  String? email;
  String? stage;
  int? stageId;
  int? cartCount;
  int? subjectId;
  String? subject;
  String? pio;
  String? photo;
  bool? isNotifiy;
  String? role;
  int? notificationCount;

  DataUser(
      {this.id,
        this.name,
        this.phone,
        this.phoneKey,
        this.email,
        this.cartCount,
        this.stage,
        this.stageId,
        this.subjectId,
        this.subject,
        this.pio,
        this.photo,
        this.isNotifiy,
        this.role,
        this.notificationCount});

  DataUser.fromJson(Map<String, dynamic> json) {
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
