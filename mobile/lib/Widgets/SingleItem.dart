import 'package:flutter/material.dart';

class SingleItem extends StatelessWidget {
  final String id;
  final String title;
  final String price;
  final String quantity;
  final String imageUrl;

  SingleItem(this.id, this.title, this.price, this.quantity, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
        ),
        footer: GridTileBar(
            backgroundColor: Colors.black54,
            title: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(right: 240, top: 5),
                  child: Text(title,
                      textScaleFactor: 1.3, textAlign: TextAlign.start),
                ),
                Text(title, textAlign: TextAlign.left),
              ],
            )),
      ),
    );
  }
}
