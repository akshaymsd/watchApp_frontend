import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:watchapp/utils/constants.dart';

import '../model/cart_model.dart';
import '../model/home_model.dart';
import '../services/cart_services.dart';

class CartViewModel extends ChangeNotifier {
  final CartService cartService;

  CartViewModel({required this.cartService});
  bool loading = false;
  List<CartModel> cartItems = [];

  final _cartService = CartService();

  // Add product to cart
  Future<Map<String, dynamic>> addProductToCart({
    required String userid,
    required productModel product,
    required BuildContext context,
  }) async {
    final Uri url = Uri.parse('$baseurl/api/cart/addItem');

    final Map<String, dynamic> cartData = {
      'productId':
          product.sId, // Ensure this matches the server's expected field
      'quantity': 1, // Adjust as needed
      'userId': userid, // Ensure this matches the server's expected field
    };

    try {
      print(
          'Request Data: ${jsonEncode(cartData)}'); // Print the request payload

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(cartData),
      );

      print(
          'Response Status Code: ${response.statusCode}'); // Print the response status code
      print('Response Body: ${response.body}'); // Print the response body

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'Success': false,
          'Message': 'Failed with status code ${response.statusCode}'
        };
      }
    } catch (e) {
      print('Error adding product to cart: $e');
      return {'Success': false, 'Message': e.toString()};
    }
  }

  // Fetch cart contents for a user
  Future<void> fetchCartContents(String userid, BuildContext context) async {
    if (userid.isEmpty) {
      throw Exception('User ID is empty');
    }

    loading = true;
    notifyListeners();

    try {
      cartItems = await _cartService.getCartContents(userid);
      notifyListeners();
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to fetch cart contents: $e"),
        ),
      );
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // Remove product from cart
  Future<void> removeProductFromCart({
    required String userid,
    required String productId,
    required BuildContext context,
  }) async {
    if (productId.isEmpty) {
      throw Exception('Product ID is empty');
    }

    try {
      loading = true;
      notifyListeners();

      await _cartService.removeProductFromCart(
          userid: userid, productId: productId);
      cartItems.removeWhere((item) => item.productId?.sId == productId);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Product removed from cart successfully"),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to remove product from cart: $e"),
        ),
      );
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
