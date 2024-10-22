import 'package:flutter/material.dart';
import 'package:surf2sawa/blocs/auth.dart';
import 'package:surf2sawa/components/dialogs.dart';
import 'package:surf2sawa/theme/app.dart';
import 'package:surf2sawa/utils/navigator.dart';

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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 6),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    auth.currentAccount!.accountNumberLabel,
                                    style: theme.primaryTextTheme.titleMedium!
                                        .copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  if (auth.currentAccount!.hasOutage != null)
                                    InkWell(
                                      onTap: auth.currentAccount!.hasOutage!
                                          ? Popup.showOutageAnnouncement
                                          : null,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: auth.currentAccount!.hasOutage!
                                              ? theme.colorScheme.error
                                              : theme.colorScheme
                                                  .secondaryColorDark,
                                          borderRadius:
                                              BorderRadius.circular(2),
                                        ),
                                        child: Text(
                                          auth.currentAccount!.outageTitle ??
                                              (auth.currentAccount!.hasOutage!
                                                  ? "Temporary Internet Outage"
                                                  : "Internet Connection Restored"),
                                          style:
                                              theme.primaryTextTheme.labelSmall,
                                        ),
                                      ),
                                    ),
                                  const SizedBox(height: 4),
                                  if ((!(auth.currentAccount!.hasOutage ??
                                          false)) &&
                                      auth.currentAccount!.outageDescription !=
                                          null)
                                    Text(
                                      auth.currentAccount!.outageDescription!,
                                      style: theme.primaryTextTheme.labelSmall!
                                          .copyWith(
                                              color: theme.colorScheme
                                                  .secondaryColorLight),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const AppLogo(size: 60),
                        const SizedBox(width: 12),
                      ],
                    ),
                    const Spacer(),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white54,
                          borderRadius: BorderRadius.horizontal(
                            right: Radius.circular(300),
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: const BorderRadius.horizontal(
                              right: Radius.circular(300),
                            ),
                            onTap: auth.pushToShop,
                            child: Padding(
                              padding:
                                  const EdgeInsets.all(6).copyWith(right: 14),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 16,
                                    height: 16,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: FittedBox(
                                      child: Text(
                                        "+",
                                        style: theme.textTheme.labelLarge!
                                            .copyWith(
                                                fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    "Buy Load",
                                    style: theme.textTheme.labelMedium!
                                        .copyWith(fontWeight: FontWeight.w700),
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
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (auth.currentAccount!.isExpired ?? false) ...[
                              const SizedBox(width: 8),
                              Icon(
                                Icons.warning_amber_rounded,
                                color: Colors.red[900],
                                size: 16,
                              ),
                            ],
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                auth.currentAccount!.currentProduct ?? "",
                                textAlign: TextAlign.right,
                                style: theme.textTheme.bodyLarge!.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
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
