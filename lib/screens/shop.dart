import 'package:flutter/material.dart';
import 'package:s2s_after_sales/models/products.dart';
import 'package:s2s_after_sales/utils/api.dart';

import '../utils/navigator.dart';

class Shop extends StatelessWidget {
  const Shop({super.key});

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
        body: FutureBuilder<List<Product>>(
            future: ProdApi().getProducts(),
            builder: (context, products) {
              if (!products.hasData)
                return const Center(
                  child: SizedBox.square(
                    dimension: 60,
                    child: CircularProgressIndicator(),
                  ),
                );
              return ListView(
                children: products.data!
                    .map((product) => Text(product.toString()))
                    .toList(),
              );
            }),
      ),
    );
  }

  static route(RouteSettings settings) {
    return BlurredRouter(
      builder: (context) {
        return const Shop();
      },
      settings: settings,
    );
  }
}
