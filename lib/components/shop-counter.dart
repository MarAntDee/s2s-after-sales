import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:s2s_after_sales/blocs/auth.dart';
import 'package:s2s_after_sales/blocs/shopkeeper.dart';
import 'package:s2s_after_sales/components/dialogs.dart';
import 'package:s2s_after_sales/components/product-shelf.dart';
import 'package:s2s_after_sales/models/payment-method.dart';
import 'package:s2s_after_sales/utils/api.dart';

class ShopCounter extends StatefulWidget {
  const ShopCounter({super.key});

  @override
  State<ShopCounter> createState() => _ShopCounterState();
}

class _ShopCounterState extends State<ShopCounter> {
  AuthBloc get auth => AuthBloc.instance(context)!;
  ThemeData get theme => Theme.of(context);
  ShopKeeper get shopKeeper => ShopKeeper.instance(context)!;

  String get priceText => shopKeeper.selectedProduct?.price == null
      ? "--"
      : NumberFormat('#,##0.00').format(shopKeeper.selectedProduct!.price);
  String get convenienceFeeText => (shopKeeper.selectedPaymentMethod
                  ?.convenienceFee(shopKeeper.selectedProduct?.price ?? 0) ??
              0) ==
          0
      ? "--"
      : NumberFormat('#,##0.00').format(
          shopKeeper.selectedPaymentMethod!
              .convenienceFee(shopKeeper.selectedProduct!.price),
        );
  String get totalPriceText {
    double basePrice = double.tryParse(priceText) ?? 0,
        convenienceFee = double.tryParse(convenienceFeeText) ?? 0;
    return NumberFormat('#,##0.00').format(basePrice + convenienceFee);
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 800),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 32),
            Text(
              "Make sure the details are correct",
              style: theme.textTheme.titleMedium!
                  .copyWith(fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
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
            Text(
              "\t\t\t\tSelect Payment Method",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const Divider(indent: 8, endIndent: 8),
            SizedBox(
              height: 360,
              child: FutureBuilder<List<PaymentMethod>>(
                future: shopKeeper.getPaymentMethodList,
                builder: (context, paymentMethods) {
                  if (paymentMethods.error?.toString() ==
                      "You are not allowed in this resource") {
                    auth.logout(autologout: true);
                  }
                  if (!paymentMethods.hasData) {
                    return const Center(
                      child: SizedBox.square(
                        dimension: 60,
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  return ListView(
                    physics: const ClampingScrollPhysics(),
                    children: paymentMethods.data!
                        .map<Widget>(
                          (paymentMethod) => RadioListTile<PaymentMethod>(
                            title: Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black54, width: 1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: Image(
                                      image: paymentMethod.image,
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(paymentMethod.name),
                              ],
                            ),
                            onChanged: (paymentMethod) => setState(() =>
                                shopKeeper.selectedPaymentMethod =
                                    paymentMethod),
                            value: paymentMethod,
                            groupValue: shopKeeper.selectedPaymentMethod,
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ),
            const Divider(indent: 8, endIndent: 8),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: Row(
                children: [
                  const Text("Subtotal:"),
                  const Spacer(),
                  Text(priceText),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: Row(
                children: [
                  const Text("Convenience fee:"),
                  const Spacer(),
                  Text(convenienceFeeText),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Text(
                    "Total:",
                    style: theme.textTheme.headlineSmall,
                  ),
                  const Spacer(),
                  Text(
                    totalPriceText,
                    style: theme.textTheme.headlineMedium!
                        .copyWith(color: theme.colorScheme.secondary),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16)
                  .copyWith(bottom: 32),
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    if (shopKeeper.selectedProduct == null)
                      throw "Please select a product to purchase";
                    if (shopKeeper.selectedPaymentMethod == null)
                      throw "Please select your preferred payment method";
                    await ProdApi().purchase(shopKeeper.selectedProduct!,
                        shopKeeper.selectedPaymentMethod!);
                  } catch (e) {
                    if (e.toString() ==
                        "You are not allowed in this resource") {
                      auth.logout(autologout: true);
                    } else {
                      Popup.showError(e);
                    }
                  }
                },
                child: const Text("Buy Load"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
