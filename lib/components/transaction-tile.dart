import 'package:flutter/material.dart';
import 'package:s2s_after_sales/models/transaction.dart';
import 'package:s2s_after_sales/theme/boxes.dart';

class TransactionTile extends StatelessWidget {
  final Transaction _transaction;
  const TransactionTile(this._transaction, {super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData _theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: AppBoxes().txTile,
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            _transaction.title,
            style: _theme.textTheme.titleSmall,
          ),
        ),
        subtitle: Text(
          _transaction.dateCreatedText,
          style: _theme.textTheme.labelSmall!.copyWith(
            color: _theme.colorScheme.onBackground.withOpacity(0.75),
          ),
        ),
        trailing: Text(
          _transaction.priceText,
          style: _theme.textTheme.titleSmall!.copyWith(
            color: _theme.colorScheme.secondary,
          ),
        ),
        tileColor: Colors.transparent,
        onTap: () {},
      ),
    );
  }
}
