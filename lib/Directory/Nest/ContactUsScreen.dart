import 'package:flutter/material.dart';
import 'package:project_blue_bird/Custom%20Widgets/InputFields.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:url_launcher/url_launcher.dart';


class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  TextEditingController body = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(child: Text("Contact Us",style: TextStyle(
                  fontWeight: FontWeight.bold,
                fontSize: 22
              ),)),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Reach out to our team for any questions. Someone will reach back out as soon as possible.',textAlign: TextAlign.center,),
              ),

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
                      controller: body,
                      decoration: const InputDecoration.collapsed(
                        hintText: 'Write email...',

                        //  filled: true
                      ),
                      maxLines: null,
                      expands: true,
                      keyboardType: TextInputType.multiline,
                    ),
                  ),
                ),
              ),


              ElevatedButton(onPressed: () async {
               await sendEmail();

               Navigator.pop(context);

              }, child: Text("Send Email",style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold
              ),))
            ],
          ),
        ),
      ),
    );
  }

  sendEmail() async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: 'ravensmith0205@gmail.com',
        query: 'subject=Customer Contact&body=${body.text}'
    );

    var url = params.toString();

    if (!await launchUrl(params)) {
      throw Exception('Could not launch url');
    }

    // final Email email = Email(
    //   body: body.text,
    //   subject: 'Customer Contact',
    //   recipients: ['dedrickhorton94@gmail.com'],
    //   cc: [],
    //   bcc: [],
    //   isHTML: false
    // );
    //
    // String platformResponse;
    //
    // try{
    //   await FlutterEmailSender.send(email);
    //   platformResponse = 'Success';
    // }catch (error){
    //   print(error);
    //   platformResponse = error.toString();
    // }

    // if(!mounted) return;
    //
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text(platformResponse))
    // );
  }
}
