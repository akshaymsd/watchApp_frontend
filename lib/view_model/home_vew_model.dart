import 'dart:convert';
import 'dart:io'; // Ensure this import is used correctly

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:watchapp/model/home_model.dart';

import '../services/product_services.dart';
import '../utils/constants.dart';

class HomeViewModel extends ChangeNotifier {
  final HomeServices _homeServices = HomeServices();

  bool _loading = false;
  bool _updateSuccess = false;
  String? _errorMessage;
  List<productModel>? _products;
  productModel? _selectedProduct;

  bool get loading => _loading;
  String? get errorMessage => _errorMessage;
  bool get updateSuccess => _updateSuccess;
  List<productModel>? get products => _products;
  productModel? get selectedProduct => _selectedProduct;

  Future<void> fetchProducts() async {
    _loading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final uri = Uri.parse(
          '$baseurl/api/products/viewProduct'); // Adjust URL as needed
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('data') && data['data'] is List) {
          List<dynamic> productList = data['data'];
          _products =
              productList.map((json) => productModel.fromJson(json)).toList();
        } else {
          throw Exception('Expected a list of products in the "data" key');
        }
      } else {
        throw Exception(
            'Failed to load products. Status code: ${response.statusCode}');
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> fetchProductById(String id) async {
    _loading = true; // Set loading to true when starting the fetch
    _errorMessage = null;
    notifyListeners();

    try {
      final uri = Uri.parse(
          '$baseurl/api/products/viewProduct/$id'); // Adjust URL as needed
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is Map<String, dynamic>) {
          _selectedProduct = productModel.fromJson(data);
        } else {
          throw Exception('Expected a single product object');
        }
      } else {
        throw Exception(
            'Failed to load product. Status code: ${response.statusCode}');
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _loading = false; // Set loading to false after fetch completes
      notifyListeners();
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
    BuildContext? context, // Accept context here
  }) async {
    _loading = true;
    _errorMessage = null;
    _updateSuccess = false;
    notifyListeners();

    try {
      await _homeServices.updateProduct(
        id: id,
        name: name,
        type: type,
        brand: brand,
        price: price,
        description: description,
        image: image,
      );
      _updateSuccess = true;
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product updated successfully.')),
        );
      }
    } catch (e) {
      _errorMessage = e.toString();
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update product: ${e.toString()}')),
        );
      }
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> addProduct({
    required String name,
    required String type,
    required String brand,
    required double price,
    required String description,
    required File image,
  }) async {
    _loading = true;
    _errorMessage = null;
    _updateSuccess = false;
    notifyListeners();

    final uri = Uri.parse('$baseurl/api/products/addProduct');
    final request = http.MultipartRequest('POST', uri)
      ..fields['name'] = name
      ..fields['type'] = type
      ..fields['brand'] = brand
      ..fields['price'] = price.toString()
      ..fields['description'] = description
      ..files.add(
        http.MultipartFile(
          'image',
          image.readAsBytes().asStream(),
          image.lengthSync(),
          filename: path.basename(image.path),
        ),
      );

    try {
      final response = await request.send();
      if (response.statusCode == 201) {
        _updateSuccess = true;
        print('Product added successfully');
      } else {
        final responseBody = await response.stream.bytesToString();
        print('Failed to add product. Status code: ${response.statusCode}');
        print('Response body: $responseBody');
        throw Exception('Failed to add product');
      }
    } catch (e) {
      _errorMessage = e.toString();
      print('Error adding product: $e');
      throw Exception('An error occurred while adding the product');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteProduct(String productId, BuildContext context) async {
    try {
      final success = await HomeServices.deleteProduct(productId);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product deleted successfully.')),
        );
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete product.')),
        );
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete product: ${e.toString()}')),
      );
      return false;
    }
  }
}
