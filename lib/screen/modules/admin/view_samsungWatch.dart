import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:watchapp/screen/modules/admin/smartwatch_edit.dart';
import 'package:watchapp/widgets/admin_widget/admin_productContainer_widget.dart';

import '../../../view_model/home_vew_model.dart';

class ViewSamsungWatch extends StatefulWidget {
  const ViewSamsungWatch({super.key});

  @override
  State<ViewSamsungWatch> createState() => _ViewSamsungWatchState();
}

class _ViewSamsungWatchState extends State<ViewSamsungWatch> {
  @override
  void initState() {
    super.initState();
    // Fetch products when the widget is first created
    Future.microtask(() =>
        Provider.of<HomeViewModel>(context, listen: false).fetchProducts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Samsung Watches",
          style: GoogleFonts.poppins(),
        ),
      ),
      body: Consumer<HomeViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.loading) {
            return Center(child: CircularProgressIndicator());
          }

          if (viewModel.errorMessage != null) {
            return Center(child: Text('Error: ${viewModel.errorMessage}'));
          }

          final samsungProducts = viewModel.products
                  ?.where((product) => product.brand == 'Samsung')
                  .toList() ??
              [];

          if (samsungProducts.isEmpty) {
            return Center(child: Text('No Samsung products available'));
          }

          return GridView.builder(
            itemCount: samsungProducts.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: .75,
            ),
            itemBuilder: (context, index) {
              final product = samsungProducts[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: AdminProductContainerwidget(
                  ontap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SmartWatchEdit(
                          productId: product.sId ?? '',
                          type: product.type ?? '',
                          name: product.name ?? '',
                          brand: product.brand ?? '',
                          price: product.price ?? 0.0,
                          description: product.description ?? '',
                          img: product.image ?? '',
                        ),
                      ),
                    );
                  },
                  clr1: Colors.transparent,
                  img: product.image ?? '',
                  txt1: product.name ?? '',
                  txt2: product.brand ?? '',
                  txt3: product.price,
                  txt4: product.description ?? '',
                  clr: Colors.transparent,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
