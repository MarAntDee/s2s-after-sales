import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:surf2sawa/main.dart';

class ErrorDisplay {
  static Widget list(dynamic e) => Builder(
        builder: (context) {
          ThemeData theme = Theme.of(context);
          return Center(
            child: Column(
              children: [
                const Spacer(),
                Icon(
                  Icons.warning_amber_rounded,
                  size: 180,
                  color: theme.colorScheme.onBackground.withOpacity(0.3),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    e.toString(),
                    style: theme.textTheme.headlineSmall!.copyWith(
                      color: theme.colorScheme.onBackground.withOpacity(0.3),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: html.window.location.reload,
                    child: const Text("Try Again"),
                  ),
                ),
                const Spacer(flex: 2),
              ],
            ),
          );
        },
      );

  static Future showLoggedOutDialog() => showDialog(
    context: navigatorKey.currentContext!,
    builder: (context) => const AlertDialog(
      content: Text(
        "You logged in on another device. For your security, you have been automatically logged out of the app",
      ),
    ),
  );
}
