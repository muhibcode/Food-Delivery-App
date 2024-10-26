import 'package:first_app/Widgets/RatingStars.dart';
import 'package:flutter/material.dart';

class Restaurants extends StatelessWidget {
  List<dynamic> restaurantList = [];

  Restaurants(this.restaurantList);

  _buildRestauratnts(BuildContext context) {
    print('rest are $restaurantList');
    return Column(
        children: restaurantList
            .map<Widget>(
              (n) => InkWell(
                onTap: () {
                  Navigator.pushNamed(context, 'HotelScreen', arguments: {
                    'id': n['_id'],
                    'name': n['hotelName'],
                    'address': n['hotelAddress']
                  });
                },
                child: Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey[200], width: 1.0),
                      borderRadius: BorderRadius.circular(15.0)),
                  // height: 150.0,
                  // width: 150.0,
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Hero(
                          tag:
                              'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
                          child: Image.network(
                            'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
                            fit: BoxFit.cover,
                            width: 140.0,
                            height: 140.0,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(12.0),
                        width: 200.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              n['hotelName'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20.0),
                            ),
                            SizedBox(
                              height: 4.0,
                            ),
                            RatingStars(5),
                            SizedBox(
                              height: 4.0,
                            ),
                            Text(
                              n['hotelAddress'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16.0),
                            ),
                            SizedBox(
                              height: 4.0,
                            ),
                            Text(
                              '2 miles away',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16.0),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return _buildRestauratnts(context);
  }
}
