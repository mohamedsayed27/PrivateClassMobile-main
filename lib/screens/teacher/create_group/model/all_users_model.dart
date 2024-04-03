class AllUsersModel {
  AllUsersModel({
    required this.users,
    required this.message,
    required this.status,
  });

  List<Users> users;
  String message;
  bool status;

  factory AllUsersModel.fromJson(Map<dynamic, dynamic>? json) => AllUsersModel(
        users: json!['data'] != null
            ? List<Users>.from(json["data"].map((x) => Users.fromJson(x)))
            : [],
        message: json["message"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(users.map((x) => x.toJson())),
        "message": message,
        "status": status,
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
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
