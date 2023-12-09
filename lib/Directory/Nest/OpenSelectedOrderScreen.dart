import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:project_blue_bird/Custom/ShopOrders.dart';

import '../../Custom/Items.dart';
import '../../Custom/Users.dart';
import '../../Firebase/ShoppingCartFirebase.dart';

class OpenSelectedOrderScreen extends StatefulWidget {
  final Users users;
  final ShopOrders shopOrders;

  const OpenSelectedOrderScreen(
      {super.key, required this.users, required this.shopOrders});

  @override
  State<OpenSelectedOrderScreen> createState() =>
      _OpenSelectedOrderScreenState();
}

class _OpenSelectedOrderScreenState extends State<OpenSelectedOrderScreen> {
  late Stream<QuerySnapshot> cartStream;
  List<DocumentSnapshot> cartList = [];

  setUp() async {
    cartStream = FirebaseFirestore.instance
        .collection('shopOrders')
        .doc(widget.shopOrders.id)
        .collection('items')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: setUp(),
        builder: (BuildContext context, AsyncSnapshot text) {
          return Scaffold(
            body: Container(
              decoration: const BoxDecoration(
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
                  ])),
              child: Column(
                children: [

                  SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.arrow_back_outlined)),
                      ],
                    ),
                  ),
                  const Center(
                    child: Text(
                      'Recent Order',
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                    ),
                  ),

                  Text("${widget.shopOrders.firstName} ${widget.shopOrders.lastName}",style: TextStyle(fontWeight: FontWeight.bold)),

                  Text("Date: ${widget.shopOrders.date.month}/${widget.shopOrders.date.day}/${widget.shopOrders.date.year}",style: TextStyle(fontWeight: FontWeight.bold),),
                  Text("Total \$${widget.shopOrders.total}",style: TextStyle(fontWeight: FontWeight.bold)),
                  Expanded(
                    child: StreamBuilder(
                      stream: cartStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        //if there is an error
                        if (snapshot.hasError) {
                          return const Text('Error');
                        }
                        //while it connects
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        cartList = snapshot.data!.docs;

                        if (cartList.isEmpty) {
                          return const Center(
                              child: Text(
                            'No previous orders.',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Colors.black),
                            textAlign: TextAlign.center,
                          ));
                        }

                        return ListView.separated(
                            itemBuilder: (BuildContext context, int index) {
                              Item thisItem = Item(
                                  itemName: cartList[index]['itemName'],
                                  retail: cartList[index]['retail'],
                                  itemID: cartList[index]['itemID'],
                                  itemDescription: cartList[index]
                                      ['itemDescription'],
                                  amountAvailable: cartList[index]
                                      ['amountAvailable'],
                                  onSale: cartList[index]['onSale'],
                                  cost: cartList[index]['cost'],
                                  picLocation: cartList[index]['picLocation'],
                                  amountInCart: cartList[index]['amountInCart'],
                                  salePrice: cartList[index]['salePrice']);

                              return itemWidget(
                                  item: thisItem,
                                  users: widget.users,
                                  cartTotal:
                                      widget.shopOrders.total.toDouble());
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const SizedBox();
                            },
                            itemCount: cartList.length);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class itemWidget extends StatefulWidget {
  final Item item;
  final Users users;
  double cartTotal;

  itemWidget(
      {required this.item, required this.users, required this.cartTotal});

  @override
  State<itemWidget> createState() => _itemWidgetState();
}

class _itemWidgetState extends State<itemWidget> {
  String? url;

  ShoppingCartFirebase shoppingCartFirebase = ShoppingCartFirebase();

  getCartTotal() async {
    widget.cartTotal = await shoppingCartFirebase.getTotalForCart(widget.users);

    setState(() {});
  }

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
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              Text(
                widget.item.itemName,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    height: 75,
                    width: 75,
                    child: widget.item.picLocation != null
                        ? url != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  url.toString(),
                                  fit: BoxFit.fitWidth,
                                ))
                            : const CircularProgressIndicator()
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              'lib/Images/under-construction-2629947_1920.jpg',
                              fit: BoxFit.fitWidth,
                            ))),
              ),
            ],
          ),

          itemInfo(),

          // amountController(),
        ],
      ),
    );
  }

  Container amountController() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: const BorderRadius.all(Radius.circular(12))),
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          //if amount in cart is 1, show trash icon

          widget.item.amountInCart! == 1
              ? IconButton(
                  onPressed: () async {
                    //subtract item
                    setState(() {
                      widget.item.amountInCart = widget.item.amountInCart! - 1;
                    });

                    await shoppingCartFirebase.subtractionToItemInCart(
                        widget.users, widget.item);

                    setState(() {
                      getCartTotal();
                    });
                  },
                  icon: const Icon(Icons.delete),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                )
              : IconButton(
                  onPressed: () async {
                    //subtract item

                    setState(() {
                      widget.item.amountInCart = widget.item.amountInCart! - 1;
                    });

                    //update database
                    await shoppingCartFirebase.subtractionToItemInCart(
                        widget.users, widget.item);

                    //update total for cart
                    await shoppingCartFirebase.getTotalForCart(widget.users);

                    setState(() {
                      //set data for UI
                      setState(() {
                        print(shoppingCartFirebase.cartTotal);
                        widget.cartTotal = shoppingCartFirebase.cartTotal;
                      });
                    });
                  },
                  icon: const Icon(Icons.exposure_minus_1_outlined),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),

          const VerticalDivider(
            color: Colors.grey,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("${widget.item.amountInCart}",
                style: const TextStyle(fontSize: 20, color: Colors.black)),
          ),

          const VerticalDivider(
            color: Colors.grey,
          ),

          IconButton(
            onPressed: () async {
              //add item

              setState(() {
                if (widget.item.amountInCart != null) {
                  widget.item.amountInCart = widget.item.amountInCart! + 1;
                } else {
                  widget.item.amountInCart = 1;
                }
              });

              //update database
              await shoppingCartFirebase.additionToItemInCart(
                  widget.users, widget.item);

              //update total for cart
              await shoppingCartFirebase.getTotalForCart(widget.users);

              //set data for UI
              setState(() {
                print(shoppingCartFirebase.cartTotal);
                widget.cartTotal = shoppingCartFirebase.cartTotal;
              });
            },
            icon: const Icon(Icons.plus_one_outlined),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget itemInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Text('Price'),
              !widget.item.onSale
                  ? Text(
                      "\$${widget.item.retail.toString()}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  : Text(
                      "\$${widget.item.salePrice?.toStringAsFixed(2).toString()}",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),

        Column(
          children: [
            Text("Amount"),
            Text("${widget.item.amountInCart}",
                style: const TextStyle(fontWeight: FontWeight.bold))
          ],
        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Text("Total"),
              !widget.item.onSale
                  ? Text(
                      "\$${(widget.item.retail * widget.item.amountInCart!).toStringAsFixed(2)}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  : Text(
                      "\$${(widget.item.salePrice! * widget.item.amountInCart!).toStringAsFixed(2).toString()}",
                      style: const TextStyle(fontWeight: FontWeight.bold))
            ],
          ),
        )
      ],
    );
  }
}
