import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/cart_model.dart';
import '../model/home_model.dart';
import '../services/cart_services.dart';
import '../utils/constants.dart';

class CartViewModel extends ChangeNotifier {
  final CartService cartService;
  CartViewModel({required this.cartService});

  bool loading = false;
  List<CartModel> cartItems = [];

  // Add product to cart
  Future<Map<String, dynamic>> addProductToCart({
    required String userid,
    required productModel product,
    required BuildContext context,
  }) async {
    final Uri url = Uri.parse('$baseurl/api/cart/addItem');

    final Map<String, dynamic> cartData = {
      'productId': product.sId,
      'quantity': 1,
      'userId': userid,
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

      if (response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        print('Item added to cart successfully: $responseBody');
        // Optionally update cartItems or other state here
        notifyListeners();
        return responseBody; // Return the response body
      } else {
        // Parse the response body to get the message
        final responseBody = jsonDecode(response.body);
        final message = responseBody['Message'] ?? 'An error occurred';
        throw Exception(
            'Failed to add item with status code ${response.statusCode}: $message');
      }
    } catch (e) {
      print('Error adding product to cart: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add product to cart: ${e.toString()}'),
        ),
      );
      return {}; // Return an empty map on error
    }
  }

  // Fetch cart contents for a user
  Future<void> fetchCartContents(String userId, BuildContext context) async {
    if (userId.isEmpty) {
      throw Exception('User ID is empty');
    }

    loading = true;
    notifyListeners();

    try {
      cartItems = await cartService.getCartContents(userId);
      notifyListeners();
    } catch (e) {
      print('Error fetching cart contents: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to fetch cart contents: $e'),
        ),
      );
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // Remove product from cart
  Future<void> deleteCartItem(String itemId, BuildContext context) async {
    try {
      loading = true;
      notifyListeners();

      bool isSuccess = await cartService.deleteItem(itemId);

      if (isSuccess) {
        // Remove the item from the local list
        cartItems.removeWhere((item) => item.sId == itemId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Item deleted successfully.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete item.')),
        );
      }
    } catch (e) {
      print('Delete error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> updateCartItemQuantity(
      String itemId, int newQuantity, BuildContext context) async {
    loading = true;
    notifyListeners();
    try {
      await CartService.updateCartItemQuantity(itemId, newQuantity);

      final itemIndex = cartItems.indexWhere((item) => item.sId == itemId);
      if (itemIndex != -1) {
        cartItems[itemIndex].quantity = newQuantity;
        notifyListeners();
      } else {
        print('Item not found in cart');
      }
    } catch (error) {
      print('Error updating cart item quantity: $error');
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
