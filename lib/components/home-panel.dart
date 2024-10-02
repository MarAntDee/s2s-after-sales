import 'package:flutter/material.dart';
import 'package:s2s_after_sales/blocs/auth.dart';
import 'package:s2s_after_sales/utils/navigator.dart';

class HomePanel extends StatelessWidget {
  final String _iconPath = "assets/icons/";

  const HomePanel({super.key});
  @override
  Widget build(BuildContext context) {
    AuthBloc auth = AuthBloc.instance(context)!;
    ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
      color: theme.primaryColor,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 540),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: ["Buy", "Logout"].map((key) {
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    switch (key) {
                      case "Logout":
                        auth.logout();
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
                          padding: const EdgeInsets.symmetric(horizontal: 20)
                              .copyWith(bottom: 8),
                          child: Image.asset(
                            "$_iconPath${key.toString().toLowerCase()}.png",
                            width: 40,
                            height: 40,
                          ),
                        ),
                        Text(
                          key,
                          style: theme.primaryTextTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
