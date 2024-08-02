import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/cart_utils.dart';
import 'orderSuccefull_screen.dart';

class PlaceOrderPage extends StatefulWidget {
  const PlaceOrderPage({super.key});

  @override
  State<PlaceOrderPage> createState() => _PlaceOrderPageState();
}

class _PlaceOrderPageState extends State<PlaceOrderPage> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  String? _selectedPaymentMethod = 'Credit Card';

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  double getTotalPrice() {
    double total = 0.0;
    for (var item in cartlist) {
      double price = item['Price'] ?? 0.0;
      int qty = (item['qty'] ?? 1) as int;
      total += price * qty;
    }
    return total;
  }

  int getTotalItems() {
    int totalItems = 0;
    for (var item in cartlist) {
      totalItems += (item['qty'] ?? 1) as int;
    }
    return totalItems;
  }

  void _placeOrder() {
    if (_formKey.currentState?.validate() ?? false) {
      if (cartlist.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Your cart is empty. Please add items to the cart.'),
        ));
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderSuccessPage(
              totalPrice: getTotalPrice(),
              totalItems: getTotalItems(),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Place Order",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: .5,
      ),
      backgroundColor: Color(0xFFF8F9FA),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Shipping Address",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter your address',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Text(
                "Payment Method",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 10),
              RadioListTile<String>(
                title: Text('Credit Card', style: GoogleFonts.poppins()),
                value: 'Credit Card',
                groupValue: _selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentMethod = value;
                  });
                },
              ),
              RadioListTile<String>(
                title: Text('PayPal', style: GoogleFonts.poppins()),
                value: 'PayPal',
                groupValue: _selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentMethod = value;
                  });
                },
              ),
              RadioListTile<String>(
                title: Text('Cash on Delivery', style: GoogleFonts.poppins()),
                value: 'Cash on Delivery',
                groupValue: _selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentMethod = value;
                  });
                },
              ),
              SizedBox(height: 20),
              Text(
                "Order Summary",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: cartlist.length,
                  itemBuilder: (context, index) {
                    var item = cartlist[index];
                    double price = item['Price'] ?? 0.0;
                    int qty = (item['qty'] ?? 1) as int;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${item['Name']} x$qty",
                            style: GoogleFonts.poppins(),
                          ),
                          Text(
                            "Rs ${(price * qty).toStringAsFixed(2)}",
                            style: GoogleFonts.poppins(),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Price",
                    style: GoogleFonts.poppins(),
                  ),
                  Text(
                    "Rs ${getTotalPrice().toStringAsFixed(2)}",
                    style: GoogleFonts.poppins(),
                  ),
                ],
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _placeOrder,
                  child: Text(
                    'Place Order',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
