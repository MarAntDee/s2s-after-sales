import 'package:flutter/material.dart';

import '../utils/navigator.dart';

class PaymentSuccessPage extends StatelessWidget {
  const PaymentSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData _theme = Theme.of(context);
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30).copyWith(bottom: 45),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Spacer(),
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
                SizedBox(height: 12),
                Icon(
                  Icons.wallet,
                  color: Color(0xFFA3DF37),
                  size: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0, top: 16.0),
                  child: Text(
                    "Successfully purchased this product",
                    textAlign: TextAlign.center,
                    style: _theme.textTheme.titleMedium,
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: {"Sample Key": "Sample Value"}
                              .entries
                              .map(
                                (entry) => Padding(
                                  padding: EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 4,
                                        child: Text(
                                          "${entry.key}:",
                                          style: _theme.textTheme.titleMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Text(
                                          entry.value.toString(),
                                          style: _theme.textTheme.titleMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.w700),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: _theme.primaryColor),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0)),
                  ),
                  onPressed: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "OK",
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
