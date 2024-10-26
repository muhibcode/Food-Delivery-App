import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../Provider/auth.dart';
import 'package:localstorage/localstorage.dart';

// ignore: must_be_immutable
class FoodDetails extends StatefulWidget {
  // final Map<String, dynamic> routeArgs = {};
  @override
  _FoodDetailsState createState() => _FoodDetailsState();
}

class _FoodDetailsState extends State<FoodDetails> {
  String id;

  String title;

  String price;

  String quantity;

  String hotelID;

  String customerName;
  List<dynamic> foodInfo = [];

  List<dynamic> foodOrders = [];

  LocalStorage storage = new LocalStorage('food_app');

  IO.Socket socket = IO.io('http://10.0.2.2:5000', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
  });

  addOrders(context, i) async {
    // 'hotelID': hotelID,

    final details = {
      'foodName': foodInfo[i]['foodName']['name'],
      'foodPrice': foodInfo[i]['foodPrice'],
      'foodQuantity': foodInfo[i]['foodQuantity']
    };

    final customer = storage.getItem('customer');

    // if (authData != null) {
    //   // userID = authData['userID'];

    //   final res = await http
    //       .get('http://10.0.2.2:5000/get_user?id=${authData['userID']}');

    //   // final data = jsonDecode(res.body);
    //   customerName = res.body;
    // }8

    foodOrders = await storage.getItem('orders') ?? [];

    foodOrders.add(details);
    storage.setItem('orders', foodOrders);
    // final authData = storage.getItem('authInfo');
    print('food added $foodOrders');
    // final userID = authData['userID'];
    Navigator.pushReplacementNamed(context, 'CustomerOrder', arguments: {
      'hotelID': hotelID,
      'customerID': customer['_id'],
      'customerName': customer['name'],
      'info': [
        {
          'foodName': foodInfo[i]['foodName']['name'],
          'foodPrice': foodInfo[i]['foodPrice'],
          'foodQuantity': foodInfo[i]['foodQuantity']
        }
      ]
    });

    // final res = await http.get('http://10.0.2.2:5000/food_order?data=$details');

    // print('hotel name is ${auth.hotelInfo['name']}');

    // socket.on('requestReceived', (msg) {
    //   print(msg);
    // });
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    hotelID = routeArgs['hotelID'];
    foodInfo = routeArgs['foodInfo'];
    return Scaffold(
      appBar: AppBar(
        title: Column(
            children: foodInfo
                .map((e) => Column(
                      children: [
                        Text(e['foodName']['name']),
                      ],
                    ))
                .toList()),
      ),
      body: Card(
          // shape:
          //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 18,
          child: Container(
            margin: EdgeInsets.all(10),
            child: Column(
              children: foodInfo
                  .asMap()
                  .map((i, n) => MapEntry(
                      i,
                      Column(
                        children: [
                          ClipRRect(
                            // clipBehavior: Clip.antiAlias,
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
                              height: 285,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Text(n['foodName']['name']),
                          RaisedButton(
                            onPressed: () => addOrders(context, i),
                            child: Text('Add To Orders'),
                          )
                        ],
                      )))
                  .values
                  .toList(),
            ),
          )),
    );
  }
}
