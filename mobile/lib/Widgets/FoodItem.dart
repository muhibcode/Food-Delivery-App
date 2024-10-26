import 'package:flutter/material.dart';

class FoodItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String price;
  // final String quantity;
  final String hotelID;
  final List<dynamic> foodInfo;
  // final String imageUrl;

  FoodItem(this.hotelID, this.foodInfo);

  onTapFood(context) {
    Navigator.pushNamed(context, 'FoodDetails', arguments: {
      // 'id': id,
      // 'title': title,
      // 'price': price,
      // 'quantity': quantity,
      'foodInfo': foodInfo,
      'hotelID': hotelID
      // 'imageUrl': imageUrl
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTapFood(context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          child: Image.network(
            'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
            fit: BoxFit.cover,
          ),
          footer: GridTileBar(
              backgroundColor: Colors.black54,
              title: Column(
                children: foodInfo
                    .map((e) => Column(
                          children: [Text(e['foodName']['name'])],
                        ))
                    .toList(),
                // children: [
                //   Text(title, textAlign: TextAlign.left),
                //   Text(title, textAlign: TextAlign.left),
                // ],
              )),
        ),
      ),
    );
  }
}
