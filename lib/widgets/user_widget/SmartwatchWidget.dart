import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../screen/modules/user/product_screen.dart';
import '../../view_model/auth_viewModel.dart';
import '../../view_model/home_vew_model.dart';
import '../ConatinerWidget.dart';

class Smartwatch extends StatefulWidget {
  const Smartwatch({super.key});

  @override
  State<Smartwatch> createState() => _SmartwatchState();
}

class _SmartwatchState extends State<Smartwatch> {
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

        if (viewModel.products == null || viewModel.products!.isEmpty) {
          return Center(child: Text('No products available'));
        }

        return GridView.builder(
          itemCount: viewModel.products!.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 1.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: .75,
          ),
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(10.0),
            child: Containerwidget(
              ontap: () async {
                final authViewModel =
                    Provider.of<AuthViewModel>(context, listen: false);
                final userId = await authViewModel.getUserId();

                if (userId == null || userId.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'User ID is not available. Please log in again.'),
                    ),
                  );
                  return; // Prevent navigation if userId is null
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductScreen(
                      img: viewModel.products![index].image,
                      txt1: viewModel.products![index].name,
                      txt2: viewModel.products![index].brand,
                      txt3: viewModel.products![index].price,
                      txt4: viewModel.products![index].description,
                      clr: Colors.transparent,
                      productId: viewModel.products![index].sId,
                    ),
                  ),
                );
              },
              clr1: Colors.transparent,
              img: viewModel.products![index].image,
              txt1: viewModel.products![index].name,
              txt2: viewModel.products![index].brand,
              txt3: viewModel.products![index].price,
              txt4: viewModel.products![index].description,
              clr: Colors.transparent,
            ),
          ),
        );
      },
    );
  }
}
