import 'dart:math';

import '../utils/dev-tools.dart';

class Account with MappedModel {
  final String name, accountNumber, maskedMobileNumber, serialNumber;
  final String? currentProduct,
      _productExpirationDate,
      outageTitle,
      outageDescription;
  final bool? hasOutage;
  final int? productDays;

  int? get daysLeft {
    if (productDays == null || _productExpirationDate == null) return null;
    int _daysLeft = productExpirationDate!.difference(DateTime.now()).inDays;
    return max(0, _daysLeft);
  }

  String get accountNumberLabel => [
        accountNumber.substring(0, 5),
        accountNumber.substring(5, 9),
        accountNumber.substring(9)
      ].join(" ");

  DateTime? get productExpirationDate =>
      DateTime.tryParse(_productExpirationDate.toString());

  bool? get isExpired {
    if (productExpirationDate == null) return null;
    return productExpirationDate!.isBefore(DateTime.now());
  }

  String? get expirationText {
    if (isExpired == null)
      return null;
    else if (isExpired!)
      return "expired last $_productExpirationDate";
    else
      return "will expire on $_productExpirationDate";
  }

  Account._(
    this.name,
    this.accountNumber,
    this.maskedMobileNumber,
    this.serialNumber,
    this.currentProduct,
    this._productExpirationDate,
    this.productDays,
    this.hasOutage,
    this.outageTitle,
    this.outageDescription,
  );

  factory Account.fromMap(Map map) => Account._(
        map['name'],
        map['accountNumber'],
        map['mobileNumber'],
        map['serialNumber'],
        map['package']?['name'],
        map['package']?['expirationDateLabel'],
        map['Package']?['noOfDays'] ?? 7,
        map['outage']?['status'],
        map['outage']?['title'],
        map['outage']?['description'],
      );

  @override
  Map toMap() => {
        "Name": name,
        "Account Number": accountNumber,
        "Masked Mobile Number": maskedMobileNumber,
        "Serial Number": serialNumber,
        if (currentProduct != null) "Current Product": currentProduct,
        if (_productExpirationDate != null)
          "Expiration Date": _productExpirationDate,
        "Has Outage": hasOutage,
        if (outageTitle != null) "Outage Title": outageTitle,
        if (outageDescription != null) "Outage Description": outageDescription,
      };
}
