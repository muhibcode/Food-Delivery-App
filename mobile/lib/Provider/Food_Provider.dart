import 'dart:async';
import 'dart:convert';

import 'package:first_app/models/Food.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/ProcessFood.dart';
import 'package:localstorage/localstorage.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:js_shims/js_shims.dart';

class FoodProvider with ChangeNotifier {
  // String mainID;
  // String typeOfFood;
  String hotelID;
  String id;
  String title;
  String price;
  String quantity;
  List<dynamic> foods;
  // List<dynamic> requests;
  List<dynamic> processFood;
  List<dynamic> items = [];
  List<dynamic> deliveryReq;
  List<dynamic> deliveryFood = [];
  List<dynamic> categories = [];
  List<dynamic> hotels = [];
  List<dynamic> foodIDs = [];

  List<Food> _foodItems = [];
  List<Food> hotelItems = [];
  List<dynamic> foodInfo = [];
  List<dynamic> cartItems = [];
  int foodIndex = -1;
  List<int> foodIndexes = [];
  int delIndex = -1;
  List<dynamic> processedItems = [];
  Map<String, dynamic> filters = {
    'search': '',
    'priceRange': [0.0, 5000.0]
  };

  final LocalStorage storage = new LocalStorage('food_app');

  IO.Socket socket = IO.io('http://10.0.2.2:5000', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
  });

  Future<void> getFoodItems(val) async {
    if (val != null && val.containsKey('search')) {
      filters['search'] = val['search'];
    }
    if (val != null && val.containsKey('priceRange')) {
      filters['priceRange'] = val['priceRange'];
    }

    print('provider val is $val');
    final res = await http.post('http://10.0.2.2:5000/show_all_food',
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(filters));
    final data = jsonDecode(res.body);

    List<Food> loadedItems = [];

    // print(data);

    for (var n in data) {
      loadedItems.add(Food(
          // id: n['_id'],
          // title: n['foodName']['name'],
          // price: n['foodPrice'],
          // quantity: n['foodQuantity'],
          foodInfo: n['foodInfo'],
          hotelID: n['hotelID']['_id']));
    }

    // for (var item in data) {
    //   for (var n in item['foods']) {
    //     loadedItems.add(Food(
    //         // id: n['_id'],
    //         // title: n['foodName']['name'],
    //         // price: n['foodPrice'],
    //         // quantity: n['foodQuantity'],
    //         foodInfo: item['foodInfo'],
    //         hotelID: n['hotelID']));
    //   }
    // }

    // loadedItems.forEach((element) {
    //   for (var i = 0; i < element.foodInfo.length; i++) {
    //     isCheck.add(i);
    //   }
    // });

    _foodItems = loadedItems;

    _foodItems.forEach((m) {
      m.foodInfo.forEach((n) {
        foodIDs.add(n['_id']);
      });
    });

    // print(_foodItems);

    // setState(() {
    //   foodItems = data;
    // });
    notifyListeners();
    // foodstype.forEach((element) { })
  }

  getCartItems() async {
    final vals = await storage.getItem('cartFood');
    if (vals != null) {
      cartItems = vals;
    }
    print('cart items are $cartItems');

    notifyListeners();
  }

  delItem(i) {
    // print('del items are ${cartItems[i]['foodID']}');

    // _foodItems.forEach((m) {
    //   m.foodInfo.forEach((n) {
    //     if (n['_id'] == cartItems[i]['foodID']) {
    //       foodIndex = m.foodInfo.indexOf(n);
    //     }
    //   });
    // });

    foodIDs.forEach((n) {
      if (n == cartItems[i]['foodID']) {
        foodIndex = foodIDs.indexOf(n);
      }
    });

    splice(cartItems, i, 1);

    storage.setItem('cartFood', cartItems);

    // delIndex = i;

    notifyListeners();
  }

  Future<void> getHotelFoods(id) async {
    final res =
        await http.get('http://10.0.2.2:5000/get_hotelFood?hotelID=$id');

    List<Food> loadedItems = [];

    final data = jsonDecode(res.body);

    for (var item in data) {
      loadedItems.add(Food(
          mainID: item['_id'],
          hotelID: item['hotelID']['_id'],
          foodInfo: item['foodInfo']));
    }
    hotelItems = loadedItems;
    notifyListeners();
    // foodstype.forEach((element) { })
  }

  Future<void> getProcessFoods(id) async {
    final res =
        await http.get('http://10.0.2.2:5000/process_orders?hotelID=$id');

    List<ProcessFood> loadedItems = [];

    final data = jsonDecode(res.body);

    for (var item in data) {
      loadedItems.add(ProcessFood(
          mainID: item['_id'],
          customerName: item['customerInfo']['name'],
          info: item['info'],
          hotelID: item['hotelID']['_id']));
    }
    // info: foodInfo,

    processedItems = loadedItems;
    notifyListeners();
    // foodstype.forEach((element) { })
  }

  getCategories() async {
    final res = await http.get('http://10.0.2.2:5000/get_categories');
    final data = jsonDecode(res.body);
    categories = data;
    notifyListeners();
  }

  getHotels() async {
    final res = await http.get('http://10.0.2.2:5000/get_hotels');
    final data = jsonDecode(res.body);
    hotels = data;
    notifyListeners();
  }

  addToCart(details, index) async {
    foodIndex = index;
    List<dynamic> foodss = [];

    List<dynamic> foodOrders = await storage.getItem('cartFood') ?? [];
    if (foodOrders.isEmpty) {
      foodOrders.add(details);
      // storage.setItem('cartFood', foodOrders);
    } else {
      foodOrders.forEach((n) {
        if (n['hotelID'] == details['hotelID']) {
          foodss.add(details);

          print('items are same');
        } else {
          print('items are not same');
        }
      });

      foodss.forEach((m) {
        foodOrders.add(m);
      });
    }

    // foodOrders.add(foodss.map(e=>e));
    await storage.setItem('cartFood', foodOrders);

    // final cart = {'hotelID': hFood.hotelID, 'foodInfo': foodOrders};

    // cart == {}
    //     ? cart.addAll({'hotelID': hFood.hotelID, 'foodInfo': foodOrders})
    //     : cart.addAll({'foodInfo': foodOrders});

    final vals = await storage.getItem('cartFood');

    cartItems = vals;
    // foodIndexes.add(index);

    print('indexes are $vals');

    notifyListeners();

    // final userID = authData['userID'];
    // Navigator.pushReplacementNamed(context, 'CustomerOrder', arguments: {
    //   'hotelID': hotelID,
    //   'customerID': customer['_id'],
    //   'customerName': customer['name'],
    //   'info': [
    //     {
    //       'foodName': foodInfo[i]['foodName']['name'],
    //       'foodPrice': foodInfo[i]['foodPrice'],
    //       'foodQuantity': foodInfo[i]['foodQuantity']
    //     }
    //   ]
    // });
  }

  acceptOrders() async {
    final vals = await storage.getItem('foodQuery');
    // final customer = storage.getItem('customer');
    List<dynamic> orders = [];
    if (vals != null) {
      for (var item in vals) {
        orders.add(item);
        // check.add(false);
      }
      items = orders;
    }

    notifyListeners();
  }

  processOrders() async {
    final vals = await storage.getItem('foodProcess');
    // final customer = storage.getItem('customer');
    List<dynamic> orders = [];
    if (vals != null) {
      for (var item in vals) {
        orders.add(item);
        // check.add(false);
      }
      processedItems = orders;
    }

    notifyListeners();
  }

  acceptDeliveryOrders() async {
    final vals = await storage.getItem('deliveryReq');
    // final customer = storage.getItem('customer');
    // List<dynamic> orders = [];
    // if (vals != null) {
    //   for (var item in vals) {
    //     orders.add(item);
    //     // check.add(false);
    //   }
    // }
    deliveryFood = vals;

    notifyListeners();
  }

  newOrder(args) async {
    List<dynamic> orders = [];

    foods = await storage.getItem('foodQuery') ?? [];

    foods.add(args);

    storage.setItem('foodQuery', foods);

    final foodOrders = await storage.getItem('foodQuery');
    if (foodOrders != null) {
      for (var item in foodOrders) {
        orders.add(item);
        // check.add(false);
      }
      items = orders;
    }

    notifyListeners();
  }

  newDeliveryOrder(args) async {
    print('new driver req is ${args['customerName']}');
    deliveryReq = await storage.getItem('deliveryReq') ?? [];

    deliveryReq.add(args);

    storage.setItem('deliveryReq', deliveryReq);

    final allReqs = await storage.getItem('deliveryReq');

    // for (var item in allReqs) {
    //   orders.add(item);
    //   // check.add(false);
    // }

    deliveryFood = allReqs;

    notifyListeners();
  }

  acceptDeliveryReq(i) async {
    final delivery = await storage.getItem('delivery');
    // final body = jsonEncode({
    //   'customerInfo': deliveryFood[i]['customerID'],
    //   'hotelID': deliveryFood[i]['hotelID'],
    //   'foodInfo': deliveryFood[i]['foodInfo'],
    // });

    final data = jsonEncode({
      'deliveryName': delivery['name'],
      'vehicleNum': delivery['vehicleNum'],
      'accepted': true
    });
    // final res = await http.post('http://10.0.2.2:5000/accept_order',
    //     headers: {"Content-Type": "application/json"}, body: body);

    socket.emit(
        'reqAcceptD', {'hotelID': deliveryFood[i]['hotelID'], 'data': data});

    splice(deliveryFood, i, 1);

    // print(deliveryFood.length);

    storage.setItem('deliveryReq', deliveryFood);

    notifyListeners();
  }

  processHotelReq(i) async {
    List<dynamic> orders = [];

    final body = jsonEncode({
      'customerInfo': items[i]['customerID'],
      'customerName': items[i]['customerName'],
      'hotelID': items[i]['hotelID'],
      'foodInfo': items[i]['foodInfo'],
    });

    final res = await http.post('http://10.0.2.2:5000/call_delivery',
        headers: {"Content-Type": "application/json"}, body: body);

    socket.emit('reqAccept',
        {'customerID': items[i]['customerID'], 'data': 'Request accepted'});
    processFood = await storage.getItem('foodProcess') ?? [];

    processFood.add(items[i]);

    storage.setItem('foodProcess', processFood);

    final vols = await storage.getItem('foodProcess');

    processedItems = vols;

    splice(items, i, 1);

    // print(items.length);

    storage.setItem('foodQuery', items);

    notifyListeners();
  }

  acceptReq(i) async {
    // final vals = storage.getItem('foodQuery');
    // final body = jsonEncode({
    //   'customerInfo': items[i]['customerID'],
    //   'hotelID': items[i]['hotelID'],
    //   'foodInfo': items[i]['info'],
    // });

    // final res = await http.post('http://10.0.2.2:5000/accept_order',
    //     headers: {"Content-Type": "application/json"}, body: body);

    socket.emit('reqAccept',
        {'customerID': items[i]['customerID'], 'data': 'Request accepted'});

    // setState(() {
    //   splice(items, i, 1);
    // });
    // splice(items, i, 1);

    // print(items.length);

    // storage.setItem('foodQuery', items);

    // notifyListeners();
  }

  // }

  // List<Food> get hotelItems {
  //   return [..._hotelItems];
  // }

  List<Food> get foodItems {
    return [..._foodItems];
  }

  void addFood(args) async {
    await http.post('http://10.0.2.2:5000/add_hotelFood',
        headers: {"Content-Type": "application/json"}, body: args);

    notifyListeners();
  }
}
