import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/cart_utils.dart';
import '../../../widgets/upi_widget.dart';
import 'orderSuccefull_screen.dart';

class PlaceOrderPage extends StatefulWidget {
  const PlaceOrderPage({super.key});

  @override
  State<PlaceOrderPage> createState() => _PlaceOrderPageState();
}

class _PlaceOrderPageState extends State<PlaceOrderPage> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _upiIdController = TextEditingController();
  String? _selectedPaymentMethod = 'Credit Card';
  UpiProvider? _selectedUpiProvider;

  final List<UpiProvider> _upiProviders = [
    UpiProvider(name: 'Google Pay', imagePath: 'assets/img/gpay.png'),
    UpiProvider(name: 'Paytm', imagePath: 'assets/img/paytm.png'),
    UpiProvider(name: 'PhonePe', imagePath: 'assets/img/phpe.png'),
    UpiProvider(name: 'Amazon Pay', imagePath: 'assets/img/amazpay.png'),
  ];

  @override
  void dispose() {
    _addressController.dispose();
    _cardNumberController.dispose();
    _upiIdController.dispose();
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
      body: SingleChildScrollView(
        child: Padding(
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
                  title: Text('UPI', style: GoogleFonts.poppins()),
                  value: 'UPI',
                  groupValue: _selectedPaymentMethod,
                  onChanged: (value) {
                    setState(() {
                      _selectedPaymentMethod = value;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: Text('Cash on Delivery (COD)',
                      style: GoogleFonts.poppins()),
                  value: 'COD',
                  groupValue: _selectedPaymentMethod,
                  onChanged: (value) {
                    setState(() {
                      _selectedPaymentMethod = value;
                    });
                  },
                ),
                if (_selectedPaymentMethod == 'Credit Card') ...[
                  SizedBox(height: 20),
                  Text(
                    "Card Number",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _cardNumberController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter your card number',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your card number';
                      }
                      // Add validation for card number format if needed
                      return null;
                    },
                  ),
                ],
                if (_selectedPaymentMethod == 'UPI') ...[
                  SizedBox(height: 20),
                  Text(
                    "Select UPI Provider",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<UpiProvider>(
                    value: _selectedUpiProvider,
                    onChanged: (UpiProvider? newValue) {
                      setState(() {
                        _selectedUpiProvider = newValue;
                      });
                    },
                    items: _upiProviders.map<DropdownMenuItem<UpiProvider>>(
                        (UpiProvider provider) {
                      return DropdownMenuItem<UpiProvider>(
                        value: provider,
                        child: Row(
                          children: [
                            Image.asset(provider.imagePath, width: 30),
                            SizedBox(width: 10),
                            Text(provider.name, style: GoogleFonts.poppins()),
                          ],
                        ),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Choose UPI Provider',
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a UPI provider';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  Text(
                    "UPI ID",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _upiIdController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter your UPI ID',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your UPI ID';
                      }
                      // Add validation for UPI ID format if needed
                      return null;
                    },
                  ),
                ],
                if (_selectedPaymentMethod == 'COD') ...[
                  SizedBox(height: 20),
                  Text(
                    "Cash on Delivery",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "You will pay cash upon delivery.",
                    style: GoogleFonts.poppins(),
                  ),
                ],
                SizedBox(height: 20),
                Text(
                  "Order Summary",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Items",
                      style: GoogleFonts.poppins(),
                    ),
                    Text(
                      "${getTotalItems()}",
                      style: GoogleFonts.poppins(),
                    ),
                  ],
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
      ),
    );
  }
}
