import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project_blue_bird/Custom%20Widgets/InputFields.dart';
import 'package:project_blue_bird/Custom%20Widgets/TextFields.dart';

import '../../../Custom/Items.dart';
import '../../../Custom/Users.dart';
import '../../../Firebase/ItemFirebase.dart';
import 'dart:io';




class AdminAddItemScreen extends StatefulWidget {
  final Users users;

  const AdminAddItemScreen({super.key, required this.users});

  @override
  State<AdminAddItemScreen> createState() => _AdminAddItemScreenState();
}

class _AdminAddItemScreenState extends State<AdminAddItemScreen> {


  TextEditingController itemNameController = TextEditingController();
  TextEditingController retailController = TextEditingController();
  TextEditingController itemDescription = TextEditingController();
  TextEditingController amountAvailable = TextEditingController();
  TextEditingController salePriceController = TextEditingController();
  TextEditingController costController = TextEditingController();

  String? picLocation;
  File? imageFile;

  bool onSale = false;

  Item item = Item(itemName: '', retail: 1.00, itemID: '', itemDescription: '', amountAvailable: 5, onSale: false);

  ItemFirebase itemFirebase = ItemFirebase();

  @override
  Widget build(BuildContext context) {
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
                  'Admin Shop',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                ),
              ),


              textFields(),


              if (imageFile != null)
                ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.file(
                      imageFile!,
                      height: 100,
                      width: 125,
                      fit: BoxFit.fill,
                    ))
              else
                const SizedBox(),

              ElevatedButton(onPressed: (){

                getImage();
              }, child: const Text("Upload Picture",style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold
              ),)),
              

              ElevatedButton(onPressed: (){

                //assign info to variable
                setState(() {
                  item.itemName = itemNameController.text;
                  item.retail = double.parse(retailController.text);
                  item.itemDescription = itemDescription.text;
                  item.amountAvailable = int.parse(amountAvailable.text);

                  if(item.onSale){
                    item.salePrice = double.parse(salePriceController.text);
                  }

                });

                //make sure all required fields are filled
                if(item.itemName.isEmpty){

                }else if (item.retail.toString().isEmpty){

                }else if (item.itemDescription.isEmpty){

                }else if (amountAvailable.toString().isEmpty){

                }else{

                  //if all fields are filled, add item to catalog

                  itemFirebase.addItemToCatalog(item, imageFile != null?  imageFile!.path :null);
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
                    Switch(value: item.onSale, onChanged: (value)=>{
                      setState((){
                        item.onSale = value;
                      })
                    }),
                  ],
                ),

                item.onSale ?
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
