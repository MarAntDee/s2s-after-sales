import 'dart:ui';

import 'package:flutter/material.dart';

import '../utils/navigator.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        color: Colors.white,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/login-bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black12],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              // child: Center(
              //   child: Padding(
              //     padding: const EdgeInsets.all(16),
              //     child: ConstrainedBox(
              //       constraints:
              //       const BoxConstraints(maxWidth: 360, maxHeight: 520),
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.stretch,
              //         children: [
              //           const SizedBox(height: 60),
              //           Expanded(
              //             child: Container(
              //               decoration: BoxDecoration(
              //                 color: Colors.white38,
              //                 borderRadius: BorderRadius.circular(24),
              //               ),
              //               child: Padding(
              //                 padding: const EdgeInsets.all(30),
              //                 child: _pages[selectedIndex],
              //               ),
              //             ),
              //           ),
              //           const SizedBox(height: 60),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
            ),
          ),
        ),
      ),
    );
  }

  static route(RouteSettings settings) {
    return BlurredRouter(
      builder: (context) {
        return const HomePage();
      },
    );
  }
}
