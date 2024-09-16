import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pos_app/Controllers/itemcontroller.dart';
import 'package:pos_app/Models/item.dart';
import 'package:pos_app/Providers/providers.dart';
import 'package:pos_app/Widgets/item_card.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key, this.screen});

  final int? screen;

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  String searchQuery = ''; // New state to store the search query

  @override
  Widget build(BuildContext context) {
    AsyncValue<List<ItemModel>> listofItems = ref.watch(allItemsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Items"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: listofItems.when(
        data: (items) {
          if (items.isEmpty) {
            return const Center(
              child: Text("No Item Found"),
            );
          } else {
            // Filter items based on the search query
            List<ItemModel> filteredItems = searchQuery.isEmpty
                ? items
                : items.where((item) {
                    if (RegExp(r'^[0-9]').hasMatch(searchQuery)) {
                      return item.itemCode.toString().startsWith(searchQuery);
                    } else {
                      return item.name
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase());
                    }
                  }).toList();

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value; // Store the search query
                          });
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          hintText: "Search by Item Name or Code",
                          hintStyle: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.black38,
                          ),
                          suffixIcon: Icon(CupertinoIcons.search),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: GridView.builder(
                        itemCount: filteredItems.length,
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.7,
                          crossAxisCount: 2,
                        ),
                        itemBuilder: (context, i) {
                          return ItemCard(
                            item: filteredItems[i],
                            number: widget.screen,
                            function: () {
                              ref
                                  .read(itemModelProvider.notifier)
                                  .loadUpState(filteredItems[i]);
                              ItemController.deleteItem(
                                  ref, filteredItems[i].itemCode, context);
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
        loading: () {
          return const Center(
            child: SpinKitThreeInOut(
              color: Colors.blue,
              size: 30,
            ),
          );
        },
        error: (error, stackTrace) => Center(
          child: Text(
            'Error: $error',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
