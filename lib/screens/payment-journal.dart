import 'package:flutter/material.dart';
import 'package:surf2sawa/blocs/auth.dart';
import 'package:surf2sawa/components/background.dart';
import 'package:surf2sawa/theme/app.dart';

import '../components/empty.dart';
import '../components/error.dart';
import '../components/transaction-tile.dart';
import '../models/transaction.dart';
import '../utils/api.dart';
import '../utils/navigator.dart';

class PaymentJournal extends StatelessWidget {
  const PaymentJournal({super.key});

  @override
  Widget build(BuildContext context) {
    AuthBloc auth = AuthBloc.instance(context)!;
    ThemeData theme = Theme.of(context);

    return PopScope(
      canPop: false,
      onPopInvoked: (canPop) {
        Navigator.of(context).popUntilRoot();
      },
      child: Background(
        fromTop: true,
        dotsPadding: 16,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text("Payment History"),
          ),
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 80),
                  Expanded(
                    child: Container(
                      color: theme.scaffoldBackgroundColor,
                      padding: const EdgeInsets.only(top: 80),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 600),
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
                                    .map((tx) => TransactionTile(tx))
                                    .toList(),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 40,
                left: 24,
                right: 24,
                height: 80,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          if (auth.currentAccount!.currentProduct != null) Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  auth.currentAccount!.currentProduct!.toString(),
                                  style: theme.textTheme.titleLarge!.copyWith(
                                    color: theme.colorScheme.darkGrayText,
                                    fontWeight: FontWeight.w700,
                                  ).apply(fontSizeDelta: -4),
                                ),
                                Text(
                                  auth.currentAccount!.expirationText!,
                                  style: theme.textTheme.labelSmall!.copyWith(
                                    color: (auth.currentAccount!.isExpired ?? true)
                                        ? theme.colorScheme.error
                                        : theme.colorScheme.lightGrayText,
                                ),
                                )
                              ],
                            ),
                          ),
                          if (auth.currentAccount!.currentProduct == null) Expanded(
                            child: Text(
                              "No Load Left?\nLet’s get you back online!",
                              textAlign: TextAlign.start,
                              style: theme.textTheme.bodySmall!.copyWith(
                                color: theme.colorScheme.darkGrayText,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: auth.pushToShop,
                            child: const SizedBox(
                              width: 80,
                              child: Center(
                                child: Text("Buy Load"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static route(RouteSettings settings) {
    return BlurredRouter(
      builder: (context) => const PaymentJournal(),
      settings: settings,
    );
  }
}
