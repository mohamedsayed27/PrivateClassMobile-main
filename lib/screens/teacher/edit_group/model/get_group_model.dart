class GetGroupModel {
  GetGroupModel({
    required this.data,
    required this.message,
    required this.status,
  });

  Data data;
  String message;
  bool status;

  factory GetGroupModel.fromJson(Map<dynamic, dynamic>? json) => GetGroupModel(
        data: Data.fromJson(json!["data"]),
        message: json["message"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
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
    required this.timeFromFormat,
    required this.link,
    required this.details,
    required this.users,
  });

  int id;
  String name;
  String dateGroup;
  String timeFrom;
  String timeFromFormat;
  String link;
  String details;
  List<Users> users;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        dateGroup: json["date_group"],
        timeFrom: json["time_from"],
        link: json["link"],
        details: json["details"] != null ? json["details"] : "",
        timeFromFormat: json["time_from_format"],
        users: List<Users>.from(json["users"].map((x) => Users.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "date_group": dateGroup,
        "time_from": timeFrom,
        "link": link,
        "time_from_format": timeFromFormat,
        "details": details,
        "users": List<dynamic>.from(users.map((x) => x.toJson())),
      };
}

class Users {
  Users({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        id: json["user_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": id,
        "name": name,
      };
}
