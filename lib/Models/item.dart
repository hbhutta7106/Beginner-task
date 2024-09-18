class ItemModel {
  ItemModel(
      {required this.name,
      required this.quantity,
      required this.itemCode,
      this.image,
      required this.purchasedPrice});
  final String name;
  final int quantity;
  final int itemCode;
  String? image;
  final double purchasedPrice;

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'name': name});
    result.addAll({'quantity': quantity});
    result.addAll({'itemCode': itemCode});
    result.addAll({'image': image});
    result.addAll({'purchasedPrice': purchasedPrice});

    return result;
  }

  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
        name: map['name'] ?? '',
        quantity: map['quantity']?.toInt() ?? 0.0,
        itemCode: map['itemCode']?.toInt() ?? 0,
        image: map['image'],
        purchasedPrice:map['purchasedPrice']?.toDouble()??0.0,
        );
  }

  ItemModel copyWith(
      {String? name, int? quantity, int? itemCode, String? image, double? purchasedPrice}) {
    return ItemModel(
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      itemCode: itemCode ?? this.itemCode,
      image: image ?? this.image,
      purchasedPrice: purchasedPrice ?? this.purchasedPrice, 
    );
  }
}
