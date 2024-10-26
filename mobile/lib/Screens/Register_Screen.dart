import 'package:flutter/material.dart';

class Register extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('Register yourself as a...'),
            RaisedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, 'SignUp');
              },
              child: Text('Customer'),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, 'HotelReg');
              },
              child: Text('Hotel'),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, 'DeliveryReg');
              },
              child: Text('Be apart of our delivery team'),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, 'Login');
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
