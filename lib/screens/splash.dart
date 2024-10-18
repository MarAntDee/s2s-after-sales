import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:surf2sawa/blocs/auth.dart';
import 'package:surf2sawa/components/background.dart';

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
      settings: settings,
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
        child: const Center(
          child: SizedBox.square(
            dimension: 120,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 6,
            ),
          ),
        ),
      ),
    );
  }

  startTime() async {
    var duration = const Duration(milliseconds: 500);
    try {
      return Timer(duration, () => navigationPage(_auth.isLoggedIn));
    } catch (e) {
      print("SPLASH ERROR: ${e.toString()}");
      return Timer(duration, () => navigationPage(false));
    }
  }

  Future<void> navigationPage(bool isLoggedIn) async {
    if (Routers.currentRoute != "/") return;
    if (isLoggedIn) {
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
