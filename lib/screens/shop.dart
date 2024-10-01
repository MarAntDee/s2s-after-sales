import 'package:flutter/material.dart';
import 'package:s2s_after_sales/blocs/shopkeeper.dart';
import 'package:s2s_after_sales/components/product-shelf.dart';
import 'package:s2s_after_sales/components/shop-counter.dart';
import 'package:s2s_after_sales/models/products.dart';

import '../utils/navigator.dart';

class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  State<Shop> createState() => _ShopState();

  static route(RouteSettings settings) {
    return BlurredRouter(
      builder: (context) => ShopKeeper.build(child: const Shop()),
      settings: settings,
    );
  }
}

class _ShopState extends State<Shop> {
  late List<Widget> _pages;
  int _index = 0;

  @override
  void initState() {
    _pages = [
      _ShopFloor(onCheckout: (product) => setState(() => _index = 1)),
      const ShopCounter(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left_rounded),
          onPressed: () {
            switch (_index) {
              case 1:
                setState(() => _index = 0);
                break;
              default:
                Navigator.of(context).popUntilHome();
                break;
            }
          },
        ),
        title: const Text("Buy Load"),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: _pages[_index],
        ),
      ),
    );
  }
}

class _ShopFloor extends StatelessWidget {
  final Function(Product)? onCheckout;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  _ShopFloor({super.key, this.onCheckout});

  @override
  Widget build(BuildContext context) {
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
                    initialProduct: shopkeeper.selectedProduct,
                    validator: (product) {
                      if (product == null) {
                        return "Please pick a SuperFiber prepaid plan";
                      }
                      return null;
                    },
                    onSaved: (product) {
                      shopkeeper.selectedProduct = product;
                      if (onCheckout != null) onCheckout!(product!);
                    },
                  );
                }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
    );
  }
}
