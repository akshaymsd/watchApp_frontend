import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Define a model for UPI Providers
class UpiProvider {
  final String name;
  final String imagePath;

  UpiProvider({required this.name, required this.imagePath});
}

class UpiProviderDropdown extends StatelessWidget {
  final UpiProvider prov;
  final void Function(UpiProvider?)? onChanged;
  final UpiProvider? value;

  UpiProviderDropdown({
    required this.prov,
    this.onChanged,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(
        prov.imagePath,
        width: 40,
        height: 40,
      ),
      title: Text(
        prov.name,
        style: GoogleFonts.poppins(),
      ),
      onTap: () => onChanged?.call(prov),
    );
  }
}
