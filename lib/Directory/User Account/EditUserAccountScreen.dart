import 'package:flutter/material.dart';
import 'package:project_blue_bird/Firebase/UsersFirebase.dart';

import '../../Custom Widgets/TextFields.dart';
import '../../Custom/Users.dart';

class EditUserAccountScreen extends StatefulWidget {
  Users users;

  EditUserAccountScreen({required this.users});

  @override
  State<EditUserAccountScreen> createState() => _EditUserAccountScreenState();
}

class _EditUserAccountScreenState extends State<EditUserAccountScreen> {

  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();

  TextEditingController streetAddress = TextEditingController();
  TextEditingController streetAddress2 = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController zipCode = TextEditingController();


  UsersFirebase usersFirebase = UsersFirebase();

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
              ])),
          child: Column(
            children: [
              SafeArea(
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          ///TODO update user variable


                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back_outlined)),
                  ],
                ),
              ),
              Text(
                "Edit Account for ${widget.users.firstName}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              
              testFields(),
              
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(onPressed: (){
                  setState(() {
                    if(firstName.text.isNotEmpty){
                      widget.users.firstName = firstName.text;
                    }
                    if(lastName.text.isNotEmpty){
                      widget.users.lastName = lastName.text;
                    }

                    if(phoneNumber.text.isNotEmpty){
                      widget.users.phoneNumber = phoneNumber.text;
                    }
                    if(streetAddress.text.isNotEmpty){
                      widget.users.addressLine1 = streetAddress.text;
                    }
                    if(streetAddress2.text.isNotEmpty){
                      widget.users.addressLine2 = streetAddress2.text;
                    }
                    if(city.text.isNotEmpty){
                      widget.users.city = city.text;
                    }
                    if(state.text.isNotEmpty){
                      widget.users.state = state.text;
                    }
                    if(zipCode.text.isNotEmpty){
                      widget.users.zipCode = zipCode.text;
                    }
                  });

                  usersFirebase.editUser(widget.users,firstName.text,lastName.text,
                      phoneNumber.text,streetAddress.text,streetAddress2.text,city.text,state.text,zipCode.text).whenComplete(() => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Updated")))
                  );

                  Navigator.pop(context);
                }, child: Text("Submit",style: TextStyle(
                  color: Colors.black
                ),)),
              )
              
              
            ],
          ),
        ),
      ),
    );
  }

  Widget testFields() {
    return Column(
            children: [
              TextFields(textEditingController: firstName,hintText: 'Enter first name',iconData: Icons.person_outline,textInputType: TextInputType.text,),
              TextFields(textEditingController: lastName,hintText: 'Enter last name',iconData: Icons.person_outline,textInputType: TextInputType.text,),
              TextFields(textEditingController: phoneNumber,hintText: 'Enter phone number',iconData: Icons.phone_outlined,textInputType: TextInputType.phone,),


              const Padding(
                padding:  EdgeInsets.only(top: 8.0,left: 16,right: 16),
                child: Divider(thickness: 2,),
              ),

              TextFields(textEditingController: streetAddress,hintText: 'Enter street address',iconData: Icons.home,textInputType: TextInputType.text,),

              TextFields(textEditingController: streetAddress2,hintText: 'Enter street address ',iconData: Icons.home,textInputType: TextInputType.text,),

              TextFields(textEditingController: city,hintText: 'Enter City',iconData: Icons.location_city_outlined,textInputType: TextInputType.text,),
              TextFields(textEditingController: state,hintText: 'Enter State',iconData: Icons.location_city_outlined,textInputType: TextInputType.text,),
              TextFields(textEditingController: zipCode,hintText: 'Enter Zipcode',iconData: Icons.location_city_outlined,textInputType: TextInputType.numberWithOptions(),),


            ],
          );
  }
}

