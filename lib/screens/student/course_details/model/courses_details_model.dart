class CoursesDetailsModel {
  Data? data;
  String? message;
  bool? status;

  CoursesDetailsModel({this.data, this.message, this.status});

  CoursesDetailsModel.fromJson(Map<dynamic, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
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
  String? paymentKey;
  List<Categories>? categories;
  List<Attachments>? attachments;
  Teacher? teacher;
  int? numSubscribe;
  bool? isFavorite;
  bool? isInstallment;
  bool? isBankPayment;
  bool? isSubscribed;
  bool? canUnsubscribe;
  int? numVideos;
  dynamic numHours;

  Data(
      {this.id,
      this.name,
      this.price,
      this.photo,
      this.details,
      this.isInstallment,
      this.isBankPayment,
      this.categories,
      this.attachments,
      this.canUnsubscribe,
      this.teacher,
      this.numSubscribe,
      this.paymentKey,
      this.isFavorite,
      this.isSubscribed,
      this.numVideos,
      this.numHours});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    isInstallment = json['isInstallment'];
    isBankPayment = json['isBankPayment'];
    photo = json['photo'];
    paymentKey = json['payment_key'];
    details = json['details'];
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(Categories.fromJson(v));
      });
    }
    if (json['attachments'] != null) {
      attachments = <Attachments>[];
      json['attachments'].forEach((v) {
        attachments!.add(Attachments.fromJson(v));
      });
    }
    teacher = json['teacher'] != null ? Teacher.fromJson(json['teacher']) : null;
    numSubscribe = json['num_subscribe'];
    isFavorite = json['is_favorite'];
    isSubscribed = json['isSubscribed'];
    canUnsubscribe = json['canUnsubscribe'];
    numVideos = json['num_videos'];
    numHours = json['num_hours'];
  }
}

class Categories {
  int? id;
  String? name;
  dynamic timeVideos;
  List<Videos>? videos;

  Categories({this.id, this.name, this.timeVideos, this.videos});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    timeVideos = json['time_videos'];
    if (json['videos'] != null) {
      videos = <Videos>[];
      json['videos'].forEach((v) {
        videos!.add(Videos.fromJson(v));
      });
    }
  }
}

class Attachments {

  String? name;
  String? file;
  String? type;


  Attachments({this.name, this.file, this.type});

  Attachments.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    file = json['file'];
    type = json['type'];
  }
}

class Videos {
  int? id;
  int? vedIndx;
  String? name;
  String? video;
  String? timeVideo;
  bool? free;

  Videos({this.id, this.name, this.video, this.timeVideo, this.free});

  Videos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vedIndx = json['vedIndx'];
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

  Teacher({this.id, this.name,this.email,this.photo, this.pio, this.jobTitle});

  Teacher.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    photo = json['photo'];
    email = json['email'];
    pio = json['pio'];
    jobTitle = json['job_title'];
  }
}
