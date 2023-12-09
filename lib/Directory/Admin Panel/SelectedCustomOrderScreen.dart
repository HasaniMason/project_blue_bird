import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:project_blue_bird/Custom%20Widgets/InputFields.dart';
import 'package:project_blue_bird/Custom%20Widgets/TextFields.dart';
import 'package:project_blue_bird/Custom/ShopOrders.dart';
import 'package:project_blue_bird/Firebase/ShopOrderFirebase.dart';

class SelectedCustomOrderScreen extends StatefulWidget {
  final ShopOrders shopOrders;

  SelectedCustomOrderScreen({required this.shopOrders});

  @override
  State<SelectedCustomOrderScreen> createState() =>
      _SelectedCustomOrderScreenState();
}

class _SelectedCustomOrderScreenState extends State<SelectedCustomOrderScreen> {
  TextEditingController price = TextEditingController();
  String? url;

  ShopOrdersFirebase shopOrdersFirebase = ShopOrdersFirebase();

  setUp() async {
    if (widget.shopOrders.picLocation != null &&
        widget.shopOrders.picLocation != 'null') {
      var ref = await FirebaseStorage.instance
          .ref()
          .child(widget.shopOrders.picLocation ?? "");

      print(widget.shopOrders.picLocation);
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
            body: SingleChildScrollView(
              child: Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height,
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
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.arrow_back_outlined),
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      'Approve or delete custom orders',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                      textAlign: TextAlign.center,
                    ),


                    widget.shopOrders.orderApproved?
                    const Text("This Order has been approved already!",style: TextStyle(
                      fontSize: 26,
                      color: Colors.green,
                      fontWeight: FontWeight.bold
                    ),textAlign: TextAlign.center,):
                        const SizedBox(),





                    orderDetails(),



                    const Text('Enter price agreed upon with customer.',
                        textAlign: TextAlign.center),

                    TextFields(
                        textEditingController: price,
                        hintText: 'Enter Price',
                        iconData: Icons.attach_money_outlined,
                        textInputType: TextInputType.number),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              if(price.text.isEmpty){
                                errorMessage(context);
                              }else{
                                shopOrdersFirebase.updatePriceForCustomOrder(widget.shopOrders, price.text);
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Price updated and order approved!")));

                                Navigator.pop(context);
                              }

                            },
                            child: const Text(
                              "Approve Order",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            )),


                        widget.shopOrders.orderApproved ?
                        ElevatedButton(
                            onPressed: () {

                              shopOrdersFirebase.deleteOrder(widget.shopOrders);
                              Navigator.pop(context);
                            },
                            child: const Text("Delete Order",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black))):
                            const SizedBox()
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<dynamic> errorMessage(BuildContext context) {
    return showDialog(context: context, builder: (BuildContext context){
                                return Dialog(
                                  child: Container(
                                    height: 200,
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
                                            ]
                                        )
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const Text('Enter Price',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22),textAlign: TextAlign.center,),


                                        TextButton(onPressed: (){
                                          Navigator.pop(context);

                                        }, child: const Text("Cancel",style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black
                                        ),))
                                      ],
                                    ),
                                  ),
                                );
                              });
  }

  Padding orderDetails() {
    return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        'Customer: ${widget.shopOrders.firstName} ${widget.shopOrders.lastName}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(
                        'Phone Number: ${widget.shopOrders.phoneNumber}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(
                        'Email: ${widget.shopOrders.email}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0,bottom: 24),
                        child: Text('Order ID: ${widget.shopOrders.id}'),
                      ),


                      Container(
                          child: widget.shopOrders.picLocation != null
                              ? url != null
                                  ? ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(20),
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
                                  )))
                    ],
                  ),
                );
  }
}
