import 'package:flutter/material.dart';
import 'package:s2s_after_sales/components/transaction-tile.dart';
import 'package:s2s_after_sales/utils/api.dart';

import '../models/transaction.dart';

class PaymentHistoryOverview extends StatelessWidget {
  const PaymentHistoryOverview({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
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
                    onTap: ProdApi().getPaymentHistory,
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
                  if (!transactions.hasData) {
                    return const Center(
                      child: SizedBox.square(
                        dimension: 60,
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  return ListView(
                    children: transactions.data!
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
