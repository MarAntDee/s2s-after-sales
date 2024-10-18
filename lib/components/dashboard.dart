import 'dart:html' as html;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:surf2sawa/blocs/auth.dart';
import 'package:surf2sawa/components/user-card.dart';
import 'package:surf2sawa/theme/app.dart';
import 'package:surf2sawa/utils/navigator.dart';

import 'home-panel.dart';
import 'payment-history-overview.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData _theme = Theme.of(context);
    AuthBloc _auth = AuthBloc.instance(context)!;

    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            const SizedBox(height: 60),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.shopping_cart_checkout_rounded,
                      color: _theme.primaryColor,
                    ),
                    title: const Text("Buy"),
                    onTap: Navigator.of(context).pushToShop,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: _theme.primaryColor,
                    ),
                    title: const Text("Logout"),
                    onTap: () {
                      _auth.logout();
                      Navigator.of(context).popUntilLogin();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          physics: const ClampingScrollPhysics(),
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
            PointerDeviceKind.trackpad
          },
        ),
        child: RefreshIndicator(
          onRefresh: () async => html.window.location.reload(),
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              height: 285 - 28,
                              decoration: BoxDecoration(
                                color: _theme.primaryColor,
                                image: const DecorationImage(
                                  image:
                                      AssetImage("assets/images/login-bg.png"),
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
                                  begin: const Alignment(-0.1, -1),
                                  end: const Alignment(0.1, 1),
                                ),
                              ),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  padding: const EdgeInsets.only(left: 8),
                                  height: 60,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: [
                                        Builder(
                                          builder: (context) => IconButton(
                                            onPressed:
                                                Scaffold.of(context).openDrawer,
                                            color: Colors.white,
                                            icon: const Icon(Icons.menu),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          _auth.currentAccount!.name,
                                          style: _theme
                                              .primaryTextTheme.titleMedium!
                                              .copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
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
                    const HomePanel(),
                    const Expanded(child: PaymentHistoryOverview()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
