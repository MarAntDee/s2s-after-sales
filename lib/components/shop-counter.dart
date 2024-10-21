import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:surf2sawa/blocs/auth.dart';
import 'package:surf2sawa/blocs/shopkeeper.dart';
import 'package:surf2sawa/components/dialogs.dart';
import 'package:surf2sawa/components/product-shelf.dart';
import 'package:surf2sawa/models/payment-method.dart';
import 'package:surf2sawa/theme/app.dart';
import 'package:surf2sawa/utils/api.dart';

class CheckoutCounter extends StatefulWidget {
  final ShopKeeper shopKeeper;
  const CheckoutCounter(this.shopKeeper, {super.key});

  @override
  State<CheckoutCounter> createState() => _CheckoutCounterState();
}

class _CheckoutCounterState extends State<CheckoutCounter> {
  ShopKeeper get shopKeeper => widget.shopKeeper;
  AuthBloc get auth => AuthBloc.instance(context)!;
  ThemeData get theme => Theme.of(context);

  bool _isLoading = false;

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
    double basePrice = double.tryParse(priceText.replaceAll(",", "")) ?? 0,
        convenienceFee = double.tryParse(convenienceFeeText) ?? 0;
    return NumberFormat('#,##0.00').format(basePrice + convenienceFee);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Text(
                    "Choose payment method",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: theme.colorScheme.darkGrayText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: Navigator.of(context).pop,
                    icon: Icon(Icons.close, color: theme.colorScheme.darkGrayText.withOpacity(0.4),),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
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
                                    (paymentMethod) =>
                                        RadioListTile<PaymentMethod>(
                                      title: Row(
                                        children: [
                                          Container(
                                            width: 60,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black54,
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(4),
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
                                      groupValue:
                                          shopKeeper.selectedPaymentMethod,
                                    ),
                                  )
                                  .toList(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
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
                      style: theme.textTheme.titleLarge!
                          .copyWith(color: theme.colorScheme.primary),
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
                      setState(() => _isLoading = true);
                      if (shopKeeper.selectedProduct == null)
                        throw "Please select a product to purchase";
                      if (shopKeeper.selectedPaymentMethod == null)
                        throw "Please select your preferred payment method";
                      await ProdApi().purchase(shopKeeper.selectedProduct!,
                          shopKeeper.selectedPaymentMethod!);
                      setState(() => _isLoading = false);
                    } catch (e) {
                      setState(() => _isLoading = false);
                      if (e.toString() ==
                          "You are not allowed in this resource") {
                        auth.logout(autologout: true);
                      } else {
                        Popup.showError(e);
                      }
                    }
                  },
                  child: const Text("Proceed Payment"),
                ),
              ),
            ],
          ),
        ),
        // if (_isLoading)
        //   Positioned.fill(
        //     child: Container(
        //       color: Colors.white54,
        //       child: Center(
        //         child: SizedBox.square(
        //           dimension: 60,
        //           child: CircularProgressIndicator(
        //             color: theme.colorScheme.secondary,
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
      ],
    );
  }
}
