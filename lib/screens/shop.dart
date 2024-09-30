import 'package:flutter/material.dart';
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
        body: Center(
          child: ElevatedButton(
            onPressed: ProdApi().getProducts,
            child: Text("Get SKU List"),
          ),
        ),
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
