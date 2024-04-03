class SavesModel {
  List<Data>? data;
  String? message;
  bool? status;

  SavesModel({this.data, this.message, this.status});

  SavesModel.fromJson(Map<dynamic, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add( Data.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
  }

}

class Data {
  int? id;
  String? photo;
  String? name;
  String? details;
  String? price;
  dynamic duration;
  bool? isFavorite;

  Data(
      {this.id,
        this.photo,
        this.name,
        this.details,
        this.price,
        this.duration,
        this.isFavorite});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    photo = json['photo'];
    name = json['name'];
    details = json['details'];
    price = json['price'];
    duration = json['duration'];
    isFavorite = json['is_favorite'];
  }

}
