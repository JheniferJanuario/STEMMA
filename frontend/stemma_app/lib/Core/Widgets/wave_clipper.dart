import 'package:flutter/material.dart';

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, 90);

    path.quadraticBezierTo(size.width * 0.25, 10, size.width * 0.55, 80);

    path.quadraticBezierTo(size.width * 0.80, 140, size.width, 70);

    path.lineTo(size.width, size.height);

    path.lineTo(0, size.height);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
