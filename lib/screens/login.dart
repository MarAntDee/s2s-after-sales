import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:surf2sawa/blocs/auth.dart';
import 'package:surf2sawa/components/account-form.dart';
import 'package:surf2sawa/components/background.dart';
import 'package:surf2sawa/components/dialogs.dart';
import 'package:surf2sawa/components/otp-form.dart';

import '../components/app-logo.dart';
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
  final FocusNode _accountNode = FocusNode(), _otpNode = FocusNode();
  final PageController controller = PageController();
  AuthBloc get _auth => AuthBloc.instance(context)!;
  Size get _size => MediaQuery.sizeOf(context);
  bool hasFocus = false;

  int selectedIndex = 0;
  int get _flex1 => 1;
  int get _flex2 => hasFocus ? 4 : 1;
  List<Widget> get _pages => [
        AccountForm(
          node: _accountNode,
          onSuccess: () async {
            if (_auth.autolink ?? false) {
              await _auth.getAccountInfo();
              Navigator.of(context).popUntilHome();
            } else
              setState(() => selectedIndex = 1);
          },
        ),
        OTPForm(
          node: _otpNode,
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
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.error != null) Popup.showError(widget.error);
      _accountNode.addListener(() => _nodeListener(_accountNode));
      _otpNode.addListener(() => _nodeListener(_otpNode));
    });
    super.initState();
  }

  @override
  void dispose() {
    _accountNode.removeListener(() => _nodeListener(_accountNode));
    _otpNode.removeListener(() => _nodeListener(_otpNode));
    super.dispose();
  }

  void _nodeListener(FocusNode node) {
    setState(() => hasFocus = node.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      dotsPadding: _size.height / 6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: _flex1,
            child: Center(
              child: AppLogo(
                size: min(_size.width / 2, _size.height / 4),
              ),
            ),
          ),
          Expanded(
            flex: _flex2,
            child: Container(
              padding: const EdgeInsets.all(45).copyWith(bottom: 0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  children: [
                    Expanded(flex: 3, child: Center(child: _pages[selectedIndex])),
                    if (hasFocus) const Spacer(flex: 2),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      // child: Center(
      //   child: SingleChildScrollView(
      //     controller: scrollController,
      //     physics: const ClampingScrollPhysics(),
      //     child: Padding(
      //       padding: const EdgeInsets.all(16)
      //           .copyWith(bottom: MediaQuery.of(context).viewInsets.bottom),
      //       child: ConstrainedBox(
      //         constraints: BoxConstraints(
      //           maxWidth: 400,
      //           maxHeight: max(_screen.height - 32, 800),
      //         ),
      //         child: Center(
      //           child: Container(
      //             child: Padding(
      //               padding: const EdgeInsets.all(30),
      //               child: _pages[selectedIndex],
      //             ),
      //           ),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
