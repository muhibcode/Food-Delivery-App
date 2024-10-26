class FoodOrder {
  // String price;
  String name;

  // FoodOrder({this.id, this.name, this.price, this.quantity, this.imageUrl});

  FoodOrder.fromJson(Map<String, dynamic> data) {
    name = data['foodName'];

    // price = data['price'];
  }
}
