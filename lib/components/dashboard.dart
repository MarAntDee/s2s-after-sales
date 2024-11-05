import 'dart:html' as html;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:surf2sawa/blocs/auth.dart';
import 'package:surf2sawa/blocs/shopkeeper.dart';
import 'package:surf2sawa/components/announcement-board.dart';
import 'package:surf2sawa/components/app-logo.dart';
import 'package:surf2sawa/components/background.dart';
import 'package:surf2sawa/components/plan-gauge.dart';
import 'package:surf2sawa/models/announcement.dart';
import 'package:surf2sawa/screens/shop.dart';
import 'package:surf2sawa/theme/app.dart';
import 'package:surf2sawa/theme/icons.dart';

import '../screens/payment-journal.dart';
import 'home-panel.dart';
import 'payment-history-overview.dart';

class Dashboard extends StatefulWidget {
  final VoidCallback? onFABPressed;
  const Dashboard({super.key, this.onFABPressed});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  ThemeData get _theme => Theme.of(context);
  AuthBloc get auth => AuthBloc.instance(context)!;
  late bool? isOutageShown;

  List<Widget> get _pages => [
        Background(
          fromTop: true,
          begin: const Alignment(-1.2, -1.2),
          end: const Alignment(1, -1 / 3),
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
        Shop(),
        Container(),
        const PaymentJournal(),
        Container(),
      ];

  @override
  void initState() {
    super.initState();
    isOutageShown = auth.currentAccount?.hasOutage;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        stream: auth.pageStream,
        builder: (context, page) {
          int _selectedIndex = page.data ?? 0;
          return Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.transparent,
            endDrawer: Drawer(
              surfaceTintColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              child: AnnouncementBoard(ShopKeeper.instance(context)!),
            ),
            body: Stack(
              children: [
                _pages[_selectedIndex],
                if (isOutageShown ?? false)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: -16,
                    height: 120,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: const Color(0xFFFFD3C5),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                          border: Border.all(
                            width: 1,
                            color: _theme.primaryColor,
                          )),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Are you experiencing network issues?",
                                  style: _theme.textTheme.labelSmall!.copyWith(
                                    color: _theme.colorScheme.lightGrayText,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  auth.currentAccount!.outageTitle ?? "Yes, we are working on it.",
                                  style: _theme.textTheme.titleMedium!.copyWith(
                                    color: _theme.colorScheme.darkGrayText,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  auth.currentAccount!.outageDescription ?? "Thank you for your patience!",
                                  style: _theme.textTheme.labelSmall!.copyWith(
                                    color: _theme.colorScheme.lightGrayText,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: _theme.primaryColor,
                              textStyle: const TextStyle(
                                decoration: TextDecoration.none,
                              ),
                            ),
                            onPressed: () =>
                                setState(() => isOutageShown = null),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Close"),
                                SizedBox(width: 4),
                                Icon(
                                  Icons.close_rounded,
                                  size: 14,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (!(isOutageShown ?? true))
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: -16,
                    height: 120,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                          border: Border.all(
                            width: 1,
                            color: Colors.green,
                          )),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  auth.currentAccount!.outageTitle ?? "Internet connection restored",
                                  style: _theme.textTheme.titleMedium!.copyWith(
                                    color: _theme.colorScheme.darkGrayText,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  auth.currentAccount!.outageDescription ?? "Outage has been restored on Date,\nYour surftime has been extended for 2 hours",
                                  style: _theme.textTheme.labelSmall!.copyWith(
                                    color: _theme.colorScheme.lightGrayText,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.green,
                              textStyle: const TextStyle(
                                decoration: TextDecoration.none,
                              ),
                            ),
                            onPressed: () =>
                                setState(() => isOutageShown = null),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Close"),
                                SizedBox(width: 4),
                                Icon(
                                  Icons.close_rounded,
                                  size: 14,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
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
                child: SizedBox(
                  height: 60,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      {
                        "name": "Home",
                        "icon": IconLibrary.dashboard_home,
                      },
                      {
                        "name": "Plans",
                        "icon": IconLibrary.wifi_tower,
                      },
                      null,
                      {
                        "name": "History",
                        "icon": IconLibrary.receipt,
                      },
                      {
                        "name": "Notification",
                        "icon": IconLibrary.notification_bell,
                      },
                    ].indexed.map(
                      (entry) {
                        if (entry.$2 == null) return const Spacer();
                        return Expanded(
                          child: IconButton(
                            hoverColor: _theme.colorScheme.primaryColorLight,
                            splashColor: _theme.colorScheme.primaryColorLight,
                            icon: Column(
                              children: [
                                _selectedIndex == entry.$1
                                    ? ShaderMask(
                                        blendMode: BlendMode.srcIn,
                                        shaderCallback: (Rect bounds) =>
                                            LinearGradient(
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
                                      )
                                    : Icon(
                                        entry.$2!['icon'] as IconData,
                                        color: _theme.colorScheme.darkGrayText,
                                      ),
                                Text(
                                  entry.$2!['name'].toString(),
                                  style: _theme.textTheme.labelSmall!.copyWith(
                                    color: _selectedIndex == entry.$1
                                        ? _theme.colorScheme.secondary
                                        : _theme.colorScheme.darkGrayText,
                                  ),
                                ),
                              ],
                            ),
                            onPressed: () {
                              if (entry.$1 == 4) _scaffoldKey.currentState?.openEndDrawer();
                              else auth.selectedIndex = entry.$1;
                            },
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: GestureDetector(
              onLongPress: () {
                if (isOutageShown == null) setState(() => isOutageShown = true);
                else if (isOutageShown!) setState(() => isOutageShown = false);
                else setState(() => isOutageShown = null);
              },
              child: FloatingActionButton(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                onPressed: widget.onFABPressed,
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
              ),
            ),
          );
        });
  }
}
