

import 'package:pos_app/Models/item.dart';

class BillItem {
  final int billItemQuantity;
  final double billItemPrice;
  final ItemModel item;
  BillItem(
      {required this.item,
      required this.billItemPrice,
      required this.billItemQuantity});
  

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'billItemQuantity': billItemQuantity});
    result.addAll({'billItemPrice': billItemPrice});
    result.addAll({'item': item.toMap()});
  
    return result;
  }

  factory BillItem.fromMap(Map<String, dynamic> map) {
    return BillItem(
     billItemQuantity:  map['billItemQuantity']?.toInt() ?? 0,
     billItemPrice:  map['billItemPrice']?.toDouble() ?? 0.0,
     item:  ItemModel.fromMap(map['item']),
    );
  }

 

  BillItem copyWith({
    int? billItemQuantity,
    double? billItemPrice,
    ItemModel? item,
  }) {
    return BillItem(
     billItemQuantity:  billItemQuantity ?? this.billItemQuantity,
     billItemPrice:  billItemPrice ?? this.billItemPrice,
     item:  item ?? this.item,
    );
  }
}
