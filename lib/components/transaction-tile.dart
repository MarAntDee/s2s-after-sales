import 'package:flutter/material.dart';
import 'package:surf2sawa/components/dialogs.dart';
import 'package:surf2sawa/models/transaction.dart';
import 'package:surf2sawa/theme/app.dart';
import 'package:surf2sawa/theme/boxes.dart';

class TransactionTile extends StatelessWidget {
  final Transaction _transaction;
  const TransactionTile(this._transaction, {super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData _theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: _theme.highlightColor,
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
            color: _theme.colorScheme.secondarySwatch[100],
          ),
          child: Center(
            child: Icon(
              Icons.shopping_cart_checkout_rounded,
              color: _theme.colorScheme.secondary,
              size: 20,
            ),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            _transaction.product ?? _transaction.title,
            style: _theme.textTheme.titleMedium!.copyWith(color: _theme.colorScheme.darkGrayText,),
          ),
        ),
        subtitle: Text(
          "${_transaction.dateCreatedText} - ${_transaction.status}",
          style: _theme.textTheme.labelMedium!.copyWith(
            color: _theme.colorScheme.onBackground.withOpacity(0.5),
          ),
        ),
        trailing: Text(
          _transaction.priceText,
          style: _theme.textTheme.titleMedium!.copyWith(color: _theme.colorScheme.darkGrayText,),
        ),
        tileColor: Colors.transparent,
        onTap: () => Popup.showPaymentDetails(_transaction),
      ),
    );
  }
}
