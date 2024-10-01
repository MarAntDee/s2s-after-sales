import 'dart:async';

import 'package:flutter/material.dart';
import 'package:s2s_after_sales/utils/api.dart';

import '../models/payment-method.dart';
import '../models/products.dart';
import 'base.dart';

class ShopKeeper implements BlocBase {
  //CART
  Product? selectedProduct;
  final Completer<List<Product>> _productListCompleter =
      Completer<List<Product>>();
  Future<List<Product>> get getProductList => _productListCompleter.future;

  //PAYMENT METHOD
  PaymentMethod? selectedPaymentMethod;
  final Completer<List<PaymentMethod>> _paymentMethodListCompleter =
      Completer<List<PaymentMethod>>();
  Future<List<PaymentMethod>> get getPaymentMethodList =>
      _paymentMethodListCompleter.future;

  ShopKeeper._() {
    _productListCompleter.complete(ProdApi().getProducts());
    _paymentMethodListCompleter.complete(ProdApi().getPaymentMethods());
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
