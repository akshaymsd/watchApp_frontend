import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:watchapp/view_model/cart_view_model.dart';

import '../../../model/home_model.dart'; // Ensure the correct import
import '../../../view_model/auth_viewModel.dart';
import '../../../widgets/ColorWidget.dart';
import 'cart_screen.dart';

class ProductScreen extends StatefulWidget {
  final String? img;
  final String? txt1;
  final String? txt2;
  final double? txt3;
  final String? txt4;
  final Color? clr;
  final String? productId;
  final int? qty;

  ProductScreen({
    this.productId,
    super.key,
    this.img,
    this.txt1,
    this.txt2,
    this.txt3,
    this.clr,
    this.txt4,
    this.qty,
  });

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool loading = false;
  String? userId;

  @override
  void initState() {
    super.initState();
    _initializeUserId();
  }

  Future<void> _initializeUserId() async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final fetchedUserId = await authViewModel.getUserId();

    if (fetchedUserId != null && fetchedUserId.isNotEmpty) {
      setState(() {
        userId = fetchedUserId;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User ID is not available. Please log in again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartViewModel>(
      builder: (context, cartViewModel, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              "Product Details",
              style: GoogleFonts.poppins(),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  // Handle bookmark action
                },
                icon: Icon(Icons.bookmark_border),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Center(
                  child: Container(
                    alignment: Alignment.center,
                    height: 200,
                    decoration: BoxDecoration(
                      color: widget.clr ?? Colors.grey,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    width: 400,
                    child: widget.img != null
                        ? Image.network(
                            widget.img!,
                            errorBuilder: (context, error, stackTrace) =>
                                Text("No Image"),
                          )
                        : Text("No Image"),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 50.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.txt1 ?? "No Name",
                        style: GoogleFonts.poppins(fontSize: 25),
                      ),
                      Text(
                        widget.txt2 ?? "No Brand",
                        style: GoogleFonts.poppins(fontSize: 12),
                      ),
                      Divider(thickness: 5, endIndent: 50),
                      Text(
                        "Description",
                        style: GoogleFonts.poppins(fontSize: 18),
                      ),
                      Text(widget.txt4 ?? "No Description"),
                      Divider(endIndent: 50),
                      Text(
                        "Available Colors",
                        style: GoogleFonts.poppins(fontSize: 18),
                      ),
                      Container(
                        height: 50,
                        child: ListView.builder(
                          itemCount: Colors.primaries.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: colorWidget(
                                clr: Colors.primaries[
                                    index]), // Ensure colorWidget is defined
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            height: 40,
                            width: 150,
                            child: Center(
                              child: Text(
                                "\$${widget.txt3?.toStringAsFixed(2) ?? '0.00'}",
                                style: GoogleFonts.poppins(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          SizedBox(width: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(16),
                              backgroundColor: Colors.blueAccent,
                            ),
                            onPressed: cartViewModel.loading
                                ? null
                                : () async {
                                    if (userId == null ||
                                        widget.productId == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'User ID or Product ID is null'),
                                        ),
                                      );
                                      return;
                                    }

                                    setState(() {
                                      loading = true;
                                    });

                                    try {
                                      final response =
                                          await cartViewModel.addProductToCart(
                                        userid: userId!,
                                        product: productModel(
                                          sId: widget.productId!,
                                          image: widget.img,
                                          name: widget.txt1,
                                          brand: widget.txt2,
                                          price: widget.txt3,
                                          description: widget.txt4,
                                        ),
                                        context: context,
                                      );

                                      if (!response['Success']) {
                                        throw Exception(
                                            'Failed to add product to cart: ${response['Message']}');
                                      }

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Row(
                                            children: [
                                              SizedBox(width: 10),
                                              Icon(
                                                  CupertinoIcons
                                                      .checkmark_alt_circle_fill,
                                                  color: Colors.white,
                                                  size: 30),
                                              SizedBox(width: 10),
                                              Text("Item Added to cart",
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.white,
                                                      fontSize: 12)),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          CartWidget(
                                                              userId: userId!),
                                                    ),
                                                  );
                                                },
                                                child: Text("Check Order",
                                                    style:
                                                        GoogleFonts.poppins()),
                                              ),
                                            ],
                                          ),
                                          shape: StadiumBorder(),
                                          elevation: 3,
                                          width: 300,
                                          padding:
                                              EdgeInsets.symmetric(vertical: 3),
                                          backgroundColor: Colors.black,
                                          behavior: SnackBarBehavior.floating,
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    } catch (e) {
                                      print("An error occurred: $e");
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Failed to add item to cart: ${e.toString()}'),
                                        ),
                                      );
                                    } finally {
                                      setState(() {
                                        loading = false;
                                      });
                                    }
                                  },
                            child: Row(
                              children: [
                                Text("Add to Cart",
                                    style: GoogleFonts.poppins(
                                        color: Colors.white)),
                                SizedBox(width: 10),
                                Icon(Icons.shopping_bag, color: Colors.white),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Divider(endIndent: 50),
                      Text(
                        "More Product",
                        style: GoogleFonts.poppins(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
