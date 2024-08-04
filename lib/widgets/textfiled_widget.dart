import 'package:flutter/material.dart';

class TextfieldWidget extends StatelessWidget {
  final String txt;
  final IconData? icon;
  final TextEditingController? ctrl;
  final FormFieldValidator<String>? validator; // Updated to function
  final bool obscureText; // Added for password fields
  TextInputType? keybrd;

  TextfieldWidget(
      {required this.txt,
      this.icon,
      this.ctrl,
      this.validator,
      this.obscureText = false, // Default to false
      super.key,
      this.keybrd});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: TextFormField(
        keyboardType: keybrd,
        validator: validator, // Use the function for validation
        controller: ctrl,
        obscureText: obscureText, // Handle obscure text for passwords
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(),
          labelText: txt,
          prefixIcon: icon != null ? Icon(icon) : null,
        ),
      ),
    );
  }
}
