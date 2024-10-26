import 'package:first_app/Screens/Categories_Screen.dart';
import 'package:first_app/Screens/DeliveryProfile.dart';
import 'package:first_app/Screens/DeliveryReg.dart';
import 'package:first_app/Screens/HotelReg_Screen.dart';
import 'package:first_app/Screens/Hotel/Hotel_Screen.dart';
import 'package:first_app/Screens/OrderLoading.dart';
import 'package:first_app/Screens/ProcessedOrders.dart';
import 'package:first_app/Screens/Register_Screen.dart';
import 'package:flutter/material.dart';

import 'package:first_app/Modals/HotelModal.dart';
import 'package:first_app/Screens/CustomerOrder_Screen.dart';
import './Screens/Filter_Screen.dart';
import './Screens/HotelOrders.dart';
import 'package:first_app/Screens/HotelProfile.dart';
import 'package:first_app/Screens/Loading.dart';
import './Screens/FoodDetail_Screen.dart';
import './Provider/auth.dart';
import 'package:first_app/Screens/Login_Screen.dart';
import 'package:provider/provider.dart';
import './Provider/Food_Provider.dart';
import './Screens/Food_overview.dart';
import './Screens/HotelFoodForm.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:localstorage/localstorage.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import 'Screens/Cart_Screen.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (ctx) => FoodProvider(),
      child: MaterialApp(
        title: 'Food Delivery',
        // theme: ThemeData(
        //   primaryColor: Colors.yellow[700],
        //   // primarySwatch: ,
        // ),

        // title: 'Food Shop',
        home: Phoenix(
          child: MyApp(),
        ),
        routes: {
          'HotelOrders': (ctx) => HotelOrders(),
          'OrderLoad': (ctx) => OrderLoad(),
          'HotelProfile': (ctx) => HotelProfile(),

          // 'HotelProfile': (ctx) => HotelProfile(),
        },
      )));
}

// class RestartWidget extends StatefulWidget {
//   RestartWidget({this.child});

//   final Widget child;

//   static void restartApp(BuildContext context) {
//     context.findAncestorStateOfType<_RestartWidgetState>().restartApp();
//   }

//   @override
//   _RestartWidgetState createState() => _RestartWidgetState();
// }

// class _RestartWidgetState extends State<RestartWidget> {
//   Key key = UniqueKey();

//   void restartApp() {
//     setState(() {
//       key = UniqueKey();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return KeyedSubtree(
//       key: key,
//       child: widget.child,
//     );
//   }
// }

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // final LocalStorage storage = new LocalStorage('foodies');
  final LocalStorage storage = new LocalStorage('food_app');

  IO.Socket socket = IO.io('http://10.0.2.2:5000', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
  });
  bool _isInit = true;
  List<dynamic> foods;
  String customerID;
  String hotelID;
  String deliveryID;

  String msgs;
  Map<String, dynamic> info;

  int count = 0;

  // @override
  // void initState() {
  //   // final authData = storage.getItem('authInfo');

  //   storage.ready.then((_) => authFunc());

  //   print('user info is');

  //   super.initState();
  // }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      // storage.clear();

      storage.ready.then((_) => authFunc());
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  authFunc() async {
    socket.connect();

    final customer = await storage.getItem('customer');
    final hotel = await storage.getItem('hotel');
    final delivery = await storage.getItem('delivery');

    if (customer != null) {
      setState(() {
        customerID = customer['_id'];

        print('user info is $customerID');
      });
    }

    if (hotel != null) {
      setState(() {
        hotelID = hotel['_id'];

        print('user info is $hotelID');
      });
    }

    if (delivery != null) {
      setState(() {
        deliveryID = delivery['_id'];

        print('user info is $deliveryID');
      });
    }

    socket.on('reqReject$customerID', (msg) {
      customerModal(context, msg);
    });

    socket.on('reqAccept$customerID', (msg) {
      customerModal(context, msg);
    });

    socket.on('orderFood$hotelID', (msg) {
      hotelModal(context, msg);
    });

    socket.on('callFoodDelivery$deliveryID', (msg) {
      deliveryModal(context, msg);
    });

    // print('auth id is $authData');
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          // ChangeNotifierProvider(create: (ctx) => Auth()),

          ChangeNotifierProvider(
            create: (ctx) => Auth(),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            // title: 'Foodie Shop',
            theme: ThemeData(
              primaryColor: Colors.yellow[700],
              // primarySwatch: ,
            ),
            home: customerID != null
                ? FoodOverview()
                : hotelID != null
                    ? HotelProfile()
                    : deliveryID != null
                        ? DeliveryProfile()
                        : Loading(),
            // initialRoute: '/',
            routes: {
              // '/': (ctx) => MyApp(auth),
              'Home': (ctx) => FoodOverview(),
              'Login': (ctx) => Login(),
              'Register': (ctx) => Register(),

              'FoodDetails': (ctx) => FoodDetails(),
              'HotelFoodForm': (ctx) => HotelFoodForm(auth),
              'Loading': (ctx) => Loading(),
              'HotelModal': (ctx) => HotelModal(),
              'HotelProfile': (ctx) => HotelProfile(),
              'HotelOrders': (ctx) => HotelOrders(),
              'HotelReg': (ctx) => HotelReg(),
              'DeliveryReg': (ctx) => DeliveryReg(),
              'OrderLoad': (ctx) => OrderLoad(),
              'DeliveryProfile': (ctx) => DeliveryProfile(),
              'HotelScreen': (ctx) => HotelScreen(),

              'CustomerOrder': (ctx) => CustomerOrders(),
              'ProcessOrders': (ctx) => ProcessedOrders(),
              'CartScreen': (ctx) => CartScreen(),
              'FoodCategory': (ctx) => FoodCategory(),

              'Filter': (ctx) => Filters()
            },
          ),

          // home: Consumer<Auth>(builder: (ctx, auth, _) => Home()),
        ));
  }

  // toJSONEncodable() {
  //   return foods.map((item) {
  //     return item.toJSONEncodable();
  //   }).toList();
  // }
  modalNavigation() {
    if (count == 1) {
      setState(() {
        count = count - 1;
      });
      Navigator.pop(context);

      // Navigator.pushReplacementNamed(context, 'OrderLoad');
    } else {
      Navigator.pop(context);
      setState(() {
        count = count - 1;
      });
    }
  }

  void deliveryModal(context, args) {
    Provider.of<FoodProvider>(context, listen: false).newDeliveryOrder(args);

    showDialog(
        context: context,
        builder: (context) => Container(
            color: Colors.white.withOpacity(0.5),
            child: AlertDialog(
              title: Text('Food Request!!'),
              // elevation: 20,
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    // Text(args['data']),
                    // Text(args['name'])
                    Text('Would you like to approve of this message?'),
                  ],
                ),
              ),
              actions: <Widget>[
                RaisedButton(child: Text('View'), onPressed: modalNavigation),
              ],
            )));
  }

  void customerModal(context, args) {
    showDialog(
        context: context,
        builder: (context) => Container(
            color: Colors.white.withOpacity(0.5),
            child: AlertDialog(
              title: Text('Food Request!!'),
              // elevation: 20,
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(args['data']),
                    // Text(args)
                    // Text('Would you like to approve of this message?'),
                  ],
                ),
              ),
              actions: <Widget>[
                RaisedButton(child: Text('OK'), onPressed: modalNavigation),
              ],
            )));
  }

  void hotelModal(context, args) {
    // Navigator.pushNamed(context, 'HotelProfile');

    setState(() {
      count = count + 1;
    });

    Provider.of<FoodProvider>(context, listen: false).newOrder(args);

    showDialog(
        context: context,
        builder: (context) => Container(
            color: Colors.white.withOpacity(0.5),
            child: AlertDialog(
              title: Text('Food Request!!'),
              // elevation: 20,
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(
                        'New Food Request ${args['foodInfo'].map((n) => n['foodName'])}'),
                    // Text('Would you like to approve of this message?'),
                  ],
                ),
              ),
              actions: <Widget>[
                RaisedButton(child: Text('View'), onPressed: modalNavigation),
              ],
            )));
  }
}
