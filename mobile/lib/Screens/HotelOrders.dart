import 'package:first_app/Provider/Food_Provider.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class HotelOrders extends StatefulWidget {
  @override
  _HotelOrdersState createState() => _HotelOrdersState();
}

class _HotelOrdersState extends State<HotelOrders> {
  final LocalStorage storage = new LocalStorage('food_app');

  IO.Socket socket = IO.io('http://10.0.2.2:5000', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
  });

  List<dynamic> items = [];
  List<dynamic> check = [];

  String title = 'Accept';

  String customerID;
  bool _isInit = true;

  // @override
  // void initState() {
  //   // final vals = storage.getItem('foodQuery');
  //   // // final customer = storage.getItem('customer');

  //   // if (vals != null) {
  //   //   for (var item in vals) {
  //   //     setState(() {
  //   //       items.add(item);
  //   //       check.add(false);
  //   //     });
  //   //   }
  //   // }

  //   // print(items);
  //   super.initState();
  // }
  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<FoodProvider>(context).acceptOrders();
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  accept(i) {
    Provider.of<FoodProvider>(context, listen: false).acceptReq(i);
  }

  rejectReq(i) {
    // final customer = storage.getItem('customer');

    // if (customer != null) {
    //   setState(() {
    //     customerID = customer['_id'];
    //   });
    // }
    // print(customerID);

    socket.emit('reqReject', {
      'customerID': items[i]['customerID'],
      'data': 'Sorry your desired food is finished'
    });

    // final authData = storage.getItem('authInfo');

    // setState(() {
    //   splice(items, i, 1);
    // });

    // print(items.length);

    // storage.setItem('foodQuery', items);
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<FoodProvider>(context);
    final orderItems = data.items;
    return Scaffold(
        appBar: AppBar(
            // automaticallyImplyLeading: false,
            title: Row(
          children: [
            Text('New Orders'),
            InkWell(
              child: Text('Profile'),
              onTap: () {
                Navigator.pushReplacementNamed(context, 'HotelProfile');
              },
            ),
          ],
        )),
        body: SingleChildScrollView(
          child: Column(
            children: orderItems
                .asMap()
                .map((i, n) => MapEntry(
                    i,
                    Container(
                        padding: EdgeInsets.only(bottom: 5, left: 5),
                        child: Column(children: [
                          Text('Customer Name: ${n['customerName']}'),
                          Column(
                            children: n['info']
                                .map<Widget>((m) => Column(children: [
                                      Text(m['foodName']),
                                    ]))
                                .toList(),
                          ),
                          Row(
                            children: [
                              RaisedButton(
                                onPressed: () => accept(i),
                                child: Text('Accept'),
                              ),
                              RaisedButton(
                                  onPressed: () => rejectReq(i),
                                  child: Text('Reject')),
                            ],
                          ),
                        ]))))
                .values
                .toList(),
          ),
        ));
  }
}
