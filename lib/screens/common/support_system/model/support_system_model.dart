class SupportSystemModel {
  Data? data;
  String? message;
  bool? status;

  SupportSystemModel({this.data, this.message, this.status});

  SupportSystemModel.fromJson(Map<dynamic, dynamic> json) {
    data = json['data'] != null ?  Data.fromJson(json['data']) : null;
    message = json['message'];
    status = json['status'];
  }

}

class Data {
  String? customerService;
  String? tawk;

  Data({this.customerService,this.tawk});

  Data.fromJson(Map<String, dynamic> json) {
    customerService = json['customer_service'];
    tawk = json['tawk'];
  }

}
