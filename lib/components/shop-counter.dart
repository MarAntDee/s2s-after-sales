import 'package:flutter/material.dart';
import 'package:s2s_after_sales/blocs/shopkeeper.dart';
import 'package:s2s_after_sales/components/product-shelf.dart';
import 'package:s2s_after_sales/utils/api.dart';

class ShopCounter extends StatelessWidget {
  const ShopCounter({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ShopKeeper shopKeeper = ShopKeeper.instance(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SizedBox(height: 60),
        Text(
          "Make sure the details are correct",
          style: theme.textTheme.titleMedium!
              .copyWith(fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 50),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(
            "Purchase Summary",
            style: theme.textTheme.bodyLarge,
          ),
        ),
        const SizedBox(height: 24),
        ProductCard(shopKeeper.selectedProduct!, selected: true),
        const SizedBox(height: 16),
        ...{
          'Account Due': shopKeeper.selectedProduct!.price,
        }
            .entries
            .map(
              (entry) => Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry.key,
                      style: theme.textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      entry.value.toString(),
                      style: theme.textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: ElevatedButton(
            onPressed: ProdApi().getPaymentMethods,
            child: const Text("Buy Load"),
          ),
        ),
      ],
    );
  }
}
