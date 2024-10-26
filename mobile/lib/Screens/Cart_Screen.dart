import 'package:first_app/Provider/Food_Provider.dart';
import 'package:flutter/material.dart';
// import 'package:js_shims/js_shims.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final LocalStorage storage = new LocalStorage('food_app');
  List<dynamic> items = [];
  List<int> counter = [];
  String address;

  bool _isInit = true;

  IO.Socket socket = IO.io('http://10.0.2.2:5000', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
  });

  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    final vals = storage.getItem('cartFood');

    if (vals != null) {
      for (var i = 0; i < vals.length; i++) {
        counter.add(1);
      }
      // setState(() {
      //   items = vals;
      // });
    }

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<FoodProvider>(context, listen: true).getCartItems();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  _cartList(cart, i) {
    // final data = Provider.of<FoodProvider>(context);
    // final cart = data.cartItems;
    // print(items);
    // int counter = int.parse(cart['foodQuantity']);

    return Container(
      // padding: EdgeInsets.all(20),
      height: 170.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  width: 120.0,
                  height: 120.0,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
                        ),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(15.0)),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cart[i]['foodName'],
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Bandu Khan',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        // alignment: Alignment.center,
                        // margin: EdgeInsets.symmetric(horizontal: 20),
                        width: 105,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1.0, color: Colors.black),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Material(
                              // borderRadius: BorderRadius.circular(25.0),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(30.0),
                                splashColor: Colors.black,
                                highlightColor: Colors.black,
                                onTap: () {
                                  setState(() {
                                    if (counter[i] > 1) {
                                      counter[i]--;
                                    }
                                  });
                                },
                                child: Icon(
                                  Icons.remove,
                                  color: Theme.of(context).primaryColor,

                                  size: 22.0,
                                  // style: TextStyle(
                                  //     fontWeight: FontWeight.w600, fontSize: 30),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              '${counter[i]}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 23),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Material(
                              child: InkWell(
                                borderRadius: BorderRadius.circular(30.0),
                                splashColor: Colors.black,
                                highlightColor: Colors.black,
                                onTap: () {
                                  setState(() {
                                    counter[i]++;
                                  });
                                },
                                child: Icon(
                                  Icons.add,
                                  color: Colors.black,
                                  size: 22.0,
                                  // style: TextStyle(
                                  //     fontWeight: FontWeight.w600, fontSize: 20),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                  icon: Icon(Icons.clear_rounded),
                  onPressed: () {
                    Provider.of<FoodProvider>(context, listen: false)
                        .delItem(i);
                  }),
              Container(
                margin: EdgeInsets.only(right: 24, top: 26),
                child: Text(
                  'Rs:${int.parse(cart[i]['foodPrice']) * counter[i]}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget addressForm() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Address',
      ),
      // ignore: missing_return
      validator: (String value) {
        if (value.length < 4) {
          return 'Enter Your Location';
        }
      },
      onSaved: (value) {
        address = value;
      },
    );
  }

  pressed() async {
    // formKey.currentState.save();

    // print('items are ${storage.getItem('cartFood')}');

    final items = await storage.getItem('cartFood');
    final customer = await storage.getItem('customer');

    // final orderDetails = items['foodPrice'];

    final orderDetails = {
      // 'hotelID': items['hotelID'],
      'customerName': customer['name'],
      'customerID': customer['_id'],
      // 'dropOffAddress': address,
      'foodInfo': items,
      // 'foodID': items['_id'],
      // 'foodName': items['foodName']['name'],
      // 'foodPrice': items['foodPrice'],
      // 'foodQuantity': items['foodQuantity']
    };
    print('items are $orderDetails');

    socket.emit('orderFood', orderDetails);
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<FoodProvider>(context, listen: false);
    final items = data.cartItems;
    double totalPrice = 0;

    items.forEach((n) {
      totalPrice += int.parse(n['foodPrice']);
    });
    // print('cart items are $items');
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          if (index < items.length) {
            return _cartList(items, index);
          }

          return Column(
            children: [
              Container(
                // margin: EdgeInsets.symmetric(vertical: 500.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Price',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          'Rs:$totalPrice',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                    addressForm()
                    // Form(
                    //   key: formKey,
                    //   child: addressForm(),
                    // )
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [Text('Hello'), Text('hello 2')],
                    // )
                  ],
                ),
              ),
              // Divider(
              //   color: Colors.black,
              //   height: 0.5,
              //   thickness: 0.5,
              // ),
              RaisedButton(
                onPressed: items.length > 0
                    ? () {
                        pressed();
                      }
                    : null,
                child: Text('Order Now'),
              )
            ],
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            color: Colors.grey,
            height: 1.0,
          );
        },
        itemCount: items.length + 1,
      ),
    );
  }
}
