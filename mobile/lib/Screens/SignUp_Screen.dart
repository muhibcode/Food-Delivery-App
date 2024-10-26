import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignUp extends StatefulWidget {
  @override
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
  //  List<DropdownMenuItem<FoodTypes>> _dropdownMenuItems;
  // FoodTypes _selectedItem;

  // Map<String, dynamic> foods;

  final formKey = GlobalKey<FormState>();
  String name = '';
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(20.0),
        child: Form(
            key: formKey,
            child: Column(
              children: [
                nameField(),
                emailField(),
                passwordField(),
                Container(
                    margin: EdgeInsets.only(top: 15), child: submitButton()),
              ],
            )),
      ),
    );
  }

  Widget emailField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          labelText: 'Email Address', hintText: 'you@example.com'),
      // ignore: missing_return
      validator: (String value) {
        if (!value.contains('@')) {
          return 'please enter a valid email';
        }
      },
      // onChanged: (value) => print(value),

      onSaved: (value) {
        email = value;
      },
    );
  }

  Widget nameField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          labelText: 'Name', hintText: 'Your Name e.g John Doe'),
      onSaved: (value) {
        name = value;
      },
    );
  }

  Widget passwordField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Password',
      ),
      // ignore: missing_return
      validator: (String value) {
        if (value.length < 4) {
          return 'password must contain 4 characters';
        }
      },
      onSaved: (value) {
        password = value;
      },
    );
  }

  Widget submitButton() {
    return RaisedButton(
      child: Text('Register'),
      onPressed: () async {
        // Navigator.pushNamed(context, 'Home');

        // Navigator.pop(context);

        // Navigator.pushReplacementNamed(context, 'Home')
        //     .then((value) => print(value));

        if (formKey.currentState.validate()) {
          formKey.currentState.save();
        }

        final body =
            jsonEncode({'name': name, 'email': email, 'password': password});
        // // print(email);
        await http.post('http://10.0.2.2:5000/register',
            headers: {"Content-Type": "application/json"}, body: body);
      },
    );
  }
}
