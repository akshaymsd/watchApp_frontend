import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class buttonWidget extends StatelessWidget {
  void Function()? ontap;
  buttonWidget({
    this.ontap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 200,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
          onPressed: ontap,
          child: Text(
            "submit",
            style: GoogleFonts.poppins(color: Colors.white),
          )),
    );
  }
}
