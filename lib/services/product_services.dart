import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:watchapp/model/home_model.dart';

import '../utils/constants.dart';

class HomeServices {
  Future<List<productModel>> HomeProducts() async {
    final Uri url = Uri.parse('$baseurl/api/products/viewProduct');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);

        if (responseBody == null || responseBody['data'] == null) {
          throw Exception('No products found');
        }

        List<dynamic> productsJson = responseBody['data'] as List<dynamic>;

        // Convert List<dynamic> to List<productModel>
        List<productModel> productsList =
            productsJson.map((json) => productModel.fromJson(json)).toList();

        print('Products fetched successfully');
        return productsList;
      } else {
        // Handle failure
        print('Failed to fetch products. Status code: ${response.statusCode}');
        throw Exception(
            'Failed to fetch products. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      print('Error during fetching products: $e');
      throw Exception('An error occurred during fetching products');
    }
  }

  Future<void> addProduct({
    required productModel product,
    required File image,
  }) async {
    final uri = Uri.parse('$baseurl/api/products/addProduct');

    final request = http.MultipartRequest('POST', uri)
      ..fields['name'] = product.name ?? ''
      ..fields['brand'] = product.type ?? ''
      ..fields['brand'] = product.brand ?? ''
      ..fields['price'] = product.price.toString()
      ..fields['description'] = product.description ?? ''
      ..files.add(
        http.MultipartFile(
          'image',
          image.readAsBytes().asStream(),
          await image.length(),
          filename: image.path.split('/').last,
        ),
      );

    try {
      final response = await request.send();

      if (response.statusCode == 201) {
        print('Product added successfully');
      } else {
        final responseString = await response.stream.bytesToString();
        throw Exception('Failed to add product: $responseString');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  Future<void> updateProduct({
    required String id,
    required String name,
    required String type,
    required String brand,
    required double price,
    required String description,
    File? image,
  }) async {
    final uri = Uri.parse('$baseurl/api/products/updateProduct/$id');
    final request = http.MultipartRequest('PUT', uri)
      ..fields['name'] = name
      ..fields['type'] = type
      ..fields['brand'] = brand
      ..fields['price'] = price.toString()
      ..fields['description'] = description;

    if (image != null) {
      request.files.add(
        http.MultipartFile(
          'image',
          image.readAsBytes().asStream(),
          image.lengthSync(),
          filename: path.basename(image.path),
        ),
      );
    }

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        print('Product updated successfully');
      } else {
        final responseBody = await response.stream.bytesToString();
        print('Failed to update product. Status code: ${response.statusCode}');
        print('Response body: $responseBody');
        throw Exception('Failed to update product');
      }
    } catch (e) {
      print('Error updating product: $e');
      throw Exception('An error occurred while updating the product');
    }
  }

  static Future<bool> deleteProduct(String productId) async {
    final url = Uri.parse(
        '$baseurl/api/products/deleteProduct/$productId'); // Adjust URL if necessary

    final response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Product deleted successfully
      return true;
    } else {
      // Handle error response
      print('Error deleting product: ${response.statusCode}');
      print('Response body: ${response.body}');
      return false;
    }
  }
}
