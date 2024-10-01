import 'package:flutter/material.dart';
import 'package:s2s_after_sales/blocs/auth.dart';
import 'package:s2s_after_sales/utils/navigator.dart';

class HomePanel extends StatelessWidget {
  final String _iconPath = "assets/icons/";

  const HomePanel({super.key});
  @override
  Widget build(BuildContext context) {
    AuthBloc _auth = AuthBloc.instance(context)!;
    ThemeData _theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
      color: _theme.primaryColor,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 540,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: ["Buy", "Logout"]
                .map((key) => Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          switch (key) {
                            case "Logout":
                              _auth.logout();
                              Navigator.of(context).popUntilLogin();
                              break;
                            case "Buy":
                              Navigator.of(context).pushToShop();
                              break;
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20)
                                        .copyWith(bottom: 8),
                                child: Image.asset(
                                  "$_iconPath${key.toString()}.png",
                                  width: 40,
                                  height: 40,
                                ),
                              ),
                              Text(
                                key,
                                style: _theme.primaryTextTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}
