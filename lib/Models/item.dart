class ItemModel {
  ItemModel(
      {required this.name,
      required this.quantity,
      required this.itemCode,
      required this.image});
  final String name;
  final int quantity;
  final int itemCode;
  final String image;

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'name': name});
    result.addAll({'quantity': quantity});
    result.addAll({'itemCode': itemCode});
    result.addAll({'image': image});

    return result;
  }

  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      name: map['name'] ?? '',
      quantity: map['quantity']?.toInt() ?? 0.0,
      itemCode: map['itemCode']?.toInt() ?? 0,
      image: map['image'] ?? "",
    );
  }

  ItemModel copyWith(
      {String? name, int? quantity, int? itemCode, String? image}) {
    return ItemModel(
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      itemCode: itemCode ?? this.itemCode,
      image: image ?? this.image,
    );
  }
}
