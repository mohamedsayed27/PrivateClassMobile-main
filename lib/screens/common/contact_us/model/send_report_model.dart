class SendReportModel {
  Null? data;
  String? message;
  bool? status;

  SendReportModel({this.data, this.message, this.status});

  SendReportModel.fromJson(Map<dynamic, dynamic> json) {
    data = json['data'];
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}
