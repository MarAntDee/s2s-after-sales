import 'package:flutter/material.dart';
import 'package:surf2sawa/blocs/auth.dart';
import 'package:surf2sawa/models/transaction.dart';

import '../main.dart';

class Popup {
  static BuildContext? _context() => navigatorKey.currentContext;

  static Future showError(dynamic e) => showDialog(
        context: _context()!,
        builder: (context) => AlertDialog(
          content: Text(
            e.toString(),
            textAlign: TextAlign.center,
          ),
        ),
      );

  static Future showPaymentDetails(Transaction tx) => showDialog(
        context: _context()!,
        builder: (context) {
          ThemeData theme = Theme.of(context);
          return AlertDialog(
            title: Text(tx.title, textAlign: TextAlign.center),
            content: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: tx
                    .toMap()
                    .entries
                    .map<Widget>(
                      (entry) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                "${entry.key}:",
                                style: theme.textTheme.bodyMedium!.copyWith(
                                  color: theme.colorScheme.onBackground
                                      .withOpacity(0.75),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 2,
                              child: Text(
                                entry.value.toString(),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          );
        },
      );

  static Future showOutageAnnouncement() => showDialog(
        context: _context()!,
        builder: (context) {
          AuthBloc auth = AuthBloc.instance(context)!;
          return AlertDialog(
            content: Text(
              auth.currentAccount!.outageDescription ??
                  "📢 Internet Outage Announcement 📢\n\nWe would like to inform you that there is currently a temporary internet outage affecting your area. Our team is actively working to resolve the issue as quickly as possible.\n\nDuring this outage, you may experience difficulties accessing the internet and related services. We apologize for any inconvenience this may cause and appreciate your understanding and patience.",
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                onPressed: Navigator.of(context).pop,
                child: const Text("Close"),
              ),
            ],
          );
        },
      );
}
