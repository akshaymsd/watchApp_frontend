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

        void increment(int index) async {
          final item = cartViewModel.cartItems[index];
          if (item.quantity != null) {
            int newQuantity = item.quantity! + 1;
            print('Incrementing item ${item.sId} to $newQuantity');
            await cartViewModel.updateCartItemQuantity(
                item.sId!, newQuantity, context);
          }
        }

        void decrement(int index) async {
          final item = cartViewModel.cartItems[index];
          if (item.quantity != null && item.quantity! > 1) {
            int newQuantity = item.quantity! - 1;
            print('Decrementing item ${item.sId} to $newQuantity');
            await cartViewModel.updateCartItemQuantity(
                item.sId!, newQuantity, context);
          }
        }

        void deleteItem(String itemId) async {
          await cartViewModel.deleteCartItem(itemId, context);
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
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: cartViewModel.cartItems.length,
                            itemBuilder: (context, index) {
                              var item = cartViewModel.cartItems[index];
                              double price =
                                  item.productId?.price?.toDouble() ?? 0.0;
                              int qty = item.quantity ?? 0;
                              return Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Container(
                                  height: 125,
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
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, top: 10, bottom: 10),
                                        child: Container(
                                          height: 85,
                                          width: 85,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: item.productId?.image != null
                                              ? Image.network(
                                                  item.productId!.image!,
                                                  fit: BoxFit.cover,
                                                )
                                              : Center(child: Text("No Image")),
                                        ),
                                      ),
                                      SizedBox(width: 30),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 15),
                                            Text(
                                              item.productId?.name ?? 'No Name',
                                              style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              "\$${price.toStringAsFixed(2)}",
                                              style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14),
                                            ),
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
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w600),
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
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          // Ensure that itemId is correctly derived from the cart item
                                          String itemId = item.sId ??
                                              ''; // Assuming sId is the correct identifier
                                          deleteItem(itemId);
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
                              );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: Container(
                              padding: EdgeInsets.all(20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: Container(
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
                    ),
        );
      },
    );
  }
}
