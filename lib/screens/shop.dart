import 'package:flutter/material.dart';
import 'package:s2s_after_sales/blocs/shopkeeper.dart';
import 'package:s2s_after_sales/components/product-shelf.dart';
import 'package:s2s_after_sales/components/shop-counter.dart';

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
  ShopKeeper get _shopkeeper => ShopKeeper.instance(context)!;

  @override
  void initState() {
    _pages = [
      ProductShelf(
        initialProduct: _shopkeeper.selectedProduct,
        validator: (product) {
          if (product == null) {
            return "Please pick a SuperFiber prepaid plan";
          }
          return null;
        },
        onSaved: (product) {
          _shopkeeper.selectedProduct = product;
          setState(() => _index = 1);
        },
      ),
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
                _shopkeeper.selectedPaymentMethod = null;
                break;
              default:
                Navigator.of(context).pop();
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
