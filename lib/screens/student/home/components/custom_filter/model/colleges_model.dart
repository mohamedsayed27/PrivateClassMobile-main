class CollegesModel {
  CollegesModel({
    required this.data,
    required this.message,
    required this.status,
  });

  List<Data> data;
  String message;
  bool status;

  factory CollegesModel.fromJson(Map<dynamic, dynamic> json) => CollegesModel(
        data: json["data"] != null
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
  });

  int id;
  String name;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id "],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id ": id,
        "name": name,
      };
}
