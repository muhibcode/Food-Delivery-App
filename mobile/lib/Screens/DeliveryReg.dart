import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DeliveryReg extends StatefulWidget {
  @override
  _DeliveryRegState createState() => _DeliveryRegState();
}

class _DeliveryRegState extends State<DeliveryReg> {
  final formKey = GlobalKey<FormState>();

  String name = '';
  String email = '';
  String password = '';
  String address = '';
  String vehicleNum = '';
  String licenseNum = '';

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
                vehicleNumField(),
                licenseNumField(),
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
        address = value;
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

  Widget vehicleNumField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          labelText: 'Vehicle Num', hintText: 'Vehicle num e,g lxl436'),
      onSaved: (value) {
        vehicleNum = value;
      },
    );
  }

  Widget licenseNumField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          labelText: 'License Num', hintText: 'Your license num'),
      onSaved: (value) {
        licenseNum = value;
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
          'name': name,
          'email': email,
          'password': password,
          'address': address,
          'vehicleNum': vehicleNum,
          'licenseNum': licenseNum
        });
        // // print(email);
        await http.post('http://10.0.2.2:5000/delivery_register',
            headers: {"Content-Type": "application/json"}, body: body);
      },
    );
  }
}
