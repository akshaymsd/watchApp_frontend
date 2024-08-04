import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../screen/modules/user/product_screen.dart';
import '../../view_model/home_vew_model.dart';
import '../ConatinerWidget.dart';

class SamsungProducts extends StatefulWidget {
  const SamsungProducts({super.key});

  @override
  State<SamsungProducts> createState() => _SamsungProductsState();
}

class _SamsungProductsState extends State<SamsungProducts> {
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

        // Filter products for Samsung
        final samsungProducts = viewModel.products
            ?.where((product) => product.brand == 'Samsung')
            .toList();

        if (samsungProducts == null || samsungProducts.isEmpty) {
          return Center(child: Text('No Samsung products available'));
        }

        return GridView.builder(
          itemCount: samsungProducts.length,
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
                      img: samsungProducts[index].image,
                      txt1: samsungProducts[index].name,
                      txt2: samsungProducts[index].brand,
                      txt3: samsungProducts[index].price,
                      txt4: samsungProducts[index].description,
                      clr: Colors.transparent,
                      productId: samsungProducts[index].sId,
                    ),
                  ),
                );
              },
              clr1: Colors.transparent,
              img: samsungProducts[index].image,
              txt1: samsungProducts[index].name,
              txt2: samsungProducts[index].brand,
              txt3: samsungProducts[index].price,
              txt4: samsungProducts[index].description,
              clr: Colors.transparent,
            ),
          ),
        );
      },
    );
  }
}
