import 'package:flutter/cupertino.dart';
import 'package:watchapp/model/home_model.dart';
import 'package:watchapp/services/home_services.dart';

class HomeViewModel extends ChangeNotifier {
  bool loading = false;
  final _homeservices = HomeServices();
  List<productModel>? products;

  Future<List<productModel>?> fetchProducts(BuildContext context) async {
    try {
      loading = true;
      notifyListeners();
      products = await _homeservices.HomeProducts();
      loading = false;
      notifyListeners();
      return products;
    } catch (e) {
      loading = false;
      notifyListeners();
      rethrow;
    }
  }
}
