import 'dart:math';

import 'package:flutter/material.dart';
import 'package:surf2sawa/blocs/shopkeeper.dart';
import 'package:surf2sawa/components/background.dart';
import 'package:surf2sawa/components/product-shelf.dart';
import 'package:surf2sawa/components/shop-counter.dart';

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
  Size get _screen => MediaQuery.sizeOf(context);
  ThemeData get _theme => Theme.of(context);

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
    return PopScope(
      canPop: (false),
      onPopInvoked: (canPop) {
        Navigator.of(context).popUntilRoot();
      },
      child: Background(
        end: const Alignment(1, 0),
        fromTop: true,
        dotsPadding: 30,
        dotsHeight: _screen.height/3,
        child: Scaffold(
          backgroundColor: Colors.transparent,
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
                    Navigator.of(context).maybePop();
                    break;
                }
              },
            ),
            title: const Text("Buy Load"),
          ),
          body: Column(
            children: [
              const SizedBox(height: 30),
              Expanded(
                child: Container(
                  color: _theme.scaffoldBackgroundColor,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          maxWidth: 600, minHeight: max(_screen.height, 800)),
                      child: _pages[_index],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
