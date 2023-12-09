import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:project_blue_bird/Directory/Nest/CartScreen.dart';
import 'package:project_blue_bird/Directory/Nest/Shop/AdminAddItemScreen.dart';
import 'package:project_blue_bird/Directory/Nest/Shop/SelectedItemScreen.dart';
import 'package:project_blue_bird/Firebase/ItemFirebase.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

import '../../../Custom/Items.dart';
import '../../../Custom/Users.dart';
import '../../../Firebase/ShoppingCartFirebase.dart';

class ShopScreen extends StatefulWidget {
  final Users users;

  ShopScreen({required this.users});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  List<Item> itemCatalog = [];
  ItemFirebase itemFirebase = ItemFirebase();

  setUp() async {
    itemCatalog = await itemFirebase.getItemCatalog();

    print("Item length: ${itemCatalog.length}");
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
                  ],
                ),
              ),
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
                            icon: Icon(Icons.arrow_back_outlined)),
                        widget.users.admin
                            ? IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AdminAddItemScreen(
                                                  users: widget.users)));
                                },
                                icon: Icon(Icons.admin_panel_settings_outlined))
                            : IconButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>CartScreen(users: widget.users)));
                                },
                                icon: Icon(Icons.shopping_cart_outlined))
                      ],
                    ),
                  ),
                  Center(
                    child: Text(
                      'Shop',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                    ),
                  ),
                  Expanded(
                    child: ResponsiveGridList(
                      rowMainAxisAlignment: MainAxisAlignment.center,
                      horizontalGridSpacing: 16,
                      verticalGridSpacing: 16,
                      minItemsPerRow: 1,
                      maxItemsPerRow: 1,
                      listViewBuilderOptions: ListViewBuilderOptions(),
                      minItemWidth: 165,
                      children: List.generate(
                          itemCatalog.length,
                          (index) => InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SelectedItemScreen(
                                                  item: itemCatalog[index],
                                                  users: widget.users,
                                              )));                                },
                                child: ItemTile(
                                  item: itemCatalog[index],
                                  users: widget.users,
                                ),
                              )),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class ItemTile extends StatefulWidget {
  final Item item;
  final Users users;

  const ItemTile({super.key, required this.item, required this.users});

  @override
  State<ItemTile> createState() => _ItemTileState();
}

class _ItemTileState extends State<ItemTile> {
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
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  pictureWidget(),
                  Row(
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
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Added to Cart")));

                        },
                        child: Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.white,
                        ),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.grey)),
                      )
                    ],
                  ),

                  Text(
                    '${widget.item.itemName}',
                    style: const TextStyle(
                        fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  // Text(
                  //   widget.item.itemDescription,
                  //   style: TextStyle(fontSize: 18),
                  //   textAlign: TextAlign.center,
                  // ),
                  Text("Amount Available: ${widget.item.amountAvailable}")
                ],
              ),
            ),
          );
        });
  }

  Widget pictureWidget() {
    return Flexible(
      child: Container(
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
    );
  }
}
