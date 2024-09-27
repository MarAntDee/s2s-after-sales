import '../utils/dev-tools.dart';

class Account with MappedModel {
  final String name, accountNumber, maskedMobileNumber, serialNumber;

  String get accountNumberLabel => [
        accountNumber.substring(0, 5),
        accountNumber.substring(5, 9),
        accountNumber.substring(9)
      ].join(" ");

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
      "ACCOUNT\nNAME:${"\t" * 4}$name\nACCOUNT NUMBER:${"\t" * 4}$accountNumber\nMASKED MOBILE NUMBER:${"\t" * 4}$maskedMobileNumber\nSERIAL NUMBER:${"\t" * 4}$serialNumber";
}
