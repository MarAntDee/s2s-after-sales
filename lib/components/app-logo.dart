import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double? size;

  const AppLogo({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/images/app-logo.png",
      width: size,
      height: size,
    );
  }

  static final Widget s2s = Image.asset(
    "assets/images/s2s.png",
    fit: BoxFit.contain,
  );
}
