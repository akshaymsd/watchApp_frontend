import 'home_model.dart';

class CartModel {
  String? sId;
  productModel? productId;
  String? userId;
  String? status;
  int? quantity;
  int? iV;

  CartModel(
      {this.sId,
      this.productId,
      this.userId,
      this.status,
      this.quantity,
      this.iV});

  CartModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    productId = json['productId'] != null
        ? productModel.fromJson(json['productId'])
        : null;
    userId = json['userId'];
    status = json['status'];
    quantity = json['quantity'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (productId != null) {
      data['productId'] = productId!.toJson();
    }
    data['userId'] = userId;
    data['status'] = status;
    data['quantity'] = quantity;
    data['__v'] = iV;
    return data;
  }
}
