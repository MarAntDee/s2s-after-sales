import '../utils/dev-tools.dart';

class Product with MappedModel {
  final int sku;
  final String name;
  final String? description;
  final double price;

  bool get hasDescription => description != null;

  Product._(this.sku, this.name, this.description, this.price);

  Product.fromMap(Map map)
      : this._(
          int.parse(map['skuId']),
          map['name'],
          map['description'],
          double.tryParse(map['price']) ?? 0,
        );

  @override
  Map toMap() => {
        "SKU": sku,
        "Name": name,
        if (description != null) "Description": description,
        "Price": price,
      };
}
