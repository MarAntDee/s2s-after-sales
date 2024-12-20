import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:surf2sawa/screens/home.dart';
import 'package:surf2sawa/screens/login.dart';
import 'package:surf2sawa/screens/purchase-failed.dart';
import 'package:surf2sawa/screens/purchase-success.dart';

import '../screens/404.dart';
import '../screens/splash.dart';

extension NavHandler on NavigatorState {
  Future popUntilRoot() async => pushReplacementNamed(Routers.splash);

  Future popUntilHome() async => pushReplacementNamed(Routers.homeScreen);

  Future popUntilLogin({String? error}) async =>
      pushReplacementNamed(Routers.loginScreen, arguments: {
        if (error != null) 'error': error,
      });
}

class Routers {
  Routers._();

  static const String splash = "/",
      homeScreen = "/home",
      loginScreen = "/login",
      paymentFailedScreen = "/payment-failed",
      paymentSuccessScreen = "/payment-success";

  static String currentRoute = splash;
  static String previousCustomerRoute = splash;
  static Route? onGenerateRouted(RouteSettings routeSettings) {
    previousCustomerRoute = currentRoute;
    currentRoute = (routeSettings.name ?? "").split("?").first;
    log("CURRENT ROUTE: $currentRoute");

    switch (currentRoute) {
      case splash:
        return LoadingScreen.route(routeSettings);
      case loginScreen:
        return LoginPage.route(routeSettings);
      case homeScreen:
        return HomePage.route(routeSettings);
      case paymentFailedScreen:
        return PaymentFailedPage.route(routeSettings);
      case paymentSuccessScreen:
        return PaymentSuccessPage.route(routeSettings);
      default:
        return Page404.route(routeSettings);
    }
  }
}

class BlurredRouter extends PageRoute<void> {
  final double? sigmaX;
  final double? sigmaY;
  final bool? barrierDismiss;
  BlurredRouter(
      {required this.builder,
      this.barrierDismiss,
      RouteSettings? settings,
      this.sigmaX,
      this.sigmaY})
      : super(settings: settings, fullscreenDialog: false);

  final WidgetBuilder builder;

  @override
  bool get opaque => false;
  @override
  Color get barrierColor => Colors.transparent;
  @override
  bool get barrierDismissible => barrierDismiss ?? super.barrierDismissible;

  @override
  String get barrierLabel => "blurred";

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 350);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final result = builder(context);
    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(animation),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: sigmaX ?? 5,
          sigmaY: sigmaY ?? 10,
        ),
        child: result,
      ),
    );
  }
}
