class GetNotificationModel {
  Data? data;
  String? message;
  bool? status;

  GetNotificationModel({this.data, this.message, this.status});

  GetNotificationModel.fromJson(Map<dynamic, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
    status = json['status'];
  }
}

class Data {
  List<Day>? day;
  List<Yesterday>? yesterday;

  Data({this.day, this.yesterday});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['day'] != null) {
      day = <Day>[];
      json['day'].forEach((v) {
        day!.add(Day.fromJson(v));
      });
    }
    if (json['yesterday'] != null) {
      yesterday = <Yesterday>[];
      json['yesterday'].forEach((v) {
        yesterday!.add(Yesterday.fromJson(v));
      });
    }
  }
}

class Day {
  String? id;
  String? type;
  String? title;
  String? body;
  String? icon;
  dynamic groupId;
  String? groupSlug;

  Day(
      {this.id,
      this.type,
      this.title,
      this.body,
      this.icon,
      this.groupId,
      this.groupSlug});

  Day.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    title = json['title'];
    body = json['body'];
    icon = json['icon'];
    groupId = json['group_id'];
    groupSlug = json['group_slug'];
  }
}

class Yesterday {
  String? id;
  String? type;
  String? title;
  String? body;
  String? icon;
  dynamic groupId;
  String? groupSlug;

  Yesterday(
      {this.id,
      this.type,
      this.title,
      this.body,
      this.icon,
      this.groupId,
      this.groupSlug});

  Yesterday.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    title = json['title'];
    body = json['body'];
    icon = json['icon'];
    groupId = json['group_id'];
    groupSlug = json['group_slug'];
  }
}
