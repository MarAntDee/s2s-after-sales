import 'dart:math';

import 'package:flutter/material.dart';
import 'package:surf2sawa/theme/app.dart';

import '../components/app-logo.dart';
import '../components/background.dart';
import '../utils/navigator.dart';

class Page404 extends StatelessWidget {
  const Page404({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size screen = MediaQuery.sizeOf(context);

    return Background(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: AppLogo(
                    size: min(screen.width / 4, screen.height / 8),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Card(
                    color: Colors.white,
                    surfaceTintColor: Colors.white,
                    shadowColor: Colors.black45,
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Center(
                            child: Text(
                              "404",
                              style: theme.textTheme.displayLarge!.copyWith(
                                color: theme.colorScheme.secondary,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Nunito",
                              ).apply(fontSizeFactor: 1.8),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: Text(
                              "Page Not Found.",
                              style: theme.textTheme.titleMedium,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 32),
                          Text(
                            "Sorry, this page does not exist. Please check the URL or return to our homepage.",
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodySmall!.copyWith(
                              color: theme.colorScheme.lightGrayText,
                            ),
                          ),
                          const SizedBox(height: 40),
                          ElevatedButton(
                            onPressed: Navigator.of(context).popUntilRoot,
                            child: const Text('Back to Home'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Spacer(),
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
        return const Page404();
      },
      settings: settings,
    );
  }
}
