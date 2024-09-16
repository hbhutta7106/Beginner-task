import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_app/Models/bill.dart';
import 'package:pos_app/Models/billitem.dart';
import 'package:pos_app/Models/item.dart';
import 'package:pos_app/Providers/providers.dart';
import 'package:pos_app/Services/psdservice.dart';

class BillItemController {
  void addItemInTheBill(
      String billItemPrice,
      String billItemQuantity,
      ItemModel item,
      WidgetRef ref,
      List<ItemModel> items,
      BuildContext context) {
    ItemModel oldItem;
    ItemModel newUpdatedItem;
    int index = -1;

    for (int i = 0; i < items.length; i++) {
      if (items[i].itemCode == item.itemCode) {
        index = i;
      }
    }
    oldItem = items[index];
    if (items[index].quantity < int.parse(billItemQuantity)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(
              "We have ${items[index].quantity} ${items[index].name} Items")));
    } else {
      newUpdatedItem = items[index].copyWith(
          quantity: items[index].quantity - int.parse(billItemQuantity));
      ref
          .read(allItemsProvider.notifier)
          .updateItemInTheList(newUpdatedItem, oldItem);

      BillItem billItem = BillItem(
          item: item,
          billItemPrice: double.parse(billItemPrice),
          billItemQuantity: int.parse(billItemQuantity));
      ref
          .read(billItemListNotifierProvider.notifier)
          .addBillItemInTheList(billItem);
    }
  }

  double calculateBillTotalAmount(String discountPrice, WidgetRef ref) {
    double totalAmount =
        ref.read(billItemListNotifierProvider.notifier).calculateTheTotalBill();

    if (double.parse(discountPrice) <= 0) {
      return totalAmount;
    } else {
      return totalAmount - double.parse(discountPrice);
    }
  }
  


  void generateBill(
      List<BillItem> billItems, double totalAmount, int billNumber,double discountAmount) async {
    Bill bill = Bill(
        billItems: billItems,
        totalBillAmount: totalAmount,
        billNumber: billNumber);
    PdfService pdfFile = PdfService();
    final generatedPdf = await pdfFile.createThePdfFile(bill,discountAmount);
    pdfFile.saveTheFileInTheDevice(billNumber, generatedPdf);

  }
}
