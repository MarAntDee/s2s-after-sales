import 'dart:math';

import 'package:flutter/material.dart';
import 'package:surf2sawa/blocs/auth.dart';
import 'package:surf2sawa/components/error.dart';
import 'package:surf2sawa/components/transaction-tile.dart';
import 'package:surf2sawa/theme/app.dart';
import 'package:surf2sawa/utils/api.dart';
import 'package:surf2sawa/utils/navigator.dart';

import '../models/transaction.dart';
import 'empty.dart';

class PaymentHistoryOverview extends StatelessWidget {
  const PaymentHistoryOverview({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    AuthBloc auth = AuthBloc.instance(context)!;

    return Center(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Payment History",
                  style: theme.textTheme.titleLarge!
                      .copyWith(fontWeight: FontWeight.w500, color: theme.colorScheme.darkGrayText,
                  ).apply(fontSizeDelta: -4),
                ),
                IconButton(
                  onPressed: auth.pushToJournal,
                  color: theme.colorScheme.secondary,
                  iconSize: 16,
                  icon: const Icon(
                    Icons.arrow_forward_rounded,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Transaction>>(
              future: ProdApi().getPaymentHistory(),
              builder: (context, transactions) {
                if (transactions.hasError) {
                  if (transactions.error?.toString() ==
                      "You are not allowed in this resource") {
                    auth.logout(autologout: true);
                  } else {
                    return ErrorDisplay.list(transactions.error);
                  }
                }
                if (!transactions.hasData) {
                  return const Center(
                    child: SizedBox.square(
                      dimension: 60,
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                if (transactions.data!.isEmpty) {
                  return EmptyDisplay.list(
                    "History is empty",
                    Icons.book_rounded,
                  );
                }
                return ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: [
                    ...transactions.data!
                        .sublist(0, min(transactions.data!.length, 5))
                        .map((tx) => TransactionTile(tx))
                        .toList(),
                    const SizedBox(height: 36),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
