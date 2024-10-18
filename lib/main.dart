import 'package:flutter/material.dart';
import 'package:surf2sawa/theme/app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_strategy/url_strategy.dart';

import 'blocs/auth.dart';
import 'utils/navigator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences cache = await SharedPreferences.getInstance();
  setPathUrlStrategy();
  runApp(
    AuthBloc.build(
      cache: cache,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Surf2Sawa',
      theme: AppTheme.data,
      navigatorKey: navigatorKey,
      initialRoute: Routers.splash,
      onGenerateRoute: Routers.onGenerateRouted,
    );
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
