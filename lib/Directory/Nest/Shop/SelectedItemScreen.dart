import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:project_blue_bird/Firebase/ShoppingCartFirebase.dart';

import '../../../Custom/Items.dart';
import '../../../Custom/Users.dart';

class SelectedItemScreen extends StatefulWidget {
  final Item item;
  final Users users;

  SelectedItemScreen({super.key, required this.item, required this.users});

  @override
  State<SelectedItemScreen> createState() => _SelectedItemScreenState();
}

class _SelectedItemScreenState extends State<SelectedItemScreen> {
  String? url;

  ShoppingCartFirebase shoppingCartFirebase = ShoppingCartFirebase();

  setUp() async {
    if (widget.item.picLocation != null && widget.item.picLocation != 'null') {
      var ref = await FirebaseStorage.instance
          .ref()
          .child(widget.item.picLocation ?? "");

      print(widget.item.picLocation);
      try {
        await ref.getDownloadURL().then((value) => setState(() {
              url = value;

              //url = 'https://${url!}';
            }));
      } on FirebaseStorage catch (e) {
        print('Did not get URL: ${e}');
      }
    }
  }

  @override
  void initState() {
    super.initState();

    setUp();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: null,
        builder: (BuildContext context, AsyncSnapshot text) {
          return Scaffold(
            body: Container(
              height: MediaQuery.of(context).size.height,
              decoration:  BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0x80baf4d7),
                    Color(0x80c8f4e1),
                    Color(0x80dff6e8),
                    Color(0x80c9f3d3),
                    Color(0x80dfefc6),
                    Color(0x80dbf4b5),
                    Color(0x80f5e5d6),
                    Color(0x80bbf0f4),
                    Color(0x80bbf0f4),
                    Color(0x80bcc7f4),
                    Color(0x80dfefc6)
                  ],
                ),

              ),
              child: Column(
                children: [
                  Flexible(
                    child: Container(
                      height: MediaQuery.of(context).size.height / 2,
                      child: widget.item.picLocation != null
                          ? url != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    url.toString(),
                                    fit: BoxFit.fill,
                                  ))
                              : const CircularProgressIndicator()
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                'lib/Images/under-construction-2629947_1920.jpg',
                                fit: BoxFit.fill,
                              )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (widget.item.onSale == true)
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "\$${widget.item.retail.toStringAsFixed(2)}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22,decoration: TextDecoration.lineThrough),
                                      ),
                                    ),
                                    Text(
                                        "\$${widget.item.salePrice!.toStringAsFixed(2)}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22))
                                  ],
                                ),
                              if (widget.item.onSale == false)
                                Text(
                                    "\$${widget.item.retail.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22)),

                              ElevatedButton(
                                onPressed: () {
                                  shoppingCartFirebase.addItemToCart(widget.users, widget.item);

                                  Navigator.pop(context);
                                },
                                child: const Icon(
                                  Icons.shopping_cart_outlined,
                                  color: Colors.white,
                                ),
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.grey)),
                              )
                            ],
                          ),
                        ),
                        Text(
                          '${widget.item.itemName}',
                          style: const TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                        Text(
                            "Amount Available: ${widget.item.amountAvailable}"),
                        Text(
                          widget.item.itemDescription,
                          style: const TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
