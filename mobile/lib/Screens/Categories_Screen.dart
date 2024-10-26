import 'dart:convert';

import 'package:first_app/Widgets/Restaurants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FoodCategory extends StatefulWidget {
  // FoodCategory(this.restaurants);

  @override
  _FoodCategoryState createState() => _FoodCategoryState();
}

class _FoodCategoryState extends State<FoodCategory> {
  List<dynamic> restaurants = [];
  String title;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    if (_isInit) {
      getHotel(routeArgs['id']);
      title = routeArgs['title'];
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  getHotel(id) async {
    final res = await http.get('http://10.0.2.2:5000/get_hotel?typeID=$id');

    setState(() {
      restaurants = jsonDecode(res.body);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$title Restaurants'),
      ),
      body: Container(
          margin: EdgeInsets.symmetric(vertical: 7),
          child: Restaurants(restaurants)),
      // body: ListView.builder(
      //     itemBuilder: (BuildContext context, int index) {
      //       return Restaurants(restaurants);
      //     },
      //     itemCount: restaurants.length),
    );
  }
}
