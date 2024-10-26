import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HotelReg extends StatefulWidget {
  @override
  _HotelRegState createState() => _HotelRegState();
}

class _HotelRegState extends State<HotelReg> {
  final formKey = GlobalKey<FormState>();
  String hotelName = '';
  String email = '';
  String password = '';
  String hotelAddress = '';

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
                addressField(),
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

  Widget addressField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration:
          InputDecoration(labelText: 'Address', hintText: 'Location/Address'),
      onSaved: (value) {
        hotelAddress = value;
      },
    );
  }

  Widget nameField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          labelText: 'Name', hintText: 'Your Name e.g John Doe'),
      onSaved: (value) {
        hotelName = value;
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
        // Navigator.pushReplacementNamed(context, 'Home')
        //     .then((value) => print(value));

        if (formKey.currentState.validate()) {
          formKey.currentState.save();
        }

        final body = jsonEncode({
          'hotelName': hotelName,
          'email': email,
          'password': password,
          'hotelAddress': hotelAddress
        });
        // // print(email);
        await http.post('http://10.0.2.2:5000/hotel_register',
            headers: {"Content-Type": "application/json"}, body: body);
      },
    );
  }
}
