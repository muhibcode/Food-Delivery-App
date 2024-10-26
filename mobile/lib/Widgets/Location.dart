import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';

class Location extends StatefulWidget {
  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<Location> {
  @override
  void initState() {
    // getAddress();
    super.initState();
  }

  Coordinates coord;

  getAddress() async {
    // From a query
    final query = "Firdous Market Gulberg 3 Lahore Pakistan";
    var addresses = await Geocoder.local.findAddressesFromQuery(query);
    var first = addresses.first;
    setState(() {
      coord = first.coordinates;
    });
    print("${first.featureName} : ${first.coordinates}");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('$coord'),
    );
  }
}
