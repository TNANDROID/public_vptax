import 'dart:math';

import 'package:flutter/material.dart';

class CustomClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(1, size.height); // Start at the bottom-left corner
    path.lineTo(size.width * 0.85, size.height); // Line to the 65% width of the container
    path.lineTo(size.width * 0.65, 0); // Line to the 75% width of the container
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..lineTo(size.width - 40, 0) // Top-right point of the card
      ..lineTo(size.width, size.height / 2) // Right-middle point of the card
      ..lineTo(size.width - 40, size.height) // Bottom-right point of the card
      ..lineTo(0, size.height) // Bottom-left point of the card
      ..close(); // Close the path to complete the shape

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

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

class RightTriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(0, 0) // Top-left point of the card
      ..lineTo(size.width - 40, 0) // Top-right point of the card
      ..lineTo(size.width, size.height / 2) // Right-middle point of the card
      ..lineTo(size.width - 40, size.height) // Bottom-right point of the card
      ..lineTo(0, size.height) // Bottom-left point of the card
      ..close(); // Close the path to complete the shape

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class TrapezoidContainer extends StatelessWidget {
  final double width;
  final double height;
  final Color color;

  const TrapezoidContainer({
    required this.width,
    required this.height,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: TrapezoidClipper(),
      child: Container(
        width: width,
        height: height,
        color: color,
      ),
    );
  }
}

class TrapezoidClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(size.width * 0.2, 0) // Top-left corner
      ..lineTo(size.width * 0.8, 0) // Top-right corner
      ..lineTo(size.width, size.height) // Bottom-right corner
      ..lineTo(0, size.height) // Bottom-left corner
      ..close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class HalfCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..addArc(
        Rect.fromCircle(
          center: Offset(size.width / 2, size.height),
          radius: size.width,
        ),
        0,
        pi,
      );

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
