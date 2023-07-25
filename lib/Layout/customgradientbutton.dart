import 'package:flutter/material.dart';

class CustomGradientButton extends StatelessWidget {
  final List<Color> gradientColors;
  final double topleft;
  final double topright;
  final double btmleft;
  final double btmright;
  final VoidCallback onPressed;
  final String text;
  final double width;
  final double height;

  const CustomGradientButton({
    required this.gradientColors,
    required this.topleft,
    required this.topright,
    required this.btmleft,
    required this.btmright,
    required this.onPressed,
    required this.text,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(topright),
            topLeft: Radius.circular(topleft),
            bottomLeft: Radius.circular(btmleft),
            bottomRight: Radius.circular(btmright),
          ),
          side: BorderSide.none, // Remove the border
        ),
        elevation: 0,
        primary: Colors.transparent, // Remove the background color
        onPrimary: Colors.transparent, // Remove the ink splash color
      ),
      child: Ink(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.2, 0.8],
            colors: gradientColors,
          ),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(topright),
            topLeft: Radius.circular(topleft),
            bottomLeft: Radius.circular(btmleft),
            bottomRight: Radius.circular(btmright),
          ),
        ),
        child: Container(
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
