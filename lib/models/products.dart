class Product {
  final int sku;
  final String name;
  final String? description;
  final double price;

  Product._(this.sku, this.name, this.description, this.price);

  Product.fromMap(Map map)
      : this._(
          int.parse(map['skuId']),
          map['name'],
          map['description'],
          double.tryParse(map['price']) ?? 0,
        );
}
