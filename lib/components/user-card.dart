import 'package:flutter/material.dart';
import 'package:s2s_after_sales/blocs/auth.dart';
import 'package:s2s_after_sales/theme/app.dart';

import 'app-logo.dart';

class UserCard extends StatelessWidget {
  const UserCard({super.key});

  @override
  Widget build(BuildContext context) {
    AuthBloc auth = AuthBloc.instance(context)!;
    ThemeData theme = Theme.of(context);
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        constraints: const BoxConstraints(maxWidth: 540),
        height: 225,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 18, bottom: 12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 6),
                              child: Text(
                                auth.currentAccount!.accountNumberLabel,
                                style: theme.primaryTextTheme.titleMedium!
                                    .copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const AppLogo(size: 50),
                        const SizedBox(width: 12),
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(15),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16, top: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Current Data Plan",
                          style: theme.textTheme.bodySmall!
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (auth.currentAccount!.isExpired ?? false) ...[
                              const SizedBox(width: 8),
                              Icon(
                                Icons.warning_amber_rounded,
                                color: Colors.red[900],
                              ),
                            ],
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                auth.currentAccount!.currentProduct ?? "",
                                textAlign: TextAlign.right,
                                style: theme.textTheme.titleLarge,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      const Spacer(),
                      Text(
                        auth.currentAccount!.expirationText ?? "",
                        style: theme.textTheme.bodySmall!.copyWith(
                          color: (auth.currentAccount!.isExpired ?? false)
                              ? theme.colorScheme.error
                              : theme.colorScheme.onBackground.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(width: 14),
                      if (false)
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              ),
                              onTap: () {},
                              child: Padding(
                                padding: const EdgeInsets.all(14)
                                    .copyWith(top: 6, bottom: 6),
                                child: Text(
                                  "Buy Again",
                                  style: theme.textTheme.bodySmall!.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: theme.colorScheme.highContrast,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
