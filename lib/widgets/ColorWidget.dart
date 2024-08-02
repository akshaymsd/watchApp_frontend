import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class colorWidget extends StatelessWidget {
  Color? clr;
  colorWidget({
    required this.clr,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: clr,
        shape: BoxShape.circle,
      ),
    );
  }
}
