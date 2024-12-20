import 'package:intl/intl.dart';
import 'package:surf2sawa/utils/dev-tools.dart';

class Transaction with MappedModel {
  final int id, sku, _timestampCreated;
  final String accountNumber,
      title,
      paymentId,
      transactionNumber,
      paymentReferenceNumber,
      status,
      dateTimeCreatedText;
  final String? product;
  final double price;

  String get priceText => "₱\t${NumberFormat('#,##0.00').format(price)}";

  DateTime get dateCreated =>
      DateTime.fromMillisecondsSinceEpoch(_timestampCreated);
  String get dateCreatedText => DateFormat.MMMd().format(dateCreated);

  Transaction._(
    this.id,
    this.sku,
      this.product,
    this._timestampCreated,
    this.accountNumber,
    this.title,
    this.paymentId,
    this.transactionNumber,
    this.paymentReferenceNumber,
    this.status,
    this.dateTimeCreatedText,
    this.price,
  );

  factory Transaction.fromMap(Map map) => Transaction._(
      int.parse(map['_id'].toString()),
      int.parse(map['skuId'].toString()),
      map['skuName'],
      int.parse(map['createdDate'].toString()),
      map['accountNumber'].toString(),
      map['title'] ?? "Unknown Transaction",
      map['paymentId'].toString(),
      map['transactionNumber'].toString(),
      map['paymentReferenceNumber'].toString(),
      map['status'].toString(),
      map['createdDateTimeLabel'].toString(),
      (double.tryParse(map['price'].toString()) ?? 0));

  @override
  Map toMap() => {
        "Price": priceText,
        "Account Number": accountNumber,
        "Status": status,
        "Payment ID": paymentId,
        "Transaction Number": transactionNumber,
        "Date Created": dateTimeCreatedText,
      };
}
