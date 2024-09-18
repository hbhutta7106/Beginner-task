import 'package:flutter/material.dart';

Widget container(String itemStock, String purchasedPrice) {
  return Container(
    height: 65,
    padding: const EdgeInsets.all(5.0),
    decoration: BoxDecoration(
      border: Border.all(),
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Item Stock"),
            Text(itemStock),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Item Purchased Price"),
            Text("Rs.$purchasedPrice"),
          ],
        ),
      ],
    ),
  );
}
