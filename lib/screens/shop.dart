import 'package:flutter/material.dart';
import 'package:s2s_after_sales/components/product-shelf.dart';
import 'package:s2s_after_sales/models/products.dart';
import 'package:s2s_after_sales/utils/api.dart';

import '../utils/navigator.dart';

class Shop extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Shop({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (canPop) {
        if (!canPop) Navigator.of(context).popUntilHome();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Buy Load"),
        ),
        body: Form(
          key: _formKey,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: FutureBuilder<List<Product>>(
                        future: ProdApi().getProducts(),
                        builder: (context, products) {
                          if (!products.hasData) {
                            return const Center(
                              child: SizedBox.square(
                                dimension: 60,
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          return ProductShelf(
                            products.data!,
                            validator: (product) {
                              if (product == null) {
                                return "Please pick a SuperFiber prepaid plan";
                              }
                              return null;
                            },
                            onSaved: (product) {},
                          );
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                        }
                      },
                      child: const Text("Next"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static route(RouteSettings settings) {
    return BlurredRouter(
      builder: (context) {
        return Shop();
      },
      settings: settings,
    );
  }
}
