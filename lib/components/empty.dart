import 'package:flutter/material.dart';

class EmptyDisplay {
  static Widget list(String label, IconData icon) => Builder(
        builder: (context) {
          ThemeData theme = Theme.of(context);
          return Center(
            child: Column(
              children: [
                const Spacer(),
                Icon(
                  icon,
                  size: 120,
                  color: theme.colorScheme.onBackground.withOpacity(0.3),
                ),
                const SizedBox(height: 16),
                Text(
                  label,
                  style: theme.textTheme.headlineSmall!.copyWith(
                    color: theme.colorScheme.onBackground.withOpacity(0.3),
                  ),
                ),
                const Spacer(flex: 2),
              ],
            ),
          );
        },
      );
}
