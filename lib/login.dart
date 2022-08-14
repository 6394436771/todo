// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebasedata/fetchdata.dart';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/homescreen.dart';
import 'package:to_do_list/sign.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

FirebaseAuth auth = FirebaseAuth.instance;
final formKey = GlobalKey<FormState>();

bool isObscure = true;
bool showSpinner = false;

TextEditingController email = TextEditingController();
TextEditingController password = TextEditingController();

class _LogInState extends State<LogIn> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child:Column(children: [

          Form(
            key: formKey,
            child:  Container(
              padding: EdgeInsets.only(left: 20,right: 20,top: 60),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 320,top: 50,bottom: 20),
                    child: Icon(Icons.task_alt,size: 50,),
                  ),
                  Container(
                    width: double.infinity,
                    child: Text(
                      'Log In ',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(

                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 320),
                          child: Text('Email',style: TextStyle(fontWeight: FontWeight.w900,fontSize: 15),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20,top: 10),
                          child: Container(
                            padding: EdgeInsets.only(right: 20,left: 20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.grey)
                            ),
                            height: 50,
                            child: TextFormField(
                              cursorColor: Colors.grey,
                              cursorHeight: 20,
                              controller: email,
                              validator: (value) => Validator.validateEmail(
                                  email: value.toString()),
                              decoration: InputDecoration(


                                  hintText: 'mail@gmail.com',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 300,top: 10),
                          child: Text('Password',style: TextStyle(fontWeight: FontWeight.w900,fontSize: 15),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20,top: 10),
                          child: Container(
                            padding: EdgeInsets.only(left: 20,right: 20),
                            height: 50,

                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.grey)
                            ),
                            child: TextFormField(
                              cursorColor: Colors.grey,
                              controller: password,
                              // validator: (value) => Validator.validatePassword(
                              //     password: value.toString()),
                              decoration: InputDecoration(
                                // icon: Icon(Icons.person),
                                  hintText: 'adi123@#',

                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 250),
                          child: TextButton(
                              onPressed: () {},
                              child: Text(
                                'Forgot password',
                                style: TextStyle(fontSize: 12, color: Colors.black),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10,right: 20),
                          child: Container(
                            height: 50,
                            width: 350,


                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: isPressed ? Colors.blue : Colors.purple,
                                onPrimary: Colors.white, // foreground
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              onPressed: () async {
                                setState(() {
                                  isPressed = true;
                                });
                                try {
                                  final user = await FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                      email: email.text,
                                      password: password.text);
                                  await FirebaseFirestore.instance
                                      .collection('user')
                                      .add({});

                                  if (formKey.currentState!.validate()) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomeScreen()));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Processing Data')),
                                    );
                                  }
                                } catch (e) {
                                  print(e);
                                }
                              },
                              child: const Text('Sign in'),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Text('Not Register yet?'),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const LogIn()));
                                },
                                child:  Text(
                                  'Create an Account',
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                )),
                          ],
                        )

                      ],
                    ),
                  )
                ],
              ),
            ),
            // Column(
            //   children: [
            //     SizedBox(
            //       width: 330,
            //       height: 80,
            //       child: TextFormField(
            //
            //         controller: email,
            //         validator: (value) => Validator.validateEmail(
            //             email: value.toString()),
            //         decoration: InputDecoration(
            //           hintText: '',
            //           hintStyle: TextStyle(color: Colors.orangeAccent),
            //           labelText: 'Email',
            //           labelStyle: TextStyle(color: Colors.black),
            //           focusedBorder: OutlineInputBorder(
            //               borderSide: BorderSide(
            //                   width: 3, color: Colors.orangeAccent),
            //               borderRadius: BorderRadius.circular(20)),
            //         ),
            //       ),
            //     ),
            //
            //     SizedBox(
            //       width: 330,
            //       height: 80,
            //       child: TextFormField(
            //
            //         controller: password,
            //         validator: (value) => Validator.validatePassword(
            //             password: value.toString()),
            //         obscureText: isObscure,
            //         decoration: InputDecoration(
            //           // icon: Icon(Icons.lock),
            //           // prefixIcon:Icon(Icons.email_rounded),
            //           suffixIcon: IconButton(
            //             onPressed: () {
            //               setState(() {
            //                 isObscure = !isObscure;
            //               });
            //             },
            //             icon: Icon(
            //               isObscure
            //                   ? Icons.visibility
            //                   : Icons.visibility_off,
            //               color: isObscure
            //                   ? Colors.black
            //                   : Colors.orangeAccent,
            //             ),
            //           ),
            //           labelText: 'Password',
            //           labelStyle: const TextStyle(color: Colors.grey),
            //           focusedBorder: OutlineInputBorder(
            //             borderSide: const BorderSide(
            //                 width: 3, color: Colors.orangeAccent),
            //             borderRadius: BorderRadius.circular(15),
            //             //  enabledBorder: OutlineInputBorder(
            //             //                   borderSide: const BorderSide(width: 3, color: Colors.blue),
            //             //                   borderRadius: BorderRadius.circular(15),
            //             //                 ),
            //           ),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
          ),



          // const SizedBox(
          //   height: 40,
          // ),
          //
          // Container(
          //   height: 50,
          //   width: 300,
          //   child: ElevatedButton(
          //     style: ElevatedButton.styleFrom(
          //       primary: Colors.orange,
          //     ),
          //     onPressed: () async {
          //
          //       try {
          //         final user = await FirebaseAuth.instance
          //             .signInWithEmailAndPassword(
          //             email: email.text, password: password.text);
          //         if (user != null) {
          //           Navigator.push(
          //               context,
          //               MaterialPageRoute(
          //                   builder: (context) => HomeScreen()));
          //         } else {
          //           return null;
          //         }
          //       } catch (e) {
          //         print(e);
          //       }
          //
          //       if (formKey.currentState!.validate()) {
          //         ScaffoldMessenger.of(context).showSnackBar(
          //           const SnackBar(content: Text('Processing Data')),
          //         );
          //       } else {
          //         ScaffoldMessenger.of(context).showSnackBar(
          //           const SnackBar(
          //               content: Text('Something went wrong')),
          //         );
          //       }
          //     },
          //     child: const Text('Submit'),
          //   ),
          // ),
          // TextButton(
          //     onPressed: () {
          //       Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //               builder: (context) => const SignUP()));
          //     },
          //     child: const Text(
          //       'Create Account',
          //       style: TextStyle(
          //         color: Colors.black,
          //       ),
          //     )),
        ],)


      )
              );


  }
}

   class Validator {
   static String? validateEmail({required String email}) {
    if (email == null) {
      return null;
    }
    RegExp emailRegExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

    if (email.isEmpty) {
      return 'Email can\'t be empty';
    } else if (!emailRegExp.hasMatch(email)) {
      return 'Enter a correct email';
    }

    return null;
  }

  static String? validatePassword({required String password}) {
    if (password == null) {
      return null;
    }
    RegExp passwordRegExp = RegExp(
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

    if (password.isEmpty) {
      return 'Password can\'t be empty';
    }
    else if (!passwordRegExp.hasMatch(password)) {
      return 'Enter a valid password';
    }
    else if (password.length < 6) {
      return 'Password must be 6 characters';
    }

    return null;
  }
}
