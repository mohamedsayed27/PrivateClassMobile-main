class UpdateProfileModel {
  DataUpdate? data;
  String? message;
  bool? status;

  UpdateProfileModel({this.data, this.message, this.status});

  UpdateProfileModel.fromJson(Map<dynamic, dynamic> json) {
    data = json['data'] != null ?  DataUpdate.fromJson(json['data']) : null;
    message = json['message'];
    status = json['status'];
  }

}

class DataUpdate {
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

  DataUpdate(
      {this.id,
        this.name,
        this.phone,
        this.phoneKey,
        this.email,
        this.stage,
        this.stageId,
        this.subjectId,
        this.subject,
        this.pio,
        this.photo,
        this.isNotifiy,
        this.role});

  DataUpdate.fromJson(Map<String, dynamic> json) {
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
    photo = json['photo'];
    isNotifiy = json['is_notifiy'];
    role = json['role'];
  }

}
