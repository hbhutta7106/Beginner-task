import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pos_app/Controllers/itemcontroller.dart';
import 'package:pos_app/Models/item.dart';
import 'package:pos_app/Providers/providers.dart';
import 'package:pos_app/Widgets/billitemcard.dart';

class BillScreen extends ConsumerStatefulWidget {
  const BillScreen({super.key});

  @override
  ConsumerState<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends ConsumerState<BillScreen> {
  int billNumber = 1;
  List<ItemModel> items = [];
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _disCountController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  ItemModel? selectedItem;
  bool isPriceHide = false;
  bool isQuantityHide = false;
  bool isItemExist = false;
  @override
  void initState() {
    _disCountController.text = '0';
    super.initState();
    _quantityController.text = "1";
  }

  String? selectedValue;
  @override
  Widget build(BuildContext context) {
    final list = ref.watch(allItemsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bill Screen"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: list.when(
        data: (items) {
          if (items.isEmpty) {
            return const Center(
              child: Text("No Item to Generate Bill"),
            );
          } else {
            return SafeArea(
                child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: DropdownButton(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          hint: const Text("Select Item"),
                          value: selectedItem?.name,
                          underline: const SizedBox(),
                          isExpanded: true,
                          dropdownColor: Colors.cyanAccent,
                          items: items
                              .map((item) => DropdownMenuItem(
                                  value: item.name,
                                  onTap: () {
                                    setState(() {
                                      selectedItem = item;
                                    });

                                    final price = ref
                                        .read(billItemListNotifierProvider
                                            .notifier)
                                        .checkItemAvailableInTheBill(
                                            selectedItem!);
                                    if (price != null) {
                                      setState(() {
                                        isPriceHide = true;
                                        isQuantityHide = true;
                                        _quantityController.text = '1';
                                        _priceController.text =
                                            price.toString();
                                        isItemExist = true;
                                      });
                                    } else {
                                      setState(() {
                                        _priceController.text = "";
                                        isItemExist = false;
                                        isPriceHide = true;
                                      });
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Item ",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        item.name,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  )))
                              .toList(),
                          onChanged: (value) {}),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    if (isPriceHide)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text(
                            "Price of Item:",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextField(
                              readOnly: isItemExist == true ? true : false,
                              onChanged: (value) =>
                                  _priceController.text = value,
                              controller: _priceController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Enter price",
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              if (_priceController.text.isEmpty ||
                                  double.parse(_priceController.text) < 0) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                        backgroundColor: Colors.red,
                                        content: Text(
                                          "Please Provide the Price First",
                                          maxLines: 2,
                                          overflow: TextOverflow.fade,
                                          style: TextStyle(
                                              backgroundColor: Colors.red),
                                        )));
                              } else {
                                setState(() {
                                  isQuantityHide = true;
                                  _quantityController.text = '1';
                                });
                              }
                            },
                            child: const Text("Done"),
                          ),
                        ],
                      ),
                    const SizedBox(height: 10),
                    if (isQuantityHide)
                      Row(
                        children: [
                          const Text(
                            "Quantity :",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              int qunatity =
                                  int.parse(_quantityController.text);
                              if (qunatity > 1) {
                                qunatity--;
                              }
                              setState(() {
                                _quantityController.text = qunatity.toString();
                              });
                            },
                            icon: const Icon(Icons.remove),
                          ),
                          Expanded(
                            child: TextField(
                              onChanged: (value) {
                                _quantityController.text = value;
                              },
                              controller: _quantityController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                hintText: "Quantity",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              int qunatity =
                                  int.parse(_quantityController.text);
                              setState(() {
                                qunatity++;
                                _quantityController.text = qunatity.toString();
                              });
                            },
                            icon: const Icon(Icons.add),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              ref
                                  .read(billItemControllerNotifier)
                                  .addItemInTheBill(
                                      _priceController.text,
                                      _quantityController.text,
                                      selectedItem!,
                                      ref,
                                      items,
                                      context);
                              setState(() {
                                isQuantityHide = false;
                                isPriceHide = false;
                                _priceController.text = '';
                              });
                            },
                            child: const Text("Done"),
                          ),
                        ],
                      ),
                    const SizedBox(
                      height: 10,
                    ),
                    Consumer(builder: (context, ref, child) {
                      final list = ref.watch(billItemListNotifierProvider);
                      return Expanded(
                        child: ListView.separated(
                            itemBuilder: (context, index) {
                              return BillItemCard(
                                item: list[index],
                                callback: () {
                                  ItemController.deleteItemFromTheList(
                                      list[index], ref, items);
                                },
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const SizedBox(
                                height: 5,
                              );
                            },
                            itemCount: list.length),
                      );
                    }),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextField(
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                setState(() {
                                  _disCountController.text = '';
                                  _disCountController.text = value;
                                });
                              } else {
                                _disCountController.text = "0";
                              }
                            },
                            controller: _disCountController,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.start,
                            decoration: const InputDecoration(
                              hintText: "Discount Amount",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "Total Amount :",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          ref
                              .read(billItemControllerNotifier)
                              .calculateBillTotalAmount(
                                  _disCountController.text, ref)
                              .toString(),
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    ElevatedButton(
                        onPressed: () {
                          ref.read(billItemControllerNotifier).generateBill(
                              ref.read(billItemListNotifierProvider),
                              ref
                                  .read(billItemControllerNotifier)
                                  .calculateBillTotalAmount(
                                      _disCountController.text, ref),
                              billNumber,
                              double.parse(_disCountController.text));
                          billNumber++;
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amberAccent,
                        ),
                        child: const Center(
                          child: Text("Generate Bill"),
                        ))
                  ],
                ),
              ),
            ));
          }
        },
        error: (e, stacktrace) => const Center(
          child: Text("No Item to Generate Bill"),
        ),
        loading: () => const Center(
          child: SpinKitThreeInOut(
            size: 20.0,
            color: Colors.blueAccent,
          ),
        ),
      ),
    );
  }
}
