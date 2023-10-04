import 'package:flutter/material.dart';

class LeftTriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..lineTo(40, 0) // Top-left point of the card
      ..lineTo(0, size.height / 2) // Left-middle point of the card
      ..lineTo(40, size.height) // Bottom-left point of the card
      ..lineTo(size.width, size.height) // Bottom-right point of the card
      ..lineTo(size.width, 0) // Top-right point of the card (to create the rectangle shape)
      ..close(); // Close the path to complete the shape

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class BottomTriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(0, 0) // Top-left point of the card
      ..lineTo(size.width, 0) // Top-right point of the card
      ..lineTo(size.width - 20, size.height) // Bottom-right point of the card
      ..lineTo(20, size.height) // Bottom-left point of the card
      ..close(); // Close the path to complete the shape

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class LeftTriangleClipper1 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(size.width, 0) // Top-right point of the card
      ..lineTo(0, size.height) // Bottom-left point of the card
      ..lineTo(size.width, size.height) // Bottom-right point of the card
      ..close(); // Close the path to complete the shape

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class RightTriangleClipper1 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(0, 0) // Top-left point of the card
      ..lineTo(0, size.width) // Top-right point of the card
      ..lineTo(size.height, size.width) // Bottom-right point of the card
      ..close(); // Close the path to complete the shape

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
