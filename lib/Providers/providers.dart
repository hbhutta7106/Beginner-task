import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_app/Controllers/billitemcontroller.dart';
import 'package:pos_app/Features/bill_model_notifier.dart';
import 'package:pos_app/Features/billitemlistnotifier.dart';
import 'package:pos_app/Features/itemlistnotifier.dart';
import 'package:pos_app/Features/itemnotifier.dart';
import 'package:pos_app/Models/bill.dart';
import 'package:pos_app/Models/billitem.dart';
import 'package:pos_app/Models/item.dart';
import 'package:pos_app/Services/itemrepo.dart';

final itemRepositoryProvider = Provider((ref) {
  return ItemRepository();
});

final itemModelProvider = StateNotifierProvider<ItemNotifier, ItemModel>((ref) {
  ItemModel item = ItemModel(image: "", name: "", quantity: 0, itemCode: 0,purchasedPrice: 0.0);
  return ItemNotifier(item);
});

final allItemsProvider =
    StateNotifierProvider<ItemListNotifier, AsyncValue<List<ItemModel>>>((ref) {
  return ItemListNotifier(const AsyncValue.loading());
});

final billItemListNotifierProvider =
    StateNotifierProvider<BillItemListNotifier, List<BillItem>>((ref) {
  return BillItemListNotifier([]);
});

final billItemControllerNotifier = Provider((ref) {
  return BillItemController();
});
final billModelProvider = StateNotifierProvider<BillModelNotifier, Bill>((ref) {
  Bill bill = Bill(billItems: [], billNumber: 1, totalBillAmount: 0.0);
  return BillModelNotifier(bill);
});
