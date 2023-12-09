import 'package:flutter/material.dart';
import 'package:project_blue_bird/Custom%20Widgets/InputFields.dart';
import 'package:project_blue_bird/Directory/Nest/Custom%20Crafts/UploadMediaScreen.dart';

import '../../../Custom/Users.dart';

class CustomCraftsScreen extends StatefulWidget {
  final Users users;

  CustomCraftsScreen({required this.users});

  @override
  State<CustomCraftsScreen> createState() => _CustomCraftsScreenState();
}

class _CustomCraftsScreenState extends State<CustomCraftsScreen> {
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();

  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
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
                      icon: const Icon(Icons.arrow_back_outlined),
                    ),
                  ],
                ),
              ),
              const Center(
                child: Text(
                  'Custom Crafts',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                ),
              ),
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Complete out all fields to ensure an accurate order or select the option to use your account details to fill out the information.",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () {
                      firstName.text = widget.users.firstName;
                      lastName.text = widget.users.lastName;

                      phone.text = widget.users.phoneNumber;
                      email.text = widget.users.email;
                    },
                    child: const Text(
                      "Use Account Details",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    )),
              ),
              textFields(),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Step 1 of 3",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    "Continue to next step",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                      onPressed: () {
                        ///TODO error handling

                        if (firstName.text.isEmpty || firstName.text == '') {
                          errorDialog(context, 'Missing first name');
                        } else if (lastName.text.isEmpty ||
                            lastName.text == '') {
                          errorDialog(context, 'Missing last name');
                        } else if (phone.text.isEmpty || phone.text == '') {
                          errorDialog(context, 'Missing phone number');
                        } else if (email.text.isEmpty || email.text == '') {
                          errorDialog(context, 'Missing email');
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UploadMediaScreen(
                                        firstName: firstName.text,
                                        lastName: lastName.text,
                                        phone: phone.text,
                                        email: email.text,
                                    users: widget.users,
                                      )));
                        }
                      },
                      icon: const Icon(Icons.forward_outlined))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> errorDialog(BuildContext context, String text) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Missing information",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  Text(text,
                      style:
                          const TextStyle(fontSize: 18, color: Colors.black)),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Exit",
                        style: TextStyle(color: Colors.black),
                      ))
                ],
              ),
            ),
          );
        });
  }

  Column textFields() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 8.0, bottom: 8, right: 24, left: 24),
          child: InputFields(
              textController: firstName,
              iconData: Icons.person_outline,
              text: 'Enter First Name'),
        ),
        Padding(
          padding:
              const EdgeInsets.only(top: 8.0, bottom: 8, right: 24, left: 24),
          child: InputFields(
              textController: lastName,
              iconData: Icons.person_outline,
              text: 'Enter Last Name'),
        ),
        Padding(
          padding:
              const EdgeInsets.only(top: 8.0, bottom: 8, right: 24, left: 24),
          child: InputFields(
              textController: phone,
              iconData: Icons.phone_outlined,
              text: 'Enter Phone Number'),
        ),
        Padding(
          padding:
              const EdgeInsets.only(top: 8.0, bottom: 8, right: 24, left: 24),
          child: InputFields(
              textController: email,
              iconData: Icons.email_outlined,
              text: 'Enter Email Address'),
        ),
      ],
    );
  }
}
