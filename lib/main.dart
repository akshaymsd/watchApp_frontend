import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watchapp/screen/modules/admin/admin_screen.dart';
import 'package:watchapp/services/cart_services.dart';
import 'package:watchapp/view_model/auth_viewModel.dart';
import 'package:watchapp/view_model/cart_view_model.dart';
import 'package:watchapp/view_model/home_vew_model.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        Provider<CartService>(
            create: (_) => CartService()), // Provide CartService
        ChangeNotifierProvider<CartViewModel>(
          create: (context) => CartViewModel(
            cartService: Provider.of<CartService>(context, listen: false),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AdminPage(),
      ),
    ),
  );
}
