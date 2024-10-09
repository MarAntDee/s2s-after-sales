import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:s2s_after_sales/blocs/auth.dart';
import 'package:s2s_after_sales/components/account-form.dart';
import 'package:s2s_after_sales/components/background.dart';
import 'package:s2s_after_sales/components/dialogs.dart';
import 'package:s2s_after_sales/components/otp-form.dart';
import 'package:s2s_after_sales/theme/boxes.dart';

import '../utils/navigator.dart';

class LoginPage extends StatefulWidget {
  final String? error;
  const LoginPage({Key? key, this.error}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();

  static route(RouteSettings settings) {
    return BlurredRouter(
      builder: (context) {
        return LoginPage(
          error: (settings.arguments as Map? ?? {})['error'],
        );
      },
      settings: settings,
    );
  }
}

class _LoginPageState extends State<LoginPage> {
  final ScrollController scrollController = ScrollController();
  final FocusNode _node = FocusNode();
  final PageController controller = PageController();
  AuthBloc get _auth => AuthBloc.instance(context)!;
  Size get _screen => MediaQuery.sizeOf(context);
  bool hasFocus = false;

  int selectedIndex = 0;
  List<Widget> get _pages => [
        AccountForm(
          node: _node,
          hasFocus: hasFocus,
          onSuccess: () async {
            if (_auth.autolink ?? false) {
              await _auth.getAccountInfo();
              Navigator.of(context).popUntilHome();
            } else
              setState(() => selectedIndex = 1);
          },
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
  void initState() {
    if (_auth.isLoggedIn) _auth.logout();
    if (widget.error != null) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        Popup.showError(widget.error);
      });
    }
    _node.addListener(() {
      if (_node.hasFocus) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 300),
        );
      }
      setState(() => hasFocus = _node.hasFocus);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Center(
        child: SingleChildScrollView(
          controller: scrollController,
          physics: const ClampingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16)
                .copyWith(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 400,
                maxHeight: max(_screen.height - 32, 800),
              ),
              child: Center(
                child: Container(
                  decoration: AppBoxes().main,
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: _pages[selectedIndex],
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
