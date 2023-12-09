import 'package:flutter/material.dart';
import 'package:images_picker/images_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../Custom/Users.dart';
import 'FinalizeCustomCraftScreen.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';



class UploadMediaScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String phone;
  final String email;

  final Users users;

  UploadMediaScreen({required this.firstName, required this.lastName, required this.phone, required this.email, required this.users});

  @override
  State<UploadMediaScreen> createState() => _UploadMediaScreenState();
}

class _UploadMediaScreenState extends State<UploadMediaScreen> {


  TextEditingController description = TextEditingController();
  File? imageFile;

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


  @override
  Widget build(BuildContext context) {
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
        child: SingleChildScrollView(
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
                      icon: const Icon(Icons.arrow_back_outlined),
                    ),
                  ],
                ),

              ),

              const Center(
                child: Text(
                  'Upload Media',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                ),
              ),

              const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Upload a picture to aid in your custom creation. Fill out the box below with as much description as possible.",textAlign: TextAlign.center,
                  ),
                ),
              ),


              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(onPressed: (){
                  getImage();
                }, child: const Text("Upload Picture",style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                ),)),
              ),

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

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: const BorderRadius.all(Radius.circular(20))
                  ),
                  height: 200,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: description,
                      decoration: const InputDecoration.collapsed(
                        hintText: 'Write message/description',

                      //  filled: true
                      ),
                      maxLines: null,
                      expands: true,
                      keyboardType: TextInputType.multiline,
                    ),
                  ),
                ),
              ),


              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Step 2 of 3",style: TextStyle(
                    fontWeight: FontWeight.bold
                ),),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text("Continue to next step",style: TextStyle(
                      fontWeight: FontWeight.bold
                  ),),

                  IconButton(onPressed: (){
                    if(imageFile == null){
                      errorDialog(context, "Must upload media");
                    }else{
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> FinalizeCustomCraftScreen(file: imageFile,description: description.text, firstName: widget.firstName,
                        lastName: widget.lastName,
                        phone: widget.phone,
                        email: widget.email,
                      users: widget.users,)));

                    }

                  }, icon: const Icon(Icons.forward_outlined))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> errorDialog(BuildContext context, String text) {
    return showDialog(context: context, builder: (BuildContext context){
      return Dialog(
        child: Container(
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
          height: 200,
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Missing information",style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
              ),),
              Text(text,style: const TextStyle(
                  fontSize: 18,

                  color: Colors.black
              )),

              ElevatedButton(onPressed: (){
                Navigator.pop(context);
              }, child: const Text("Exit",style: TextStyle(color: Colors.black),))
            ],
          ),
        ),
      );
    });
  }
}
