import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class CustomerOrders extends StatefulWidget {
  @override
  _CustomerOrdersState createState() => _CustomerOrdersState();
}

class _CustomerOrdersState extends State<CustomerOrders> {
  final LocalStorage storage = new LocalStorage('food_app');
  final formKey = GlobalKey<FormState>();

  List<dynamic> items = [];
  String hotelID;
  String customerName;
  String address = '';

  IO.Socket socket = IO.io('http://10.0.2.2:5000', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
  });

  @override
  void initState() {
    final vals = storage.getItem('orders');
    if (vals != null) {
      for (var item in vals) {
        setState(() {
          items.add(item);
        });
      }
    }

    // print(items);
    super.initState();
  }

  orderFood() {
    formKey.currentState.save();
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

    // socket.connect();
    print('pressed');
    final orderDetails = {
      'hotelID': routeArgs['hotelID'],
      'customerName': routeArgs['customerName'],
      'customerID': routeArgs['customerID'],
      'dropOffAddress': address,
      'foodInfo': items
    };

    socket.emit('orderFood', orderDetails);
  }

  Widget addressField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          labelText: 'Address', hintText: 'Enter Drop off Address'),
      onSaved: (value) {
        address = value;
      },
    );
  }

  // String showItems() {}

  @override
  Widget build(BuildContext context) {
    // final routeArgs =
    //     ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    // hotelID = routeArgs['hotelID'];
    // customerName = routeArgs['customerName'];

    return Scaffold(
        appBar: AppBar(
          title: Text('Orders Page'),
        ),
        body: Container(
          margin: EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Column(
                  children: items
                      .asMap()
                      .map((i, n) => MapEntry(
                          i,
                          Container(
                              padding: EdgeInsets.only(bottom: 5, left: 5),
                              child: Column(
                                children: [
                                  Text(n['foodName']),
                                  Text(n['foodPrice']),
                                  Text(n['foodQuantity']),
                                ],
                              ))))
                      .values
                      .toList(),
                ),
                addressField(),
                ElevatedButton(
                  onPressed: orderFood,
                  child: Text('Order Food'),
                )
              ],
            ),
          ),
        ));
  }
}
