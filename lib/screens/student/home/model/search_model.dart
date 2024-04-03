class SearchModel {
  List<Data>? data;
  String? message;
  bool? status;

  SearchModel({this.data, this.message, this.status});

  SearchModel.fromJson(Map<dynamic, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
  }

}

class Data {
  int? id;
  String? name;
  String? price;
  String? photo;
  String? details;
  List<Categories>? categories;
  Teacher? teacher;
  int? numSubscribe;
  bool? isFavorite;
  int? numVideos;
  dynamic numHours;
  bool? isSubscribed;
  bool? isInstallment;
  bool? canUnsubscribe;
  String? paymentKey;

  Data(
      {this.id,
        this.name,
        this.price,
        this.photo,
        this.details,
        this.categories,
        this.teacher,
        this.numSubscribe,
        this.isFavorite,
        this.numVideos,
        this.numHours,
        this.isSubscribed,
        this.isInstallment,
        this.canUnsubscribe,
        this.paymentKey});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    photo = json['photo'];
    details = json['details'];
    isInstallment = json['isInstallment'];
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add( Categories.fromJson(v));
      });
    }
    teacher = json['teacher'] != null ?  Teacher.fromJson(json['teacher']) : null;
    numSubscribe = json['num_subscribe'];
    isFavorite = json['is_favorite'];
    numVideos = json['num_videos'];
    numHours = json['num_hours'];
    isSubscribed = json['isSubscribed'];
    canUnsubscribe = json['canUnsubscribe'];
    isInstallment = json['isInstallment'];
    paymentKey = json['payment_key'];
  }

}

class Categories {
  int? id;
  String? name;
  String? timeVideos;
  List<Videos>? videos;

  Categories({this.id, this.name, this.timeVideos, this.videos});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    timeVideos = json['time_videos'];
    if (json['videos'] != null) {
      videos = <Videos>[];
      json['videos'].forEach((v) {
        videos!.add(new Videos.fromJson(v));
      });
    }
  }

}

class Videos {
  int? id;
  String? name;
  String? video;
  String? timeVideo;
  bool? free;

  Videos({this.id, this.name, this.video, this.timeVideo, this.free});

  Videos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    video = json['video'];
    timeVideo = json['time_video'];
    free = json['free'];
  }

}

class Teacher {
  int? id;
  String? name;
  String? photo;
  String? email;
  String? pio;
  String? jobTitle;

  Teacher(
      {this.id, this.name, this.photo, this.email, this.pio, this.jobTitle});

  Teacher.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    photo = json['photo'];
    email = json['email'];
    pio = json['pio'];
    jobTitle = json['job_title'];
  }

}
