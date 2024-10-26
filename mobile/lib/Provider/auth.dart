import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:localstorage/localstorage.dart';

import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String _token = '';
  String userID = '';
  Map<String, dynamic> authInfo = {};

  Map<String, dynamic> userInfo = {};
  Map<String, dynamic> deliveryInfo = {};
  Map<String, dynamic> hotelInfo = {};

  // Map<String, dynamic> get userInfo {
  //   return {..._userInfo};
  // }

  LocalStorage storage = new LocalStorage('food_app');

  Future<void> login(String email, String password) async {
    var body = json.encode({'email': email, 'password': password});
    // var body = {'email': email, 'password': password};

    final response = await http.post('http://10.0.2.2:5000/login',
        headers: {"Content-Type": "application/json"}, body: body);

    if (response.body != null) {
      final data = jsonDecode(response.body);

      // print('user data is $data');

      if (data['customer'] != null) {
        storage.setItem('customer', data['customer']);
        // userInfo.addAll(data['user']);
      }
      if (data['delivery'] != null) {
        storage.setItem('delivery', data['delivery']);

        // deliveryInfo.addAll(data['delivery']);
      }
      if (data['hotel'] != null) {
        storage.setItem('hotel', data['hotel']);

        // hotelInfo.addAll(data['hotel']);
      }

      // _token = data['token'];

      // // userID = data['userID'];

      // authInfo = {
      //   'token': _token,
      //   'userID': data['userID'],
      //   'hotelID': data['hotelID']
      // };

      // storage.setItem('authInfo', authInfo);
      // print(_token);
      // deliveryInfo.addAll(data['deliveryInfo']);
      // hotelInfo.addAll(data['hotelInfo']);
    }

    notifyListeners();
  }

  authenticate() async {
    final authData = await storage.getItem('authInfo');

    // print(authData);

    if (authData != null) {
      final authUserID = authData['userID'];

      final response =
          await http.get('http://10.0.2.2:5000/auth?userID=$authUserID');

      final data = jsonDecode(response.body);

      if (data['userInfo'] != null) {
        userInfo.addAll(data['userInfo']);
      }
      if (data['deliveryInfo'] != null) {
        deliveryInfo.addAll(data['deliveryInfo']);
      }
      if (data['hotelInfo'] != null) {
        hotelInfo.addAll(data['hotelInfo']);
      }

      // print(userInfo);

      notifyListeners();
    }
  }

  get token async {
    final customer = await storage.getItem('customer');
    final hotel = await storage.getItem('hotel');

    String authToken;
    if (customer != null) {
      authToken = customer['token'];
    }
    if (hotel != null) {
      authToken = hotel['token'];
    }

    // print('auth token is $authData');

    // if (_token != null) {
    //   return _token;
    // }
    return authToken;
  }

  bool get isAuth {
    return token != null;
  }

  // userInfo.update(key, (value) => null);
}
//   bool get isAuth{

//    return data['token'] != null;

// };
