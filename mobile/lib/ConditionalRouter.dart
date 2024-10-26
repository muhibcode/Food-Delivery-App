import 'dart:collection';

import 'package:first_app/Screens/Login_Screen.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ConditionalRouter extends MapMixin<String, WidgetBuilder> {
  final Map<String, WidgetBuilder> public;
  final Map<String, WidgetBuilder> private;

  ConditionalRouter({this.public, this.private});

  bool isAuth;
  // @override
  void initState() {
    // super.initState();
  }

  getUser() async {
    http.Response response = await http.get('http://10.0.2.2:5000/auth');

    var data = jsonDecode(response.body);

    isAuth = data['isAuth'];

    print(isAuth);
  }

  @override
  WidgetBuilder operator [](Object key) {
    if (public.containsKey(key)) return public[key];
    if (private.containsKey(key)) {
      if (isAuth) {
        return private[key];
      }
      // Adding next page parameter to your Login page
      // will allow you to go back to page, that user were going to
      return (context) => Login();
    }
    return null;
  }

  @override
  void operator []=(key, value) {}

  @override
  void clear() {}

  @override
  Iterable<String> get keys {
    final set = Set<String>();
    set.addAll(public.keys);
    set.addAll(private.keys);
    return set;
  }

  @override
  WidgetBuilder remove(Object key) {
    return public[key] ?? private[key];
  }
}

// MaterialApp(
//   // ...
//   routes: ConditionalRouter(
//     public: {
//       '/start_page': (context) => StartPage()
//     },
//     private: {
//       '/user_profile': (context) => UserProfilePage()
//     }
//   )
// )
