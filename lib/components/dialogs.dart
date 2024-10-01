import 'package:flutter/material.dart';
import 'package:s2s_after_sales/models/transaction.dart';

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
}
