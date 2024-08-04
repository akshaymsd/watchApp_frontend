import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:watchapp/screen/modules/admin/smartwatch_edit.dart';
import 'package:watchapp/widgets/admin_widget/admin_productContainer_widget.dart';

import '../../../view_model/home_vew_model.dart';

class ViewSmartWatch extends StatefulWidget {
  const ViewSmartWatch({super.key});

  @override
  State<ViewSmartWatch> createState() => _ViewSmartWatchState();
}

class _ViewSmartWatchState extends State<ViewSmartWatch> {
  @override
  void initState() {
    super.initState();
    // Fetch products in initState or wherever appropriate
    Provider.of<HomeViewModel>(context, listen: false).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Smart Watch",
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
            itemBuilder: (context, index) {
              final product = viewModel.products![index];
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: AdminProductContainerwidget(
                  ontap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SmartWatchEdit(
                          productId: product.sId ?? '',
                          type: product.type ?? '',
                          name: product.name ?? "",
                          brand: product.brand ?? "",
                          price: product.price ?? 0.0, // Handle null price
                          description: product.description ?? "",
                          img: product.image ?? "",
                        ),
                      ),
                    );
                  },
                  clr1: Colors.transparent,
                  img: product.image ?? '', // Ensure this is a valid string
                  txt1: product.name ?? '',
                  txt2: product.brand ?? '',
                  txt3: product.price, // Pass the price as a double
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
