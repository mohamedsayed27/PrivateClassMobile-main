class CartModel {
  Data? data;
  String? message;
  bool? status;

  CartModel({this.data, this.message, this.status});

  CartModel.fromJson(Map<dynamic, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
    status = json['status'];
  }

}

class Data {
  int? id;
  String? totalSub;
  String? discount;
  int? total;
  int? numOfPurchases;
  List<Items>? items;
  String? paymentKey;
  bool? isInstallment;
  bool? isBankPayment;

  Data(
      {this.id,
        this.totalSub,
        this.discount,
        this.total,
        this.numOfPurchases,
        this.isInstallment,
        this.isBankPayment,
        this.items,
        this.paymentKey});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    totalSub = json['total_sub'];
    discount = json['discount'];
    total = json['total'];
    numOfPurchases = json['num_of_purchases'];
    isInstallment = json['isInstallment'];
    isBankPayment = json['isBankPayment'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
    paymentKey = json['payment_key'];
  }

}

class Items {
  int? id;
  int? cartId;
  String? name;
  String? photo;
  String? price;
  String? details;
  bool? isFavorite;

  Items(
      {this.id,
        this.cartId,
        this.name,
        this.photo,
        this.price,
        this.details,
        this.isFavorite});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cartId = json['cart_id'];
    name = json['name'];
    photo = json['photo'];
    price = json['price'];
    details = json['details'];
    isFavorite = json['is_favorite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cart_id'] = this.cartId;
    data['name'] = this.name;
    data['photo'] = this.photo;
    data['price'] = this.price;
    data['details'] = this.details;
    data['is_favorite'] = this.isFavorite;
    return data;
  }
}
