import 'dart:convert';

import 'package:http/http.dart' as http;
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
}
