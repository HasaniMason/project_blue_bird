import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
//import 'package:flutter_stripe/flutter_stripe.dart';

import 'package:project_blue_bird/Firebase/ShopOrderFirebase.dart';

import '../../Custom Widgets/OrderWidget.dart';
import '../../Custom/Items.dart';
import '../../Custom/Users.dart';
import '../../Firebase/ShoppingCartFirebase.dart';
import 'package:http/http.dart' as http;

class CartScreen extends StatefulWidget {
  final Users users;

  const CartScreen({super.key, required this.users});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Stream<QuerySnapshot> cartStream;
  List<DocumentSnapshot> cartList = [];
ShopOrdersFirebase shopOrdersFirebase = ShopOrdersFirebase();
  num cartTotal = 0.00;

  Map<String, dynamic>? paymentIntent;

  setUp() async {
    cartStream = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.users.id)
        .collection('cart')
        .snapshots();


  }

  @override
  void initState(){
    super.initState();

    DocumentReference totalReference =
    FirebaseFirestore.instance.collection('users').doc(widget.users.id);

    totalReference.snapshots().listen((event) {
      if(mounted)
        setState(() {
          cartTotal = event.get('cartTotal');
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: setUp(),
        builder: (BuildContext context, AsyncSnapshot text) {
          return Scaffold(

            body: Container(
              height: MediaQuery.of(context).size.height,
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

                      ],
                    ),
                  ),
                  Center(
                    child: Text(
                      'Cart',
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                    ),
                  ),
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
                          return Center(
                              child: Text(
                            'Whoops... it looks empty in here. Add some items from the shop.',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary),
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

                              return itemWidget(item: thisItem,cartTotal: cartTotal.toDouble(), users: widget.users,);
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const SizedBox();
                            },
                            itemCount: cartList.length);
                      },
                    ),
                  ),
                  
                  ElevatedButton(onPressed: (){
                   // makePayment();

                    setState(() {
                      widget.users.cartTotal =cartTotal;
                    });

                    if(cartTotal>0) {
                      shopOrdersFirebase.createOrderFromCart(widget.users).whenComplete(() => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Successful, check recent order for details.")))
                    );
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Add items to cart.")));
                    }


                  }, child: Text("Pay \$${cartTotal.toStringAsFixed(2)}"))
                ],
              ),
            ),
          );
        });
  }
  // Future<void> makePayment() async {
  //
  //   var newTotal = cartTotal.toString().replaceAll('.', '');
  //   try {
  //     //payment intent
  //     paymentIntent = await createPaymentIntent(newTotal, 'USD');
  //
  //     //initialize payment sheet
  //     await Stripe.instance.initPaymentSheet(
  //       paymentSheetParameters: SetupPaymentSheetParameters(
  //           paymentIntentClientSecret: paymentIntent!['client_secret'],
  //           style: ThemeMode.light,
  //           merchantDisplayName: 'Top Tier'
  //       ),
  //     );
  //
  //     //display payment sheet
  //     displayPaymentSheet();
  //   } catch (error) {
  //     throw Exception(error);
  //   }
  //
  //
  // }
  //
  // createPaymentIntent(String amount, String currency) async {
  //   try {
  //     Map<String, dynamic> body = {
  //       'amount': amount,
  //       'currency': currency,
  //     };
  //
  //     //make post request to stripe
  //     var response =
  //     await http.post(Uri.parse('https://api.stripe.com/v1/payment_intents'),
  //         headers: {
  //           'Authorization': 'Bearer sk_test_51OBePwJn90tCGP7sb6Hx19OMoFxJlYDa4Fn6JwqzNL8r2HOBNVhbJYul75Om1FFIY9fwHEkM44LJCb70SHOwXsaA0018f05ekO',
  //           'Content-Type': 'application/x-www-form-urlencoded'
  //         },
  //         body: body);
  //     return json.decode(response.body);
  //   } catch (error) {
  //     throw Exception(error.toString());
  //   }
  // }
  //
  // displayPaymentSheet()async{
  //   try{
  //     await Stripe.instance.presentPaymentSheet().then((value) => {
  //
  //       setState(() {
  //         widget.users.cartTotal =cartTotal;
  //       }),
  //
  //       shopOrdersFirebase.createOrderFromCart(widget.users),
  //       Navigator.pop(context)
  //
  //     }).onError((error, stackTrace) => {throw Exception(error)});
  //   }catch (error){
  //
  //   }  StripeException (error){
  //     print("error");
  //   }
  // }
 }


class itemWidget extends StatefulWidget {
  final Item item;
  final Users users;
   double cartTotal;

  itemWidget({required this.item, required this.users, required this.cartTotal});

  @override
  State<itemWidget> createState() => _itemWidgetState();
}

class _itemWidgetState extends State<itemWidget> {
  String? url;

  ShoppingCartFirebase shoppingCartFirebase = ShoppingCartFirebase();

  getCartTotal() async {

    widget.cartTotal =
    await shoppingCartFirebase.getTotalForCart(widget.users);

    setState(() {

    });
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
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
                      )),
            ),
          ),
          itemInfo(),



          amountController(),
        ],
      ),
    );
  }

  Container amountController() {
    return Container(
          height: 40,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //if amount in cart is 1, show trash icon

              widget.item.amountInCart! == 1
                  ? IconButton(
                onPressed: () async {
                  //subtract item
                  setState(() {
                    widget.item.amountInCart = widget.item.amountInCart! -1;
                  });

                  await  shoppingCartFirebase.subtractionToItemInCart(
                      widget.users, widget.item);

                  setState(() {
                    getCartTotal();
                  });
                },
                icon: Icon(Icons.delete),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              )
                  : IconButton(
                onPressed: () async {
                  //subtract item


                  setState(() {
                    widget.item.amountInCart = widget.item.amountInCart! -1;
                  });

                  //update database
                  await shoppingCartFirebase.subtractionToItemInCart(
                      widget.users, widget.item);

                  //update total for cart
                  await shoppingCartFirebase
                      .getTotalForCart(widget.users);


                  setState(() {
                    //set data for UI
                    setState(() {
                      print(shoppingCartFirebase.cartTotal);
                      widget.cartTotal = shoppingCartFirebase.cartTotal;
                    });
                  });
                },
                icon: Icon(Icons.exposure_minus_1_outlined),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),

              VerticalDivider(
                color: Colors.grey,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("${widget.item.amountInCart}",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black
                    )),
              ),

              VerticalDivider(
                color: Colors.grey,
              ),

              IconButton(
                onPressed: () async {
                  //add item

                  setState(() {
                    if(widget.item.amountInCart != null){
                      widget.item.amountInCart = widget.item.amountInCart! + 1;
                    }else{
                      widget.item.amountInCart = 1;
                    }
                  });

                  //update database
                  await  shoppingCartFirebase.additionToItemInCart(
                      widget.users, widget.item);

                  //update total for cart
                  await shoppingCartFirebase
                      .getTotalForCart(widget.users);

                  //set data for UI
                  setState(() {
                    print(shoppingCartFirebase.cartTotal);
                    widget.cartTotal = shoppingCartFirebase.cartTotal;
                  });

                },
                icon: Icon(Icons.plus_one_outlined),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
            ],
          ),
        );
  }

  Column itemInfo() {
    return Column(
          children: [
            Text(
              widget.item.itemName,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            !widget.item.onSale
                ? Text(
                    "\$${widget.item.retail.toString()}",
                    style: TextStyle(),
                  )
                : Text(
                    "\$${widget.item.salePrice?.toStringAsFixed(2).toString()}",
                    style: TextStyle()),

            !widget.item.onSale
                ? Text(
              "\$${(widget.item.retail * widget.item.amountInCart!).toStringAsFixed(2)}",
              style: TextStyle(),
            )
                : Text(
                "\$${(widget.item.salePrice! * widget.item.amountInCart!).toStringAsFixed(2).toString()}",
                style: TextStyle())

          ],
        );
  }
}
