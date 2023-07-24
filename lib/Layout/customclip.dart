import 'dart:ui';
import 'package:flutter/material.dart';

class CustomClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(1, size.height); // Start at the bottom-left corner
    path.lineTo(size.width * 0.85,
        size.height); // Line to the 65% width of the container
    path.lineTo(size.width * 0.65, 0); // Line to the 75% width of the container
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
