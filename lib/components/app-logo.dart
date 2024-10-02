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
}
