import 'dart:ui';

import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget? child;
  final double? dotsPadding;
  const Background({super.key, this.child, this.dotsPadding});

  @override
  Widget build(BuildContext context) {
    ThemeData _theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    _theme.colorScheme.primary,
                    _theme.colorScheme.secondary,
                  ],
                  begin: const Alignment(-1.5, -0.4),
                  end: const Alignment(1.5, 0.4),
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 111, sigmaY: 111),
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: dotsPadding ?? 30,
            height: MediaQuery.sizeOf(context).height / 2,
            child: Image.asset(
              "assets/ui/bg-dots.png",
              fit: BoxFit.contain,
            ),
          ),
          if (child != null) Positioned.fill(child: child!),
        ],
      ),
    );
  }
}
