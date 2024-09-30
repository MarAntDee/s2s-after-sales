import 'package:flutter/material.dart';

import '../theme/boxes.dart';
import '../utils/navigator.dart';

class PaymentFailedPage extends StatelessWidget {
  const PaymentFailedPage({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData _theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 400,
            maxHeight: 800,
          ),
          decoration: AppBoxes().receipt,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30).copyWith(bottom: 45),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
                Center(
                  child: Text(
                    "Payment Failed!",
                    style: _theme.textTheme.headlineSmall!.copyWith(
                      color: _theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _theme.colorScheme.error,
                    boxShadow: [
                      const BoxShadow(
                        color: Colors.black45,
                        blurRadius: 4,
                        spreadRadius: 0,
                        offset: Offset(0, 3),
                      ),
                      BoxShadow(
                        color: _theme.colorScheme.error.withAlpha(60),
                        blurRadius: 24,
                        spreadRadius: 8,
                        offset: Offset.zero,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 60, top: 16),
                  child: Text(
                    "An error occurred during your payment. Please try again.",
                    textAlign: TextAlign.center,
                    style: _theme.textTheme.titleMedium,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _theme.colorScheme.error,
                  ),
                  onPressed: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Try Again",
                      style: _theme.primaryTextTheme.headline6,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
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
