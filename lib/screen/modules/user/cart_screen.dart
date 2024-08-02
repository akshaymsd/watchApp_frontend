import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../view_model/cart_view_model.dart';

class CartWidget extends StatefulWidget {
  final String? userId;

  CartWidget({Key? key, required this.userId}) : super(key: key);

  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      final userId = widget.userId;
      if (userId != null) {
        Provider.of<CartViewModel>(context, listen: false)
            .fetchCartContents(userId, context);
      } else {
        print('User ID is null');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartViewModel>(
      builder: (context, cartViewModel, child) {
        double getTotalPrice() {
          double total = 0.0;
          for (var item in cartViewModel.cartItems) {
            double price = item.productId?.price?.toDouble() ?? 0.0;
            int qty = item.quantity ?? 0;
            total += price * qty;
          }
          return total;
        }

        int getTotalItem() {
          int totalItems = 0;
          for (var item in cartViewModel.cartItems) {
            totalItems += (item.quantity ?? 0);
          }
          return totalItems;
        }

        void increment(int index) {
          final item = cartViewModel.cartItems[index];
          if (item.quantity != null) {
            item.quantity = item.quantity! + 1;
            cartViewModel.notifyListeners();
          }
        }

        void decrement(int index) {
          final item = cartViewModel.cartItems[index];
          if (item.quantity != null && item.quantity! > 1) {
            item.quantity = item.quantity! - 1;
            cartViewModel.notifyListeners();
          }
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            title: Text(
              "My Cart",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
              ),
            ),
            elevation: .5,
          ),
          backgroundColor: Color(0xFFF8F9FA),
          body: cartViewModel.loading
              ? Center(child: CircularProgressIndicator())
              : cartViewModel.cartItems.isEmpty
                  ? Center(
                      child: Text(
                        'Your cart is empty.',
                        style: GoogleFonts.poppins(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    )
                  : CustomScrollView(
                      slivers: [
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              var item = cartViewModel.cartItems[index];
                              double price =
                                  item.productId?.price?.toDouble() ?? 0.0;
                              int qty = item.quantity ?? 0;
                              return Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 1,
                                            blurRadius: 7,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 85,
                                              width: 85,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: item.productId?.image !=
                                                      null
                                                  ? Image.network(
                                                      item.productId!.image!,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Center(
                                                      child: Text("No Image")),
                                            ),
                                            SizedBox(width: 30),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(height: 10),
                                                Text(
                                                  item.productId?.name ??
                                                      'No Name',
                                                  style: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 16),
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                  "\$${price.toStringAsFixed(2)}",
                                                  style: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 14),
                                                ),
                                                SizedBox(height: 10),
                                                Row(
                                                  children: [
                                                    IconButton(
                                                      onPressed: () {
                                                        decrement(index);
                                                      },
                                                      icon: Icon(Icons.remove),
                                                      color: Colors.blue,
                                                    ),
                                                    SizedBox(width: 10),
                                                    Text(
                                                      "$qty",
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                    ),
                                                    SizedBox(width: 10),
                                                    IconButton(
                                                      onPressed: () {
                                                        increment(index);
                                                      },
                                                      icon: Icon(Icons.add),
                                                      color: Colors.blue,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Spacer(),
                                            IconButton(
                                              onPressed: () {
                                                cartViewModel.cartItems
                                                    .removeAt(index);
                                                cartViewModel.notifyListeners();
                                              },
                                              icon: Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                                size: 20,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            childCount: cartViewModel.cartItems.length,
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 20),
                            padding: EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total",
                                  style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  "\$${getTotalPrice().toStringAsFixed(2)}",
                                  style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 20),
                            padding: EdgeInsets.all(20),
                            child: ElevatedButton(
                              onPressed: () {
                                // Handle checkout process
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(16),
                                backgroundColor: Colors.blueAccent,
                              ),
                              child: Center(
                                child: Text(
                                  "Checkout (${getTotalItem()} items)",
                                  style: GoogleFonts.poppins(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
        );
      },
    );
  }
}
