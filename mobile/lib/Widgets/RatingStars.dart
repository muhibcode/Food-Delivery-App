import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  final int rating;

  RatingStars(this.rating);

  @override
  Widget build(BuildContext context) {
    String stars = '';
    // Icon stars;
    for (var i = 0; i < rating; i++) {
    
      stars += '⭐';
    }
    stars.trim();
    return Text(
      stars,
      style: TextStyle(fontSize: 16.0),
    );
  }
}
