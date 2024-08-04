class productModel {
  String? sId;
  String? name;
  String? type;
  String? brand;
  double? price;
  String? description;
  int? iV;
  String? image;

  productModel({
    this.sId,
    this.name,
    this.type,
    this.brand,
    this.price,
    this.description,
    this.iV,
    this.image,
  });

  // Factory constructor for creating a productModel from JSON
  factory productModel.fromJson(Map<String, dynamic> json) {
    try {
      return productModel(
        sId: json['_id'] as String?,
        name: json['name'] as String?,
        type: json['type'] as String?,
        brand: json['brand'] as String?,
        price: (json['price'] as num?)?.toDouble(),
        description: json['description'] as String?,
        iV: json['__v'] as int?,
        image: json['image'] as String?,
      );
    } catch (e) {
      print('Error parsing productModel from JSON: $e');
      // Handle parsing error or return a default instance if needed
      return productModel();
    }
  }

  // Convert a productModel instance to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['type'] = this.type;
    data['brand'] = this.brand;
    data['price'] = this.price;
    data['description'] = this.description;
    data['__v'] = this.iV;
    data['image'] = this.image;
    return data;
  }
}
