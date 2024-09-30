import 'dart:async';

import 'package:flutter/material.dart';
import 'package:s2s_after_sales/utils/api.dart';

import '../models/products.dart';
import 'base.dart';

class ShopKeeper implements BlocBase {
  //CART
  Product? product;
  final Completer<List<Product>> _productListCompleter =
      Completer<List<Product>>();
  Future<List<Product>> get getProductList => _productListCompleter.future;

  ShopKeeper._() {
    _productListCompleter.complete(ProdApi().getProducts());
  }

  @override
  void dispose() {}

  static Widget build({required Widget child}) => BlocProvider<ShopKeeper>(
        bloc: ShopKeeper._(),
        child: child,
      );

  static ShopKeeper? instance(BuildContext context) =>
      BlocProvider.of<ShopKeeper>(context);
}
