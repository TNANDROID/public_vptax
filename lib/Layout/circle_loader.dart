import 'package:flutter/material.dart';

class CircleLoader extends StatefulWidget {
  final String url;
  const CircleLoader({super.key, required this.url});
  @override
  State<CircleLoader> createState() => _CircleLoaderState();
}

class _CircleLoaderState extends State<CircleLoader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // Set the duration of the animation
    )..repeat(); // Repeat the animation continuously
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: SizedBox(
        width: 70,
        height: 70,
        child: Image.asset(widget.url),
      ),
    );
  }
}
