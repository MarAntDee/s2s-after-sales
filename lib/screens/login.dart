import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:s2s_after_sales/blocs/auth.dart';
import 'package:s2s_after_sales/components/account-form.dart';
import 'package:s2s_after_sales/components/otp-form.dart';

import '../utils/navigator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();

  static route(RouteSettings settings) {
    return BlurredRouter(
      builder: (context) {
        return LoginPage();
      },
    );
  }
}

class _LoginPageState extends State<LoginPage> {
  final PageController controller = PageController();
  AuthBloc get _auth => AuthBloc.instance(context)!;

  int selectedIndex = 0;
  List<Widget> get _pages => [
        AccountForm(
          onSuccess: () => setState(() => selectedIndex = 1),
        ),
        OTPForm(
          initialData: _auth.pincode,
          onResend: _auth.checkAccount,
          onSubmit: (code) async {
            await _auth.verifyAccount(code);
            Navigator.of(context).popUntilHome();
          },
          mobile: _auth.maskedMobileNumber,
          onCancel: () => setState(() => selectedIndex = 0),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        color: Colors.white,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/login-bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black12],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ConstrainedBox(
                    constraints:
                        const BoxConstraints(maxWidth: 360, maxHeight: 520),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 60),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white38,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(30),
                              child: _pages[selectedIndex],
                            ),
                          ),
                        ),
                        const SizedBox(height: 60),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
