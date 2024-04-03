class ContactUsModel {
  Data? data;
  String? message;
  bool? status;

  ContactUsModel({this.data, this.message, this.status});

  ContactUsModel.fromJson(Map<dynamic, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class Data {
  String? phone;
  String? email;
  String? twitterLink;
  String? address;
  String? lat;
  String? lng;
  String? tawk;

  Data(
      {this.phone,
        this.email,
        this.twitterLink,
        this.address,
        this.tawk,
        this.lat,
        this.lng});

  Data.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    email = json['email'];
    twitterLink = json['telegram_link'];
    address = json['address'];
    lat = json['lat'];
    tawk = json['tawk'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['telegram_link'] = this.twitterLink;
    data['address'] = this.address;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['tawk'] = this.tawk;
    return data;
  }
}
