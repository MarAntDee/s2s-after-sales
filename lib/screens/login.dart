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
  void initState() {
    if (_auth.isLoggedIn) _auth.logout();
    if (widget.error != null) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        Popup.showError(widget.error);
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Center(
        child: SingleChildScrollView(
          physics: MediaQuery.of(context).size.height < 832
              ? ClampingScrollPhysics()
              : NeverScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 400,
                minHeight: 800,
                maxHeight: 800,
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
