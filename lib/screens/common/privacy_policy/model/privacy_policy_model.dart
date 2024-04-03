class PrivacyPolicyModel {
  Data? data;
  String? message;
  bool? status;

  PrivacyPolicyModel({this.data, this.message, this.status});

  PrivacyPolicyModel.fromJson(Map<dynamic, dynamic> json) {
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
  String? privacyPolicy;

  Data({this.privacyPolicy});

  Data.fromJson(Map<String, dynamic> json) {
    privacyPolicy = json['privacy_policy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['privacy_policy'] = this.privacyPolicy;
    return data;
  }
}
