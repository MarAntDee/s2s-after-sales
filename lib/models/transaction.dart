import 'package:s2s_after_sales/utils/dev-tools.dart';

class Transaction with MappedModel {
  final int id, sku, _timestampCreated;
  final String accountNumber,
      paymentId,
      transactionNumber,
      paymentReferenceNumber,
      status,
      dateCreatedText;
  final double price;

  DateTime get dateCreated =>
      DateTime.fromMillisecondsSinceEpoch(_timestampCreated);

  Transaction._(
    this.id,
    this.sku,
    this._timestampCreated,
    this.accountNumber,
    this.paymentId,
    this.transactionNumber,
    this.paymentReferenceNumber,
    this.status,
    this.dateCreatedText,
    this.price,
  );

  factory Transaction.fromMap(Map map) => Transaction._(
      int.parse(map['_id'].toString()),
      int.parse(map['skuId'].toString()),
      int.parse(map['createdDate'].toString()),
      map['accountNumber'].toString(),
      map['paymentId'].toString(),
      map['transactionNumber'].toString(),
      map['paymentReferenceNumber'].toString(),
      map['status'].toString(),
      map['createdDateTimeLabel'].toString(),
      (double.tryParse(map['price'].toString()) ?? 0));

  @override
  Map toMap() => {
        "ID": id,
        "Sku": sku,
        "Price": price,
        "Account Number": accountNumber,
        "Status": status,
        "Payment ID": paymentId,
        "Payment Reference Number": paymentReferenceNumber,
        "Transaction Number": transactionNumber,
        "Date Created": dateCreatedText,
      };
}
