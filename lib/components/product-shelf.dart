import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:surf2sawa/blocs/auth.dart';
import 'package:surf2sawa/components/checkout-counter.dart';
import 'package:surf2sawa/components/dialogs.dart';
import 'package:surf2sawa/components/empty.dart';
import 'package:surf2sawa/components/error.dart';
import 'package:surf2sawa/theme/app.dart';
import 'package:surf2sawa/theme/icons.dart';

import '../blocs/shopkeeper.dart';
import '../models/products.dart';

class ProductShelf extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Product? initialProduct;
  final FormFieldValidator<Product>? validator;
  final FormFieldSetter<Product>? onSaved;
  ProductShelf({super.key, this.validator, this.onSaved, this.initialProduct});

  @override
  Widget build(BuildContext context) {
    AuthBloc auth = AuthBloc.instance(context)!;
    ThemeData theme = Theme.of(context);
    ShopKeeper shopkeeper = ShopKeeper.instance(context)!;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: FutureBuilder<List<Product>>(
                future: shopkeeper.getProductList,
                builder: (context, products) {
                  if (products.hasError) {
                    if (products.error?.toString() ==
                        "You are not allowed in this resource") {
                      auth.logout(autologout: true);
                    } else {
                      return ErrorDisplay.list(products.error);
                    }
                  }
                  if (!products.hasData) {
                    return const Center(
                      child: SizedBox.square(
                        dimension: 60,
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  if (products.data!.isEmpty) {
                    return EmptyDisplay.list(
                      "Shop is empty",
                      Icons.shopping_basket_rounded,
                    );
                  }
                  return FormField<Product>(
                    initialValue: initialProduct,
                    validator: validator,
                    onSaved: onSaved,
                    builder: (state) => Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ListView(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 30.0),
                                child: Text(
                                  state.errorText ?? "",
                                  style: Theme.of(state.context)
                                      .textTheme
                                      .caption!
                                      .apply(
                                        color:
                                            Theme.of(state.context).errorColor,
                                      ),
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: products.data!.map(
                                  (product) {
                                    return ProductCard(product);
                                  },
                                ).toList(),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 30.0,
                                    bottom: state.hasError ? 20 : 0),
                                child: Text(
                                  state.errorText ?? "",
                                  style: Theme.of(state.context)
                                      .textTheme
                                      .caption!
                                      .apply(
                                        color:
                                            Theme.of(state.context).errorColor,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      height: 120,
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.highlightColor.withOpacity(0.25),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                product.name,
                style: theme.textTheme.titleSmall,
              ),
            ],
          ),
          const SizedBox(height: 4),
          if (product.hasDescription)
            Row(
              children: [
                Icon(
                  IconLibrary.check_sharp,
                  size: 16,
                  color: theme.colorScheme.secondary,
                ),
                Expanded(
                  child: Text(
                    product.description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall!.copyWith(
                      color: theme.colorScheme.onBackground.withOpacity(0.6),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          Expanded(
            child: Row(
              children: [
                Text(
                  NumberFormat('₱#,##0.00').format(product.price),
                  style: theme.textTheme.bodyLarge!.copyWith(
                    color: theme.colorScheme.darkGrayText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: 60,
                  child: Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 12),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      onPressed: () {
                        ShopKeeper _shopkeeper = ShopKeeper.instance(context)!;
                        _shopkeeper.selectedProduct = product;
                        CheckoutCounter.show(_shopkeeper);
                      },
                      child: const Text("Buy"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
