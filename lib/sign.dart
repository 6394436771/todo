import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:to_do_list/homescreen.dart';
import 'package:to_do_list/login.dart';

class SignUP extends StatefulWidget {
  const SignUP({Key? key}) : super(key: key);

  @override
  State<SignUP> createState() => _SignUPState();
}

bool isPressed = false;

TextEditingController passwordController = TextEditingController();
TextEditingController emailController = TextEditingController();

class _SignUPState extends State<SignUP> {
  final auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child:
          Container(
            padding: const EdgeInsets.only(left: 20,right: 20,top: 60),
            child: Column(
              children: [
                const Padding(
                  padding:  EdgeInsets.only(right: 320,top: 50,bottom: 20),
                  child: Icon(Icons.task_alt,size: 50,),
                ),
                const SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Sign up ',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: Colors.black),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(

                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: [
                      const Padding(
                        padding:  EdgeInsets.only(right: 320),
                        child: Text('Email',style: TextStyle(fontWeight: FontWeight.w900,fontSize: 15),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20,top: 10),
                        child: Container(
                          padding: const EdgeInsets.only(right: 20,left: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey)
                          ),
                          height: 50,
                          child: TextFormField(
                            cursorColor: Colors.grey,
                            cursorHeight: 20,
                            controller: emailController,
                            validator: (value) => Validator.validateEmail(
                                email: value.toString()),
                            decoration: const InputDecoration(


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
                            controller: passwordController,
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
                             await FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                        email: emailController.text,
                                        password: passwordController.text);

                                if (_formKey.currentState!.validate()) {
                                  await FirebaseFirestore.instance.collection('users').doc(auth.currentUser?.uid).set({
                                    'email':emailController.text
                                  });
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
                          Text('Already have an Account?'),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const LogIn()));
                              },
                              child:  Text(
                                'Log in',
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
        ),
      ),
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
    RegExp passwordRegExp =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

    if (password.isEmpty) {
      return 'Password can\'t be empty';
    } else if (!passwordRegExp.hasMatch(password)) {
      return 'Enter a valid password';
    } else if (password.length < 6) {
      return 'Password must be 6 characters';
    }

    return null;
  }
}
