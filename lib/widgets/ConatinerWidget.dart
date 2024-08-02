import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Containerwidget extends StatelessWidget {
  final String? img;
  final String? txt1;
  final String? txt2;
  final double? txt3;
  final Color? clr;
  final Color? clr1;
  final String? txt4;
  final void Function()? ontap;

  Containerwidget({
    super.key,
    this.img,
    this.txt1,
    this.txt2,
    this.txt3,
    this.clr,
    this.clr1,
    this.ontap,
    this.txt4,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        height: 200,
        width: 200,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: 220,
                  width: 180,
                  decoration: BoxDecoration(
                    color: clr,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: img != null
                      ? Image.network(img!) // Assuming images are URLs
                      : Container(),
                ),
              ),
            ),
            Text(
              txt1 ?? '',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            Text(
              txt2 ?? '',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w300,
                fontSize: 10,
              ),
            ),
            Row(
              children: [
                SizedBox(width: 50),
                Text(
                  "\$${txt3?.toStringAsFixed(2) ?? ''}",
                  style: GoogleFonts.poppins(
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(flex: 500),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    shape: BoxShape.rectangle,
                    color: clr,
                  ),
                  child: IconButton(
                    onPressed: ontap,
                    icon: Icon(Icons.shopping_bag_outlined),
                  ),
                ),
                SizedBox(height: 20),
                Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
