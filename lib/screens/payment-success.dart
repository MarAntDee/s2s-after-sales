import 'package:flutter/material.dart';
import 'package:s2s_after_sales/theme/boxes.dart';

import '../utils/navigator.dart';

class PaymentSuccessPage extends StatelessWidget {
  const PaymentSuccessPage({super.key});

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
                    "Payment Successful!",
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
                    color: _theme.colorScheme.secondary,
                    boxShadow: [
                      const BoxShadow(
                        color: Colors.black45,
                        blurRadius: 4,
                        spreadRadius: 0,
                        offset: Offset(0, 3),
                      ),
                      BoxShadow(
                        color: _theme.colorScheme.secondary.withAlpha(60),
                        blurRadius: 24,
                        spreadRadius: 8,
                        offset: Offset.zero,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 60, top: 16),
                  child: Text(
                    "Successfully purchased this product",
                    textAlign: TextAlign.center,
                    style: _theme.textTheme.titleMedium,
                  ),
                ),
                // Expanded(
                //   flex: 4,
                //   child: Center(
                //     child: Padding(
                //       padding: const EdgeInsets.symmetric(horizontal: 16.0),
                //       child: SingleChildScrollView(
                //         child: Column(
                //           mainAxisSize: MainAxisSize.min,
                //           children: {"Sample Key": "Sample Value"}
                //               .entries
                //               .map(
                //                 (entry) => Padding(
                //                   padding: EdgeInsets.only(bottom: 8),
                //                   child: Row(
                //                     children: [
                //                       Expanded(
                //                         flex: 4,
                //                         child: Text(
                //                           "${entry.key}:",
                //                           style: _theme.textTheme.titleMedium!
                //                               .copyWith(
                //                                   fontWeight: FontWeight.w400),
                //                         ),
                //                       ),
                //                       Expanded(
                //                         flex: 6,
                //                         child: Text(
                //                           entry.value.toString(),
                //                           style: _theme.textTheme.titleMedium!
                //                               .copyWith(
                //                                   fontWeight: FontWeight.w700),
                //                           textAlign: TextAlign.right,
                //                         ),
                //                       ),
                //                     ],
                //                   ),
                //                 ),
                //               )
                //               .toList(),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                ElevatedButton(
                  onPressed: Navigator.of(context).popUntilHome,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Back to Home",
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
        return PaymentSuccessPage();
      },
      settings: settings,
    );
  }
}
