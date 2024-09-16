import 'package:flutter/material.dart';
import 'package:pos_app/Screens/addupdate.dart';
import 'package:pos_app/Screens/bill.dart';
import 'package:pos_app/Screens/items.dart';
import 'package:pos_app/Widgets/buttons.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  image: const DecorationImage(
                    image: AssetImage("assets/images/inventory.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(
              height: 2.0,
              thickness: 3,
            ),
            Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height * 0.545,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Button(
                            radiusCorner: 1,
                            internalText: "Add Item",
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return const AddUpdateScreen(whichScreen: 0);
                              }));
                            }),
                        const SizedBox(
                          width: 10,
                        ),
                        Button(
                            radiusCorner: 2,
                            internalText: "Edit Item",
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return const ProductsScreen();
                              }));
                            })
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Button(
                            radiusCorner: 3,
                            internalText: "Delete item",
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return const ProductsScreen(
                                  screen: 2,
                                );
                              }));
                            }),
                        const SizedBox(
                          width: 10,
                        ),
                        Button(
                            radiusCorner: 4,
                            internalText: "View Items",
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return const ProductsScreen();
                              }));
                            }),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: MaterialButton(
                      textColor: Colors.white,
                      color: const Color.fromARGB(255, 224, 190, 70),
                      minWidth: MediaQuery.of(context).size.width,
                      shape: Border.all(),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const BillScreen();
                        }));
                      },
                      child: const Text("Generate Bill"),
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
