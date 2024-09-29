import 'package:flutter/material.dart';

import '../utils/navigator.dart';

class PaymentFailedPage extends StatelessWidget {
  const PaymentFailedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: const Text("Failed!"),
      ),
    );
  }

  static route(RouteSettings settings) {
    return BlurredRouter(
      builder: (context) {
        return PaymentFailedPage();
      },
      settings: settings,
    );
  }
}
