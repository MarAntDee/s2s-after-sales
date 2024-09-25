import 'package:flutter/material.dart';
import 'package:s2s_after_sales/screens/login.dart';
import 'package:s2s_after_sales/theme/app.dart';

import 'blocs/auth.dart';

void main() {
  runApp(
    AuthBloc.build(
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
      home: LoginPage(),
    );
  }
}
