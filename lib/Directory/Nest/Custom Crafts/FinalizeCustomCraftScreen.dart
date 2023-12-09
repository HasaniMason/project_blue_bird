import 'package:flutter/material.dart';
import 'package:project_blue_bird/Directory/Nest/NestScreen.dart';
import 'package:project_blue_bird/Firebase/ShopOrderFirebase.dart';
import 'dart:io';

import '../../../Custom/Users.dart';

class FinalizeCustomCraftScreen extends StatefulWidget {
  final File? file;
  final String description;

  final String firstName;
  final String lastName;
  final String phone;
  final String email;

  final Users users;

  const FinalizeCustomCraftScreen(
      {super.key,
      this.file,
      required this.description,
      required this.firstName,
      required this.lastName,
      required this.phone,
      required this.email,
      required this.users});

  @override
  State<FinalizeCustomCraftScreen> createState() =>
      _FinalizeCustomCraftScreenState();
}

class _FinalizeCustomCraftScreenState extends State<FinalizeCustomCraftScreen> {
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
                  'Confirm Details',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                ),
              ),
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Confirm that all details of this order are accurate. You will be contacted in the near future about your request and if any further information is needed. Price varies per project and will be discussed.",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              orderInfo(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () {
                      //recreate users based on new info
                      Users user =  Users(
                          firstName: widget.firstName,
                          lastName: widget.lastName,
                          email: widget.email,
                          birthday: DateTime.now(),
                          id: widget.users.id,
                          token: widget.users.token,
                          activeAccount: widget.users.activeAccount,
                          admin: widget.users.admin,
                          phoneNumber: widget.phone,
                          notificationsOn: widget.users.notificationsOn);

                      ShopOrdersFirebase().addCustomOrderForReview(user,widget.description, widget.file!.path).whenComplete(() => {
                        Navigator.pop(context),
                        Navigator.pop(context),
                        Navigator.pop(context),
                      });


                    },
                    child: const Text(
                      "Submit Order",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () {
                      ///TODO add users variable back
                      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>NestScreen()));
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel Order",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black))),
              )
            ],
          ),
        ),
      ),
    );
  }

  Padding orderInfo() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            "First Name: ${widget.firstName}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text("Last Name: ${widget.lastName}",
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Text("Phone Number: ${widget.phone}",
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Text("Email: ${widget.email}",
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Divider(
              thickness: 1,
            ),
          ),
          const Text("Uploaded Picture:",
              style: TextStyle(fontWeight: FontWeight.bold)),
          if (widget.file != null)
            ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.file(
                  widget.file!,
                  height: 100,
                  width: 125,
                  fit: BoxFit.fill,
                ))
          else
            const SizedBox(),
          const Text("Description/Message:",
              style: TextStyle(fontWeight: FontWeight.bold)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.description),
          )
        ],
      ),
    );
  }
}
