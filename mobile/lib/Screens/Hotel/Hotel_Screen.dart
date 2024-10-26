import 'package:first_app/Provider/Food_Provider.dart';
import 'package:first_app/Widgets/RatingStars.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:provider/provider.dart';
import 'package:localstorage/localstorage.dart';

class HotelScreen extends StatefulWidget {
  @override
  _HotelScreenState createState() => _HotelScreenState();
}

class _HotelScreenState extends State<HotelScreen> {
  LocalStorage storage = new LocalStorage('food_app');

  bool _isInit = true;
  String hotelAddress;
  String hotelName;
  String hotelID;
  List<dynamic> foodOrders = [];
  Coordinates coord;

  // Location adress = Location();
  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final routeArgs =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      hotelID = routeArgs['id'];
      hotelName = routeArgs['name'];
      hotelAddress = routeArgs['address'];

      Provider.of<FoodProvider>(context).getHotelFoods(hotelID);
      // getAddress();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  getAddress() async {
    // From a query
    // final query = "Firdous Market Gulberg 3 Lahore Pakistan";
    // var addresses = await Geocoder.local.findAddressesFromQuery(query);
    // var first = addresses.first;
    // // setState(() {
    // //   coord = first.coordinates;
    // // });
    // print("${first.featureName} : ${first.coordinates}");
    // bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

    // LocationPermission permission = await Geolocator.checkPermission();
    // Position geoPosition = await Geolocator.getCurrentPosition(
    //     desiredAccuracy: LocationAccuracy.high,
    //     forceAndroidLocationManager: true);

    // print('lati is $geoPosition');

    // return isLocationServiceEnabled;
    // From coordinates
    final coordinates = new Coordinates(37.4219983333333, -122.08400000000002);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print("${first.featureName} : ${first.addressLine}");
  }

  addToCart(context, foodInfo) async {
    // 'hotelID': hotelID,

    final details = {
      'hotelID': hotelID,
      'foodName': foodInfo['foodName']['name'],
      'foodPrice': foodInfo['foodPrice'],
      'foodQuantity': foodInfo['foodQuantity']
    };

    // final customer = storage.getItem('customer');

    foodOrders = await storage.getItem('cartFood') ?? [];

    foodOrders.add(details);
    storage.setItem('cartFood', foodOrders);
    // final authData = storage.getItem('authInfo');
    // print('user ID is $details');
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

  _buildFoodList(BuildContext context, hotelFood) {
    print('hotel food is $hotelFood');
    return Column(
        children: hotelFood.foodInfo
            .map<Widget>(
              (n) => Container(
                margin: EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(width: 1.0, color: Colors.grey[200])),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                      child: Material(
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
                            // addToCart(context, n);
                            getAddress();
                            // Navigator.pushNamed(context, 'CartScreen');
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    final hotelFood = Provider.of<FoodProvider>(context).hotelItems;
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Hero(
                tag:
                    'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
                child: Image.network(
                  'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
                  height: 220.0,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 60.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        color: Colors.white,
                        iconSize: 30.0,
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    IconButton(
                        icon: Icon(Icons.favorite),
                        color: Colors.white,
                        iconSize: 35.0,
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ],
                ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Text(
                    hotelName,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
                  ),
                ]),
                SizedBox(
                  height: 4,
                ),
                RatingStars(5),
                SizedBox(
                  height: 4,
                ),
                Text(
                  hotelAddress,
                  style: TextStyle(fontSize: 18.0),
                ),
                // Text('$coord')
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  // scrollDirection: Axis.vertical,
                  itemCount: hotelFood.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildFoodList(context, hotelFood[index]);
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
