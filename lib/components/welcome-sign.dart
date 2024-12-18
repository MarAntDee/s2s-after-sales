import 'dart:math';

import 'package:flutter/material.dart';
import 'package:surf2sawa/blocs/auth.dart';
import 'package:surf2sawa/utils/navigator.dart';

import '../models/account.dart';
import 'app-logo.dart';
import 'background.dart';

class WelcomeSign extends StatelessWidget {
  final Account account;
  final VoidCallback? onProceed;
  const WelcomeSign(this.account, {super.key, this.onProceed});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    ThemeData theme = Theme.of(context);
    AuthBloc auth = AuthBloc.instance(context)!;

    return Background(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: AppLogo(
                size: min(size.width / 2, size.height / 4),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text(
                    "Welcome, ${account.name}!",
                    style: theme.primaryTextTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                ),
                Center(
                  child: Text(
                    account.accountNumber,
                    style: theme.primaryTextTheme.titleMedium,
                  ),
                ),
                const Spacer(flex: 4),
                TextButton(
                  onPressed: () {
                    auth.logout();
                    Navigator.of(context).popUntilLogin();
                  },
                  child: const Text("Use a different mobile number"),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton(
                    onPressed: onProceed,
                    child: const Text("Proceed"),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
