import 'dart:math';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:surf2sawa/components/app-logo.dart';
import 'package:surf2sawa/components/background.dart';
import 'package:surf2sawa/theme/app.dart';
import 'package:surf2sawa/utils/api.dart';

import '../utils/navigator.dart';

class PaymentSuccessPage extends StatelessWidget {
  const PaymentSuccessPage({super.key});

  String? _parseTransactionNumber() {
      String url = html.window.location.href;
      if (!url.contains("?")) return null;
      List<String> chunk = url.split("?");
      if (chunk.length != 2) return null;

      return url.split("?")[1];
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size screen = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Background(
                  dotsPadding: 0,
                  dotsHeight: screen.height * 0.35,
                ),
              ),
              Expanded(
                flex: 6,
                child: Container(
                  color: Colors.white,
                ),
              )
            ],
          ),
          Center(
            child: FutureBuilder<Map<String, dynamic>>(
              future: ProdApi().getPaymentDetails(_parseTransactionNumber() ?? ""),
              builder: (context, payload) {
                if (payload.connectionState == ConnectionState.waiting) {
                  return const SizedBox.square(
                  dimension: 60,
                  child: CircularProgressIndicator(),
                );
                }
                return ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(32),
                          child: AppLogo(
                            size: min(screen.width / 4, screen.height / 8),
                          ),
                        ),
                        Card(
                          color: Colors.white,
                          surfaceTintColor: Colors.white,
                          shadowColor: Colors.black45,
                          elevation: 2,
                          child: SizedBox(
                            height: payload.hasError ? (screen.height /3) : (screen.height / 2),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const SizedBox(height: 32),
                                Container(
                                  width: 75,
                                  height: 75,
                                  margin: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: theme.colorScheme.primary,
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 2,
                                        spreadRadius: 0,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.check_rounded,
                                      color: Colors.white,
                                      size: 56,
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    "Payment Successful",
                                    style: theme.textTheme.titleMedium,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: Text(
                                    payload.hasError ? "" : (payload.data!.containsKey("skuName") ? "You have successfully purchased\n${payload.data!['skuName']}" : ""),
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.bodySmall!.copyWith(
                                      color: theme.colorScheme.lightGrayText,
                                    ),
                                  ),
                                ),
                                if (payload.hasData) ...[
                                  const Divider(
                                    thickness: 0.5,
                                    color: Color(0xFFD6D6D6),
                                    height: 48,
                                  ),
                                  ...payload.data!
                                      .entries.where((element) => element.key != "skuName")
                                      .map<Widget>(
                                        (entry) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 32,
                                        vertical: 4,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            entry.key,
                                            style: theme.textTheme.bodyMedium!
                                                .copyWith(
                                              color:
                                              theme.colorScheme.lightGrayText,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Text(
                                              entry.value.toString(),
                                              style: theme.textTheme.bodySmall!
                                                  .copyWith(
                                                fontFamily: "Poppins",
                                                color:
                                                theme.colorScheme.darkGrayText,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              textAlign: TextAlign.end,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                      .toList(),
                                ],
                              ],
                            ),
                          ),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: Navigator.of(context).popUntilHome,
                          child: const Text("Done"),
                        ),
                        const Spacer(flex: 6),
                      ],
                    ),
                  ),
                );
              }
            ),
          ),
        ],
      ),
    );
  }

  static route(RouteSettings settings) {
    return BlurredRouter(
      builder: (context) {
        return const PaymentSuccessPage();
      },
      settings: settings,
    );
  }
}
