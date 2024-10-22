import 'dart:html' as html;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:surf2sawa/blocs/auth.dart';
import 'package:surf2sawa/components/app-logo.dart';
import 'package:surf2sawa/components/background.dart';
import 'package:surf2sawa/components/plan-gauge.dart';
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

    return Background(
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
            // child: SizedBox(
            //   width: double.infinity,
            //   height: 60,
            //   child: Row(
            //   mainAxisSize: MainAxisSize.max,
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: <Widget>[
            //     Expanded(
            //       child: IconButton(
            //         icon: Icon(
            //           Icons.menu,
            //           color: Colors.black,
            //         ),
            //         onPressed: () {},
            //       ),
            //     ),
            //     Expanded(
            //       child: IconButton(
            //         icon: Icon(
            //           Icons.search,
            //           color: Colors.black,
            //         ),
            //         onPressed: () {},
            //       ),
            //     ),
            //     Expanded(
            //       child: IconButton(
            //         icon: Icon(
            //           Icons.print,
            //           color: Colors.black,
            //         ),
            //         onPressed: () {},
            //       ),
            //     ),
            //     Expanded(
            //       child: IconButton(
            //         icon: Icon(
            //           Icons.people,
            //           color: Colors.black,
            //         ),
            //         onPressed: () {},
            //       ),
            //     ),
            //   ],
            // ),
            // ),
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
      ),
    );
  }
}
