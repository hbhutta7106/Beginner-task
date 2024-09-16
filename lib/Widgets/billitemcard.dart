import 'package:flutter/material.dart';
import 'package:pos_app/Models/billitem.dart';

class BillItemCard extends StatelessWidget {
  const BillItemCard({super.key, required this.item, required this.callback});
  final BillItem item;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), color: Colors.grey[350]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item.item.name),
              IconButton(
                  onPressed: callback,
                  icon: const Icon(Icons.delete_forever_rounded)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Price of the Item",
              ),
              const SizedBox(
                width: 20,
              ),
              Text("Rs.${item.billItemPrice}",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Quantity of the Item"),
              const SizedBox(
                width: 20,
              ),
              Text(item.billItemQuantity.toString(),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}
