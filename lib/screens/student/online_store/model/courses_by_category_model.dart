class CoursesByCategoryModel {
  Dataa? data;
  String? message;
  bool? status;

  CoursesByCategoryModel({this.data, this.message, this.status});

  CoursesByCategoryModel.fromJson(Map<dynamic, dynamic> json) {
    data = json['data'] != null ? Dataa.fromJson(json['data']) : null;
    message = json['message'];
    status = json['status'];
  }
}

class Dataa {
  List<CourseData>? data;
  Links? links;
  Meta? meta;

  Dataa({this.data, this.links, this.meta});

  Dataa.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <CourseData>[];
      json['data'].forEach((v) {
        data!.add(new CourseData.fromJson(v));
      });
    }
    links = json['links'] != null ? new Links.fromJson(json['links']) : null;
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.links != null) {
      data['links'] = this.links!.toJson();
    }
    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
    }
    return data;
  }
}

class CourseData {
  int? id;
  String? photo;
  String? name;
  String? details;
  String? price;
  dynamic duration;
  bool? isFavorite;
  bool? isInstallment;

  CourseData(
      {this.id,
      this.photo,
      this.name,
      this.details,
      this.price,
      this.duration,
      this.isInstallment,
      this.isFavorite});

  CourseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    photo = json['photo'];
    name = json['name'];
    details = json['details'];
    price = json['price'];
    duration = json['duration'];
    isFavorite = json['is_favorite'];
    isInstallment = json['isInstallment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['photo'] = this.photo;
    data['name'] = this.name;
    data['details'] = this.details;
    data['price'] = this.price;
    data['duration'] = this.duration;
    data['is_favorite'] = this.isFavorite;
    data['isInstallment'] = this.isInstallment;
    return data;
  }
}

class Links {
  dynamic prev;
  String? next;

  Links({this.prev, this.next});

  Links.fromJson(Map<String, dynamic> json) {
    prev = json['prev'];
    next = json['next'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['prev'] = this.prev;
    data['next'] = this.next;
    return data;
  }
}

class Meta {
  int? currentPage;
  int? from;
  int? to;
  int? lastPage;
  int? perPage;
  int? count;
  int? total;

  Meta(
      {this.currentPage,
      this.from,
      this.to,
      this.lastPage,
      this.perPage,
      this.count,
      this.total});

  Meta.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    from = json['from'];
    to = json['to'];
    lastPage = json['last_page'];
    perPage = json['per_page'];
    count = json['count'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    data['from'] = this.from;
    data['to'] = this.to;
    data['last_page'] = this.lastPage;
    data['per_page'] = this.perPage;
    data['count'] = this.count;
    data['total'] = this.total;
    return data;
  }
}
