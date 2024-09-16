import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pos_app/Models/billitem.dart';
import 'package:pos_app/Models/item.dart';

class BillItemListNotifier extends StateNotifier<List<BillItem>> {
  BillItemListNotifier(super._state);

  void addBillItemInTheList(BillItem billItem) {
    state = [...state, billItem];
  }

  double? checkItemAvailableInTheBill(ItemModel item) {
    final existingItemIndex =
        state.indexWhere((billItem) => billItem.item.itemCode == item.itemCode);
    if (existingItemIndex == -1) {
      return null;
    } else {
      return state[existingItemIndex].billItemPrice;
    }
  }

  void deleteItem(BillItem item) {
    state = state
        .where((billItem) => billItem.item.itemCode != item.item.itemCode)
        .toList();
  }

  double calculateTheTotalBill() {
    double totalBillAmount = 0;
    for (int i = 0; i < state.length; i++) {
      totalBillAmount += state[i].billItemPrice*state[i].billItemQuantity;
    }
    return totalBillAmount;
  }
}
