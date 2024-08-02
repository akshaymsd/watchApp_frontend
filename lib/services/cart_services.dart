import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../model/cart_model.dart';
import '../model/home_model.dart';
import '../utils/constants.dart';
import '../view_model/cart_view_model.dart';

class CartService {
  // Add product to cart
// Updated method to add product to cart with additional null safety checks
  Future<void> addProductToCart({
    required String userid,
    required productModel product,
  }) async {
    final Uri url = Uri.parse('$baseurl/api/cart/addItem');

    final Map<String, dynamic> cartData = {
      'userId': userid, // Ensure 'userId' is not empty
      'productId': product.sId,
      'quantity': 1,
    };

    try {
      if (userid.isEmpty) {
        throw Exception('User ID is empty');
      }

      if (product.sId == null) {
        throw Exception('Product ID is null');
      }

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(cartData),
      );

      if (response.statusCode == 201) {
        print('Product added to cart successfully');
      } else {
        print('Response body: ${response.body}');
        throw Exception('Failed to add product to cart: ${response.body}');
      }
    } catch (e) {
      print('An error occurred: $e');
      throw Exception('An error occurred: $e');
    }
  }

// Updated method to handle UI updates and error handling
  Future<void> addProductToCartWithUI({
    required String userid,
    required productModel product,
    required BuildContext context,
    required CartService
        cartService, // Ensure CartService is provided correctly
  }) async {
    try {
      // Ensure cartService is not null
      if (cartService == null) {
        throw Exception('CartService is null');
      }

      // Ensure context is not null and provider is available
      final cartViewModel = Provider.of<CartViewModel>(context, listen: false);
      if (cartViewModel == null) {
        throw Exception('CartViewModel is null');
      }

      cartViewModel.loading = true;
      cartViewModel.notifyListeners();

      // Check if product.sId is null
      if (product.sId == null) {
        throw Exception('Product ID is null');
      }

      // Add product to cart
      await cartService.addProductToCart(userid: userid, product: product);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Product added to cart successfully"),
        ),
      );
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to add product to cart: $e"),
        ),
      );
    } finally {
      // Hide loading indicator
      final cartViewModel = Provider.of<CartViewModel>(context, listen: false);
      if (cartViewModel != null) {
        cartViewModel.loading = false;
        cartViewModel.notifyListeners();
      } else {
        print('CartViewModel is null');
      }
    }
  }

  // Fetch cart contents for a user
  Future<List<CartModel>> getCartContents(String userId) async {
    final Uri url = Uri.parse('$baseurl/api/cart/viewCart/$userId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print('Response data: $data'); // Log response data for debugging

        if (data.containsKey('data') && data['data'] is List) {
          return (data['data'] as List)
              .map((item) => CartModel.fromJson(item as Map<String, dynamic>))
              .toList();
        } else {
          throw Exception('The key "data" is missing or not a list');
        }
      } else {
        print(
            'Failed to load cart contents: ${response.statusCode}, ${response.body}');
        throw Exception('Failed to load cart contents: ${response.body}');
      }
    } catch (e) {
      print('An error occurred: $e');
      throw Exception('An error occurred: $e');
    }
  }

  // Remove product from cart
  Future<void> removeProductFromCart({
    required String userid,
    required String productId,
  }) async {
    final Uri url = Uri.parse('$baseurl/api/cart/removeItem');
    final Map<String, dynamic> cartData = {
      'userid': userid,
      'productid': productId,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(cartData),
      );

      if (response.statusCode == 200) {
        print('Product removed from cart successfully');
      } else {
        throw Exception('Failed to remove product from cart: ${response.body}');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }
}
