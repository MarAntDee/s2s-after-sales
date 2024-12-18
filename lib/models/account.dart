
import '../utils/dev-tools.dart';

class Account with MappedModel {
  final String name, accountNumber, maskedMobileNumber, serialNumber;
  final String? currentProduct,
      _productExpirationDate;
  final int? productDays, daysLeft;

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
    if (isExpired == null) {
      return null;
    } else if (isExpired!)
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
    this.daysLeft,
  );

  factory Account.fromMap(Map map) => Account._(
        map['name'],
        map['accountNumber'],
        map['mobileNumber'],
        map['serialNumber'],
        map['package']?['name'],
        map['package']?['expirationDateLabel'],
        map['package']?['noOfDays'],
        map['package']?['daysLeft'],
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
      };
}
