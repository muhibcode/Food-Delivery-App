import 'dart:convert';
import 'package:js_shims/js_shims.dart';

import '../Provider/auth.dart';

import '../models/FoodItem.dart';

import '../models/FoodTypes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import '../Provider/Food_Provider.dart';

class HotelFoodForm extends StatefulWidget {
  final Auth auth;

  HotelFoodForm(this.auth);
  @override
  HotelFoodFormState createState() => HotelFoodFormState();
}

class HotelFoodFormState extends State<HotelFoodForm> {
  LocalStorage storage = new LocalStorage('food_app');

  final formKey = GlobalKey<FormState>();

  // int counter;
  String typeId = '';
  // int indi;
  // String typeOfFood;

  String type;
  String food;
  String foodId = '';
  String hotelID = '';

  List<dynamic> foods = [];
  List<dynamic> foodItems = [];

  // List<FoodTypes> foodstype = [];
  List<dynamic> foodVal = [];
  List<dynamic> foodstype = [];

  // bool _isInit = true;

  @override
  void initState() {
    super.initState();
    final hotel = storage.getItem('hotel');
    print('id is ${hotel['_id']}');
    if (hotel != null) {
      hotelID = hotel['_id'];
    }

    fetchTypes();
  }

  // @override
  // void didChangeDependencies() {
  //   if (_isInit) {
  //     print(widget.auth.userInfo);
  //   }
  //   _isInit = false;
  //   super.didChangeDependencies();
  // }

  fetchTypes() async {
    http.Response response = await http.get('http://10.0.2.2:5000/get_type');

    var data = jsonDecode(response.body);

    setState(() {
      foodstype = data;
    });

    // for (var item in data) {
    //   var types = FoodTypes.fromJson(item);

    //   setState(() {
    //     foodstype.add(types);
    //   });
    // }
    // types = FoodTypes.fromjson(data);
    // print(foodstype.map((n) => MapEntry(n.id, n.title)));

    // var foodTypes = FoodTypes({data['_id'],data['title']});
  }

  onChangeType(val) async {
    setState(() {
      type = val;
    });

    for (var i = 0; i < foodstype.length; i++) {
      if (foodstype[i]['title'] == val) {
        setState(() {
          typeId = foodstype[i]['_id'];
        });

        break;
      }
    }

    final respose = await http.get('http://10.0.2.2:5000/get_food?id=$typeId');

    final data = jsonDecode(respose.body);

    // for (var item in data) {
    //   // var types = FoodTypes(id: item['_id'], title: item['title']);

    //   var foodies = FoodItem.fromJson(item);

    //   setState(() {
    //     foodItems.add(foodies);
    //   });
    // }

    print(val);

    setState(() {
      foodItems = data;
    });

    // print(foodItems);
    // foodstype.forEach((element) { })
  }

  hotelVal() {}

  onChangeFood(val, j) {
    var newVal = [...foodVal];

    newVal[j] = val;

    setState(() {
      foodVal[j] = newVal[j];

      food = newVal[j];
    });

    for (var i = 0; i < foodItems.length; i++) {
      if (foodItems[i]['name'] == val) {
        setState(() {
          foodId = foodItems[i]['_id'];
        });

        break;
      }
    }

    foods[j]['foodName'] = foodId;
    // setState(() {
    //   food = '';

    //   food = foodVal[i];
    // });

    print(j);
    // foodstype.forEach((element) { })
  }

  iterations(counter) {
    for (var i = 0; i < counter; i++) {
      setState(() {
        foods.add({
          // 'hotelID': hotelID,
          'foodName': '',
          'foodPrice': '',
          'foodQuantity': ''
        });
        foodVal.add('');
      });
    }

    // print(foods);
  }

  onChangePrice(val, i) {
    var newFood = [...foods];

    newFood[i]['foodPrice'] = val;

    setState(() {
      foods = newFood;
    });

    print(foods);
  }

  onChangeTitle(val, i) {
    var newFood = [...foods];

    newFood[i]['foodName'] = val;
    setState(() {
      foods = newFood;
    });

    print(foods);
  }

  onChangeQuantity(val, i) {
    var newFood = [...foods];

    newFood[i]['foodQuantity'] = val;
    setState(() {
      foods = newFood;
    });

    print(foods);
  }

  @override
  Widget build(BuildContext context) {
    // hotelID = widget.auth.hotelInfo['_id'];
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Form'),
      ),
      body: Container(
          margin: EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                type == null ? dropDownCategory() : noOfItems(),
                Container(
                  child: fields(),
                )
              ],
            ),
          )),
    );
  }

  Widget fields() {
    return Container(
        child: Column(
            children: foods
                .asMap()
                .map((i, e) {
                  return MapEntry(
                      i,
                      Container(
                        child: Column(
                          children: <Widget>[
                            dropDownFood(i),
                            priceField(i),
                            quantityField(i),
                            Container(
                                margin: EdgeInsets.only(top: 15),
                                child: submitButton()),
                          ],
                        ),
                      ));
                })
                .values
                .toList()));
  }

  Widget dropDownCategory() {
    return Container(
      margin: EdgeInsets.only(top: 25),
      child: DropdownButton(
        hint: Text("Select Food Category"),
        value: type,
        onChanged: (val) => onChangeType(val),
        items: foodstype
            .asMap()
            .map((i, e) {
              return MapEntry(
                  i,
                  DropdownMenuItem(
                      value: e['title'],
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            e['title'],
                            style: TextStyle(color: Colors.black),
                          )
                        ],
                      )));
            })
            .values
            .toList(),
      ),
    );
  }

  Widget dropDownFood(j) {
    print(foodItems);
    return Container(
      margin: EdgeInsets.only(top: 25),
      child: DropdownButton(
        hint: Text("Select Food"),
        value: foodVal[j] == '' ? food : foodVal[j],
        onChanged: (val) => onChangeFood(val, j),
        items: foodItems
            .asMap()
            .map((i, e) {
              return MapEntry(
                  i,
                  DropdownMenuItem(
                      value: e['name'],
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            e['name'],
                            style: TextStyle(color: Colors.black),
                          )
                        ],
                      )));
            })
            .values
            .toList(),
      ),
    );
  }

  Widget noOfItems() {
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 20),
            child: Text('Food Category is $type'),
          ),
          TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  labelText: 'No OF Food Items', hintText: 'e.g 2,4,5'),
              onChanged: (value) => onChnageNum(value))
        ],
      ),
    );
  }

  onChnageNum(val) {
    iterations(int.parse(val));
  }

  Widget priceField(i) {
    return TextFormField(
        keyboardType: TextInputType.emailAddress,
        decoration:
            InputDecoration(labelText: 'Enter Price', hintText: 'Price'),
        // ignore: missing_return
        validator: (String value) {
          if (!value.contains('@')) {
            return 'please enter a valid email';
          }
        },
        onChanged: (value) => onChangePrice(value, i)
        // onSaved: (String value) {
        //    = value;
        );
  }

  // Widget nameField(i) {
  //   return TextFormField(
  //     keyboardType: TextInputType.emailAddress,
  //     decoration: InputDecoration(
  //         labelText: 'Title', hintText: 'Your Name e.g John Doe'),
  //     onChanged: (val) => onChangeTitle(val, i),
  //   );
  // }

  Widget quantityField(i) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Password',
      ),
      onChanged: (val) => onChangeQuantity(val, i),
      // ignore: missing_return
      // validator: (String value) {
      //   if (value.length < 4) {
      //     return 'password must contain 4 characters';
      //   }
      // },
    );
  }

  submitFood() {
    final body = jsonEncode(
        {'typeOfFood': typeId, 'hotelID': hotelID, 'foodInfo': foods});

    Provider.of<FoodProvider>(context, listen: false).addFood(body);

    Navigator.pop(context);

    // await http.post('http://10.0.2.2:5000/add_hotelFood',
    //     headers: {"Content-Type": "application/json"}, body: body);

    // hotelID = ''
  }

  Widget submitButton() {
    return RaisedButton(
      child: Text('Add Food'),
      onPressed: () {
        submitFood();
      },
    );
  }
}

// names.asMap().map((index, name)=> MapEntry(index, Container(
//             child: Column(
//               children: <Widget>[
//                 Text(
//                  name
//                 ),
//                 Text(
//                   difficulty[index]
//                 ),
//               ],
//             ),
//           ))).values.toList();
