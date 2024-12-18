import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:surf2sawa/utils/dev-tools.dart';

class PaymentMethod with MappedModel {
  final int id;
  final String name, code;
  final double transferFeeRate;
  final double? minTransferFee, additionalFee, minValue, maxValue;
  final bool enableFee;

  String get _imageDir => "assets/images/$code.png";
  ImageProvider get image => AssetImage(_imageDir);

  double convenienceFee(double amount) {
    if (!enableFee) return 0;
    if (additionalFee != null) return additionalFee! + transferFeeRate * amount;
    if (minTransferFee != null) {
      return max(minTransferFee!, transferFeeRate * amount);
    }
    return 0;
  }

  PaymentMethod._(
    this.id,
    this.name,
    this.code,
    this.transferFeeRate,
    this.minTransferFee,
    this.additionalFee,
    this.minValue,
    this.maxValue,
    this.enableFee,
  );

  factory PaymentMethod.fromMap(Map map) => PaymentMethod._(
        int.parse(map['_id'].toString()),
        map['name'].toString(),
        map['code'].toString(),
        (double.tryParse(map['transferFee'].toString()) ?? 0) / 100,
        double.tryParse(map['minTransferFee'].toString()),
        double.tryParse(map['additionalFee'].toString()),
        double.tryParse(map['minValue'].toString()),
        double.tryParse(map['maxValue'].toString()),
        map['enableFee'] ?? false,
      );

  @override
  Map toMap() => {
        "ID": id,
        "Name": name,
        "Code": code,
        "Transfer Fee Rate": transferFeeRate,
        "Enable Fee": enableFee,
        "Image Directory": _imageDir,
        if (minTransferFee != null) "Minimum Transfer Fee": minTransferFee,
        if (additionalFee != null) "Additional Fee": additionalFee,
        if (minValue != null) "Minimum Value": minValue,
        if (maxValue != null) "Maximum Value": maxValue,
      };
}
