import 'package:first_app/Provider/auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:localstorage/localstorage.dart';
import './HotelProfile.dart';

class Loading extends StatefulWidget {
  // final Auth auth;

  // Loading(this.auth);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  LocalStorage storage = new LocalStorage('food_app');

  // @override
  // void initState() {
  //   // widget.auth.authenticate();
  //   storage.ready.then((_) => authInfo());
  //   // authInfo();
  //   super.initState();
  // }

  authInfo() async {
    final hotel = await storage.getItem('hotel');

    final customer = await storage.getItem('customer');
    final delivery = await storage.getItem('delivery');

    print('store data is $hotel');
    if (hotel == null && customer == null && delivery == null) {
      // CircularProgressIndicator()
      Navigator.pushReplacementNamed(context, 'Register');
    } else {
      if (hotel != null) {
        Navigator.pushReplacementNamed(context, 'HotelProfile');
      } else if (customer != null) {
        Navigator.pushReplacementNamed(context, 'Home');
      } else if (delivery != null) {
        Navigator.pushReplacementNamed(context, 'DeliveryProfile');
      }
    }

    // Timer(Duration(seconds: 3), () {
    //   if (hotel != null) {
    //     Navigator.pushReplacementNamed(context, 'HotelProfile');
    //   } else if (customer != null) {
    //     Navigator.pushReplacementNamed(context, 'Home');
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    storage.ready.then((_) => authInfo());

    // print(auth);
    return Container(
        color: Colors.white.withOpacity(0.5),
        child: AlertDialog(
          title: Text('Please wait....'),
          // elevation: 20,

          // backgroundColor: Colors.blueGrey,
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(
                  height: 10,
                ),
                // Text('This is a demo alert dialog.'),
                // Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ));
  }
}
