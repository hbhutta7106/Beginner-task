import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_app/Models/item.dart';

class ItemNotifier extends StateNotifier<ItemModel> {
  ItemNotifier(super._state);

  void loadUpState(ItemModel item) {
    state = item;
  }
  
}
