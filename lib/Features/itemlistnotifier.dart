import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_app/Models/item.dart';
import 'package:pos_app/Services/itemrepo.dart';

class ItemListNotifier extends StateNotifier<AsyncValue<List<ItemModel>>> {
  ItemListNotifier(super.state) {
    getAllUsersfromDatabase();
  }

  ItemRepository itemsRepo = ItemRepository();

  void addItem(ItemModel item) {
    state.whenData((items) {
      state = AsyncValue.data([...items, item]);
    });
  }

  void getAllUsersfromDatabase() async {
    final List<ItemModel>? items = await itemsRepo.getFromDatabase();
    if (items != null) {
      state = AsyncValue.data(items);
    }
  }

  void updateItemInTheList(ItemModel newItem, ItemModel oldItem) {
    state = state.whenData((items) {
      return items.map((item) {
        if (item.itemCode == oldItem.itemCode) {
          item = newItem;
          return item;
        } else {
          return item;
        }
      }).toList();
    });
  }

  void deleteItem(int itemCode) {
    state.whenData((items) {
      state = AsyncValue.data(
          items.where((item) => item.itemCode != itemCode).toList());
    });
  }

  bool checkItemExist(int  itemCode) {
    bool isExist = false;
    state.whenData((items) {
      for (int i = 0; i < items.length; i++) {
        if (items[i].itemCode == itemCode) {
          isExist = true;
        }
      }
    });
    return isExist;
  }
}
