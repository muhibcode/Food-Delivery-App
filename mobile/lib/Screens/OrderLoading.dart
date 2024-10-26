import 'dart:async';

import 'package:flutter/material.dart';

class OrderLoad extends StatefulWidget {
  @override
  _OrderLoadState createState() => _OrderLoadState();
}

class _OrderLoadState extends State<OrderLoad> {
  @override
  void initState() {
    Timer(Duration(seconds: 1), () {
      Navigator.pushReplacementNamed(context, 'HotelOrders');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
