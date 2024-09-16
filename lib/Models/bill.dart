
import 'package:pos_app/Models/billitem.dart';

class Bill {
  Bill(
      {required this.billItems,
      required this.totalBillAmount,
      required this.billNumber});
  final List<BillItem> billItems;
  final double totalBillAmount;
  final int billNumber;
  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'billItems': billItems.map((x) => x.toMap()).toList()});
    result.addAll({'totalBillAmount': totalBillAmount});
    result.addAll({'billNumber': billNumber});
  
    return result;
  }

  factory Bill.fromMap(Map<String, dynamic> map) {
    return Bill(
      billItems: 
      List<BillItem>.from(map['billItems']?.map((item) => BillItem.fromMap(item))??[]),
     totalBillAmount:  map['totalBillAmount']?.toDouble() ?? 0.0,
     billNumber:  map['billNumber']?.toInt() ?? 0,
    );
  }


  Bill copyWith({
    List<BillItem>? billItems,
    double? totalBillAmount,
    int? billNumber,
  }) {
    return Bill(
     billItems:  billItems ?? this.billItems,
    totalBillAmount:   totalBillAmount ?? this.totalBillAmount,
    billNumber:   billNumber ?? this.billNumber,
    );
  }
}
