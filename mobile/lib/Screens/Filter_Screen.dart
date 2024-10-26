import 'package:first_app/Provider/Food_Provider.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class Filters extends StatefulWidget {
  @override
  _FiltersState createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  // bool status = false;
  // Map<String, List<dynamic>> filters = {'types': [], 'typesOfFood': []};

  // List<dynamic> types = [];
  RangeValues _currentRangeValues = RangeValues(0, 5000);

  @override
  void initState() {
    super.initState();
  }

  // types = FoodTypes.fromjson(data);
  // print(foodstype.map((n) => MapEntry(n.id, n.title)));

  // var foodTypes = FoodTypes({data['_id'],data['title']});

  // filterItems(val, id, category) {
  //   final newFilter = {...filters};

  //   final newArray = [...newFilter[category]];

  //   final index = newArray.indexOf(id);

  //   if (index == -1) {
  //     newArray.add(id);
  //   } else {
  //     splice(newArray, index, 1);
  //   }

  //   setState(() {
  //     newFilter[category] = newArray;

  //     filters = newFilter;
  //     status = val;
  //   });
  //   // setState(() {
  //   //   status = val;
  //   // });

  //   print(filters);
  // }

  // Widget toggeleSwitch(id) {
  //   return FlutterSwitch(
  //       showOnOff: true,
  //       value: status,
  //       onToggle: (val) => filterItems(val, id, 'typesOfFood'));
  // }

  filterItems(val) {
    Map<String, dynamic> filter = {
      'priceRange': [val.start, val.end]
    };

    Provider.of<FoodProvider>(context, listen: false).getFoodItems(filter);

    print(val);
  }

  @override
  Widget build(BuildContext context) {
    final vals = Provider.of<FoodProvider>(context).filters;

    return Scaffold(
      appBar: AppBar(
          title: FlatButton(
        child: Text('Main Page'),
        onPressed: () {
          Navigator.pop(context);
        },
      )),
      body: Column(
        children: [
          Text('${_currentRangeValues.end}'),
          RangeSlider(
              onChanged: (RangeValues values) {
                setState(() {
                  _currentRangeValues = values;
                  vals['priceRange'][0] = values.start;
                  vals['priceRange'][1] = values.end;
                });
              },
              values: RangeValues(vals['priceRange'][0], vals['priceRange'][1]),
              min: 0,
              max: 5000,
              divisions: 500,
              labels: RangeLabels(
                vals['priceRange'][0].round().toString(),
                vals['priceRange'][1].round().toString(),
              ),
              onChangeEnd: (RangeValues values) => filterItems(values)),
        ],
      ),
    );
  }
}
