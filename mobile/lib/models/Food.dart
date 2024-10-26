class Food {
  // String id;
  String mainID;
  String typeOfFood;
  String hotelID;
  // String title;
  // String price;
  // String quantity;
  List<dynamic> foodInfo = [];

  // };
  // ng imageUrl;

  Food({this.mainID, this.typeOfFood, this.hotelID, this.foodInfo});

  // Food.fromMap(Map<String, dynamic> map) {
  //   mainID = map['_id'];
  //   typeOFFood = map['typeOfFood']['_id'];
  //   hotelID = map['hotelID']['_id'];
  //   List foods = map['foods'];
  //   foods.forEach((n) {
  //     id = n['_id'];
  //     title = n['foodName']['name'];
  //     price = n['foodPrice'];
  //     quantity = n['foodQuantity'];
  //   });
  // for (var n in map['foods']) {
  //   id = n['_id'];
  //   title = n['foodName']['name'];
  //   price = n['foodPrice'];
  //   quantity = n['foodQuantity'];
  // }

  // print(title);
  // imageUrl = map['image'];
}
