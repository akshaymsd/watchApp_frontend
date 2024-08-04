import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../screen/modules/user/product_screen.dart';
import '../../view_model/home_vew_model.dart';
import '../ConatinerWidget.dart';

class AppleProducts extends StatefulWidget {
  const AppleProducts({super.key});

  @override
  State<AppleProducts> createState() => _AppleProductsState();
}

class _AppleProductsState extends State<AppleProducts> {
  @override
  void initState() {
    super.initState();
    // Fetch products in initState or wherever appropriate
    Provider.of<HomeViewModel>(context, listen: false).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.loading) {
          return Center(child: CircularProgressIndicator());
        }

        if (viewModel.errorMessage != null) {
          return Center(child: Text('Error: ${viewModel.errorMessage}'));
        }

        // Filter products for Apple
        final appleProducts = viewModel.products
            ?.where((product) => product.brand == 'Apple')
            .toList();

        if (appleProducts == null || appleProducts.isEmpty) {
          return Center(child: Text('No Apple products available'));
        }

        return GridView.builder(
          itemCount: appleProducts.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 1.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: .75,
          ),
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(10.0),
            child: Containerwidget(
              ontap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductScreen(
                      img: appleProducts[index].image,
                      txt1: appleProducts[index].name,
                      txt2: appleProducts[index].brand,
                      txt3: appleProducts[index].price,
                      txt4: appleProducts[index].description,
                      clr: Colors.transparent,
                      productId: appleProducts[index].sId,
                    ),
                  ),
                );
              },
              clr1: Colors.transparent,
              img: appleProducts[index].image,
              txt1: appleProducts[index].name,
              txt2: appleProducts[index].brand,
              txt3: appleProducts[index].price,
              txt4: appleProducts[index].description,
              clr: Colors.transparent,
            ),
          ),
        );
      },
    );
  }
}
