import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:surf2sawa/blocs/auth.dart';
import 'package:surf2sawa/theme/app.dart';
import 'package:surf2sawa/theme/icons.dart';
import 'package:surf2sawa/utils/extensions.dart';

import 'app-logo.dart';

class HomePanel extends StatelessWidget {
  const HomePanel({super.key});
  @override
  Widget build(BuildContext context) {
    AuthBloc auth = AuthBloc.instance(context)!;
    ThemeData theme = Theme.of(context);
    bool isScreenShort = MediaQuery.sizeOf(context).height < 720;

    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 480,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 12),
            if (!isScreenShort) const AppLogo(size: 72),
            Row(
              children: [
                if (isScreenShort) const AppLogo(size: 72),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "${DateTime.now().greeting}, ${auth.username ?? auth.currentAccount!.name}",
                      style: theme.primaryTextTheme.labelMedium,
                    ),
                    Text(
                      auth.currentAccount!.accountNumber,
                      style: theme.primaryTextTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
              ],
            ),
            Expanded(
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      height: 80,
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Colors.white38,
                      ),
                      child: Row(
                        children: <Widget>[
                          if (auth.currentAccount!.currentProduct != null)
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Current Data Plan",
                                  style: theme.primaryTextTheme.labelSmall,
                                ),
                                Text(
                                  auth.currentAccount!.currentProduct!,
                                  style: theme.primaryTextTheme.titleLarge!
                                      .copyWith(fontWeight: FontWeight.w700)
                                      .apply(fontSizeDelta: -4),
                                ),
                                if (auth.currentAccount!.expirationText != null) Text(
                                  auth.currentAccount!.expirationText!,
                                  style: theme.primaryTextTheme.labelSmall,
                                ),
                              ],
                            ),
                          if (auth.currentAccount!.currentProduct == null)
                            Text(
                              "No Load Left?\nLet’s get you back online!",
                              textAlign: TextAlign.start,
                              style: theme.primaryTextTheme.labelSmall,
                            ),
                          const Spacer(),
                          SizedBox(
                            width: 80,
                            child: ElevatedButton(
                              onPressed: auth.pushToShop,
                              child: const Text("Buy Load"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
