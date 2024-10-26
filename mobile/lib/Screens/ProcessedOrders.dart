import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import '../Provider/Food_Provider.dart';
import 'package:http/http.dart' as http;

class ProcessedOrders extends StatefulWidget {
  @override
  _ProcessedOrdersState createState() => _ProcessedOrdersState();
}

class _ProcessedOrdersState extends State<ProcessedOrders> {
  LocalStorage storage = new LocalStorage('food_app');

  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final hotel = storage.getItem('hotel');
      // print('profile id is $id');
      Provider.of<FoodProvider>(context).getProcessFoods(hotel['_id']);
      // final user = Provider.of<Auth>(context).authenticate();

      // print(user);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  callDelivery(i) async {
    final body = jsonEncode({});
    await http.post('http://10.0.2.2:5000/call_delivery',
        headers: {"Content-Type": "application/json"}, body: body);
  }

  @override
  Widget build(BuildContext context) {
    final foodData = Provider.of<FoodProvider>(context);
    final foods = foodData.processedItems;

    print('processed ordes are $foods');

    return Scaffold(
        appBar: AppBar(
          title: Text('Orders in Process'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: foods
                .asMap()
                .map((i, n) => MapEntry(
                    i,
                    Container(
                        padding: EdgeInsets.only(bottom: 5, left: 5),
                        child: Column(children: [
                          Text('Customer Name: ${n.customerName}'),
                          Column(
                            children: n.info
                                .map<Widget>((m) => Column(children: [
                                      Text(m['foodName']),
                                    ]))
                                .toList(),
                          ),
                          Row(
                            children: [
                              Text('Call the delivery Man when ready'),
                              RaisedButton(
                                onPressed: () => callDelivery(i),
                                child: Text('Call'),
                              ),
                            ],
                          ),
                        ]))))
                .values
                .toList(),
          ),
        ));
  }
}
