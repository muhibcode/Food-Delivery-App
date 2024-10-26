import 'package:first_app/Widgets/Categories.dart';
import 'package:first_app/Widgets/FeaturedFoods.dart';
import 'package:first_app/Widgets/FoodDrawer.dart';
import 'package:first_app/Widgets/FoodItems.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/Food_Provider.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

class FoodOverview extends StatefulWidget {
  @override
  _FoodOverviewState createState() => _FoodOverviewState();
}

class _FoodOverviewState extends State<FoodOverview> {
  bool _isInit = true;
  final LocalStorage storage = new LocalStorage('food_app');
  final formKey = GlobalKey<FormState>();

  // String valia = 'yalla';
  Map<String, dynamic> filter = {'search': ''};

  // Map<String, dynamic> filters = {
  //   'search': '',
  //   'priceRange': [0, 5000]
  // };
  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<FoodProvider>(context, listen: true).getFoodItems(filter);
      Provider.of<FoodProvider>(context).getCategories();
      Provider.of<FoodProvider>(context).getHotels();
      // final user = Provider.of<Auth>(context).authenticate();

      // print('mr lova lova');
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  searchFood() {
    // if (formKey.currentState.validate()) {
    //   formKey.currentState.save();
    // }
    formKey.currentState.save();

    // final value = jsonEncode({'search': filters['search']});

    // final value = jsonEncode(filters);

    // print('search is ${filters['search']}');
    // formKey.currentState.save();
    Provider.of<FoodProvider>(context, listen: false).getFoodItems(filter);
  }

  onPressLogin(BuildContext ctx) async {
    final data = await http.get('http://10.0.2.2:5000/flutter');

    print(data.body);

    // socketIO.sendMessage(
    //     'foodRequest', json.encode({'message': 'Hello backend'}));
    // Socket socket = io('http://10.0.2.2:5000');

    // socket.on('connect', (_) {
    //   print('connect');
    //   socket.emit('foodRequest', 'hello from flutter');
    // });

    // Navigator.of(ctx).pushNamed('Loading');

    Navigator.pushReplacementNamed(ctx, 'Login');
  }

  onPressSignUp(BuildContext ctx) {
    // Navigator.of(ctx).pushNamedRe('Register');

    Navigator.pushNamed(ctx, 'Filter');
    // .then((value) =>http.Response response = http.get('http://10.0.2.2:5000/auth');
//  );
  }

  onPressForm(BuildContext ctx) {
    // Navigator.of(ctx).pushNamedRe('Register');

    Navigator.pushReplacementNamed(ctx, 'HotelOrders');
    // .then((value) =>http.Response response = http.get('http://10.0.2.2:5000/auth');
//  );
  }

  @override
  Widget build(BuildContext context) {
    // final hotels = Provider.of<FoodProvider>(context).hotels;
    // final data = Provider.of<FoodProvider>(context);
    // final hotelFood = data.foodItems;

    // print(hotelFood);

    return Scaffold(
        appBar: AppBar(
            title: Row(
          children: [
            Text('Food Shop'),
            FlatButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'CartScreen');
                },
                child: Text('Cart'))
            // GestureDetector(
            //     child: Text('Login'), onTap: () => onPressLogin(context)),
            // GestureDetector(
            //     child: Text('Register'), onTap: () => onPressSignUp(context)),
            // GestureDetector(
            //     child: Text('FoodForm'), onTap: () => onPressForm(context))
          ],
        )),
        drawer: FoodDrawer(),
        body: ListView(children: [
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: TextFormField(
                // initialValue: filter['search'],
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide(width: 0.8)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide(
                            width: 0.8, color: Theme.of(context).primaryColor)),
                    hintText: 'Search Food',
                    prefixIcon: Material(
                      color: Colors.white.withOpacity(0),
                      borderRadius: BorderRadius.circular(20.0),
                      child: IconButton(
                          splashRadius: 20.0,
                          highlightColor: Colors.red,
                          splashColor: Colors.red,
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            // search = '';

                            formKey.currentState.reset();
                          }),
                    ),
                    suffixIcon: Material(
                      color: Colors.white.withOpacity(0),
                      borderRadius: BorderRadius.circular(20.0),
                      child: Padding(
                        padding: EdgeInsets.only(right: 6),
                        child: IconButton(
                            splashRadius: 20.0,
                            highlightColor: Colors.red,
                            splashColor: Colors.red,
                            icon: Icon(
                              Icons.search,
                              size: 35,
                            ),
                            // iconSize: 40.0,
                            onPressed: () {
                              searchFood();
                            }),
                      ),
                    )),
                onSaved: (newValue) {
                  filter['search'] = newValue;
                },
              ),
            ),
          ),
          FeaturedFoods(),
          Categories(),
          FoodItems()
          // RangeSlider(values: , onChanged: null)
          // Restaurants(hotels)
        ])
        // FoodGrid(),

        // Container(
        //   child: Column(
        //     children: [
        //       //  toggeleSwitch()
        //     ],
        //   ),
        // )
        );
  }
}
