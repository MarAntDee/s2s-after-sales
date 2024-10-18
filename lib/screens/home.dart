import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:surf2sawa/blocs/auth.dart';
import 'package:surf2sawa/components/background.dart';
import 'package:surf2sawa/components/dashboard.dart';
import 'package:surf2sawa/components/welcome-sign.dart';

import '../components/dialogs.dart';
import '../models/account.dart';
import '../utils/navigator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();

  static route(RouteSettings settings) {
    return BlurredRouter(
      builder: (context) {
        return const HomePage();
      },
      settings: settings,
    );
  }
}

class _HomePageState extends State<HomePage> {
  ThemeData get _theme => Theme.of(context);
  AuthBloc get _auth => AuthBloc.instance(context)!;
  bool _isOutageShown = false, _hasProceed = false;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!_auth.isLoggedIn) {
        _auth.logout();
        Navigator.of(context).popUntilLogin();
      } else if (_auth.currentAccount == null) {
        print("FROM HOME NULL ACCOUNT");
        _auth.getAccountInfo().then((_) {
          AuthBloc _auth = AuthBloc.instance(context)!;
          if ((_auth.currentAccount!.hasOutage ?? false) && !_isOutageShown) {
            Popup.showOutageAnnouncement();
            _isOutageShown = true;
          }
        }).catchError((e) {
          _auth.logout();
          Navigator.of(context).popUntilLogin();
          return;
        });
      } else if ((_auth.currentAccount!.hasOutage ?? false) &&
          !_isOutageShown) {
        Popup.showOutageAnnouncement();
        _isOutageShown = true;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Account?>(
        stream: _auth.accountStream,
        initialData: _auth.currentAccount,
        builder: (context, account) {
          if (!account.hasData || account.data == null) {
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
          return AnimatedCrossFade(
            duration: const Duration(milliseconds: 400),
            firstChild: WelcomeSign(
              account.data!,
              onProceed: () => setState(() => _hasProceed = true),
            ),
            secondChild: const Dashboard(),
            crossFadeState: !_hasProceed
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
          );
        });
  }
}
