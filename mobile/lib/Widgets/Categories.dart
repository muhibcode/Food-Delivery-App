import 'package:first_app/Provider/Food_Provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Categories extends StatelessWidget {
  // List<dynamic> categories = [];
  _buildCategories(categs, context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, 'FoodCategory',
            arguments: {'id': categs['_id'], 'title': categs['title']});
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            margin: EdgeInsets.all(3),
            width: 100.0,
            height: 100.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                image: DecorationImage(
                    image: NetworkImage(
                      'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
                    ),
                    fit: BoxFit.cover)),
          ),
          Container(
            margin: EdgeInsets.all(3),
            width: 100.0,
            height: 100.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.black87.withOpacity(0.3),
                      Colors.black54.withOpacity(0.3),
                      Colors.black38.withOpacity(0.3),
                    ],
                    stops: [
                      0.1,
                      0.4,
                      0.6,
                      0.9
                    ])),
          ),
          Positioned(
            bottom: 8,
            child: Container(
              width: 100.0,
              child: Text(
                categs['title'],
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                // softWrap: true,
                maxLines: 4,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<FoodProvider>(context).categories;
    return Container(
      padding: EdgeInsets.only(left: 10),
      height: 100,
      child: ListView.builder(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (BuildContext context, int index) {
            return _buildCategories(categories[index], context);
          }),
    );
  }
}
