class FoodItem {
  String id;
  String name;

  // FoodItem({this.id, this.name, this.price, this.quantity, this.imageUrl});

  FoodItem.fromJson(Map<String, dynamic> data) {
    id = data['_id'];
    name = data['name'];
  }
}


