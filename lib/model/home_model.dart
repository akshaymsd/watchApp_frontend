class productModel {
  String? sId;
  String? name;
  String? brand;
  double? price; // Changed to double to match your usage
  String? description;
  int? iV;
  String? image;

  productModel({
    this.sId,
    this.name,
    this.brand,
    this.price,
    this.description,
    this.iV,
    this.image,
  });

  productModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    brand = json['brand'];
    price = json['price'].toDouble(); // Ensure this is a double
    description = json['description'];
    iV = json['__v'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['brand'] = this.brand;
    data['price'] = this.price;
    data['description'] = this.description;
    data['__v'] = this.iV;
    data['image'] = this.image;
    return data;
  }
}
