import 'dart:html' as html;

import 'package:flutter/material.dart';

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
}
