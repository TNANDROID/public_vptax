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
  final double? elevation;
  final Widget? child;

  const CustomGradientButton({
    super.key,
    this.gradientColors,
    required this.width,
    required this.height,
    this.child,
    this.topleft,
    this.topright,
    this.btmleft,
    this.btmright,
    this.btnPadding,
    this.elevation,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation ?? 5,
      color: c.full_transparent,
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(topright ?? 15),
        topLeft: Radius.circular(topleft ?? 15),
        bottomLeft: Radius.circular(btmleft ?? 15),
        bottomRight: Radius.circular(btmright ?? 15),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shadowColor: Colors.red,
          padding: EdgeInsets.all(btnPadding ?? 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(topright ?? 15),
              topLeft: Radius.circular(topleft ?? 15),
              bottomLeft: Radius.circular(btmleft ?? 15),
              bottomRight: Radius.circular(btmright ?? 15),
            ),
          ),
          backgroundColor: Colors.white, // Remove the background color
          foregroundColor: Colors.white, // Remove the ink splash color
        ),
        child: Ink(
            width: width,
            height: height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0.2, 0.8],
                colors:
                    gradientColors ?? [c.colorPrimary, c.colorPrimaryDark],
              ),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(topright ?? 15),
                topLeft: Radius.circular(topleft ?? 15),
                bottomLeft: Radius.circular(btmleft ?? 15),
                bottomRight: Radius.circular(btmright ?? 15),
              ),
            ),
            child: child ?? const SizedBox()),
      ),
    );
  }
}
