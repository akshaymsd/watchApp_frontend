import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watchapp/model/home_model.dart';

import '../screen/modules/user/product_screen.dart';
import '../view_model/auth_viewModel.dart';
import '../view_model/home_vew_model.dart';
import 'ConatinerWidget.dart';

class Smartwatch extends StatefulWidget {
  const Smartwatch({super.key});

  @override
  State<Smartwatch> createState() => _SmartwatchState();
}

class _SmartwatchState extends State<Smartwatch> {
  late Future<List<productModel>?> _futureProducts;

  @override
  void initState() {
    super.initState();
    _futureProducts = HomeViewModel()
        .fetchProducts(context); // Fetch products when widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<productModel>?>(
      future: _futureProducts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final products = snapshot.data!;
          if (products.isEmpty) {
            return Center(child: Text('No products available'));
          }
          return GridView.builder(
            itemCount: products.length,
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

                  try {
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

                    print('Retrieved User ID: $userId');

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Productscreen(
                          img: products[index].image,
                          txt1: products[index].name,
                          txt2: products[index].brand,
                          txt3: products[index].price?.toDouble(),
                          txt4: products[index].description,
                          clr: Colors.transparent,
                          productId: products[index].sId,
                          userId: userId!,
                        ),
                      ),
                    );
                  } catch (e) {
                    print('Error retrieving user ID: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Failed to retrieve User ID. Please try again.'),
                      ),
                    );
                  }
                },
                clr1: Colors.transparent,
                img: products[index].image,
                txt1: products[index].name,
                txt2: products[index].brand,
                txt3: products[index].price?.toDouble(),
                txt4: products[index].description,
                clr: Colors.transparent,
              ),
            ),
          );
        } else {
          return Center(child: Text('No products available'));
        }
      },
    );
  }
}
