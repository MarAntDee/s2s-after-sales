import 'package:flutter/material.dart';
import 'package:surf2sawa/components/dialogs.dart';
import 'package:surf2sawa/models/transaction.dart';
import 'package:surf2sawa/theme/app.dart';
import 'package:surf2sawa/theme/icons.dart';

class TransactionTile extends StatelessWidget {
  final Transaction _transaction;
  const TransactionTile(this._transaction, {super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.highlightColor,
            width: 1,
          ),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 24),
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.colorScheme.secondarySwatch[100],
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 2, right: 2),
              child: Icon(
                IconLibrary.payment_entry,
                color: theme.colorScheme.secondary,
                size: 16,
              ),
            ),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            _transaction.product ?? _transaction.title,
            style: theme.textTheme.titleMedium!.copyWith(color: theme.colorScheme.darkGrayText,),
          ),
        ),
        subtitle: Text(
          "${_transaction.dateCreatedText} - ${_transaction.status}",
          style: theme.textTheme.labelMedium!.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
        trailing: Text(
          _transaction.priceText,
          style: theme.textTheme.titleMedium!.copyWith(color: theme.colorScheme.darkGrayText,),
        ),
        tileColor: Colors.transparent,
        onTap: () => Popup.showPaymentDetails(_transaction),
      ),
    );
  }
}
