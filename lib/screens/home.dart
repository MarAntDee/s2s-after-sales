import 'package:flutter/material.dart';
import 'package:s2s_after_sales/blocs/auth.dart';
import 'package:s2s_after_sales/components/home-panel.dart';
import 'package:s2s_after_sales/components/user-card.dart';
import 'package:s2s_after_sales/theme/app.dart';

import '../utils/navigator.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData _theme = Theme.of(context);
    AuthBloc _auth = AuthBloc.instance(context)!;

    return Scaffold(
      body: Column(
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 310 - 28,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage("assets/images/login-bg.png"),
                        fit: BoxFit.cover,
                        opacity: 0.25,
                      ),
                      gradient: LinearGradient(
                        colors: <Color>[
                          _theme.colorScheme.primaryColorDark,
                          _theme.colorScheme.primary,
                          _theme.colorScheme.secondaryColorDark,
                        ],
                        stops: const [0, 0.7, 1],
                        begin: const Alignment(-0.35, -1),
                        end: const Alignment(0.35, 1),
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        padding: const EdgeInsets.only(left: 24),
                        height: 60,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _auth.currentAccount!.name,
                            style:
                                _theme.primaryTextTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: _theme.primaryColor,
                    height: 28,
                  ),
                ],
              ),
              const UserCard(),
            ],
          ),
          HomePanel(),
          Spacer(),
        ],
      ),
    );
  }

  static route(RouteSettings settings) {
    return BlurredRouter(
      builder: (context) {
        return const HomePage();
      },
      settings: settings,
    );
  }
}
