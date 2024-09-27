import 'package:flutter/material.dart';
import 'package:s2s_after_sales/blocs/auth.dart';
import 'package:s2s_after_sales/components/background.dart';
import 'package:s2s_after_sales/components/user-card.dart';

import '../utils/navigator.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData _theme = Theme.of(context);
    AuthBloc _auth = AuthBloc.instance(context)!;

    return Background(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480, maxHeight: 520),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),
                const Spacer(),
                const UserCard(),
                const SizedBox(
                  height: 32,
                ),
                ElevatedButton(
                  onPressed: () {
                    _auth.logout();
                    Navigator.of(context).popUntilLogin();
                  },
                  child: const Text("Log out"),
                ),
                const Spacer(),
                const SizedBox(height: 60),
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
        return const HomePage();
      },
    );
  }
}
