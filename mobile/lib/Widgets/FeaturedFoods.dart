import 'package:first_app/Provider/Food_Provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeaturedFoods extends StatelessWidget {
  _buildRecent(BuildContext context, foods) {
    return Row(
        children: foods.foodInfo
            .map<Widget>((n) => Container(
                margin: EdgeInsets.all(7),
                width: 320.0,
                // height: 200.0,
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
                            height: 100.0,
                            width: 100.0,
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
                                ),
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
                            ),
                          ),
                        ),
                      ])),
                      Container(
                        margin: EdgeInsets.only(right: 20.0),
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: IconButton(
                          icon: Icon(Icons.add),
                          iconSize: 30.0,
                          onPressed: () {},
                          color: Colors.white,
                        ),
                      )
                    ])))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    final foodData = Provider.of<FoodProvider>(context);
    final foods = foodData.foodItems;
    return Column(children: [
      Text('Featured Food'),
      Container(
        padding: EdgeInsets.only(left: 10),
        height: 120,
        child: ListView.builder(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: foods.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildRecent(context, foods[index]);
            }),
      )
    ]);
  }
}
