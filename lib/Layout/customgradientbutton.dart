import 'package:flutter/material.dart';
import 'package:public_vptax/Resources/ColorsValue.dart' as c;

class CustomGradientButton extends StatelessWidget {
  final double width;
  final double height;
  final VoidCallback? onPressed;
  final List<Color>? gradientColors;
  final double? topleft;
  final double? topright;
  final double? btmleft;
  final double? btmright;
  final double? btnPadding;
  final Widget? child;

  const CustomGradientButton({
    this.gradientColors,
    required this.width,
    required this.height,
    required this.child,
    this.topleft,
    this.topright,
    this.btmleft,
    this.btmright,
    this.btnPadding,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(btnPadding ?? 10),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(topright ?? 15),
              topLeft: Radius.circular(topleft ?? 15),
              bottomLeft: Radius.circular(btmleft ?? 15),
              bottomRight: Radius.circular(btmright ?? 15),
            ),
          ),
          elevation: 0.0,
          primary: Colors.white, // Remove the background color
          onPrimary: Colors.white, // Remove the ink splash color
        ),
        child: Ink(
            width: width,
            height: height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.2, 0.8],
                colors:
                    gradientColors ?? [c.colorAccentlight, c.colorPrimaryDark],
              ),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(topright ?? 15),
                topLeft: Radius.circular(topleft ?? 15),
                bottomLeft: Radius.circular(btmleft ?? 15),
                bottomRight: Radius.circular(btmright ?? 15),
              ),
            ),
            child: child),
      ),
    );
  }
}
