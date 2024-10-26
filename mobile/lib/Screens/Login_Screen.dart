import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/auth.dart';
import 'dart:async';

class Login extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
          decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/e3a5d05f404c56afa57c023f4ba44612.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken),
        ),
      )),
      Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            margin: EdgeInsets.all(20.0),
            child: Form(
                key: formKey,
                child: Column(
                  children: [
                    emailField(),
                    passwordField(),
                    submitButton(),
                    Text('If not member then first register'),
                  ],
                )),
          )),
    ]);
  }

  Widget emailField() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16)),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email Address',
              hintText: 'you@example.com',
              border: InputBorder.none,
            ),
            // ignore: missing_return
            validator: (String value) {
              if (!value.contains('@')) {
                return 'please enter a valid email';
              }
            },
            onSaved: (value) {
              email = value;
            },
          ),
        ),
      ),
    );
  }

  Widget passwordField() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16)),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Password',
              // hintText: 'you@example.com',
              border: InputBorder.none,
            ),
            // ignore: missing_return
            // validator: (String value) {
            //   if (!value.contains('@')) {
            //     return 'please enter a valid email';
            //   }
            // },
            onSaved: (value) {
              password = value;
            },
          ),
        ),
      ),
    );
  }

  Widget submitButton() {
    return ElevatedButton(
      child: Text('Submit'),
      onPressed: () {
        if (formKey.currentState.validate()) {
          formKey.currentState.save();
        }
        Provider.of<Auth>(context, listen: false).login(email, password);

        Timer(Duration(seconds: 1), () {
          Navigator.pushReplacementNamed(context, 'Loading');
        });

        // var res = Provider.of<Auth>(context).token;

        // print(res);
      },
    );
  }
}
