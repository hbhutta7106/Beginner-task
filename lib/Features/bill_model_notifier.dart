import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_app/Models/bill.dart';

class BillModelNotifier extends StateNotifier<Bill> {
  BillModelNotifier(super._state);

  void makeBill(Bill newBill) {
    state = newBill;
  }
}
