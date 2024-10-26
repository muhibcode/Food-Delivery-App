import 'package:first_app/Provider/auth.dart';
import 'package:first_app/Widgets/Categories.dart';
import 'package:first_app/Widgets/FeaturedFoods.dart';
import 'package:first_app/Widgets/Restaurants.dart';
import 'package:flutter/material.dart';
import '../Widgets/FoodGrid.dart';
import 'package:provider/provider.dart';
import '../Provider/Food_Provider.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isInit = true;
  final LocalStorage storage = new LocalStorage('food_app');

  // String id;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      // Provider.of<FoodProvider>(context, listen: true).getFoodItems();
      Provider.of<FoodProvider>(context).getCategories();
      Provider.of<FoodProvider>(context).getHotels();

      // final user = Provider.of<Auth>(context).authenticate();

      // print(user);
    }
    _isInit = false;
    super.didChangeDependencies();
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
    final hotels = Provider.of<FoodProvider>(context).hotels;
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
        body: ListView(children: [
          Padding(
            padding: EdgeInsets.all(20.0),
            child: TextField(
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
                  hintText: 'Search Food or Hotel',
                  prefixIcon: Material(
                    color: Colors.white.withOpacity(0),
                    borderRadius: BorderRadius.circular(20.0),
                    child: IconButton(
                        splashRadius: 20.0,
                        highlightColor: Colors.red,
                        splashColor: Colors.red,
                        icon: Icon(Icons.clear),
                        onPressed: () {}),
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
                          onPressed: () {}),
                    ),
                  )),
            ),
          ),
          FeaturedFoods(),
          Categories(),
          Restaurants(hotels)
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
