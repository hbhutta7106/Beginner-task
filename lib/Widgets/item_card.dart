import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_app/Models/item.dart';
import 'package:pos_app/Providers/providers.dart';
import 'package:pos_app/Screens/addupdate.dart';
import 'package:pos_app/Widgets/dialog.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({super.key, required this.item, this.number, this.function});
  final ItemModel item;
  final int? number;
  final VoidCallback? function;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.deepPurple[50],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AspectRatio(
            aspectRatio: 1.4,
            child: SizedBox(
                child: item.image == null
                    ? const Center(child: Text("No image of the Item"))
                    : Image.memory(
                        base64Decode(item.image!),
                        fit: BoxFit.fitWidth,
                        width: 200,
                      )),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                item.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(
                height: 3,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Item Code "),
                  Text(
                    item.itemCode.toString(),
                    style: const TextStyle(
                        color: Color.fromARGB(253, 113, 135, 191),
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              const SizedBox(
                height: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Stock Available",
                  ),
                  Text(
                    item.quantity.toString(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(253, 113, 135, 191),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Consumer(
                builder: (context, ref, child) => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(40),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero, // No rounded corners
                      ),
                    ),
                    onPressed: () {
                      if (number == 2) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: SizedBox(
                                  height: 250,
                                  width: 300,
                                  child: alertDialog(context, function!),
                                ),
                              );
                            });
                      } else {
                        ref.read(itemModelProvider.notifier).loadUpState(item);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const AddUpdateScreen(whichScreen: 1);
                        }));
                      }
                    },
                    child: number != 2
                        ? const Text("Edit Item")
                        : const Text("Delete Item")),
              ),
            ]),
          )
        ],
      ),
    );
  }
}
