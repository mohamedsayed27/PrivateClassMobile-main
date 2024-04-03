class ProfileModel {
  Data? data;
  String? message;
  bool? status;

  ProfileModel({this.data, this.message, this.status});

  ProfileModel.fromJson(Map<dynamic, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
    status = json['status'];
  }

}

class Data {
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

  Data(
      {this.id,
        this.name,
        this.phone,
        this.phoneKey,
        this.email,
        this.stage,
        this.stageId,
        this.subjectId,
        this.subject,
        this.cartCount,
        this.pio,
        this.photo,
        this.isNotifiy,
        this.role,
        this.notificationCount});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    phoneKey = json['phone_key'];
    email = json['email'];
    stage = json['stage'];
    stageId = json['stage_id'];
    cartCount = json['cart_count'];
    subjectId = json['subject_id'];
    subject = json['subject'];
    pio = json['pio'];
    photo = json['photo'];
    isNotifiy = json['is_notifiy'];
    role = json['role'];
    notificationCount = json['notification_count'];
  }

}
