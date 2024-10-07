import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:s2s_after_sales/blocs/auth.dart';
import 'package:s2s_after_sales/components/background.dart';
import 'package:s2s_after_sales/components/home-panel.dart';
import 'package:s2s_after_sales/components/payment-history-overview.dart';
import 'package:s2s_after_sales/components/user-card.dart';
import 'package:s2s_after_sales/theme/app.dart';

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
  bool _isOutageShown = false;

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
          return Scaffold(
            drawer: Drawer(
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  Expanded(
                    child: ListView(
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.shopping_cart_checkout_rounded,
                            color: _theme.primaryColor,
                          ),
                          title: const Text("Buy"),
                          onTap: Navigator.of(context).pushToShop,
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.logout,
                            color: _theme.primaryColor,
                          ),
                          title: const Text("Logout"),
                          onTap: () {
                            _auth.logout();
                            Navigator.of(context).popUntilLogin();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            body: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          height: 285 - 28,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            image: const DecorationImage(
                              image: AssetImage("assets/images/login-bg.png"),
                              fit: BoxFit.cover,
                              opacity: 0.25,
                            ),
                            gradient: LinearGradient(
                              colors: <Color>[
                                _theme.colorScheme.primaryColorDark,
                                _theme.colorScheme.primary,
                                _theme.colorScheme.secondaryColorDark,
                              ],
                              stops: const [0, 0.7, 1],
                              begin: const Alignment(-0.1, -1),
                              end: const Alignment(0.1, 1),
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              padding: const EdgeInsets.only(left: 8),
                              height: 60,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Builder(
                                      builder: (context) => IconButton(
                                        onPressed:
                                            Scaffold.of(context).openDrawer,
                                        color: Colors.white,
                                        icon: const Icon(Icons.menu),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      _auth.currentAccount!.name,
                                      style: _theme
                                          .primaryTextTheme.titleMedium!
                                          .copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          color: _theme.primaryColor,
                          height: 28,
                        ),
                      ],
                    ),
                    const UserCard(),
                  ],
                ),
                const HomePanel(),
                const Expanded(child: PaymentHistoryOverview()),
              ],
            ),
          );
        });
  }
}
