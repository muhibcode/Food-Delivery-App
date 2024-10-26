import '../Provider/Food_Provider.dart';
import 'package:flutter/material.dart';
// import '../models/Food.dart';
import '../Widgets/FoodItem.dart';
import 'package:provider/provider.dart';

class FoodGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final foodData = Provider.of<FoodProvider>(context);
    final foods = foodData.foodItems;
    // print(foods);

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: foods.length,
      itemBuilder: (ctx, i) => FoodItem(
        foods[i].hotelID, foods[i].foodInfo,
        // foods[i].imageUrl,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 4 / 3.5,
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
    );
  }
}
