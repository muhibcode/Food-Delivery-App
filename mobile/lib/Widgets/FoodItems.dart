import 'package:first_app/Provider/Food_Provider.dart';
import 'package:first_app/Widgets/RatingStars.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:localstorage/localstorage.dart';

class FoodItems extends StatefulWidget {
  // final List<dynamic> hotelFood;

  // FoodItems(this.hotelFood);

  @override
  _FoodItemsState createState() => _FoodItemsState();
}

class _FoodItemsState extends State<FoodItems> {
  LocalStorage storage = new LocalStorage('food_app');

  List<dynamic> foodOrders = [];

  List<bool> isCheck = [];
  // List<dynamic> foodIDs = [];

  bool _isInit = true;

  String foodID = '';
  // int foodIndex = -1;
  // @override
  // void initState() {
  //   widget.hotelFood.forEach((n) {
  //     n.foodInfo.forEach((m) {
  //       setState(() {
  //         foods.add(m);
  //       });
  //     });
  //   });
  //   super.initState();
  // }

  // @override
  // void didChangeDependencies() {
  //   // if (_isInit) {
  //   final data = Provider.of<FoodProvider>(context).foodItems;
  //   print(data.length);
  //   // }
  //   // _isInit = false;
  //   super.didChangeDependencies();
  // }

  // getID() async {
  //   final vals = await storage.getItem('cartFood');

  //   setState(() {
  //     foodIDs = vals;
  //   });
  // }

  addCartFood(hotelFood, foodInfo, i, j) async {
    final details = {
      'hotelID': hotelFood[i].hotelID,
      'foodID': foodInfo['_id'],
      'foodName': foodInfo['foodName']['name'],
      'foodPrice': foodInfo['foodPrice'],
      'foodQuantity': foodInfo['foodQuantity']
    };
    // foodOrders = await storage.getItem('cartFood') ?? [];

    // foodOrders.add(details);
    // await storage.setItem('cartFood', foodOrders);

    // final vals = await storage.getItem('cartFood');

    // setState(() {
    //   // foodIDs = vals;
    //   foodIndex = j;
    // });
    // foodIDs.forEach((n) {
    //   if (n.containsValue(widget.hotelFood[i].foodInfo[j]['_id'])) {
    //     isCheck[j] = true;
    //   } else {
    //     isCheck[j] = false;
    //   }
    // });
    // print('foodies are ${widget.hotelFood[i].foodInfo}');

    Provider.of<FoodProvider>(context, listen: false).addToCart(details, j);
  }

  _buildFoodList(BuildContext context, data, i) {
    // final data = Provider.of<FoodProvider>(context);
    final items = data.cartItems;
    final hotelFood = data.foodItems;
    final foodIndex = data.foodIndex;
    final foodIDs = data.foodIDs;

    if (foodIndex != -1) {
      // if items are empty then the else code did not execute therefore put in if
      if (items.length == 0) {
        isCheck[foodIndex] = false;
        // print('is chekc is ${isCheck[foodIndex]}');
      } else {
        items.forEach((n) {
          if (n['foodID'] == foodIDs[foodIndex]) {
            isCheck[foodIndex] = true;
          } else {
            isCheck[foodIndex] = false;
          }
        });
      }
    }

    if (_isInit == true) {
      for (var item in hotelFood) {
        item.foodInfo.forEach((m) {
          isCheck.add(false);
        });
      }
    }
    _isInit = false;
    // print('is chekc is $foodIndex');

    // print('length is ${foodIDs.length}');

    return Column(
        children: hotelFood[i]
            .foodInfo
            .map<Widget>(
              (n) => Container(
                margin: EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(width: 1.0, color: Colors.grey[200])),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Row(children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Image.network(
                            'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
                            fit: BoxFit.cover,
                            height: 120.0,
                            width: 120.0,
                          ),
                        ),
                        Expanded(
                          child: Container(
                              margin: EdgeInsets.all(12.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    n['foodName']['name'],
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                  SizedBox(
                                    height: 4.0,
                                  ),
                                  RatingStars(5),
                                  SizedBox(
                                    height: 4.0,
                                  ),
                                  Text(
                                    n['foodPrice'],
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(
                                    height: 4.0,
                                  ),
                                  Text(
                                    n['foodQuantity'],
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              )),
                        ),
                      ]),
                    ),
                    Container(
                        margin: EdgeInsets.only(right: 24),
                        width: 50,
                        height: 50,
                        child: isCheck[foodIDs.indexOf(n['_id'])] == false
                            ? Material(
                                elevation: 8.0,
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(30.0),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(30.0),

                                  radius: 150.0,
                                  splashColor: Colors.red,
                                  // focusColor: Colors.red,
                                  highlightColor: Colors.red,
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.black,
                                    size: 30.0,
                                  ),
                                  onTap: () {
                                    addCartFood(hotelFood, n, i,
                                        foodIDs.indexOf(n['_id']));
                                    // getAddress();
                                    // Navigator.pushNamed(context, 'CartScreen');
                                  },
                                ),
                              )
                            : Icon(
                                Icons.check_sharp,
                                color: Colors.black,
                                size: 35.0,
                              )),
                  ],
                ),
              ),
            )
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<FoodProvider>(context);

    // print('cart vals are $items');

    // print('food is ${hotelFood[0].hotelID}');
    // final hotelFood = Provider.of<FoodProvider>(context).hotelItems;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: data.foodItems.length,
          itemBuilder: (BuildContext context, int index) {
            return _buildFoodList(
              context,
              data,
              index,
            );
          }),
    );
  }
}
