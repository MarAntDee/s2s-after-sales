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
    Size _size = MediaQuery.sizeOf(context);
    ThemeData _theme = Theme.of(context);
    AuthBloc _auth = AuthBloc.instance(context)!;

    return Background(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: AppLogo(
                size: min(_size.width / 2, _size.height / 4),
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
                    style: _theme.primaryTextTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                ),
                Center(
                  child: Text(
                    account.accountNumber,
                    style: _theme.primaryTextTheme.titleMedium,
                  ),
                ),
                const Spacer(flex: 4),
                TextButton(
                  onPressed: () {
                    _auth.logout();
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
