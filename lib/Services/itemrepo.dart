import 'package:pos_app/Models/item.dart';
import 'package:pos_app/Services/database.dart';

class ItemRepository {
  Future<int> addItem(ItemModel item) async {
    final database = await DatabaseService().getDatabase;
    int done = await database.insert('Items', item.toMap());
    return done;
  }

  Future<List<ItemModel>?> getFromDatabase() async {
    final database = await DatabaseService().getDatabase;
    final alluserMapList = await database.rawQuery("SELECT * FROM Items");
    if (alluserMapList.isNotEmpty) {
      List<ItemModel> items = alluserMapList.map((eachuserMap) {
        return ItemModel.fromMap(eachuserMap);
      }).toList();
      return items;
    } else {
      return null;
    }
  }

  Future<int> updateItemInTheDatabase(ItemModel item, int itemCode) async {
    final database = await DatabaseService().getDatabase;
    int done = await database.update("Items", item.toMap(),
        where: 'itemCode = ?', whereArgs: [itemCode]);

    return done;
  }

  Future<int> deleteItem(int itemCode) async {
    final database = await DatabaseService().getDatabase;
    int done = await database
        .delete('Items', where: 'itemCode = ?', whereArgs: [itemCode]);
    return done;
  }
}
