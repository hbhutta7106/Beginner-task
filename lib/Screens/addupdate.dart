import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_app/Controllers/itemcontroller.dart';
import 'package:pos_app/Providers/providers.dart';

class AddUpdateScreen extends ConsumerStatefulWidget {
  const AddUpdateScreen({super.key, required this.whichScreen});
  final int whichScreen;

  @override
  ConsumerState<AddUpdateScreen> createState() => _AddUpdateScreenState();
}

class _AddUpdateScreenState extends ConsumerState<AddUpdateScreen> {
  void pickImage() async {
    final image = await ItemController.pickImageFromGallery();
    setState(() {
      imageFile = image;
    });
  }

  @override
  void initState() {
    super.initState();
    final item = ref.read(itemModelProvider);
    if (widget.whichScreen == 1) {
      _itemCodeController.text = item.itemCode.toString();
      _nameController.text = item.name;
      _itemAmountController.text = item.quantity.toString();
      _purchasedPriceController.text = item.purchasedPrice.toString().trim();
      if (item.image != null) {
        base64Image = base64Decode(item.image!);
      }
    }
  }

  void setControllerText() {
    setState(() {
      _itemCodeController.text = '';
      _nameController.text = "";
      _itemAmountController.text = '';
      _purchasedPriceController.text = '';
      imageFile = null;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _itemAmountController.dispose();
    _itemCodeController.dispose();
    super.dispose();
  }

  final _nameController = TextEditingController();
  final _itemAmountController = TextEditingController();
  final _itemCodeController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  final _purchasedPriceController = TextEditingController();

  File? imageFile;
  Uint8List? base64Image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:widget.whichScreen==1? const Text("Edit Screen"):const Text("Update Screen"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: MaterialButton(
            color: Colors.blueAccent,
            shape: Border.all(),
            onPressed: () async {
              if (widget.whichScreen == 1) {
                if (imageFile == null) {
                  ItemController.updateItemInTheDatabase(
                      ref,
                      context,
                      _nameController.text,
                      base64Encode(base64Image!),
                      _itemAmountController.text,
                      _itemCodeController.text,
                      _purchasedPriceController.text);
                } else {
                  final base64StrinImage =
                      await ItemController.convertImageIntoBase64String(
                          imageFile!);
                  ItemController.updateItemInTheDatabase(
                      ref,
                      context,
                      _nameController.text,
                      base64StrinImage,
                      _itemAmountController.text,
                      _itemCodeController.text,
                      _purchasedPriceController.text);
                }
              } else {
                if (_formkey.currentState!.validate()) {
                  _formkey.currentState!.save();
                  String? base64StrinImage;
                  if (imageFile != null) {
                    base64StrinImage =
                        await ItemController.convertImageIntoBase64String(
                            imageFile!);
                  }

                  ItemController.addItemInDatabase(
                      _nameController.text,
                      base64StrinImage,
                      _itemAmountController.text,
                      _itemCodeController.text,
                      context,
                      ref,
                      double.parse(_purchasedPriceController.text));
                  setControllerText();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text(" Input all the Fields")));
                }
              }
            },
            textColor: Colors.white,
            elevation: 2.0,
            height: 60,
            minWidth: MediaQuery.of(context).size.width,
            child: widget.whichScreen == 1
                ? const Text(
                    "Update Product",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )
                : const Text(
                    "Add Product",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
              key: _formkey,
              child: Column(children: [
                TextFormField(
                  onSaved: (newValue) {
                    _nameController.text = newValue!;
                  },
                  controller: _nameController,
                  onChanged: (value) {
                    if (value.isNotEmpty) {}
                    return;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please Enter Name";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      fillColor: Colors.blue[100],
                      filled: true,
                      label: const Text("Item Name"),
                      border: const OutlineInputBorder(),
                      hintText: "Name of the Item",
                      prefixIcon: const Icon(Icons.text_fields_rounded)),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                          onSaved: (value) {
                            _itemAmountController.text = value!;
                            
                          },
                          onChanged: (value) {
                            if (value.isNotEmpty) {}
                            return;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Item Amount";
                            }
                            return null;
                          },
                          controller: _itemAmountController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              fillColor: Colors.blue[100],
                              filled: true,
                              label: const Text("Item Amount"),
                              border: const OutlineInputBorder(),
                              hintText: "Amount of the Item",
                              prefixIcon:
                                  const Icon(Icons.text_fields_rounded))),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextFormField(
                          readOnly: widget.whichScreen == 1 ? true : false,
                          onSaved: (value) {
                            _itemCodeController.text = value!;
                          },
                          onChanged: (value) {
                            if (value.isNotEmpty) {}
                            return;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Item Code";
                            }
                            return null;
                          },
                          controller: _itemCodeController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              fillColor: Colors.blue[100],
                              filled: true,
                              label: const Text("Item Code"),
                              border: const OutlineInputBorder(),
                              hintText: "Code of Item",
                              prefixIcon: const Icon(Icons.qr_code_2_rounded))),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                    onSaved: (value) {
                      _purchasedPriceController.text = value!;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please Enter purchased Price of Item";
                      }
                      return null;
                    },
                    controller: _purchasedPriceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        fillColor: Colors.blue[100],
                        filled: true,
                        label: const Text("Purchased Price"),
                        border: const OutlineInputBorder(),
                        hintText: "Item Purchased Price",
                        prefixIcon: const Icon(Icons.qr_code_2_rounded))),
                const SizedBox(
                  height: 10,
                ),
                Stack(
                  children: [
                    GestureDetector(
                      onTap: pickImage,
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            color: Colors.blue[100],
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all()),
                        height: 280,
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: Center(
                          child: base64Image != null
                              ? Image.memory(base64Image!)
                              : imageFile != null
                                  ? Image.file(
                                      fit: BoxFit.fitWidth,
                                      width: MediaQuery.of(context).size.width,
                                      imageFile!)
                                  : const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                          Icon(
                                            Icons.drive_folder_upload_outlined,
                                            size: 40,
                                          ),
                                          Text(
                                            "Upload Image ",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic),
                                          )
                                        ]),
                        ),
                      ),
                    ),
                    imageFile != null || base64Image != null
                        ? Positioned(
                            right: 5,
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    imageFile = null;
                                    base64Image = null;
                                  });
                                },
                                icon: const Icon(Icons.highlight_remove)))
                        : const Text("")
                  ],
                ),
              ])),
        ),
      )),
    );
  }
}
