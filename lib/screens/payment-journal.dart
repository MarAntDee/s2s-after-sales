import 'package:flutter/material.dart';
import 'package:surf2sawa/blocs/auth.dart';

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

    return PopScope(
      canPop: false,
      onPopInvoked: (canPop) {
        Navigator.of(context).popUntilRoot();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.chevron_left_rounded),
              onPressed: Navigator.of(context).maybePop),
          title: const Text("Payment History"),
        ),
        body: Center(
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
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListView(
                    children: transactions.data!
                        .map((tx) => TransactionTile(tx))
                        .toList(),
                  ),
                );
              },
            ),
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
