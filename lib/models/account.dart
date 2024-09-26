import '../utils/dev-tools.dart';

class Account with MappedModel {
  final String name, accountNumber, maskedMobileNumber, serialNumber;

  Account._(
    this.name,
    this.accountNumber,
    this.maskedMobileNumber,
    this.serialNumber,
  );

  factory Account.fromMap(Map map) => Account._(
        map['name'],
        map['accountNumber'],
        map['mobileNumber'],
        map['serialNumber'],
      );

  @override
  Map toMap() => {
        "Name": name,
        "Account Number": accountNumber,
        "Masked Mobile Number": maskedMobileNumber,
        "Serial Number": serialNumber,
      };

  @override
  String toString() =>
      "ACCOUNT\nNAME: $name\nACCOUNT NUMBER: $accountNumber\nMASKED MOBILE NUMBER: $maskedMobileNumber\nSERIAL NUMBER: $serialNumber";
}
