import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminContainer extends StatelessWidget {
  AdminContainer(
      {super.key,
      required this.screenHeight,
      required this.screenWidth,
      required this.text,
      required this.clr1,
      required this.clr2,
      this.clr3,
      required this.ontap});

  final String text;
  final Color clr1;
  final Color clr2;
  final Color? clr3;
  final void Function()? ontap; // Update to final

  final double screenHeight;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap, // Call the ontap function
      child: Container(
        height: screenHeight * 0.1,
        width: screenWidth * 0.45,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: clr1.withOpacity(1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 2),
            ),
            BoxShadow(
              color: clr2.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(2, 2),
            ),
          ],
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [clr1, clr2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: clr3 // 40% transparent
                ),
          ),
        ),
      ),
    );
  }
}
