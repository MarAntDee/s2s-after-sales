import 'dart:math';

import 'package:flutter/material.dart';
import 'package:s2s_after_sales/blocs/auth.dart';
import 'package:s2s_after_sales/components/error.dart';
import 'package:s2s_after_sales/components/transaction-tile.dart';
import 'package:s2s_after_sales/utils/api.dart';
import 'package:s2s_after_sales/utils/navigator.dart';

import '../models/transaction.dart';
import 'empty.dart';

class PaymentHistoryOverview extends StatelessWidget {
  const PaymentHistoryOverview({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    AuthBloc auth = AuthBloc.instance(context)!;

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 20),
        constraints: const BoxConstraints(
          maxWidth: 720,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Payment History",
                  style: theme.textTheme.titleMedium!
                      .copyWith(fontWeight: FontWeight.w700),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: Navigator.of(context).pushToPaymentJournal,
                    borderRadius: BorderRadius.circular(15),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "See all",
                            style: theme.textTheme.titleSmall,
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: theme.colorScheme.secondary,
                            ),
                            child: const Center(
                                child: Icon(
                              Icons.arrow_forward_rounded,
                              size: 12,
                              color: Colors.white,
                            )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
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
                    children: transactions.data!
                        .sublist(0, min(transactions.data!.length, 5))
                        .map((tx) => TransactionTile(tx))
                        .toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
