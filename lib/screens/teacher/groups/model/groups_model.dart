class GroupsModel {
  GroupsModel({
    required this.data,
    required this.message,
    required this.status,
  });

  List<Data> data;
  String message;
  bool status;

  factory GroupsModel.fromJson(Map<dynamic, dynamic> json) => GroupsModel(
        data: json['data'] != null
            ? List<Data>.from(json["data"].map((x) => Data.fromJson(x)))
            : [],
        message: json["message"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
        "status": status,
      };
}

class Data {
  Data({
    required this.id,
    required this.name,
    required this.dateGroup,
    required this.timeFrom,
    required this.dateGroupFormatted,
    required this.timeFromFormat,
    required this.link,
    required this.details,
    required this.users,
  });

  int id;
  String name;
  String dateGroup;
  String timeFrom;
  String dateGroupFormatted;
  String timeFromFormat;

  String link;
  String details;
  List<User> users;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        dateGroup: json["date"],
        dateGroupFormatted: json["date_group"],
        timeFrom: json["time_from"],
        link: json["link"],
        details: json["details"] != null ? json["details"] : "",
        timeFromFormat: json["time_from_format"],
        users: List<User>.from(json["users"].map((x) => User.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "date": dateGroup,
        "date_group": dateGroupFormatted,
        "time_from": timeFrom,
        "link": link,
        "time_from_format": timeFromFormat,
        "details": details,
        "users": List<dynamic>.from(users.map((x) => x.toJson())),
      };
}

class User {
  User({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
