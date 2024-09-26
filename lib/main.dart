import 'package:flutter/material.dart';
import 'package:s2s_after_sales/screens/login.dart';
import 'package:s2s_after_sales/theme/app.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'blocs/auth.dart';

void main() async {
  final SharedPreferences cache = await SharedPreferences.getInstance();
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
      title: 'S2S After Sales',
      theme: AppTheme.data,
      navigatorKey: navigatorKey,
      home: LoginPage(),
    );
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
