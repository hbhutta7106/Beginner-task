import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pos_app/Models/billitem.dart';
import 'package:pos_app/Models/item.dart';
import 'package:pos_app/Providers/providers.dart';

class ItemController {
  static Future<File?> pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();

    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return null;
    return File(pickedFile.path);
  }

  static Future<String> convertImageIntoBase64String(File image) async {
    List<int> imagesBytes = await image.readAsBytes();
    String base64String = base64Encode(imagesBytes);
    return base64String;
  }

  static addItemInDatabase(String name, String? image, String stock, String code,
      BuildContext context, WidgetRef ref, double purchasedPrice) async {
    bool isExist =
        ref.read(allItemsProvider.notifier).checkItemExist(int.parse(code));
    if (isExist) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Item Already Exist with this Code !")));
    } else {
      ItemModel item = ItemModel(
          name: name,
          quantity: int.parse(stock),
          itemCode: int.parse(code),
          image: image,
          purchasedPrice: purchasedPrice
          );
      int done = await ref.read(itemRepositoryProvider).addItem(item);
      if (done > 0) {
        ref.read(allItemsProvider.notifier).addItem(item);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Item Inserted Succssfully")));
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Error : Try Again")));
        }
      }
    }
  }

  static updateItemInTheDatabase(WidgetRef ref, BuildContext context,
      String? name, String? image, String? stock, String code,String? purchasedPrice) async {
    final item = ref.read(itemModelProvider);
    
    final updatedItem = item.copyWith(
        name: name,
        quantity:stock!=null ? int.parse(stock):0,
        itemCode: int.parse(code),
        image: image,
        purchasedPrice:purchasedPrice!=null? double.parse(purchasedPrice):0,
        );
    int done = await ref
        .read(itemRepositoryProvider)
        .updateItemInTheDatabase(updatedItem, int.parse(code));
    if (done > 0) {
      if (context.mounted) {
        ref
            .read(allItemsProvider.notifier)
            .updateItemInTheList(updatedItem, item);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Item Updated Succssfully")));

        Future.delayed(const Duration(seconds: 1));
        Navigator.pop(context);
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Error : Try Again")));
      }
    }
  }

  static void deleteItem(
      WidgetRef ref, int itemCode, BuildContext context) async {
    int done = await ref.read(itemRepositoryProvider).deleteItem(itemCode);
    if (done > 0) {
      ref.read(allItemsProvider.notifier).deleteItem(itemCode);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Item deleted Succssfully")));
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Error! Try Again")));
        }
      }
    }
  }

  static int checkQuantity(ItemModel item, WidgetRef ref,
      List<ItemModel> listOfItems, BuildContext context) {
    int index = -1;
    for (int i = 0; i < listOfItems.length; i++) {
      if (listOfItems[i].itemCode == item.itemCode) {
        index = i;
      }
    }
    if (listOfItems[index].quantity < item.quantity) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text("Required Quantity is Greater than existing Quantity:")));
      return 1;
    } else {
      listOfItems[index]
          .copyWith(quantity: listOfItems[index].quantity - item.quantity);
      return 0;
    }
  }

  static void deleteItemFromTheList(
      BillItem billItem, WidgetRef ref, List<ItemModel> items) {
    final index = items.indexWhere((item) {
      return item.itemCode == billItem.item.itemCode;
    });
    final itemToBeRemove = items[index];
    final newItem = itemToBeRemove.copyWith(
        quantity: billItem.billItemQuantity + itemToBeRemove.quantity);
    ref
        .read(allItemsProvider.notifier)
        .updateItemInTheList(newItem, itemToBeRemove);

    ref.read(billItemListNotifierProvider.notifier).deleteItem(billItem);
  }
}
