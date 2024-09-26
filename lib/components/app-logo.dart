import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double? size;

  const AppLogo({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    return FlutterLogo(
      size: size,
    );
  }
}
