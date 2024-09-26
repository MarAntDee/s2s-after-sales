import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:s2s_after_sales/blocs/auth.dart';
import 'package:s2s_after_sales/components/background.dart';

import '../utils/navigator.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();

  static route(RouteSettings settings) {
    return BlurredRouter(
      builder: (context) {
        return const LoadingScreen();
      },
    );
  }
}

class _LoadingScreenState extends State<LoadingScreen> {
  AuthBloc get _auth => AuthBloc.instance(context)!;
  ThemeData get _theme => Theme.of(context);

  bool from = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    //setToken();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.transparent, Colors.black12],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SizedBox.square(
            dimension: 120,
            child: CircularProgressIndicator(
              color: _theme.colorScheme.secondary,
              strokeWidth: 6,
            ),
          ),
        ),
      ),
    );
  }

  startTime() async {
    var duration = const Duration(seconds: 2);
    if (_auth.isLoggedIn) {
      await _auth.getAccountInfo();
    }
    return Timer(duration, navigationPage);
  }

  Future<void> navigationPage() async {
    if (_auth.isLoggedIn) {
      Navigator.of(context).popUntilHome();
    } else {
      Navigator.of(context).popUntilLogin();
    }
  }

  @override
  void dispose() {
    if (from) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
    }
    super.dispose();
  }
}
