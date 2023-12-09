import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project_blue_bird/Firebase/ItemFirebase.dart';

import '../../Custom Widgets/InputFields.dart';
import '../../Custom Widgets/TextFields.dart';
import '../../Custom/Items.dart';




class EditItemCatalogScreen extends StatefulWidget {
 final Item item;

 EditItemCatalogScreen({required this.item});

  @override
  State<EditItemCatalogScreen> createState() => _EditItemCatalogScreenState();
}

class _EditItemCatalogScreenState extends State<EditItemCatalogScreen> {


  TextEditingController itemNameController = TextEditingController();
  TextEditingController retailController = TextEditingController();
  TextEditingController itemDescription = TextEditingController();
  TextEditingController amountAvailable = TextEditingController();
  TextEditingController salePriceController = TextEditingController();
  TextEditingController costController = TextEditingController();

  ItemFirebase itemFirebase = ItemFirebase();

  String? picLocation;
  File? imageFile;

  bool onSale = false;
  String? url;


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
        body:SingleChildScrollView(
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back_outlined)),

                      IconButton(
                          onPressed: () {
                            itemFirebase.deleteItem(widget.item);
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.delete_outline))
                    ],
                  ),
                ),

                const Center(
                  child: Text(
                    'Edit Item',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                  ),
                ),


                textFields(),


                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(onPressed: (){
                    getImage();
                  }, child: const Text("Upload Picture",style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                  ),)),
                ),


                Flexible(
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
                ),




                if (imageFile != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("New Picture"),
                        ),

                        ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Image.file(
                              imageFile!,
                              height: 100,
                              width: 125,
                              fit: BoxFit.fill,
                            )),
                      ],
                    ),
                  )
                else
                  const SizedBox(),


                ElevatedButton(onPressed: (){

                  //assign info to variable
                  setState(() {

                    if(itemNameController.text.isNotEmpty) {
                      widget. item.itemName = itemNameController.text;
                    }
                    if(retailController.text.isNotEmpty) {
                      widget. item.retail = double.parse(retailController.text);
                    }

                    if(itemDescription.text.isNotEmpty) {
                      widget. item.itemDescription = itemDescription.text;
                    }

                    if(amountAvailable.text.isNotEmpty) {
                      widget.  item.amountAvailable = int.parse(amountAvailable.text);
                    }

                    if(widget.item.onSale){
                      widget. item.salePrice = double.parse(salePriceController.text);
                    }

                  });

                  //make sure all required fields are filled
                  if(widget.item.itemName.isEmpty){

                  }else if (widget.item.retail.toString().isEmpty){

                  }else if (widget.item.itemDescription.isEmpty){

                  }else if (amountAvailable.toString().isEmpty){

                  }else{

                    //if all fields are filled, add item to catalog

                    itemFirebase.editItemInCatalog(widget.item, imageFile != null?  imageFile!.path :null);
                    Navigator.pop(context);

                  }


                  Navigator.pop(context);

                }, child: const Text("Submit",style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                ),))
              ],
            ),
          ),
        ),
      );
              }
    );
  }

  Padding textFields() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [

          TextFields(textEditingController: itemNameController, hintText: "Enter item name (Required)", iconData:  Icons.shop_outlined, textInputType: TextInputType.text)
          ,
          TextFields(textEditingController: retailController, hintText: "Enter item price (Required)", iconData:  Icons.monetization_on_outlined, textInputType: TextInputType.number)
          ,
          TextFields(textEditingController: itemDescription, hintText: "Enter item description (Required)", iconData:  Icons.info_outline, textInputType: TextInputType.text)
          ,

          TextFields(textEditingController: amountAvailable, hintText: "Enter amount available (Required)", iconData:  Icons.numbers_outlined, textInputType: TextInputType.number)
          ,

          Column(
            children: [
              const Text("On Sale?",style: TextStyle(
                  fontWeight: FontWeight.bold
              ),),
              Switch(value: widget.item.onSale, onChanged: (value)=>{
                setState((){
                  widget.item.onSale = value;
                })
              }),
            ],
          ),

          widget.item.onSale ?
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InputFields(textController: salePriceController, iconData: Icons.monetization_on_outlined, text: "Enter sale price  (Required)"),
          ):
          const SizedBox()

        ],
      ),
    );
  }

  Future getImage() async {

    PermissionStatus result;

    final ImagePicker picker = ImagePicker();


    if(Platform.isAndroid) {
      print("Is android");
      result = await Permission.photos.request();
      print("Status: ${result}");

      if (result.isGranted) {
        try {

          final XFile? media = await picker.pickMedia();

          if(media != null){
            setState(() {
              imageFile = File(media.path);
            });
          }


        } catch (err) {
          print("Image Error $err");
        }
      } else if (result.isPermanentlyDenied) {
        openAppSettings();
      }
    }else{
      try {

        final XFile? media = await picker.pickMedia();

        if(media != null){
          setState(() {
            imageFile = File(media.path);
          });
        }

      } catch (err) {
        print("Image Error $err");
      }
    }
  }
}
