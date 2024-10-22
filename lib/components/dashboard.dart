import 'dart:html' as html;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:surf2sawa/blocs/auth.dart';
import 'package:surf2sawa/blocs/shopkeeper.dart';
import 'package:surf2sawa/components/app-logo.dart';
import 'package:surf2sawa/components/background.dart';
import 'package:surf2sawa/components/plan-gauge.dart';
import 'package:surf2sawa/components/user-card.dart';
import 'package:surf2sawa/screens/shop.dart';
import 'package:surf2sawa/theme/app.dart';
import 'package:surf2sawa/utils/navigator.dart';

import '../screens/payment-journal.dart';
import 'home-panel.dart';
import 'payment-history-overview.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  ThemeData get _theme => Theme.of(context);
  AuthBloc get auth => AuthBloc.instance(context)!;

  List<Widget> get _pages => [
    Background(
      fromTop: true,
      begin: const Alignment(-1.2, -1.2),
      end: const Alignment(1, -1/3),
      dotsPadding: 60,
      child: Scaffold(
        backgroundColor: Colors.transparent,
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
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              slivers: [
                SliverFillRemaining(
                  child: Column(
                    children: [
                      const Expanded(child: HomePanel()),
                      Expanded(
                        flex: 2,
                        child: Container(
                          decoration: BoxDecoration(
                            color: _theme.scaffoldBackgroundColor,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(30),
                            ),
                          ),
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxWidth: 720,
                              ),
                              child: const Column(
                                children: [
                                  Expanded(child: PLanGauge()),
                                  Expanded(child: PaymentHistoryOverview()),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    ShopKeeper.build(child: const Shop()),
    Container(),
    const PaymentJournal(),
    Container(),
  ];
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: auth.pageStream,
      builder: (context, page) {
        int _selectedIndex = page.data ?? 0;
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: _pages[_selectedIndex],
          bottomNavigationBar: Container(
            color: _theme.scaffoldBackgroundColor,
            child: BottomAppBar(
              elevation: 6,
              notchMargin: 4,
              clipBehavior: Clip.antiAlias,
              color: Colors.white,
              surfaceTintColor: Colors.white,
              shape: const AutomaticNotchedShape(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                  ),
                ),
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(22)),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    {
                      "name": "Home",
                      "icon": Icons.home,
                    },
                    {
                      "name": "Plans",
                      "icon": Icons.podcasts_rounded,
                    },
                    null,
                    {
                      "name": "History",
                      "icon": Icons.receipt_long,
                    },
                    null,
                  ].indexed.map(
                        (entry) {
                      if (entry.$2 == null) return const Spacer();
                      return Expanded(
                        child: IconButton(
                          hoverColor: _theme.colorScheme.primaryColorLight,
                          splashColor: _theme.colorScheme.primaryColorLight,
                          icon: Column(
                            children: [
                              _selectedIndex == entry.$1 ? ShaderMask(
                                blendMode: BlendMode.srcIn,
                                shaderCallback: (Rect bounds) => LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    _theme.colorScheme.primary,
                                    _theme.colorScheme.secondary,
                                  ],
                                ).createShader(bounds),
                                child: Icon(
                                  entry.$2!['icon'] as IconData,
                                  color: Colors.black,
                                ),
                              ) : Icon(
                                entry.$2!['icon'] as IconData,
                                color: _theme.colorScheme.darkGrayText,
                              ),
                              Text(
                                entry.$2!['name'].toString(),
                                style: _theme.textTheme.labelSmall!.copyWith(
                                  color: _selectedIndex == entry.$1 ? _theme.colorScheme.secondary : _theme.colorScheme.darkGrayText,
                                ),
                              ),
                            ],
                          ),
                          onPressed: () {
                            auth.selectedIndex = entry.$1;
                          },
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: <Color>[
                    _theme.colorScheme.primary,
                    _theme.colorScheme.secondary,
                  ],
                  begin: const Alignment(-1, -1),
                  end: const Alignment(1, 1),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: AppLogo.s2s,
              ),
            ),
            onPressed: () {},
          ),
        );
      }
    );
  }
}
