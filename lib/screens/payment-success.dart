import 'package:flutter/material.dart';

import '../utils/navigator.dart';

class PaymentSuccessPage extends StatelessWidget {
  const PaymentSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: const Text("Success!"),
      ),
    );
  }

  static route(RouteSettings settings) {
    return BlurredRouter(
      builder: (context) {
        return PaymentSuccessPage();
      },
      settings: settings,
    );
  }
}
