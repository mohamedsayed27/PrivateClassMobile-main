class ReturnPolicyModel {
  Data? data;
  String? message;
  bool? status;

  ReturnPolicyModel({this.data, this.message, this.status});

  ReturnPolicyModel.fromJson(Map<dynamic, dynamic> json) {
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
  String? returnPolicy;

  Data({this.returnPolicy});

  Data.fromJson(Map<String, dynamic> json) {
    returnPolicy = json['returnPolicy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['returnPolicy'] = this.returnPolicy;
    return data;
  }
}
