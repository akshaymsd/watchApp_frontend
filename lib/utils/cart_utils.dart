List<dynamic> cartlist = [];
void cart(String? img, String? name, String? brand, double? price, int? qty) {
  final cartItems = {
    "img": img ?? "",
    "Name": name ?? "",
    "brand": brand ?? "",
    "Price": price ?? 0.0,
    "Quantity": qty ?? 1
  };
  cartlist.add(cartItems);
}

void Fcart(
  String? img,
  String? name,
  String? brand,
  double? price,
) {
  final favItems = {"img": img, "name": name, "brand": brand, "price": price};
  // Add favItems to a favorites list if applicable
}
